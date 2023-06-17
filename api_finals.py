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
        for key, value in data.items():
            sub_element = ET.SubElement(element, key)
            sub_element.text = str(value)

    xml_string = ET.tostring(root, encoding='utf-8', method='xml')
    readable_xml = xml.dom.minidom.parseString(xml_string).toprettyxml(indent="  ")
    return readable_xml