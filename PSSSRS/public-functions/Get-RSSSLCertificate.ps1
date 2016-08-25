<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Get-RSSSLCertificate
{
<#
.SYNOPSIS
List SSRS SSL Certificates
.EXAMPLE
Get-RSSSLCertificates
.EXAMPLE
 
.NOTES
ListSSLCertificates()
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

            Write-Verbose 'ListSSLCertificates'
            $results = Invoke-CimMethod -InputObject $rsSettings -MethodName ListSSLCertificates

            if($results.Length)
            {
                for($index = 0;$index -lt $results.Length; $index += 1)
                {
                    $cert = [pscustomobject]@{                        
                        CertName        = $results.CertName[$index]
                        Hostname        = $results.Hostname[$index]
                        CertificateHash = $results.CertificateHash[$index]
                        PSComputerName  = $node
                    }

                    $url.psobject.TypeNames.Insert(0, "PSSSRS.SslCertificate")
                    Write-Output $cert
                }
            }
        }
    }
}
