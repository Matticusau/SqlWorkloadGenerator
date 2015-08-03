<#
    .NOTES

        Script:     RunWorkload.ps1
        Author:     Matt Lavery (https://github.com/Matticusau/SqlWorkloadGenerator)
        Created:    29/05/2015
        Version:    0.0.1
    
        Change History
        Version    Who          When           What
        --------------------------------------------------------------------------------------------------
        0.0.1      MLavery      29/05/2015     Initial Coding
        0.0.2      MLavery      03/08/2015     Minor fixes (issue #1) removal of Write-Host
        
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
    # The SQL Server host name and instance to connect to
    [parameter(mandatory=$true)]
    [string]$SQLServer,
    
    # The name of the database to run the script against. This allows for restoring the AdventureWorks database schema to custom databases.
    [parameter(mandatory=$true)]
    [string]$Database,
    
    # If SQL Authentication is required this is the UserName to authenticate with. If not provided then Windows Auth is used.
    [parameter(mandatory=$false)]
    [string]$UserName,
    
    # If SQL Authentication is required this is the Password to authenticate with. Not required for Windows Auth.
    [parameter(mandatory=$false)]
    [string]$Password,

    # The path to the TSQL file which contains the sample statements to execute.
    [parameter(mandatory=$true)]
    [string]$TSQLFile,

    # The path to the TSQL file which contains the setup statements to execute before starting the process (if required).
    [parameter(mandatory=$false)]
    [string]$TSQLSetupFile
)

Clear-Host

Write-Output "SQL Workload Generator"
Write-Output "Starting..."

# Load the SMO assembly 
[void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo"); 

# Set the server to run the workload against
#$ServerName = "azureessentials.database.windows.net"; 

# Run the setup file if supplied
if ($TSQLSetupFile.Length -gt 0)
{
    try
    {
        # get the setup queries
        $SetupTSQL = Get-Content -Path $TSQLSetupFile;
        
        #Get a server object which corresponds to the default instance 
        $srv = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server $SQLServer

        # Use the database 
        $srv.ConnectionContext.set_DatabaseName($Database)   

        # Set the credentials if needed
        if ($UserName.Length -gt 0)
        {
            $srv.ConnectionContext.LoginSecure = $false;
            $srv.ConnectionContext.Login = $UserName;
            $srv.ConnectionContext.Password = $Password;
        }

        #Write-Output $Query;

        # Execute the query with ExecuteNonQuery 
        $result = $srv.ConnectionContext.ExecuteNonQuery($SetupTSQL); 

        # Disconnect from the server 
        $srv.ConnectionContext.Disconnect(); 

        Write-Output "Setup Script Executed"
    
    }
    catch
    {
        #Write an error
        Write-Error "Setup Script Failed"
        #throw $_;
        Exit; # stop the script execution
    }
}

# Split the input on the delimeter 
$Queries = Get-Content -Delimiter "----Query----" -Path $TSQLFile #"AdventureWorks2012BOLWorkload.sql" 

[int]$LoopCount = 0;

WHILE(1 -eq 1) 
{
    $LoopCount = $LoopCount + 1;
    try
    {
        # Pick a Random Query from the input object 
        $Query = Get-Random -InputObject $Queries; 

        #Get a server object which corresponds to the default instance 
        $srv = New-Object -TypeName Microsoft.SqlServer.Management.SMO.Server $SQLServer

        # Use the database 
        $srv.ConnectionContext.set_DatabaseName($Database)   

        # Set the credentials if needed
        if ($UserName.Length -gt 0)
        {
            $srv.ConnectionContext.LoginSecure = $false;
            $srv.ConnectionContext.Login = $UserName;
            $srv.ConnectionContext.Password = $Password;
        }

        # Execute the query with ExecuteNonQuery 
        $result = $srv.ConnectionContext.ExecuteNonQuery($Query); 

        # Disconnect from the server 
        $srv.ConnectionContext.Disconnect(); 

        Write-Output "Query Executed ($($LoopCount))"
        Write-Verbose "`$Query = $($Query)";
    
    }
    catch
    {
        #Use Verbose for troubleshooting
        Write-Verbose "Failed to execute:"
        Write-Verbose "`$Query = $($Query)";
        #throw $_;
    }
    finally
    {
        #Wait for a random delay to make this more realistic when running multiple workloads
        $SleepMilSecs = Get-Random -Minimum 10 -Maximum 5000
        Start-Sleep -Milliseconds $SleepMilSecs
    }

} 

Write-Output "Done..."