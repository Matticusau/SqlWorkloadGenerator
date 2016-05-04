[![Build status](https://ci.appveyor.com/api/projects/status/54s91yyoc7n70ceh/branch/master?svg=true)](https://ci.appveyor.com/project/Matticusau/sqlworkloadgenerator/branch/master)

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

This example runs a single workload session against a database running in SQL Azure with a fast frequency between batches

```sh
Set-Location C:\WorkLoad 
.\RunWorkload.ps1 -SQLServer myazuredb.database.windows.net -Database DemoDB01 -UserName DemoUsr -Password ?????? -TSQLFile C:\WorkLoad\AdventureWorksAzureBOLWorkload.sql -Frequency 'Fast'
```

## Running Larger Workloads

To run a larger workload you may need to execute this script multiple times. To achieve this create a .cmd file with multiple lines such as:
```sh
Start PowerShell.exe -File "C:\Workload\RunWorkload.ps1" -SQLServer "SqlServer.contoso.com" -Database "DemoDB01" -TSQLFile "C:\Workload\AdventureWorks2012BOLWorkload.sql" -Frequency "Fast"
```

## PowerShell Execution Policies

As this workload is generated through a PowerShell script, it is not excempt from PowerShell Execution Policies. The default policy is Restricted which will stop you from executing the workload script. In production environments it is not recommended to set this to Unrestricted, instead you should use RemoteSigned or AllSigned and then code sign the script files with your organisations certificate.

As a workaround you could run the workload script from a .cmd file with the PowerShell.exe -ExecutionPolicy parameter set to RemoteSigned or as appropriate. This will only change the policy for the process and still allow you to execute the workload. However, if your policy is set through Group Policy then this will not take effect.
```sh
Start PowerShell.exe -ExecutionPolicy RemoteSigned -File "C:\Workload\RunWorkload.ps1" -SQLServer "SqlServer.contoso.com" -Database "DemoDB01" -TSQLFile "C:\Workload\AdventureWorks2012BOLWorkload.sql" -Frequency "Fast"
```

For further information see:
Get-Help about_Execution_Policies
https://technet.microsoft.com/en-au/library/hh847748.aspx  

## Versions

### 0.0.3

* Added ability to specify frequency for improved control over workload level

### 0.0.2

* Added minor fixes (issue #1) removal of Write-Host


### 0.0.1

* Initial release includes basic functionality and sample scripts

    