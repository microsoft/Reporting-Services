<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Get-RSReservedUrls
{
<#
.SYNOPSIS
List Reserved Urls
.EXAMPLE
Get-RSReservedUrls
.EXAMPLE
 
.NOTES
ListReservedUrls()
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
            $rsSettings = Get-RSConfigurationSettings @rsParam 

            Write-Verbose 'ListReservedUrls'
            $results = Invoke-CimMethod -InputObject $rsSettings -MethodName ListReservedUrls

            if($results.Length)
            {
                for($index = 0;$index -lt $results.Length; $index += 1)
                {
                    $url = [pscustomobject]@{
                        Application    =  $results.Application[$index]
                        UrlString      = $results.UrlString[$index]
                        Account        = $results.Account[$index]
                        AccountSID     = $results.AccountSID[$index]
                        PSComputerName = $node
                    }

                    $url.psobject.TypeNames.Insert(0, "PSSSRS.ReservedUrl")
                    Write-Output $url
                }
            }
        }
    }
}
