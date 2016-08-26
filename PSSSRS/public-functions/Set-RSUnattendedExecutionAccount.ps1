<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Set-RSUnattendedExecutionAccount
{
<#
.SYNOPSIS
Sets the Windows Service Identity
.EXAMPLE
Set-RSWindowsServiceIdentity -UseBuiltInAccount -ServiceIdentityCredential $credential
.EXAMPLE
 
.NOTES

SetUnattendedExecutionAccount(
    System.String UserName, 
    System.String Password
)

#>
    [cmdletbinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="medium"
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

        [Alias('AccountName')]
        [PSCredential]
        [System.Management.Automation.Credential()]
        $AccountCredential
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
                Account           = $AccountCredential.UserName
                Password          = $AccountCredential.GetNetworkCredential().Password            
            }

            if ($pscmdlet.ShouldProcess('Set Unattended Execution Account')) 
            {
                Invoke-CimMethod -InputObject $rsSettings -MethodName SetUnattendedExecutionAccount -Arguments $CimArguments | Out-Null
            }
        }
    }
}
