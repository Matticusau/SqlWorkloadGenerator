# SqlWorkloadGenerator
PowerShell scripts to general SQL Server workload against AdventureWorks database schemas

## Description
Provides sample SQL Scripts and PowerShell scripts to automate the generation of load against the AdventureWorks schema.

Current supported versions are:
- SQL 2008 / R2
- SQL 2012
- SQL 2014 (via 2012 script)
- SQL Azure

## Example

Set-Location C:\WorkLoad 
.\RunWorkload.ps1 -SQLServer myazuredb.database.windows.net -Database DemoDB01 -UserName DemoUsr -Password ?????? -TSQLFile C:\WorkLoad\AdventureWorksAzureBOLWorkload.sql -Frequency 'Fast'

## Running Larger Workloads

To run a larger workload you may need to execute this script multiple times. To achieve this create a .cmd file with multiple lines such as:
Start PowerShell.exe -File "C:\Workload\RunWorkload.ps1" -SQLServer "SqlServer.contoso.com" -Database "DemoDB01" -TSQLFile "C:\Workload\AdventureWorks2012BOLWorkload.sql" -Frequency "Fast"

## Versions

### 0.0.3

* Added ability to specify frequency for improved control over workload level

### 0.0.2

* Added minor fixes (issue #1) removal of Write-Host


### 0.0.1

* Initial release includes basic functionality and sample scripts

    