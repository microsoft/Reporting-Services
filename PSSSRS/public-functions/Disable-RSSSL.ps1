<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Disable-RSSSL
{
<#
.SYNOPSIS
Sets the Secure Connection Level to not require SSL
.EXAMPLE
Disable-RSSSL
.EXAMPLE
 
.NOTES

https://msdn.microsoft.com/en-us/library/ms152810(v=sql.110).aspx
SetSecureConnectionLevel(System.Int32 Level)

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

            $CimArguments = [ordered]@{
                Level = 0 # Disabled        
            }

            Write-Verbose 'SetSecureConnectionLevel'
            Invoke-CimMethod -InputObject $rsSettings -MethodName SetSecureConnectionLevel -Arguments $CimArguments | Out-Null
        }
    }
}


