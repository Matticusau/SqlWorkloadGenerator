/*******************************************************************************
Scripts from http://msdn.microsoft.com/en-us/library/ms187731%28v=sql.110%29.aspx
*******************************************************************************/

----Query----
SELECT *
FROM Production.Product
ORDER BY Name ASC;

----Query----
SELECT p.*
FROM Production.Product AS p
ORDER BY Name ASC;

----Query----
SELECT Name, ProductNumber, ListPrice AS Price
FROM Production.Product 
ORDER BY Name ASC;

----Query----
SELECT Name, ProductNumber, ListPrice AS Price
FROM Production.Product 
WHERE ProductLine = 'R' 
AND DaysToManufacture < 4
ORDER BY Name ASC;

----Query----
SELECT p.Name AS ProductName, 
NonDiscountSales = (OrderQty * UnitPrice),
Discounts = ((OrderQty * UnitPrice) * UnitPriceDiscount)
FROM Production.Product AS p 
INNER JOIN Sales.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID 
ORDER BY ProductName DESC;

----Query----
SELECT 'Total income is', ((OrderQty * UnitPrice) * (1.0 - UnitPriceDiscount)), ' for ',
p.Name AS ProductName 
FROM Production.Product AS p 
INNER JOIN Sales.SalesOrderDetail AS sod
ON p.ProductID = sod.ProductID 
ORDER BY ProductName ASC;

----Query----
SELECT DISTINCT JobTitle
FROM HumanResources.Employee
ORDER BY JobTitle;

----Query----
USE tempdb;
GO
IF OBJECT_ID (N'#Bicycles',N'U') IS NOT NULL
DROP TABLE #Bicycles;
GO
SELECT * 
INTO #Bicycles
FROM Production.Product
WHERE ProductNumber LIKE 'BK%';

----Query----
SELECT DISTINCT Name
FROM Production.Product AS p 
WHERE EXISTS
    (SELECT *
     FROM Production.ProductModel AS pm 
     WHERE p.ProductModelID = pm.ProductModelID
           AND pm.Name LIKE 'Long-Sleeve Logo Jersey%');

----Query----

SELECT DISTINCT Name
FROM Production.Product
WHERE ProductModelID IN
    (SELECT ProductModelID 
     FROM Production.ProductModel
     WHERE Name LIKE 'Long-Sleeve Logo Jersey%');

----Query----
SELECT DISTINCT p.LastName, p.FirstName 
FROM Person.Person AS p 
JOIN HumanResources.Employee AS e
    ON e.BusinessEntityID = p.BusinessEntityID WHERE 5000.00 IN
    (SELECT Bonus
     FROM Sales.SalesPerson AS sp
     WHERE e.BusinessEntityID = sp.BusinessEntityID);

----Query----
SELECT p1.ProductModelID
FROM Production.Product AS p1
GROUP BY p1.ProductModelID
HAVING MAX(p1.ListPrice) >= ALL
    (SELECT AVG(p2.ListPrice)
     FROM Production.Product AS p2
     WHERE p1.ProductModelID = p2.ProductModelID);

----Query----
SELECT DISTINCT pp.LastName, pp.FirstName 
FROM Person.Person pp JOIN HumanResources.Employee e
ON e.BusinessEntityID = pp.BusinessEntityID WHERE pp.BusinessEntityID IN 
(SELECT SalesPersonID 
FROM Sales.SalesOrderHeader
WHERE SalesOrderID IN 
(SELECT SalesOrderID 
FROM Sales.SalesOrderDetail
WHERE ProductID IN 
(SELECT ProductID 
FROM Production.Product p 
WHERE ProductNumber = 'BK-M68B-42')));

----Query----
SELECT SalesOrderID, SUM(LineTotal) AS SubTotal
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY SalesOrderID;

----Query----
SELECT ProductID, SpecialOfferID, AVG(UnitPrice) AS [Average Price], 
    SUM(LineTotal) AS SubTotal
FROM Sales.SalesOrderDetail
GROUP BY ProductID, SpecialOfferID
ORDER BY ProductID;

