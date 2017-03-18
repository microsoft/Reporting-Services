<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Initialize-ReportServer
{
<#
.SYNOPSIS
Initializes the report server
.EXAMPLE
Initialize-ReportServer
.EXAMPLE
 
.NOTES

InitializeReportServer(
    System.String InstallationID
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
            $rsSettings = Get-RSConfigurationSetting @rsParam 

            $CimArguments = [ordered]@{
                InstallationID = $rsSettings.InstallationID        
            }

            Write-Verbose 'InitializeReportServer'
            Invoke-CimMethod -InputObject $rsSettings -MethodName InitializeReportServer -Arguments $CimArguments | Out-Null
        }
    }
}


