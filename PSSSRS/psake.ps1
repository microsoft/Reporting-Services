
#requires -modules psake, buildhelpers, pester
<#
.SYNOPSIS
Handles all the build related tasks for this module
.EXAMPLE
Invoke-PSake psake.ps1
.EXAMPLE

.NOTES

#>

task Default -Depends UpdateExportFunctions, RunTests

task UpdateExportFunctions {

    $module    = Split-Path $PSScriptRoot -Leaf

    $functions = Get-ChildItem "$PSScriptRoot\Public-Functions\*.ps1" | 
                    Where-Object{ $_.name -notmatch 'Tests'} | 
                    ForEach-Object { $_.basename.tostring()}
    
    $modulePath = Join-Path $PSScriptRoot "$module.psd1"

    Set-ModuleFunctions -Name $modulePath -FunctionsToExport $functions 
}

Task RunTests {

    $testResults = Invoke-Pester $PSScriptRoot -PassThru

    if($testResults.FailedCount -gt 0)
    {
        # Because we may run hundreds of tests, echo out the failed ones at the end so they are easy to find
        $FailedTests = $testResults.Testresult | where passed -eq $false        
        $FailedTests | %{
            Write-Warning ('[{0,-20}][{1,-20}][{2,-20}][{3}]' -f $_.Describe,$_.Context,$_.Name,$_.Failuremessage)
        }

        # This error causes the build to fail
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
}

Task InstallLocal {

    $moduleName = Split-path $psscriptroot -Leaf
    $destination = "$env:USERPROFILE\Documents\WindowsPowershell\Modules\$moduleName"

    if(Test-Path $destination)
    {
        Write-Verbose "Removing module $destination"
        Remove-Item -Path $destination -Recurse | Out-Null
    }
    Robocopy $PSScriptRoot $destination /e | Out-Null
}

Task UpdateBuildVersion -Depends Default {

    $module = Split-Path $PSScriptRoot -Leaf    
    Step-ModuleVersion -path "$psscriptroot\$module.psd1"
}

