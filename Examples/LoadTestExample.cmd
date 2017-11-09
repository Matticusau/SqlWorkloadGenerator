@echo off
REM Script:     LoadTestExample.cmd
REM Author:     Matt Lavery (https://github.com/Matticusau/SqlWorkloadGenerator)
REM Created:    09/11/2017
REM Version:    0.0.1
REM 
REM DISCLAIMER
REM This Sample Code is provided for the purpose of illustration only and is not intended to be 
REM used in a production environment.  THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED 
REM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
REM TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant 
REM You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and 
REM distribute the object code form of the Sample Code, provided that You agree: (i) to not use 
REM Our name, logo, or trademarks to market Your software product in which the Sample Code is 
REM embedded; (ii) to include a valid copyright notice on Your software product in which the 
REM Sample Code is embedded; and (iii) to indemnify, hold harmless, and defend Us and Our 
REM suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise 
REM or result from the use or distribution of the Sample Code.

Start PowerShell.exe -File "C:\Workload\RunWorkload.ps1" -SQLServer "SQLNode01\Prd01" -Database "AdventureWorks2014" -TSQLFile "C:\Workload\SqlScripts\AdventureWorksWorkload.sql" -Frequency "Fast"
Start PowerShell.exe -File "C:\Workload\RunWorkload.ps1" -SQLServer "SQLNode01\Prd01" -Database "AdventureWorks2014" -TSQLFile "C:\Workload\SqlScripts\AdventureWorksWorkload.sql" -Frequency "Fast"
Start PowerShell.exe -File "C:\Workload\RunWorkload.ps1" -SQLServer "SQLNode01\Prd01" -Database "AdventureWorks2014" -TSQLFile "C:\Workload\SqlScripts\AdventureWorksWorkload.sql" -Frequency "Normal"
Start PowerShell.exe -File "C:\Workload\RunWorkload.ps1" -SQLServer "SQLNode01\Prd01" -Database "AdventureWorks2014" -TSQLFile "C:\Workload\SqlScripts\AdventureWorksWorkload.sql" -Frequency "Fast"
Start PowerShell.exe -File "C:\Workload\RunWorkload.ps1" -SQLServer "SQLNode01\Prd01" -Database "AdventureWorks2014" -TSQLFile "C:\Workload\SqlScripts\AdventureWorksWorkload.sql" -Frequency "Fast"
PAUSE