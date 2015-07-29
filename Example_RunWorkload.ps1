<#
    .NOTES
        
        Script:     Example_RunWorkload.ps1
        Author:     Matt Lavery (https://github.com/Matticusau/SqlWorkloadGenerator)
        Created:    29/05/2015
        Version:    0.0.1
    
        Change History
        Version    Who          When           What
        --------------------------------------------------------------------------------------------------
        0.0.1      MLavery      29/05/2015     Initial Coding

        DISCLAIMER
        This Sample Code is provided for the purpose of illustration only and is not intended to be 
        used in a production environment.  THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED 
        "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
        TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant 
        You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and 
        distribute the object code form of the Sample Code, provided that You agree: (i) to not use 
        Our name, logo, or trademarks to market Your software product in which the Sample Code is 
        embedded; (ii) to include a valid copyright notice on Your software product in which the 
        Sample Code is embedded; and (iii) to indemnify, hold harmless, and defend Us and Our 
        suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise 
        or result from the use or distribution of the Sample Code.
#>

Set-Location C:\WorkLoad 

.\RunWorkload.ps1 -SQLServer myazuredb.database.windows.net -Database DemoDB01 -UserName DemoUsr -Password ?????? -TSQLFile C:\WorkLoad\AdventureWorksAzureBOLWorkload.sql