----Query----
SELECT ProductModelID, AVG(ListPrice) AS [Average List Price]
FROM Production.Product
WHERE ListPrice > $1000
GROUP BY ProductModelID
ORDER BY ProductModelID;

----Query----
SELECT AVG(OrderQty) AS [Average Quantity], 
NonDiscountSales = (OrderQty * UnitPrice)
FROM Sales.SalesOrderDetail
GROUP BY (OrderQty * UnitPrice)
ORDER BY (OrderQty * UnitPrice) DESC;

----Query----
SELECT ProductID, AVG(UnitPrice) AS [Average Price]
FROM Sales.SalesOrderDetail
WHERE OrderQty > 10
GROUP BY ProductID
ORDER BY AVG(UnitPrice);

----Query----
SELECT ProductID 
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING AVG(OrderQty) > 5
ORDER BY ProductID;

----Query----
SELECT SalesOrderID, CarrierTrackingNumber 
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID, CarrierTrackingNumber
HAVING CarrierTrackingNumber LIKE '4BD%'
ORDER BY SalesOrderID ;

----Query----
SELECT ProductID 
FROM Sales.SalesOrderDetail
WHERE UnitPrice < 25.00
GROUP BY ProductID
HAVING AVG(OrderQty) > 5
ORDER BY ProductID;

----Query----
SELECT ProductID, AVG(OrderQty) AS AverageQuantity, SUM(LineTotal) AS Total
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(LineTotal) > $1000000.00
AND AVG(OrderQty) < 3;

----Query----
SELECT ProductID, Total = SUM(LineTotal)
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(LineTotal) > $2000000.00;

----Query----
SELECT ProductID, SUM(LineTotal) AS Total
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING COUNT(*) > 1500;

----Query----
SELECT pp.FirstName, pp.LastName, e.NationalIDNumber
FROM HumanResources.Employee AS e WITH (INDEX(AK_Employee_NationalIDNumber))
JOIN Person.Person AS pp on e.BusinessEntityID = pp.BusinessEntityID
WHERE LastName = 'Johnson';

----Query----
-- Force a table scan by using INDEX = 0.
SELECT pp.LastName, pp.FirstName, e.JobTitle
FROM HumanResources.Employee AS e WITH (INDEX = 0) JOIN Person.Person AS pp
ON e.BusinessEntityID = pp.BusinessEntityID
WHERE LastName = 'Johnson';

----Query----
SELECT ProductID, OrderQty, SUM(LineTotal) AS Total
FROM Sales.SalesOrderDetail
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
FROM Production.ProductModel
WHERE ProductModelID NOT IN (3, 4)
UNION
SELECT ProductModelID, Name
FROM dbo.Gloves
ORDER BY Name;

----Query----
SELECT ProductModelID, Name 
FROM dbo.ProductResults;

----Query----
/* Union */
SELECT ProductModelID, Name
FROM Production.ProductModel
WHERE ProductModelID NOT IN (3, 4)
UNION
SELECT ProductModelID, Name
FROM dbo.Gloves
ORDER BY Name;

----Query----
-- Union ALL
SELECT LastName, FirstName, JobTitle
FROM dbo.EmployeeOne
UNION ALL
SELECT LastName, FirstName ,JobTitle
FROM dbo.EmployeeTwo
UNION ALL
SELECT LastName, FirstName,JobTitle 
FROM dbo.EmployeeThree;

----Query----
-- Union ALL 2
SELECT LastName, FirstName,JobTitle
FROM dbo.EmployeeOne
UNION 
SELECT LastName, FirstName, JobTitle 
FROM dbo.EmployeeTwo
UNION 
SELECT LastName, FirstName, JobTitle 
FROM dbo.EmployeeThree;

----Query----
-- Union ALL 3
SELECT LastName, FirstName,JobTitle 
FROM dbo.EmployeeOne
UNION ALL
(
SELECT LastName, FirstName, JobTitle 
FROM dbo.EmployeeTwo
UNION
SELECT LastName, FirstName, JobTitle 
FROM dbo.EmployeeThree
);


