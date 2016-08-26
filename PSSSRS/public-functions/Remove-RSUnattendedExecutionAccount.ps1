<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Remove-RSUnattendedExecutionAccount
{
<#
.SYNOPSIS
Remove Unattended Execution Account
.EXAMPLE
Remove-RSUnattendedExecutionAccount
.EXAMPLE
 
.NOTES
RemoveUnattendedExecutionAccount()
#>
    [cmdletbinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="High"
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

            Write-Verbose 'RemoveUnattendedExecutionAccount'
            Invoke-CimMethod -InputObject $rsSettings -MethodName RemoveUnattendedExecutionAccount | Out-Null
        }
    }
}
