<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Set-RSDatabaseLogonTimeout
{
<#
.SYNOPSIS
Specifies the database logon time-out value for report server database queries.
.EXAMPLE
Set-RSDatabaseLogonTimeout -LogonTimeout -1
.EXAMPLE
 
.NOTES
SetDatabaseLogonTimeout(System.Int32 LogonTimeout)

A value of -1 means unlimited or no timeout defined
#>
    [cmdletbinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium"
    )]
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
        $Credential,

        # The default time-out value, in seconds, for report server database connections.
        [int32]
        $LogonTimeout = -1
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
                LogonTimeout = $LogonTimeout  
            }

            if ($pscmdlet.ShouldProcess('Set Database Logon Timeout')) 
            {
                Invoke-CimMethod -InputObject $rsSettings -MethodName SetDatabaseLogonTimeout -Arguments $CimArguments | Out-Null
            }
        }
    }
}