----Query----
/*******************************************************************************
Scripts from http://msdn.microsoft.com/en-us/library/bb510625.aspx
*******************************************************************************/

----Query----
-- Test the procedure
EXEC InsertUnitMeasure @UnitMeasureCode = 'ABC', @Name = 'New Test Value';
EXEC InsertUnitMeasure @UnitMeasureCode = 'XYZ', @Name = 'Test Value';
EXEC InsertUnitMeasure @UnitMeasureCode = 'ABC', @Name = 'Another Test Value';

-- Cleanup 
DELETE FROM Production.UnitMeasure WHERE UnitMeasureCode IN ('ABC','XYZ');


----Query----
EXECUTE Production.usp_UpdateInventory '20030501'

----Query----
-- Create a temporary table variable to hold the output actions.
DECLARE @SummaryOfChanges TABLE(Change VARCHAR(20));

MERGE INTO Sales.SalesReason AS Target
USING (VALUES ('Recommendation','Other'), ('Review', 'Marketing'), ('Internet', 'Promotion'))
       AS Source (NewName, NewReasonType)
ON Target.Name = Source.NewName
WHEN MATCHED THEN
	UPDATE SET ReasonType = Source.NewReasonType
WHEN NOT MATCHED BY TARGET THEN
	INSERT (Name, ReasonType) VALUES (NewName, NewReasonType)
OUTPUT $action INTO @SummaryOfChanges;

-- Query the results of the table variable.
SELECT Change, COUNT(*) AS CountPerChange
FROM @SummaryOfChanges
GROUP BY Change;

----Query----
INSERT INTO Production.UpdatedInventory
SELECT ProductID, LocationID, NewQty, PreviousQty 
FROM
(    MERGE Production.ProductInventory AS pi
     USING (SELECT ProductID, SUM(OrderQty) 
            FROM Sales.SalesOrderDetail AS sod
            JOIN Sales.SalesOrderHeader AS soh
            ON sod.SalesOrderID = soh.SalesOrderID
            AND soh.OrderDate BETWEEN '20030701' AND '20030731'
            GROUP BY ProductID) AS src (ProductID, OrderQty)
     ON pi.ProductID = src.ProductID
    WHEN MATCHED AND pi.Quantity - src.OrderQty >= 0 
        THEN UPDATE SET pi.Quantity = pi.Quantity - src.OrderQty
    WHEN MATCHED AND pi.Quantity - src.OrderQty <= 0 
        THEN DELETE
    OUTPUT $action, Inserted.ProductID, Inserted.LocationID, Inserted.Quantity AS NewQty, Deleted.Quantity AS PreviousQty)
 AS Changes (Action, ProductID, LocationID, NewQty, PreviousQty) WHERE Action = 'UPDATE';





/*******************************************************************************
Scripts from http://msdn.microsoft.com/en-us/library/ms174335.aspx
*******************************************************************************/

----Query----
INSERT INTO Production.UnitMeasure
VALUES (N'FT', N'Feet', '20080414');

----Query----
INSERT INTO Production.UnitMeasure
VALUES (N'FT2', N'Square Feet ', '20080923'), (N'Y', N'Yards', '20080923'), (N'Y3', N'Cubic Yards', '20080923');

----Query----
INSERT INTO Production.UnitMeasure (Name, UnitMeasureCode,
    ModifiedDate)
VALUES (N'Square Yards', N'Y2', GETDATE());

----Query----
INSERT INTO dbo.T1 (column_4) 
    VALUES ('Explicit value');
INSERT INTO dbo.T1 (column_2, column_4) 
    VALUES ('Explicit value', 'Explicit value');
INSERT INTO dbo.T1 (column_2) 
    VALUES ('Explicit value');
INSERT INTO T1 DEFAULT VALUES; 
SELECT column_1, column_2, column_3, column_4
FROM dbo.T1;

----Query----
INSERT T1 VALUES ('Row #1');
INSERT T1 (column_2) VALUES ('Row #2');
SET IDENTITY_INSERT T1 ON;
INSERT INTO T1 (column_1,column_2) 
    VALUES (-99, 'Explicit identity value');
SELECT column_1, column_2
FROM T1;

