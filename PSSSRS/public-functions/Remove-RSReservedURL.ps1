<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Remove-RSReservedURL
{
<#
.SYNOPSIS
Removes a URL reserved for the report server. If there are multiple URLs that need to be removed, this must be done one by one calling this API.
.EXAMPLE
Remove-RSReservedURL -Application ReportManager -UrlString 'http://+:80'
.EXAMPLE
 
.NOTES
https://msdn.microsoft.com/en-us/library/bb630596(v=sql.110).aspx
RemoveURL(
    System.String Application, 
    System.String UrlString, 
    System.Int32 Lcid
)

UrlString does not include the Virtual Directory name – the Set-RSVirtualDirectory Method (WMI MSReportServer_ConfigurationSetting) method is provided for that purpose.

Before calling the ReserveURL method, you must supply a value for the VirtualDirectory configuration property for the Application parameter. Use the Set-RSVirtualDirectory Method (WMI MSReportServer_ConfigurationSetting) method to set the VirtualDirectory property.

If an SSL Certificate was provisioned by Reporting Services and no other URLs need it, it is removed.

This method causes all non-configuration app domains to hard recycle and stop during this operation; app domains are restarted after this operation complete.
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
        [Alias('Server','PSComputerName')]
        [string[]]$ComputerName = 'localhost',

        [string]
        $InstanceName='MSSQLSERVER',

        [PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        # The name of application for which to set the virtual directory.
        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Application,

        # The URL for the reservation.
        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $UrlString
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
                Application = $Application  
                UrlString   = $UrlString
                Lcid        = [int32](Get-Culture).Lcid
            }

            if ($pscmdlet.ShouldProcess('Remove SSL Certificate Bindings')) 
            {
                Invoke-CimMethod -InputObject $rsSettings -MethodName RemoveURL -Arguments $CimArguments | Out-Null
            }
        }
    }
}


