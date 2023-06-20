@echo off
setlocal enabledelayedexpansion


start "Customer Management System" cmd /k "python api_finals.py"

:main
cls
echo.
echo   _____         __                       ________  __  _____ 
echo  / ___/_ _____ / /____  __ _  ___ ____  / ___/ _ \/ / / / _ \
echo / /__/ // ^(_-^</ __/ _ \/  ' \/ -_^) __/ / /__/ , _/ /_/ / // /
echo \___/\_,_/___/\__/\___/_/_/_/\__/_/    \___/_/^|_^|\____/____/ 
echo.


curl http://127.0.0.1:5000/

choice /c 1234e /N

if %ERRORLEVEL% == 1 (
	cls
	goto add
) else if %ERRORLEVEL% == 2 (
	cls
	goto retrieve
) else if %ERRORLEVEL% == 3 (
	cls
	goto update
) else if %ERRORLEVEL% == 4 (
	cls
	goto delete
) else if %ERRORLEVEL% == 5 (
	cls
	goto end
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
	cls
	goto add
)
if "%contactLastName%"=="" (
	echo Contact Last Name cannot be empty
	pause
	cls
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


choice /c 12345 /N

if %ERRORLEVEL% == 1 (
	cls
	goto all_format
) else if %ERRORLEVEL% == 2 (
	cls
	goto search
) else if %ERRORLEVEL% == 3 (
	cls
	goto orders
) else if %ERRORLEVEL% == 4 (
	cls
	goto city
) else if %ERRORLEVEL% == 5 (
	cls
	goto main
) else (
    echo ERROR!
    pause
    goto retrieve
)

:all_format
echo ==============
echo SELECT FORMAT
echo [1] JSON
echo [2] XML
echo ==============

choice /c 12 /N
if %ERRORLEVEL% == 1 (
	cls
	curl http://127.0.0.1:5000/customers
	pause
	goto retrieve_end
) else if %ERRORLEVEL% == 2 (
	cls
	curl http://127.0.0.1:5000/customers?format=xml
	pause
	goto retrieve_end
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
	cls
	goto search
)
echo ==============
echo SELECT FORMAT
echo [1] JSON
echo [2] XML
echo ==============
choice /c 12 /N
if %ERRORLEVEL% == 1 (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%search_customer_id%
	pause
	goto retrieve_end
) else if %ERRORLEVEL% == 2 (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%search_customer_id%?format=xml
	pause
	goto retrieve_end
)

:orders
echo ============================
echo SHOW CUSTOMERS ORDERS BY ID
echo ============================
echo.
set /p "search_by_orders=Enter Customer ID: "


if "%search_by_orders%"=="" (
	echo Customer ID cannot be empty
	pause
	cls
	goto orders
)
echo ==============
echo SELECT FORMAT
echo [1] JSON
echo [2] XML
echo ==============

choice /c 12 /N
if %ERRORLEVEL% == 1 (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%search_by_orders%/orders
	pause
	goto retrieve_end
) else if %ERRORLEVEL% == 2 (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%search_by_orders%/orders?format=xml
	pause
	goto retrieve_end
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
	cls
	goto city
)

set "encodedCity=!city: =%%20!"
echo ==============
echo SELECT FORMAT
echo [1] JSON
echo [2] XML
echo ==============
choice /c 12 /N
if %ERRORLEVEL% == 1 (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%encodedCity%
	pause
	goto retrieve_end
) else if %ERRORLEVEL% == 2 (
	cls
	curl -X GET http://127.0.0.1:5000/customers/%encodedCity%?format=xml
	pause
	goto retrieve_end
)

:retrieve_end
echo Returning to Retrieve Menu...
goto retrieve



:update
echo ================
echo UPDATE CUSTOMER
echo ================
echo.
set /p "update_customer=Enter Customer ID: "

if "%update_customer%"=="" (
	echo Customer ID cannot be empty
	pause
	cls
	goto update
)

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
	cls
	goto update
)
if "%contactLastName%"=="" (
	echo Contact Last Name cannot be empty
	pause
	cls
	goto update
)

curl -X PUT -H "Content-Type: application/json" -d "{ \"customerName\": \"%customerName%\", \"contactLastName\": \"%contactLastName%\", \"contactFirstName\": \"%contactFirstName%\", \"phone\": \"%phone%\", \"addressLine1\": \"%addressLine1%\", \"addressLine2\": \"%addressLine2%\", \"city\": \"%city%\", \"state\": \"%state%\", \"postalCode\": \"%postalCode%\", \"country\": \"%country%\", \"salesRepEmployeeNumber\": %salesRepEmployeeNumber%, \"creditLimit\": %creditLimit% }" http://127.0.0.1:5000/customers/%update_customer%

pause
goto main

:delete
echo ================
echo DELETE CUSTOMER 
echo ================
echo.
set /p "delete_customer=Enter Customer ID: "
if "%delete_customer%"=="" (
	echo Customer ID cannot be empty
	pause
	cls
	goto delete
)

echo Are you sure you want to delete customer %delete_customer%? (Y/N)
choice /c YN /N
if %ERRORLEVEL% == 1 (
	curl -X DELETE http://127.0.0.1:5000/customers/%delete_customer%
) else if %ERRORLEVEL% == 2 (
	echo Deletion canceled.
)
pause
goto main


:end
echo Thankyou for using the Customer Management System.
pause
exit
