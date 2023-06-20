from flask import Flask, make_response, jsonify, request, Response
from flask_mysqldb import MySQL
import xml.etree.ElementTree as ET
import xml.dom.minidom

app = Flask(__name__)
app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = "root"
app.config["MYSQL_DB"] = "classicmodels"
app.config["MYSQL_CURSORCLASS"] = "DictCursor"
mysql = MySQL(app)


def data_fetch(query):
    cur = mysql.connection.cursor()
    cur.execute(query)
    data = cur.fetchall()
    cur.close()
    data = [{k: v.decode() if isinstance(v, bytes) else v for k, v in item.items()} for item in data]
    return data

def generate_xml_response(data_list, root_element="root"):
    root = ET.Element(root_element)
    for data in data_list:
        element = ET.SubElement(root, "customer")
        if isinstance(data, dict):
            for key, value in data.items():
                sub_element = ET.SubElement(element, key)
                sub_element.text = str(value)
        else:
            sub_element = ET.SubElement(element, "data")
            sub_element.text = str(data)
            
    xml_string = ET.tostring(root, encoding="utf-8", method="xml")
    readable_xml = xml.dom.minidom.parseString(xml_string).toprettyxml(indent="  ")
    return readable_xml


# MAIN PAGE
@app.route("/")
def home_page():
    return Response("""
    ==============================
    Classic Models Customers CRUD

    SELECT OPERATION
    [1] Add Customers
    [2] Retrieve Customers
    [3] Update Customers
    [4] Delete Customers
    [E] Exit
    ==============================
    """, mimetype="text/plain")
    
# ADD CUSTOMER

# add new customer data (customerNumber is AutoIncremented)
@app.route("/customers", methods=["POST"])
def add_customer():
    info = request.get_json()
    customer_name = info["customerName"]
    first_name = info["contactFirstName"]
    last_name = info["contactLastName"]
    phone = info["phone"]
    street_1 = info["addressLine1"]
    street_2 = info["addressLine2"]
    city = info["city"]
    state = info["state"]
    postal_code = info["postalCode"]
    country = info["country"]
    sales_rep_employee_number = info["salesRepEmployeeNumber"]
    credit_limit = info["creditLimit"]

    query = f"""INSERT INTO customers (customerName, contactFirstName, contactLastName, phone, addressLine1, addressLine2,
                city, state, postalCode, country, salesRepEmployeeNumber, creditLimit)
                VALUES ('{customer_name}', '{first_name}', '{last_name}', '{phone}', '{street_1}', '{street_2}', '{city}',
                '{state}', '{postal_code}', '{country}', {sales_rep_employee_number}, {credit_limit})"""

    data_fetch(query)
    mysql.connection.commit()
    return make_response(jsonify("Customer added successfully"), 201)


# RETRIEVE CUSTOMER

# show all customers (no condition)
@app.route("/customers", methods=["GET"])
def get_customers():
    query = """SELECT customerNumber, customerName, contactFirstName, contactLastName, phone, addressLine1,
               city, state, postalCode, country, salesRepEmployeeNumber, creditLimit
               FROM customers;"""
    data = data_fetch(query)
    format_param = request.args.get('format')

    if format_param == 'xml':
        response = generate_xml_response(data, root_element="Customers")
        return Response(response, content_type='application/xml')
    else:
        return make_response(jsonify(data), 200)


# search customer by ID (customerNumber)    
@app.route("/customers/<int:id>", methods=["GET"])
def get_customer_by_id(id):
    query = f"""SELECT customerNumber, customerName, contactFirstName, contactLastName, phone, addressLine1,
                city, state, postalCode, country, salesRepEmployeeNumber, creditLimit
                FROM customers WHERE customerNumber = {id};"""
    data = data_fetch(query)
    if data == []:
        return make_response(jsonify(f"Customer {id} has no record in this table"), 404)

    format_param = request.args.get('format')
    if format_param == 'xml':
        response = generate_xml_response(data, root_element="Customer")
        return Response(response, content_type='application/xml')
    else:
        return make_response(jsonify(data), 200)    
    

# show customer orders (note: new added data won't have orders unless input manually in MySQL DB)

