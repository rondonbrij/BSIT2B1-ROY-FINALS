@echo off

start cmd /k title "Customer Management System" & python api_finals.py

:main
echo.
echo   _____         __                       ________  __  _____ 
echo  / ___/_ _____ / /____  __ _  ___ ____  / ___/ _ \/ / / / _ \
echo / /__/ // ^(_-^</ __/ _ \/  ' \/ -_^) __/ / /__/ , _/ /_/ / // /
echo \___/\_,_/___/\__/\___/_/_/_/\__/_/    \___/_/^|_^|\____/____/ 
echo.


curl http://127.0.0.1:5000

set /p choice=Enter your choice (1-4 or e): 

if "%choice%"=="1" (
	cls
	goto add
) else if "%choice%"=="2" (
	cls
	goto retrieve
) else if "%choice%"=="3" (
	cls
	goto update
) else if "%choice%"=="4" (
	cls
	goto delete
) else if "%choice%"=="e" (
	cls
	goto end
) else (
	echo Invalid Choice!
	goto main
)

:add

echo =================
echo ADD NEW CUSTOMER
echo =================
echo.
set /p "customerName=Enter Company Name: "
set /p "contactLastName=Enter Customer Last Name: "
set /p "contactFirstName=Enter Customer First Name: "
set /p "phone=Enter Phone Number: "
set /p "addressLine1=Enter Address Line 1: "
set /p "addressLine2=Enter Address Line 2: "
set /p "city=Enter City: "
set /p "state=Enter State: "
set /p "postalCode=Enter Postal Code: "
set /p "country=Enter Country: "
set /p "salesRepEmployeeNumber=Enter Sales Rep Employee Number: "
set /p "creditLimit=Enter Credit Limit: "

rem Validate input (customerName and contactLastName cannot be empty)

if "%customerName%"=="" (
	echo Customer Name cannot be empty
	pause
	goto add
)
if "%contactLastName%"=="" (
	echo Contact Last Name cannot be empty
	pause
	goto add
)

curl -X POST -H "Content-Type: application/json" -d "{ \"customerName\": \"%customerName%\", \"contactLastName\": \"%contactLastName%\", \"contactFirstName\": \"%contactFirstName%\", \"phone\": \"%phone%\", \"addressLine1\": \"%addressLine1%\", \"addressLine2\": \"%addressLine2%\", \"city\": \"%city%\", \"state\": \"%state%\", \"postalCode\": \"%postalCode%\", \"country\": \"%country%\", \"salesRepEmployeeNumber\": %salesRepEmployeeNumber%, \"creditLimit\": %creditLimit% }" http://127.0.0.1:5000/customers
pause
goto main


:retrieve
cls

echo =========
echo RETRIEVE
echo =========
echo.
echo SELECT OPERATION
echo [1] Retrieve All Customers
echo [2] Search Customer
echo [3] Show Customer Orders
echo [4] Show Customers by City
echo [5] Back

set /p "retrieve_operation=Enter operation number: "

if "%retrieve_operation%"=="1" (
	cls
	goto all
) else if "%retrieve_operation%"=="2" (
	cls
	goto search
) else if "%retrieve_operation%"=="3" (
	cls
	goto orders
) else if "%retrieve_operation%"=="4" (
	cls
	goto city
) else if "%retrieve_operation%"=="5" (
	goto main
) else (
	echo Invalid option, please try again!
	pause
	goto retrieve
)

:all_format
echo ==============
echo SELECT FORMAT
echo [1] JSON
echo [2] XML
echo ==============

set /p "format=Enter format number: "
if "%format%"=="1" (
	cls
	curl http://127.0.0.1:5000/customers
	pause
	goto retrieve_end
) else if "%format%"=="2" (
	cls
	curl http://127.0.0.1:5000/customers?format=xml
	pause
	goto retrieve_end
) else (
	echo Invalid option, please try again!
	pause
	goto all
)

:search
echo ===================
echo SEARCH CUSTOMER ID
echo ===================
echo.
set /p "search_customer_id=Enter Customer ID: "

if "%search_customer_id%"=="" (
	echo Customer ID cannot be empty
	pause
	goto search
)

:search_format
echo ==============
echo SELECT FORMAT
echo [1] JSON
echo [2] XML
echo ==============
set /p "format=Enter format number: "
if "%format%"=="1" (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%search_customer_id%
	pause
	goto retrieve_end
) else if "%format%"=="2" (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%search_customer_id%?format=xml
	pause
	goto retrieve_end
) else (
	echo Invalid option, please try again!
	pause
	goto search_format
)

:orders
echo ============================
echo SHOW CUSTOMERS ID BY ORDERS
echo ============================
echo.
set /p "search_by_orders=Enter Customer ID: "

if "%search_by_orders%"=="" (
	echo Customer ID cannot be empty
	pause
	goto search
)

:orders_format
echo ==============
echo SELECT FORMAT
echo [1] JSON
echo [2] XML
echo ==============
set /p "format=Enter format number: "
if "%format%"=="1" (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%search_by_orders%/orders
	pause
	goto retrieve_end
) else if "%format%"=="2" (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%search_by_orders%/orders?format=xml
	pause
	goto retrieve_end
) else (
	echo Invalid option, please try again!
	pause
	goto orders_format
)

:city
echo =======================
echo SHOW CUSTOMERS BY CITY
echo =======================
echo.
set /p "city=Enter city: "

rem Validate input (city cannot be empty)
if "%city%"=="" (
	echo City cannot be empty
	pause
	goto retrieve
)

:city_format
set "encodedCity=!city: =%%20!"
echo ==============
echo SELECT FORMAT
echo [1] JSON
echo [2] XML
echo ==============
set /p "format=Enter format number: "
if "%format%"=="1" (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%encodedCity%
	pause
	goto retrieve_end
) else if "%format%"=="2" (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%encodedCity%?format=xml
	pause
	goto retrieve_end
) else (
	echo Invalid option, please try again!
	pause
	goto city_format
)

:retrieve_end
echo Returning to Retrieve Menu...
goto retrieve



:update
:delete
:end