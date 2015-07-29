/*******************************************************************************
Setup
*******************************************************************************/
--USE AdventureWorks2012;
--GO

IF OBJECT_ID ('dbo.Gloves', 'U') IS NULL
BEGIN
	-- Create Gloves table.
	SELECT ProductModelID, Name
	INTO dbo.Gloves
	FROM Production.ProductModel
	WHERE ProductModelID IN (3, 4);
	--DROP TABLE dbo.Gloves;
	--GO
END
IF OBJECT_ID ('dbo.ProductResults', 'U') IS NULL
BEGIN
	--DROP TABLE dbo.ProductResults;
	--GO
	SELECT ProductModelID, Name
	INTO dbo.ProductResults
	FROM Production.ProductModel
	WHERE ProductModelID NOT IN (3, 4)
	UNION
	SELECT ProductModelID, Name
	FROM dbo.Gloves;
END

IF OBJECT_ID ('dbo.EmployeeSales', 'U') IS NULL
BEGIN
	--DROP TABLE dbo.EmployeeSales;
	--GO
	CREATE TABLE dbo.EmployeeSales
	( DataSource   varchar(20) NOT NULL,
	  BusinessEntityID   varchar(11) NOT NULL,
	  LastName     varchar(40) NOT NULL,
	  SalesDollars money NOT NULL
	);
END


IF OBJECT_ID ('dbo.EmployeeOne', 'U') IS NULL
BEGIN
	--DROP TABLE dbo.EmployeeOne;
	--GO

	SELECT pp.LastName, pp.FirstName, e.JobTitle 
	INTO dbo.EmployeeOne
	FROM Person.Person AS pp JOIN HumanResources.Employee AS e
	ON e.BusinessEntityID = pp.BusinessEntityID
	WHERE LastName = 'Johnson';
END
IF OBJECT_ID ('dbo.EmployeeTwo', 'U') IS NULL
BEGIN
	--DROP TABLE dbo.EmployeeTwo;
	--GO
	SELECT pp.LastName, pp.FirstName, e.JobTitle 
	INTO dbo.EmployeeTwo
	FROM Person.Person AS pp JOIN HumanResources.Employee AS e
	ON e.BusinessEntityID = pp.BusinessEntityID
	WHERE LastName = 'Johnson';
END
IF OBJECT_ID ('dbo.EmployeeThree', 'U') IS NULL
BEGIN
	--DROP TABLE dbo.EmployeeThree;
	--GO
	SELECT pp.LastName, pp.FirstName, e.JobTitle 
	INTO dbo.EmployeeThree
	FROM Person.Person AS pp JOIN HumanResources.Employee AS e
	ON e.BusinessEntityID = pp.BusinessEntityID
	WHERE LastName = 'Johnson';
END



IF OBJECT_ID ('dbo.uspGetEmployeeSales', 'P') IS NOT NULL
	DROP PROCEDURE uspGetEmployeeSales;
GO
CREATE PROCEDURE dbo.uspGetEmployeeSales 
AS 
	SET NOCOUNT ON;
	SELECT 'PROCEDURE', sp.BusinessEntityID, c.LastName, 
		sp.SalesYTD 
	FROM Sales.SalesPerson AS sp  
	INNER JOIN Person.Person AS c
		ON sp.BusinessEntityID = c.BusinessEntityID
	WHERE sp.BusinessEntityID LIKE '2%'
	ORDER BY sp.BusinessEntityID, c.LastName;
GO

IF OBJECT_ID (N'HumanResources.NewEmployee', N'U') IS NOT NULL
    DROP TABLE HumanResources.NewEmployee;
GO
CREATE TABLE HumanResources.NewEmployee
(
    EmployeeID int NOT NULL,
    LastName nvarchar(50) NOT NULL,
    FirstName nvarchar(50) NOT NULL,
    PhoneNumber Phone NULL,
    AddressLine1 nvarchar(60) NOT NULL,
    City nvarchar(30) NOT NULL,
    State nchar(3) NOT NULL, 
    PostalCode nvarchar(15) NOT NULL,
    CurrentFlag Flag
);
GO

IF OBJECT_ID ('dbo.EmployeeSales', 'U') IS NOT NULL
    DROP TABLE dbo.EmployeeSales;
GO
CREATE TABLE dbo.EmployeeSales
( EmployeeID   nvarchar(11) NOT NULL,
  LastName     nvarchar(20) NOT NULL,
  FirstName    nvarchar(20) NOT NULL,
  YearlySales  money NOT NULL
 );
GO


