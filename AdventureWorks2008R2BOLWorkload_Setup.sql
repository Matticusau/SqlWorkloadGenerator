/*******************************************************************************
Setup
*******************************************************************************/

/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
W. Using a simple UNION 
In the following example, the result set includes the contents
of the ProductModelID and Name columns of both the ProductModel
and Gloves tables.
*/

USE AdventureWorks2008R2;
GO
IF OBJECT_ID ('dbo.Gloves', 'U') IS NOT NULL
DROP TABLE dbo.Gloves;
GO
-- Create Gloves table.
SELECT ProductModelID, Name
INTO dbo.Gloves
FROM Production.ProductModel
WHERE ProductModelID IN (3, 4);
GO

/* http://msdn.microsoft.com/en-us/library/ms187731.aspx
Z. Using UNION of three SELECT statements to show the 
	effects of ALL and parentheses 
The following examples use UNION to combine the results 
of three tables that all have the same 5 rows of data. 
The first example uses UNION ALL to show the duplicated 
records, and returns all 15 rows. The second example uses 
UNION without ALL to eliminate the duplicate rows from the 
combined results of the three SELECT statements, and 
returns 5 rows. The third example uses ALL with the first 
UNION and parentheses enclose the second UNION that is not 
using ALL. The second UNION is processed first because it 
is in parentheses, and returns 5 rows because the ALL option 
is not used and the duplicates are removed. These 5 rows are 
combined with the results of the first SELECT by using the 
UNION ALL keywords. This does not remove the duplicates 
between the two sets of 5 rows. The final result has 10 rows.
*/

USE AdventureWorks2008R2;
GO
IF OBJECT_ID ('dbo.EmployeeOne', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeOne;
GO
IF OBJECT_ID ('dbo.EmployeeTwo', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeTwo;
GO
IF OBJECT_ID ('dbo.EmployeeThree', 'U') IS NOT NULL
DROP TABLE dbo.EmployeeThree;
GO

SELECT pp.LastName, pp.FirstName, e.JobTitle 
INTO dbo.EmployeeOne
FROM Person.Person AS pp JOIN HumanResources.Employee AS e
ON e.BusinessEntityID = pp.BusinessEntityID
WHERE LastName = 'Johnson';
GO
SELECT pp.LastName, pp.FirstName, e.JobTitle 
INTO dbo.EmployeeTwo
FROM Person.Person AS pp JOIN HumanResources.Employee AS e
ON e.BusinessEntityID = pp.BusinessEntityID
WHERE LastName = 'Johnson';
GO
SELECT pp.LastName, pp.FirstName, e.JobTitle 
INTO dbo.EmployeeThree
FROM Person.Person AS pp JOIN HumanResources.Employee AS e
ON e.BusinessEntityID = pp.BusinessEntityID
WHERE LastName = 'Johnson';
GO