----Query----
INSERT INTO dbo.T1 (column_2) 
    VALUES (NEWID());
INSERT INTO T1 DEFAULT VALUES; 
SELECT column_1, column_2
FROM dbo.T1;

----Query----
--INSERT...SELECT example
INSERT INTO dbo.EmployeeSales
    SELECT 'SELECT', sp.BusinessEntityID, c.LastName, sp.SalesYTD 
    FROM Sales.SalesPerson AS sp
    INNER JOIN Person.Person AS c
        ON sp.BusinessEntityID = c.BusinessEntityID
    WHERE sp.BusinessEntityID LIKE '2%'
    ORDER BY sp.BusinessEntityID, c.LastName;
--INSERT...EXECUTE procedure example
INSERT INTO dbo.EmployeeSales 
EXECUTE dbo.uspGetEmployeeSales;
--INSERT...EXECUTE('string') example
INSERT INTO dbo.EmployeeSales 
EXECUTE 
('
SELECT ''EXEC STRING'', sp.BusinessEntityID, c.LastName, 
    sp.SalesYTD 
    FROM Sales.SalesPerson AS sp 
    INNER JOIN Person.Person AS c
        ON sp.BusinessEntityID = c.BusinessEntityID
    WHERE sp.BusinessEntityID LIKE ''2%''
    ORDER BY sp.BusinessEntityID, c.LastName
');
--Show results.
SELECT DataSource,BusinessEntityID,LastName,SalesDollars
FROM dbo.EmployeeSales;

----Query----
WITH EmployeeTemp (EmpID, LastName, FirstName, Phone, 
                   Address, City, StateProvince, 
                   PostalCode, CurrentFlag)
AS (SELECT 
       e.BusinessEntityID, c.LastName, c.FirstName, pp.PhoneNumber,
       a.AddressLine1, a.City, sp.StateProvinceCode, 
       a.PostalCode, e.CurrentFlag
    FROM HumanResources.Employee e
        INNER JOIN Person.BusinessEntityAddress AS bea
        ON e.BusinessEntityID = bea.BusinessEntityID
        INNER JOIN Person.Address AS a
        ON bea.AddressID = a.AddressID
        INNER JOIN Person.PersonPhone AS pp
        ON e.BusinessEntityID = pp.BusinessEntityID
        INNER JOIN Person.StateProvince AS sp
        ON a.StateProvinceID = sp.StateProvinceID
        INNER JOIN Person.Person as c
        ON e.BusinessEntityID = c.BusinessEntityID
    )
INSERT INTO HumanResources.NewEmployee 
    SELECT EmpID, LastName, FirstName, Phone, 
           Address, City, StateProvince, PostalCode, CurrentFlag
    FROM EmployeeTemp;

----Query----
INSERT TOP(5)INTO dbo.EmployeeSales
    OUTPUT inserted.EmployeeID, inserted.FirstName, inserted.LastName, inserted.YearlySales
    SELECT sp.BusinessEntityID, c.LastName, c.FirstName, sp.SalesYTD 
    FROM Sales.SalesPerson AS sp
    INNER JOIN Person.Person AS c
        ON sp.BusinessEntityID = c.BusinessEntityID
    WHERE sp.SalesYTD > 250000.00
    ORDER BY sp.SalesYTD DESC;

----Query----
INSERT INTO dbo.EmployeeSales
    OUTPUT inserted.EmployeeID, inserted.FirstName, inserted.LastName, inserted.YearlySales
    SELECT TOP (5) sp.BusinessEntityID, c.LastName, c.FirstName, sp.SalesYTD 
    FROM Sales.SalesPerson AS sp
    INNER JOIN Person.Person AS c
        ON sp.BusinessEntityID = c.BusinessEntityID
    WHERE sp.SalesYTD > 250000.00
    ORDER BY sp.SalesYTD DESC;

----Query----
INSERT INTO V1 
    VALUES ('Row 1',1);
SELECT column_1, column_2 
FROM T1;
SELECT column_1, column_2
FROM V1;

----Query----
-- Create the table variable.
DECLARE @MyTableVar table(
    LocationID int NOT NULL,
    CostRate smallmoney NOT NULL,
    NewCostRate AS CostRate * 1.5,
    ModifiedDate datetime);

-- Insert values into the table variable.
INSERT INTO @MyTableVar (LocationID, CostRate, ModifiedDate)
    SELECT LocationID, CostRate, GETDATE() FROM Production.Location
    WHERE CostRate > 0;

-- View the table variable result set.
SELECT * FROM @MyTableVar;  




/*******************************************************************************
Scripts from http://msdn.microsoft.com/en-us/library/ms177523.aspx
*******************************************************************************/

----Query----
UPDATE Person.Address
SET ModifiedDate = GETDATE();

----Query----
UPDATE Sales.SalesPerson
SET Bonus = 6000, CommissionPct = .10, SalesQuota = NULL;

----Query----
UPDATE Production.Product
SET Color = N'Metallic Red'
WHERE Name LIKE N'Road-250%' AND Color = N'Red';

----Query----
UPDATE TOP (10) HumanResources.Employee
SET VacationHours = VacationHours * 1.25 ;

----Query----
UPDATE HumanResources.Employee
SET VacationHours = VacationHours + 8
FROM (SELECT TOP 10 BusinessEntityID FROM HumanResources.Employee
     ORDER BY HireDate ASC) AS th
WHERE HumanResources.Employee.BusinessEntityID = th.BusinessEntityID;

----Query----
WITH Parts(AssemblyID, ComponentID, PerAssemblyQty, EndDate, ComponentLevel) AS
(
    SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty,
        b.EndDate, 0 AS ComponentLevel
    FROM Production.BillOfMaterials AS b
    WHERE b.ProductAssemblyID = 800
          AND b.EndDate IS NULL
    UNION ALL
    SELECT bom.ProductAssemblyID, bom.ComponentID, p.PerAssemblyQty,
        bom.EndDate, ComponentLevel + 1
    FROM Production.BillOfMaterials AS bom 
        INNER JOIN Parts AS p
        ON bom.ProductAssemblyID = p.ComponentID
        AND bom.EndDate IS NULL
)
UPDATE Production.BillOfMaterials
SET PerAssemblyQty = c.PerAssemblyQty * 2
FROM Production.BillOfMaterials AS c
JOIN Parts AS d ON c.ProductAssemblyID = d.AssemblyID
WHERE d.ComponentLevel = 0; 

----Query----
DECLARE complex_cursor CURSOR FOR
    SELECT a.BusinessEntityID
    FROM HumanResources.EmployeePayHistory AS a
    WHERE RateChangeDate <> 
         (SELECT MAX(RateChangeDate)
          FROM HumanResources.EmployeePayHistory AS b
          WHERE a.BusinessEntityID = b.BusinessEntityID) ;
OPEN complex_cursor;
FETCH FROM complex_cursor;
UPDATE HumanResources.EmployeePayHistory
SET PayFrequency = 2 
WHERE CURRENT OF complex_cursor;
CLOSE complex_cursor;
DEALLOCATE complex_cursor;

----Query----
UPDATE Production.Product
SET ListPrice = ListPrice * 2;

----Query----
DECLARE @NewPrice int = 10;
UPDATE Production.Product
SET ListPrice += @NewPrice
WHERE Color = N'Red';

----Query----
UPDATE Production.ScrapReason 
SET Name += ' - tool malfunction'
WHERE ScrapReasonID BETWEEN 10 and 12;

----Query----
UPDATE Sales.SalesPerson
SET SalesYTD = SalesYTD + 
    (SELECT SUM(so.SubTotal) 
     FROM Sales.SalesOrderHeader AS so
     WHERE so.OrderDate = (SELECT MAX(OrderDate)
                           FROM Sales.SalesOrderHeader AS so2
                           WHERE so2.SalesPersonID = so.SalesPersonID)
     AND Sales.SalesPerson.BusinessEntityID = so.SalesPersonID
     GROUP BY so.SalesPersonID);

----Query----
UPDATE Production.Location
SET CostRate = DEFAULT
WHERE CostRate > 20.00;

----Query----
UPDATE Person.vStateProvinceCountryRegion
SET CountryRegionName = 'United States of America'
WHERE CountryRegionName = 'United States';


----Query----
UPDATE sr
SET sr.Name += ' - tool malfunction'
FROM Production.ScrapReason AS sr
JOIN Production.WorkOrder AS wo 
     ON sr.ScrapReasonID = wo.ScrapReasonID
     AND wo.ScrappedQty > 300;

----Query----
-- Create the table variable.
DECLARE @MyTableVar table(
    EmpID int NOT NULL,
    NewVacationHours int,
    ModifiedDate datetime);

-- Populate the table variable with employee ID values from HumanResources.Employee.
INSERT INTO @MyTableVar (EmpID)
    SELECT BusinessEntityID FROM HumanResources.Employee;

-- Update columns in the table variable.
UPDATE @MyTableVar
SET NewVacationHours = e.VacationHours + 20,
    ModifiedDate = GETDATE()
FROM HumanResources.Employee AS e 
WHERE e.BusinessEntityID = EmpID;

-- Display the results of the UPDATE statement.
SELECT EmpID, NewVacationHours, ModifiedDate FROM @MyTableVar
ORDER BY EmpID;

----Query----
UPDATE Sales.SalesPerson
SET SalesYTD = SalesYTD + SubTotal
FROM Sales.SalesPerson AS sp
JOIN Sales.SalesOrderHeader AS so
    ON sp.BusinessEntityID = so.SalesPersonID
    AND so.OrderDate = (SELECT MAX(OrderDate)
                        FROM Sales.SalesOrderHeader
                        WHERE SalesPersonID = sp.BusinessEntityID);

----Query----
UPDATE Sales.SalesPerson
SET SalesYTD = SalesYTD + 
    (SELECT SUM(so.SubTotal) 
     FROM Sales.SalesOrderHeader AS so
     WHERE so.OrderDate = (SELECT MAX(OrderDate)
                           FROM Sales.SalesOrderHeader AS so2
                           WHERE so2.SalesPersonID = so.SalesPersonID)
     AND Sales.SalesPerson.BusinessEntityID = so.SalesPersonID
     GROUP BY so.SalesPersonID);

----Query----
DECLARE @MyTableVar table (
    SummaryBefore nvarchar(max),
    SummaryAfter nvarchar(max));
UPDATE Production.Document
SET DocumentSummary .WRITE (N'features',28,10)
OUTPUT deleted.DocumentSummary, 
       inserted.DocumentSummary 
    INTO @MyTableVar
WHERE Title = N'Front Reflector Bracket Installation';
SELECT SummaryBefore, SummaryAfter 
FROM @MyTableVar;

----Query----
UPDATE Production.Product
WITH (TABLOCK)
SET ListPrice = ListPrice * 1.10
WHERE ProductNumber LIKE 'BK-%';

----Query----
/*CREATE PROCEDURE Production.uspProductUpdate
@Product nvarchar(25)
AS
SET NOCOUNT ON;
UPDATE Production.Product
SET ListPrice = ListPrice * 1.10
WHERE ProductNumber LIKE @Product
OPTION (OPTIMIZE FOR (@Product = 'BK-%') );
GO*/
-- Execute the stored procedure 
EXEC Production.uspProductUpdate 'BK-%';

----Query----
DECLARE @MyTableVar table(
    EmpID int NOT NULL,
    OldVacationHours int,
    NewVacationHours int,
    ModifiedDate datetime);
UPDATE TOP (10) HumanResources.Employee
SET VacationHours = VacationHours * 1.25,
    ModifiedDate = GETDATE() 
OUTPUT inserted.BusinessEntityID,
       deleted.VacationHours,
       inserted.VacationHours,
       inserted.ModifiedDate
INTO @MyTableVar;
--Display the result set of the table variable.
SELECT EmpID, OldVacationHours, NewVacationHours, ModifiedDate
FROM @MyTableVar;
--Display the result set of the table.
SELECT TOP (10) BusinessEntityID, VacationHours, ModifiedDate
FROM HumanResources.Employee;

