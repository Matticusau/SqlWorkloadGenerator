/*******************************************************************************
Scripts adapted from http://msdn.microsoft.com/en-us/library/ms187731%28v=sql.110%29.aspx
*******************************************************************************/

----Query----
SELECT *
FROM SalesLT.Product
ORDER BY Name ASC;

----Query----
SELECT p.*
FROM SalesLT.Product AS p
ORDER BY Name ASC;

----Query----
SELECT Name, ProductNumber, ListPrice AS Price
FROM SalesLT.Product 
ORDER BY Name ASC;

----Query----
SELECT Name, ProductNumber, ListPrice AS Price
FROM SalesLT.Product 
WHERE ProductLine = 'R' 
AND DaysToManufacture < 4
ORDER BY Name ASC;

----Query----
SELECT p.Name AS ProductName, 
NonDiscountSales = (OrderQty * UnitPrice),
Discounts = ((OrderQty * UnitPrice) * UnitPriceDiscount)
FROM SalesLT.Product AS p 
INNER JOIN SalesLT.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID 
ORDER BY ProductName DESC;

----Query----
SELECT 'Total income is', ((OrderQty * UnitPrice) * (1.0 - UnitPriceDiscount)), ' for ',
p.Name AS ProductName 
FROM SalesLT.Product AS p 
INNER JOIN SalesLT.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID 
ORDER BY ProductName ASC;

----Query----
SELECT DISTINCT FirstName, LastName
FROM SalesLT.Customer
ORDER BY LastName, FirstName;

----Query----
SELECT C.CustomerID, C.NameStyle, C.Title, C.FirstName, C.LastName, C.Suffix, C.CompanyName, C.SalesPerson, C.EmailAddress
, C.Phone, CA.AddressType, A.AddressLine1, A.AddressLine2, A.City, A.StateProvince, A.CountryRegion, A.PostalCode
FROM SalesLT.Customer C
INNER JOIN SalesLT.CustomerAddress CA ON CA.CustomerID = C.CustomerID
INNER JOIN SalesLT.Address A ON A.AddressID = CA.AddressID
ORDER BY C.LastName, C.FirstName;

----Query----
SELECT DISTINCT FirstName, LastName
FROM SalesLT.Customer
ORDER BY LastName, FirstName;


----Query----
IF OBJECT_ID (N'#Bicycles',N'U') IS NOT NULL
DROP TABLE #Bicycles;
GO
SELECT * 
INTO #Bicycles
FROM SalesLT.Product
WHERE ProductNumber LIKE 'BK%';

----Query----
SELECT DISTINCT Name
FROM SalesLT.Product AS p 
WHERE EXISTS
    (SELECT *
     FROM SalesLT.ProductModel AS pm 
     WHERE p.ProductModelID = pm.ProductModelID
           AND pm.Name LIKE 'Long-Sleeve Logo Jersey%');

----Query----

SELECT DISTINCT Name
FROM SalesLT.Product
WHERE ProductModelID IN
    (SELECT ProductModelID 
     FROM SalesLT.ProductModel
     WHERE Name LIKE 'Long-Sleeve Logo Jersey%');

----Query----
SELECT p1.ProductModelID
FROM SalesLT.Product AS p1
GROUP BY p1.ProductModelID
HAVING MAX(p1.ListPrice) >= ALL
    (SELECT AVG(p2.ListPrice)
     FROM SalesLT.Product AS p2
     WHERE p1.ProductModelID = p2.ProductModelID);



----Query----
SELECT SalesOrderID, SUM(LineTotal) AS SubTotal
FROM SalesLT.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY SalesOrderID;

----Query----
SELECT ProductID, OrderQty, AVG(UnitPrice) AS [Average Price],
    SUM(LineTotal) AS SubTotal
FROM SalesLT.SalesOrderDetail
GROUP BY ProductID, OrderQty
ORDER BY ProductID;

----Query----
SELECT ProductModelID, AVG(ListPrice) AS [Average List Price]
FROM SalesLT.Product
WHERE ListPrice > $1000
GROUP BY ProductModelID
ORDER BY ProductModelID;

----Query----
SELECT AVG(OrderQty) AS [Average Quantity], 
NonDiscountSales = (OrderQty * UnitPrice)
FROM SalesLT.SalesOrderDetail
GROUP BY (OrderQty * UnitPrice)
ORDER BY (OrderQty * UnitPrice) DESC;

----Query----
SELECT ProductID, AVG(UnitPrice) AS [Average Price]
FROM SalesLT.SalesOrderDetail
WHERE OrderQty > 10
GROUP BY ProductID
ORDER BY AVG(UnitPrice);