IF OBJECT_ID ('dbo.T1', 'U') IS NULL
BEGIN
	--DROP TABLE dbo.T1;
	--GO
	CREATE TABLE dbo.T1 
	(
		column_1 int IDENTITY, 
		column_2 uniqueidentifier,
	);
END

IF OBJECT_ID ('dbo.T1', 'U') IS NOT NULL
    DROP TABLE dbo.T1;
GO
IF OBJECT_ID ('dbo.V1', 'V') IS NOT NULL
    DROP VIEW dbo.V1;
GO
CREATE TABLE T1 ( column_1 int, column_2 varchar(30));
GO
CREATE VIEW V1 AS 
SELECT column_2, column_1 
FROM T1;
GO

IF OBJECT_ID ('Production.uspProductUpdate', 'P') IS NOT NULL
	DROP PROCEDURE Production.uspProductUpdate;
GO
CREATE PROCEDURE Production.uspProductUpdate
@Product nvarchar(25)
AS
SET NOCOUNT ON;
UPDATE Production.Product
SET ListPrice = ListPrice * 1.10
WHERE ProductNumber LIKE @Product
OPTION (OPTIMIZE FOR (@Product = 'BK-%') );


-- Rewrite the procedure to perform the same operations using the MERGE statement.
-- Create a temporary table to hold the updated or inserted values from the OUTPUT clause.
IF OBJECT_ID ('dbo.InsertUnitMeasure', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.InsertUnitMeasure;
END
GO
CREATE PROCEDURE dbo.InsertUnitMeasure
	@UnitMeasureCode nchar(3),
	@Name nvarchar(25)
AS 
BEGIN
	SET NOCOUNT ON;

	CREATE TABLE #MyTempTable
		(ExistingCode nchar(3),
		 ExistingName nvarchar(50),
		 ExistingDate datetime,
		 ActionTaken nvarchar(10),
		 NewCode nchar(3),
		 NewName nvarchar(50),
		 NewDate datetime
		);
	
	MERGE Production.UnitMeasure AS target
	USING (SELECT @UnitMeasureCode, @Name) AS source (UnitMeasureCode, Name)
	ON (target.UnitMeasureCode = source.UnitMeasureCode)
	WHEN MATCHED THEN 
		UPDATE SET Name = source.Name
	WHEN NOT MATCHED THEN	
		INSERT (UnitMeasureCode, Name)
		VALUES (source.UnitMeasureCode, source.Name)
		OUTPUT deleted.*, $action, inserted.* INTO #MyTempTable;

	SELECT * FROM #MyTempTable;

	DROP TABLE #MyTempTable;

END;
GO


IF OBJECT_ID (N'Production.usp_UpdateInventory', N'P') IS NOT NULL DROP PROCEDURE Production.usp_UpdateInventory;
GO
CREATE PROCEDURE Production.usp_UpdateInventory
    @OrderDate datetime
AS
MERGE Production.ProductInventory AS target
USING (SELECT ProductID, SUM(OrderQty) FROM Sales.SalesOrderDetail AS sod
    JOIN Sales.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID
    AND soh.OrderDate = @OrderDate
    GROUP BY ProductID) AS source (ProductID, OrderQty)
ON (target.ProductID = source.ProductID)
WHEN MATCHED AND target.Quantity - source.OrderQty <= 0
    THEN DELETE
WHEN MATCHED 
    THEN UPDATE SET target.Quantity = target.Quantity - source.OrderQty, 
                    target.ModifiedDate = GETDATE()
OUTPUT $action, Inserted.ProductID, Inserted.Quantity, Inserted.ModifiedDate, Deleted.ProductID,
    Deleted.Quantity, Deleted.ModifiedDate;
GO

IF OBJECT_ID ('Production.UpdatedInventory', 'U') IS NULL
BEGIN
	--DROP TABLE Production.UpdatedInventory;
	--GO
	CREATE TABLE Production.UpdatedInventory
		(ProductID INT NOT NULL, LocationID int, NewQty int, PreviousQty int,
		CONSTRAINT PK_Inventory PRIMARY KEY CLUSTERED (ProductID, LocationID));
END

IF OBJECT_ID ('dbo.T1', 'U') IS NULL
BEGIN
	--DROP TABLE dbo.T1;
	--GO
	CREATE TABLE dbo.T1 
	(
		column_1 AS 'Computed column ' + column_2, 
		column_2 varchar(30) 
			CONSTRAINT default_name DEFAULT ('my column default'),
		column_3 rowversion,
		column_4 varchar(40) NULL
	);
END

