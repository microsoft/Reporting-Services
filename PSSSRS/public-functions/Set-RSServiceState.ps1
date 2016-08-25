<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Set-RSServiceState
{
<#
.SYNOPSIS
Sets the SSRS service state for the windows service, web service and the report manager
.EXAMPLE
Set-RSServiceState
.EXAMPLE
 
.NOTES

SetServiceState(
    System.Boolean EnableWindowsService, 
    System.Boolean EnableWebService, 
    System.Boolean EnableReportManager
)

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
        $Credential,

        [switch]
        $EnableWindowsService = $true,

        [switch]
        $EnableWebService = $true,
        
        [switch]
        $EnableReportManager = $true
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

            $CimArguments = [ordered]@{
                EnableWindowsService = [bool]$EnableWindowsService 
                EnableWebService     = [bool]$EnableWebService
                EnableReportManager  = [bool]$EnableReportManager          
            }

            Write-Verbose 'SetServiceState'
            Invoke-CimMethod -InputObject $rsSettings -MethodName SetServiceState -Arguments $CimArguments | Out-Null
        }
    }
}