@app.route("/customers/<int:id>/orders", methods=["GET"])
def get_customer_orders(id):
    query = f"""SELECT customers.customerNumber, CONCAT(customers.contactFirstName, " ", customers.contactLastName) as "Customer",
                orders.orderDate, products.productName
                FROM products
                INNER JOIN orderdetails ON products.productCode = orderdetails.productCode
                INNER JOIN orders ON orderdetails.orderNumber = orders.orderNumber
                INNER JOIN customers ON orders.customerNumber = customers.customerNumber
                WHERE customers.customerNumber = {id}
                ORDER BY orders.orderDate;"""
    data = data_fetch(query)
    orders = [{"product_name": item["productName"], "order_date": item["orderDate"]} for item in data]
    if data == [] and orders == []:
        return make_response(jsonify(f"Customer {id} has no recorded orders"), 404)

    result = {
        "Customer Id": data[0]['customerNumber'],
        "Customer Name": data[0]['Customer'],
        "No. of Orders": len(data),
        "Orders": orders
    }
    format_param = request.args.get('format')
    if format_param == 'xml':
        response = generate_xml_response(result, root_element="Orders")
        return Response(response, content_type='application/xml')
    return make_response(jsonify(result), 200)

# show customer/s by city (condition: city)
@app.route("/customers/<string:city>", methods=["GET"])
def get_customers_by_city(city):
    query = f"""SELECT customerNumber, customerName, contactFirstName, contactLastName, phone, addressLine1,
                city, state, postalCode, country, salesRepEmployeeNumber, creditLimit
                FROM customers
                WHERE city = '{city}';"""
    data = data_fetch(query)
    if data == []:
        return make_response(jsonify("No recorded customers for this City"), 404)

    format_param = request.args.get('format')
    if format_param == 'xml':
        response = generate_xml_response(data, root_element="City")
        return Response(response, content_type='application/xml')
    result = {"City": data[0]['city'], "Customer Count": len(data), "List of Customers": data}
    return make_response(jsonify(result), 200)
    
    
# UPDATE CUSTOMER DATA

@app.route("/customers/<int:id>", methods=["PUT"])
def update_customer(id):
    info = request.get_json()
    customer_name = info["customerName"]
    first_name = info["contactFirstName"]
    last_name = info["contactLastName"]
    phone = info["phone"]
    street_1 = info["addressLine1"]
    street_2 = info["addressLine2"]
    city = info["city"]
    state = info["state"]
    postal_code = info["postalCode"]
    country = info["country"]
    sales_rep_employee_number = info["salesRepEmployeeNumber"]
    credit_limit = info["creditLimit"]

    check_query = f"SELECT * FROM customers WHERE customerNumber = {id}"
    existing_customer = data_fetch(check_query)
    if not existing_customer:
        return make_response(jsonify(f"Customer {id} does not exist"), 404)

    query = f"""UPDATE customers
                SET customerName = '{customer_name}',
                contactFirstName = '{first_name}',
                contactLastName = '{last_name}',
                phone = '{phone}',
                addressLine1 = '{street_1}',
                addressLine2 = '{street_2}',
                city = '{city}',
                state = '{state}',
                postalCode = '{postal_code}',
                country = '{country}',
                salesRepEmployeeNumber = {sales_rep_employee_number},
                creditLimit = {credit_limit}
                WHERE customerNumber = {id};"""

    data_fetch(query)
    mysql.connection.commit()
    return make_response(jsonify(f"Customer {id} records have been successfully updated"), 201)

    
# DELETE CUSTOMER DATA (ROW)

@app.route("/customers/<int:id>", methods=["DELETE"])
def delete_customer(id):
    check_query = f"SELECT * FROM customers WHERE customerNumber = {id}"
    existing_customer = data_fetch(check_query)
    if not existing_customer:
        return make_response(jsonify(f"Customer {id} does not exist"), 404)

    query = f"DELETE FROM customers WHERE customerNumber = {id};"
    data_fetch(query)
    mysql.connection.commit()
    return make_response(jsonify(f"Customer {id} records have been successfully deleted"), 200)
   
    
    
    
if __name__ == "__main__":
    app.run(debug=True)