<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Set-RSEmailConfiguration
{
<#
.SYNOPSIS
Sets the SSRS email configuration details
.EXAMPLE
Set-RSEmailConfiguration -SmtpServer 127.0.0.1 -SenderEmailAddress 'reports@contoso.com'
.EXAMPLE
 
.NOTES

SetEmailConfiguration(
    System.Boolean SendUsingSmtpServer, 
    System.String SmtpServer, 
    System.String SenderEmailAddress
)

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

        [string]
        $SmtpServer = '',

        [string]
        [alias('Email')]
        $SenderEmailAddress = '',

        [switch]
        $Enabled = $true
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
                SendUsingSmtpServer = [bool]$Enabled
                SmtpServer          = $SmtpServer
                SenderEmailAddress  = $SenderEmailAddress            
            }

            Write-Verbose 'SetEmailConfiguration'
            Invoke-CimMethod -InputObject $rsSettings -MethodName SetEmailConfiguration -Arguments $CimArguments | Out-Null
        }
    }
}
