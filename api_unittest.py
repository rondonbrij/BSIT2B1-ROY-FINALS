import unittest
import warnings
from api_finals import app


class MyAppTests(unittest.TestCase):
    def setUp(self):
        app.config["TESTING"] = True
        self.app = app.test_client()

        warnings.simplefilter("ignore", category=DeprecationWarning)

    def test_main_page(self):
        response = self.app.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.data.decode(), """
    ==============================
    Classic Models Customers CRUD

    SELECT OPERATION
    [1] Add Customers
    [2] Retrieve Customers
    [3] Update Customers
    [4] Delete Customers
    [E] Exit
    ==============================
    """)
    #get functions
    def test_customers(self):
        response = self.app.get("/customers")
        self.assertEqual(response.status_code, 200)
        self.assertTrue("King" in response.data.decode())

    def test_getcustomers_by_id(self):
        response = self.app.get("/customers/114")
        self.assertEqual(response.status_code, 200)
        self.assertTrue("Ferguson" in response.data.decode())

    def test_get_customer_by_id_not_found(self):
        response = self.app.get(f"/customers/103")
        self.assertEqual(response.status_code, 404) 

    def test_get_customers_order(self):
        response = self.app.get("/customers/114/orders")
        self.assertEqual(response.status_code, 200)
        self.assertTrue("Ferguson" in response.data.decode()) 
    
    def test_get_customer_orders_not_found(self):
        response = self.app.get(f"/customers/500/orders")
        self.assertEqual(response.status_code, 404)

    def test_get_customers_by_city(self):
        response = self.app.get("/customers/London")
        self.assertEqual(response.status_code, 200)
        self.assertTrue("Brown" in response.data.decode())
    
    def test_get_customers_by_city_not_found(self):
        response = self.app.get(f"/customers/Bombastic City")
        self.assertEqual(response.status_code, 404) 

    def test_add_customer(self):
        data = {
            "customerName": "LG",
            "contactFirstName": "Good",
            "contactLastName": "Life",
            "phone": "00000987654",
            "addressLine1": "San Miguel",
            "addressLine2": "San Manuel",
            "city": "PPC",
            "state": "Palawan",
            "postalCode": "5300",
            "country": "PH",
            "salesRepEmployeeNumber": "1370",
            "creditLimit": "69696969"
        }
        response = self.app.post("/customers", json=data)
        self.assertEqual(response.status_code, 201)

    def test_update_customer(self):
        data = {
            "customerName": "Animal INC",
            "contactFirstName": "Doggy",
            "contactLastName": "Catty",
            "phone": "09876543212",
            "addressLine1": "Wano",
            "addressLine2": "Cake Isle",
            "city": "Cebu City",
            "state": "Cebu Province",
            "postalCode": "6000",
            "country": "PH",
            "salesRepEmployeeNumber": "1370",
            "creditLimit": "6666"

        }
        response = self.app.put("/customers/502", json=data)
        self.assertEqual(response.status_code, 201)

    def test_update_customer_non_existing(self):
        data = {
            "customerName": "Animal INC",
            "contactFirstName": "Doggy",
            "contactLastName": "Catty",
            "phone": "09876543212",
            "addressLine1": "Wano",
            "addressLine2": "Cake Isle",
            "city": "Cebu City",
            "state": "Cebu Province",
            "postalCode": "6000",
            "country": "PH",
            "salesRepEmployeeNumber": "1370",
            "creditLimit": "6666"

        }
        response = self.app.put("/customers/666", json=data)
        self.assertEqual(response.status_code, 404)
    
    def test_delete_customer(self):
        response = self.app.delete("/customers/503")
        self.assertEqual(response.status_code, 200)

    def test_delete_customer_non_existing(self):
        response = self.app.delete("/customers/508")
        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.json, "Customer 508 does not exist")
     


if __name__ == "__main__":
    unittest.main()
    
    
    
    