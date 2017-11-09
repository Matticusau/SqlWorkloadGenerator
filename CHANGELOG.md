# Change log for SqlWorkloadGenerator

## Unreleased

* None

### 1.1.0.0

* Created version independant .sql files
* Moved the Example_RunWorkload.ps1 to .\Examples
* Renamed Example_RunWorkload.ps1 to AzureSQLDbExample.ps1
* Created .\Examples\SQLServerExample.ps1
* Created .\Examples\LoadTestExample.cmd
* Improved error handling
* SQL Assemblies are loaded by importing either SqlServer or SQLPS module

### 0.1.2

* Moved functions to a module for better code coverage
* Improved test coverage through AppVeyor

### 0.1.1

* Added Duration parameter and better error verbatim (Issue4)

### 0.1.0

* Added functions Invoke-Workload, Invoke-WorkloadSetup, Invoke-WorkloadQuery (Issue6)

### 0.0.3

* Added ability to specify frequency for improved control over workload level

### 0.0.2

* Added minor fixes (issue #1) removal of Write-Host


### 0.0.1

* Initial release includes basic functionality and sample scripts

