<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Get-RSSSLCertificateBindings
{
<#
.SYNOPSIS
Gets the SSL Certificate Bindings
.EXAMPLE
Get-RSSSLCertificateBindings
.EXAMPLE
 
.NOTES
ListSSLCertificateBindings(System.Int32 Lcid)

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

            $CimArguments = [ordered]@{
                Lcid = [int](Get-Culture).Lcid       
            }

            Write-Verbose 'ListSSLCertificateBindings'
            Invoke-CimMethod -InputObject $rsSettings -MethodName ListSSLCertificateBindings -Arguments $CimArguments | Out-Null
        }
    }
}
