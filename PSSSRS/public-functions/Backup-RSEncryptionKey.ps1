function Backup-RSEncryptionKey
{
<#
.SYNOPSIS
Backups the encryption key
.EXAMPLE
Backup-RSEncryptionKey
.EXAMPLE
 
.NOTES

BackupEncryptionKey(
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

        [Parameter(Mandatory = $true)]
        [PSCredential]
        [System.Management.Automation.Credential()]
        $KeyCredential,

        [Parameter(Mandatory = $true)]
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

        $CimArguments = [ordered]@{
            Password = $KeyCredential.GetNetworkCredential().Password       
        }

        Write-Verbose 'BackupEncryptionKey'
        $results = Invoke-CimMethod -InputObject $rsSettings -MethodName BackupEncryptionKey -Arguments $CimArguments

        if ($results.HRESULT -eq 0) 
        {
            Write-Verbose "Saving keyfile to $Path"
            [void][System.IO.File]::WriteAllBytes($Path, $results.KeyFile)
            Get-ChildItem -Path $Path
        }
    }
}


