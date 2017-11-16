<#
        Script:     RunWorkload.psm1
        Author:     Matt Lavery (https://github.com/Matticusau/SqlWorkloadGenerator)
        Created:    05/05/2016
        Version:    1.1.0.0
            
        Change History
        Version      Who          When           What
        --------------------------------------------------------------------------------------------------
        1.0.0.0      MLavery      05/05/2016     Initial Coding from existing scripts (Issue6)
        1.1.0.0      MLavery      09/11/2017     Better error handling and uses the SQL modules to load assemblies
        

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

function Invoke-SqlWorkload
{
    [CmdLetBinding()]
    Param(
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

    # Run the setup file if supplied
    if ($TSQLSetupFile.Length -gt 0)
    {
        Invoke-SqlWorkloadSetup -SQLServer $SQLServer -Database $Database -UserName $UserName -Password $Password -TSQLSetupFile $TSQLSetupFile;
    }

    # set the start time
    $startTime = Get-Date;

    # Split the input on the delimeter 
    $queries = Get-Content -Delimiter "----Query----" -Path $TSQLFile #"AdventureWorks2012BOLWorkload.sql" 

    [int]$loopCount = 0;

    WHILE(1 -eq 1) 
    {
        # increment the count
        $loopCount = $loopCount + 1;
        
        # check if we have exceeded the timespan for execution
        if ($Duration -gt 0 -and ((New-TimeSpan -Start $startTime -End (Get-Date)).Seconds -ge $Duration))
        {
            Write-Verbose "Duration of $Duration seconds reached";
            Break;
        }
        
        try
        {
            # Pick a Random Query from the input object 
            $query = Get-Random -InputObject $queries; 

            Write-Output "Query ($($loopCount))"
        
            #Run the Query
            Invoke-SqlWorkloadQuery -SQLServer $SQLServer -Database $Database -UserName $UserName -Password $Password -Query $query;

        }
        catch
        {
            #Report the error
            Write-Warning "Could not execute via Invoke-SqlWorkloadQuery"
            Write-Warning "$($PSItem.Exception.Message)";
            #throw $PSItem;
        }
        finally
        {
            #Wait for a random delay to make this more realistic when running multiple workloads
            if ($Frequency = "Fast") {$sleepMilSecs = Get-Random -Minimum 1 -Maximum 500}
            elseif ($Frequency = "Slow") {$sleepMilSecs = Get-Random -Minimum 1000 -Maximum 5000}
            else {$SleepMilSecs = Get-Random -Minimum 100 -Maximum 5000};
        
            Write-Verbose "Waiting for $($sleepMilSecs) milliseconds";
            Start-Sleep -Milliseconds $sleepMilSecs
        }

    } 

}

function Invoke-SqlWorkloadQuery
{
    [CmdLetBinding()]
    Param(
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

        [Parameter(Mandatory=$true)]
        [string]$Query

    )

    try
    {
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

        Write-Debug "`$Query = $($Query)";
    
    }
    # SQL Exception
    catch [System.Data.SqlClient.SqlException],[Microsoft.SqlServer.Management.Common.ExecutionFailureException]
    {
        # Use Verbose for troubleshooting
        Write-Verbose "Failed to execute: $($Query)";
        # we need to go a few levels deep to get the actual exception from sql
        Write-Verbose "$($PSItem.Exception.InnerException.InnerException.Message)";
        # throw $PSItem;
    }
    # All Other Exception
    catch
    {
        # Use Verbose for troubleshooting
        Write-Verbose "Failed to execute: $($Query)";
        # General error so just use the exception
        Write-Verbose "$($PSItem.Exception.Message)";
        # throw $PSItem;
    }
    finally
    {
        #remove the SQL Server object if required
        if ($srv){
           $srv.ConnectionContext.Disconnect(); 
        }
    }
}




function Invoke-SqlWorkloadSetup
{
    [CmdLetBinding()]
    Param(
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

        # The path to the TSQL file which contains the setup statements to execute before starting the process (if required).
        [Parameter(Mandatory=$false)]
        [string]$TSQLSetupFile
    )

    try
    {
        # get the setup queries
        $setupTSQL = Get-Content -Path $TSQLSetupFile;
        
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
        $result = $srv.ConnectionContext.ExecuteNonQuery($setupTSQL); 

        # Disconnect from the server 
        $srv.ConnectionContext.Disconnect(); 

        Write-Output "Setup Script Executed"
    
    }
    catch
    {
        #Write an error
        Write-Error "Setup Script Failed"
        #throw $PSItem;
        Exit; # stop the script execution
    }
}


# Load the SMO assembly 
# [void][reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo"); 
# Import the SQL Module to load the assemblies
if ($null -ne (Get-module -Name SqlServer -ListAvailable -ErrorAction SilentlyContinue))
{
    Import-Module -Name SqlServer;
}
elseif ($null -ne (Get-module -Name SQLPS -ListAvailable -ErrorAction SilentlyContinue)) 
{
    Import-Module -Name SQLPS -DisableNameChecking;
}
else 
{
    Write-Error "Neither the SqlServer or SQLPS PowerShell Modules are installed"
    #throw $PSItem;
    Exit; # stop the script execution
}
