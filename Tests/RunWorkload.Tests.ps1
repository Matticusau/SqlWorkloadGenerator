Import-Module "$PSScriptRoot\..\RunWorkload" -Force -Verbose;

$Error.Clear();

Describe 'Invoke-SqlWorkload'{
    Mock -ModuleName RunWorkload -CommandName Get-Content -MockWith {
        Write-Output 'SELECT * FROM Test.TestData'
    }
    Mock -ModuleName RunWorkload -CommandName Invoke-SqlWorkloadSetup -MockWith {
        Write-Output 'Setup script executed'
    }
    Mock -ModuleName RunWorkload -CommandName Invoke-SqlWorkloadQuery -MockWith {
        Write-Output 'Query executed'
    }
    
    Invoke-SqlWorkload -SqlServer 'localhost' -Database 'AdventureWorks' -TSQLFile 'C:\SqlQueries.sql' -TSQLSetupFile '' -Frequency 'Normal' -Duration 15 -Verbose; 

    It 'Should not have any errors'{
        $? | Should Be $true
    }
     
    It 'Should not have any exceptions'{
        $Error.Count -eq 0
    }
}
