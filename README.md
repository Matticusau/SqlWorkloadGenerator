[![Build status](https://ci.appveyor.com/api/projects/status/54s91yyoc7n70ceh/branch/master?svg=true)](https://ci.appveyor.com/project/Matticusau/sqlworkloadgenerator/branch/master)

# SqlWorkloadGenerator
PowerShell scripts to general SQL Server workload against AdventureWorks database schemas

## Description
Provides sample SQL Scripts and PowerShell scripts to automate the generation of load against the AdventureWorks schema.

Current supported versions are:
- SQL 2008 / R2
- SQL 2012
- SQL 2014
- SQL 2016
- SQL 2017
- SQL Azure

This tool is currently only supported on Windows and PowerShell. It has not yet been tested on PowerShell Core. It will though work remotely against SQL Server on Linux.

NOTE: For SQL Server 2014 and higher, use the non-version specific scripts.

## Installation
To install and use this toolset follow these steps.
1. Create a folder *C:\Workload* or other suitable location
2. Download the project source or one of the releases to that location you just created
3. Create a wrapper script or start the RunWorkload.ps1 script from the console depending on your needs. Refer to the examples for various ways to execute this workload.

## Example

This example runs a single workload session against a database running in SQL Azure with a fast frequency between batches

```
Set-Location C:\WorkLoad 
.\RunWorkload.ps1 -SQLServer myazuredb.database.windows.net -Database DemoDB01 -UserName DemoUsr -Password ?????? -TSQLFile C:\WorkLoad\AdventureWorksAzureBOLWorkload.sql -Frequency 'Fast'
```

For further examples see the files provided in [.\Examples](Examples\) folder.

## Running Larger Workloads

To run a larger workload you may need to execute this script multiple times. To achieve this create a .cmd file with multiple lines such as:
```
Start PowerShell.exe -File "C:\Workload\RunWorkload.ps1" -SQLServer "SqlServer.contoso.com" -Database "DemoDB01" -TSQLFile "C:\Workload\AdventureWorks2012BOLWorkload.sql" -Frequency "Fast"
```

For an example see the file [.\Examples\LoadTestExample.cmd](Examples\LoadTestExample.cmd)

## PowerShell Execution Policies

As this workload is generated through a PowerShell script, it is not excempt from PowerShell Execution Policies. The default policy is Restricted which will stop you from executing the workload script. In production environments it is **not** recommended to set this to Unrestricted, instead you should use `RemoteSigned` or `AllSigned` and then code sign the script files with your organisations certificate.

As a workaround you could run the workload script from a .cmd file with the PowerShell.exe -ExecutionPolicy parameter set to RemoteSigned or as appropriate. This will only change the policy for the process and still allow you to execute the workload. However, if your policy is set through Group Policy then this will not take effect.
```
Start PowerShell.exe -ExecutionPolicy RemoteSigned -File "C:\Workload\RunWorkload.ps1" -SQLServer "SqlServer.contoso.com" -Database "DemoDB01" -TSQLFile "C:\Workload\AdventureWorks2012BOLWorkload.sql" -Frequency "Fast"
```
For further information see:
Get-Help about_Execution_Policies
https://technet.microsoft.com/en-au/library/hh847748.aspx  

## Parameters

### SQLServer
The SQL Server host name and instance to connect to (e.g. Server01\Prd01)

### Database
The name of the database to run the script against. This allows for restoring the AdventureWorks database schema to custom databases.

### UserName
If SQL Authentication is required this is the UserName to authenticate with. If not provided then Windows Auth is used.

### Password
If SQL Authentication is required this is the Password to authenticate with. Not required for Windows Auth.
Warning: This is currently stored in plain text

### TSQLFile
The path to the TSQL file which contains the sample statements to execute.

### TSQLSetupFile
The path to the TSQL file which contains the setup statements to execute before starting the process (if required).

### Frequency
The frequency of which to run the statements at (Fast, Normal, or Slow)

### Duration
The duration to run the workload for (seconds). 0 is unlimited, otherwise maximum allowed is 172800 (48hrs) 

## Change log
A full list of changes in each version can be found in the [change log](CHANGELOG.md).

