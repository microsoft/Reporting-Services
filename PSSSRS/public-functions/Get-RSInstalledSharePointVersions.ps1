<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Get-RSInstalledSharePointVersions
{
<#
.SYNOPSIS
List Installed Share Point Versions
.EXAMPLE
Get-RSInstalledSharePointVersions
.EXAMPLE
 
.NOTES
ListInstalledSharePointVersions()
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

            Write-Verbose 'ListInstalledSharePointVersions'
            Invoke-CimMethod -InputObject $rsSettings -MethodName ListInstalledSharePointVersions
        }
    }
}
