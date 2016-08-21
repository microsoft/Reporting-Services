function Remove-RSEncryptionKey
{
<#
.SYNOPSIS
Removes the encryption key
.EXAMPLE
Remove-RSEncryptionKey
.EXAMPLE
 
.NOTES

DeleteEncryptionKey(
    System.String InstallationID
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
                InstallationID = $rsSettings.InstallationID        
            }

            Write-Verbose 'DeleteEncryptionKey'
            Invoke-CimMethod -InputObject $rsSettings -MethodName DeleteEncryptionKey -Arguments $CimArguments | Out-Null
        }
    }
}