----Query----
SELECT ProductID 
FROM SalesLT.SalesOrderDetail
GROUP BY ProductID
HAVING AVG(OrderQty) > 5
ORDER BY ProductID;

----Query----
SELECT SalesOrderID, CarrierTrackingNumber 
FROM SalesLT.SalesOrderDetail
GROUP BY SalesOrderID, CarrierTrackingNumber
HAVING CarrierTrackingNumber LIKE '4BD%'
ORDER BY SalesOrderID;

----Query----
SELECT ProductID 
FROM SalesLT.SalesOrderDetail
WHERE UnitPrice < 25.00
GROUP BY ProductID
HAVING AVG(OrderQty) > 5
ORDER BY ProductID;

----Query----
SELECT ProductID, AVG(OrderQty) AS AverageQuantity, SUM(LineTotal) AS Total
FROM SalesLT.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(LineTotal) > $1000000.00
AND AVG(OrderQty) < 3;

----Query----
SELECT ProductID, Total = SUM(LineTotal)
FROM SalesLT.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(LineTotal) > $2000000.00;

----Query----
SELECT ProductID, SUM(LineTotal) AS Total
FROM SalesLT.SalesOrderDetail
GROUP BY ProductID
HAVING COUNT(*) > 1500;


----Query----
-- Performs an index seek
SELECT C.CustomerID, C.NameStyle, C.Title, C.FirstName, C.LastName, C.Suffix, C.CompanyName, C.SalesPerson, C.EmailAddress
, C.Phone, CA.AddressType, A.AddressLine1, A.AddressLine2, A.City, A.StateProvince, A.CountryRegion, A.PostalCode
FROM SalesLT.Customer C 
INNER JOIN SalesLT.CustomerAddress CA ON CA.CustomerID = C.CustomerID
INNER JOIN SalesLT.Address A ON A.AddressID = CA.AddressID
WHERE C.EmailAddress = 'martha0@adventure-works.com'
ORDER BY C.LastName, C.FirstName;

----Query----
-- Force a table scan by using INDEX = 0.
SELECT C.CustomerID, C.NameStyle, C.Title, C.FirstName, C.LastName, C.Suffix, C.CompanyName, C.SalesPerson, C.EmailAddress
, C.Phone, CA.AddressType, A.AddressLine1, A.AddressLine2, A.City, A.StateProvince, A.CountryRegion, A.PostalCode
FROM SalesLT.Customer C WITH (INDEX = 0)
INNER JOIN SalesLT.CustomerAddress CA ON CA.CustomerID = C.CustomerID
INNER JOIN SalesLT.Address A ON A.AddressID = CA.AddressID
WHERE C.EmailAddress = 'martha0@adventure-works.com'
ORDER BY C.LastName, C.FirstName;


----Query----
SELECT ProductID, OrderQty, SUM(LineTotal) AS Total
FROM SalesLT.SalesOrderDetail
WHERE UnitPrice < $5.00
GROUP BY ProductID, OrderQty
ORDER BY ProductID, OrderQty
OPTION (HASH GROUP, FAST 10);

----Query----
SELECT BusinessEntityID, JobTitle, HireDate, VacationHours, SickLeaveHours
FROM HumanResources.Employee AS e1
UNION
SELECT BusinessEntityID, JobTitle, HireDate, VacationHours, SickLeaveHours
FROM HumanResources.Employee AS e2
OPTION (MERGE UNION);

----Query----
-- Here is the simple union.
SELECT ProductModelID, Name
FROM SalesLT.ProductModel AS pm1
WHERE ProductModelID NOT IN (3, 4)
UNION
SELECT ProductModelID, Name
FROM SalesLT.ProductModel AS pm2
WHERE ProductModelID IN (3, 4)
ORDER BY Name;

----Query----
-- Union ALL 1
SELECT LastName, FirstName, EmailAddress
FROM SalesLT.Customer as C1
UNION ALL
SELECT LastName, FirstName, EmailAddress
FROM SalesLT.Customer as C2
UNION ALL
SELECT LastName, FirstName, EmailAddress
FROM SalesLT.Customer as C3

----Query----
-- Union ALL 2
SELECT LastName, FirstName, EmailAddress
FROM SalesLT.Customer as C1
UNION
SELECT LastName, FirstName, EmailAddress
FROM SalesLT.Customer as C2
UNION
SELECT LastName, FirstName, EmailAddress
FROM SalesLT.Customer as C3

----Query----
-- Union ALL 3
SELECT LastName, FirstName, EmailAddress
FROM SalesLT.Customer as C1
UNION ALL
(
SELECT LastName, FirstName, EmailAddress
FROM SalesLT.Customer as C2
UNION
SELECT LastName, FirstName, EmailAddress
FROM SalesLT.Customer as C3
);

