function Set-RSExtendedProtectionSettings
{
<#
.SYNOPSIS
The SetExtendedProtectionSettings method is used to set the RSWindowsExtendedProtectionLevel and the RSWindowsExtendedProtectionScenario properties in the Reporting Services configuration file RSReportServer.config.
.EXAMPLE
Set-RSExtendedProtectionSettings -ExtendedProtectionLevel Allow -ExtendedProtectionScenario Any
.EXAMPLE
 
.NOTES
https://msdn.microsoft.com/en-us/library/ff487724(v=sql.110).aspx

SetExtendedProtectionSettings(
    System.String ExtendedProtectionLevel, 
    System.String ExtendedProtectionScenario
)

The RSWindowsExtendedProtectionLevel and the RSWindowsExtendedProtectionScenario properties apply when the AuthenticationTypes in the RSReportServer.config file include RSWindowNTLM, RSWindowsNegotiate, or RSWindowsKerberos. Setting these properties affects how users and client software authenticate with a report server. It is recommended that you read the documentation for extended protection before setting ExtendedProtectionLevel to either Allow or Require.

To set the ExtendedProtectionLevel, the user must be a member of the BUILTIN\Administrators group on the report server.

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

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet('Off', 'Allow', 'Require')]
        [string]
        $ExtendedProtectionLevel,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet('Any','Proxy','Direct')]
        [string]
        $ExtendedProtectionScenario
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
                ExtendedProtectionLevel    = $ExtendedProtectionLevel
                ExtendedProtectionScenario = $ExtendedProtectionScenario            
            }

            Write-Verbose 'SetExtendedProtectionSettings'
            Invoke-CimMethod -InputObject $rsSettings -MethodName SetExtendedProtectionSettings -Arguments $CimArguments | Out-Null
        }
    }
}
