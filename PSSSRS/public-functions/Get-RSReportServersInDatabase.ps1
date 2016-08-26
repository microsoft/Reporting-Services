<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Get-RSReportServersInDatabase
{
<#
.SYNOPSIS
List Report Servers In Database
.EXAMPLE
Get-RSInstalledSharePointVersions
.EXAMPLE
 
.NOTES
ListReportServersInDatabase()
#>
    [cmdletbinding()]
    param
    (
        [Parameter(
            HelpMessage = 'The computer hosting SSRS',
            Position    = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('Server')]
        [string[]]$ComputerName = 'localhost',

        [string]
        $InstanceName='MSSQLSERVER',

        [Alias('UserName')]
        [PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    begin
    {
        # Build a hashtable for spallting that takes into account optional values
        $rsParam = @{}
        if($PSBoundParameters.Instancename)
        {
            $rsParam.Instancename = $PSBoundParameters.Instancename
        }
        if($PSBoundParameters.Credential)
        {
            $rsParam.Credential = $PSBoundParameters.Credential
        }
    }
    process
    {
        foreach($node in $ComputerName) 
        {
            Write-Verbose $node
            $rsParam.ComputerName = $node         
            $rsSettings = Get-RSConfigurationSettings @rsParam 

            Write-Verbose 'ListReportServersInDatabase'
            $results = Invoke-CimMethod -InputObject $rsSettings -MethodName ListReportServersInDatabase

            if($results.Length)
            {
                for($index = 0;$index -lt $results.Length; $index += 1)
                {
                    $Server = [pscustomobject]@{
                        MachineName    =  $results.MachineNames[$index]
                        InstanceName   = $results.InstanceNames[$index]
                        InstallationID = $results.InstallationIDs[$index]
                        IsInitialized  = $results.IsInitialized[$index]
                        PSComputerName = $node
                    }

                    $Server.psobject.TypeNames.Insert(0, "PSSSRS.ServerInDatabase")
                    Write-Output $Server
                }
            }
        }
    }
}
