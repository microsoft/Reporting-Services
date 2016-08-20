function Set-RSDatabaseConnection
{
<#
.SYNOPSIS
Sets the SSRS database connection details
.EXAMPLE
Set-RSDatabaseConnection -SQLServer server -DatabaseName reportserver -Credentialstype SQL -UserName reports -Password P@ssw0rd11
.EXAMPLE
 
.NOTES
https://msdn.microsoft.com/en-us/library/ms155102.aspx
SetDatabaseConnection(
    System.String Server, 
    System.String DatabaseName, 
    System.Int32 CredentialsType, 
    System.String UserName, 
    System.String Password)

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

        [string]
        [alias('SQLServer')]
        $Source = 'localhost',

        [string]
        $DatabaseName = 'ReportServer',

        [string]
        [ValidateSet('Windows','SQL','Service')]
        $CredentialType = 'Service',

        [PSCredential]
        [System.Management.Automation.Credential()]
        $SQLCredential
    )

    begin
    {
        $credentialsTypes = @{
            'Windows' = 0
            'SQL'     = 1
            'Service' = 2
        }

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

            $RSParams = [ordered]@{
                Server = $Source
                DatabaseName = $DatabaseName
                CredentialsType = $credentialsTypes[$CredentialType] 
                UserName = ''
                Password = ''               
            }

            if($SQLCredential)
            {
                $RSParams.UserName = $SQLCredential.UserName
                $RSParams.Password = $SQLCredential.GetNetworkCredential().Password
            }

            Invoke-CimMethod -InputObject $rsSettings -MethodName SetDatabaseConnection -Arguments $RSParams | Out-Null
        }
    }
}
