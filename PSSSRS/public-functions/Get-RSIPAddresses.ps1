<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Get-RSIPAddresses
{
<#
.SYNOPSIS
Get SSRS IP Addresses
.EXAMPLE
Get-RSIPAddresses
.EXAMPLE
 
.NOTES
ListIPAddresses()
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

            Write-Verbose 'ListIPAddresses'
            $addresses = Invoke-CimMethod -InputObject $rsSettings -MethodName ListIPAddresses

            for($index = 0;$index -lt $addresses.Length; $index += 1)
            {
                $IPAddress = [pscustomobject]@{
                    IPAddress     =  $addresses.IPAddress[$index]
                    IPVersion     = $addresses.IPVersion[$index]
                    IsDhcpEnabled = $addresses.IsDhcpEnabled[$index]
                    PSComputerName  = $node
                }

                $IPAddress.psobject.TypeNames.Insert(0, "PSSSRS.IPAddress")
                Write-Output $IPAddress
            }
        }
    }
}
