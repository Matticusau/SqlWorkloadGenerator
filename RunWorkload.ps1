<#
    .NOTES

        Script:     RunWorkload.ps1
        Author:     Matt Lavery (https://github.com/Matticusau/SqlWorkloadGenerator)
        Created:    29/05/2015
        Version:    0.1.2
            
        Change History
        Version    Who          When           What
        --------------------------------------------------------------------------------------------------
        0.0.1      MLavery      29/05/2015     Initial Coding
        0.0.2      MLavery      03/08/2015     Minor fixes (issue #1) removal of Write-Host
        0.0.3      MLavery      10/08/2015     Added Frequency parameter
        0.1.0      MLavery      04/05/2016     Added functions Invoke-Workload, Invoke-WorkloadSetup, Invoke-WorkloadQuery (Issue6)
        0.1.1      MLavery      05/05/2016     Added Duration parameter and better error verbatim (Issue4)
        0.1.2      MLavery      05/05/2016     Moved functions to a module for better code coverage

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
    
    .SYNOPSIS
        A script to run SQL workload against an AdventureWorks database for demos

    .DESCRIPTION
        A script to run SQL workload against an AdventureWorks database for demos. Uses a collection of 
        sample SQL statements taken from MSDN BOL for the various versions of SQL Server. 
        Current supported versions are:
        - SQL 2008 / R2
        - SQL 2012
        - SQL 2014 (via 2012 script)
        - SQL Azure 

#>

[cmdletbinding()]
param (
    # The SQL Server host name and instance to connect to (e.g. Server01\Prd01)
    [Parameter(Mandatory=$true)]
    [string]$SQLServer,
    
    # The name of the database to run the script against. This allows for restoring the AdventureWorks database schema to custom databases.
    [Parameter(Mandatory=$true)]
    [string]$Database,
    
    # If SQL Authentication is required this is the UserName to authenticate with. If not provided then Windows Auth is used.
    [Parameter(Mandatory=$false)]
    [string]$UserName,
    
    # If SQL Authentication is required this is the Password to authenticate with. Not required for Windows Auth.
    [Parameter(Mandatory=$false)]
    [string]$Password,

    # The path to the TSQL file which contains the sample statements to execute.
    [Parameter(Mandatory=$true)]
    [string]$TSQLFile,

    # The path to the TSQL file which contains the setup statements to execute before starting the process (if required).
    [Parameter(Mandatory=$false)]
    [string]$TSQLSetupFile,

    # The frequency of which to run the statements at (Fast, Normal, or Slow)
    [Parameter(Mandatory=$false)]
    [string][ValidateSet("Fast", "Normal", "Slow")]$Frequency = "Normal",

    # The duration to run the workload for (seconds). 0 is unlimited, otherwise maximum allowed is 172800 (48hrs) 
    [parameter(mandatory=$false)]
    [int64][ValidateRange(0,172800)]$Duration = 0
)

Clear-Host

Write-Output "SQL Workload Generator"
Write-Output "Starting..."

[string]$workloadModulePath = ".\RunWorkload"
if (-not(Test-Path -Path $workloadModulePath))
{
    Write-Output "Cannot find RunWorkload module at path '$($workloadModulePath)'";
    $workloadModulePath = Read-Host -prompt "Please enter path to '.\RunWorkload' Module included with this toolset"; 
}

Import-Module $workloadModulePath

Invoke-SqlWorkload -SQLServer $SQLServer -Database $Database -UserName $UserName -Password $Password -TSQLFile $TSQLFile -TSQLSetupFile $TSQLSetupFile -Frequency $Frequency -Duration $Duration -Verbose;

Write-Output "Done..."


