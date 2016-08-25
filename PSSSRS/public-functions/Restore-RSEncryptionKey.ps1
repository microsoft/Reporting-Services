<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Restore-RSEncryptionKey
{
<#
.SYNOPSIS
Restore an encryption key to a SSRS instance
.EXAMPLE
Restore-RSEncryptionKey -Path key.snk -
.EXAMPLE
 
.NOTES

RestoreEncryptionKey(
    System.Byte[] KeyFile, 
    System.Int32 Length, 
    System.String Password
)
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
        [string]$ComputerName = 'localhost',

        [string]
        $InstanceName='MSSQLSERVER',

        [PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [PSCredential]
        [System.Management.Automation.Credential()]
        $KeyCredential,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({Test-Path $_})]
        [string]
        $Path
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
        $rsParam.ComputerName = $ComputerName         
        $rsSettings = Get-RSConfigurationSettings @rsParam 

        Write-Verbose "Reading key from $Path"
        $keyFile = [System.IO.File]::ReadAllBytes($Path)

        $CimArguments = [ordered]@{
            KeyFile  = $keyFile
            Length   = $keyFile.Length
            Password = $KeyCredential.GetNetworkCredential().Password       
        }

        Write-Verbose 'RestoreEncryptionKey'
        Invoke-CimMethod -InputObject $rsSettings -MethodName RestoreEncryptionKey -Arguments $CimArguments | Out-Null
    }
}


