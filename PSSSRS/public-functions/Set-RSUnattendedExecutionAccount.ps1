function Set-RSUnattendedExecutionAccount
{
<#
.SYNOPSIS
Sets the Windows Service Identity
.EXAMPLE
Set-RSWindowsServiceIdentity -UseBuiltInAccount -ServiceIdentityCredential $credential
.EXAMPLE
 
.NOTES

SetUnattendedExecutionAccount(
    System.String UserName, 
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
        [string[]]$ComputerName = 'localhost',

        [string]
        $InstanceName='MSSQLSERVER',

        [PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [PSCredential]
        [System.Management.Automation.Credential()]
        $AccountCredential
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
                Account           = $AccountCredential.UserName
                Password          = $AccountCredential.GetNetworkCredential().Password            
            }

            Write-Verbose 'SetUnattendedExecutionAccount'
            Invoke-CimMethod -InputObject $rsSettings -MethodName SetUnattendedExecutionAccount -Arguments $CimArguments | Out-Null
        }
    }
}
