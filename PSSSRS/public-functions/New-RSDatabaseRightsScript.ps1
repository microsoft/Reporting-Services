<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function New-RSDatabaseRightsScript
{
<#
.SYNOPSIS
Generates a SQL Script that can be used to grant a user rights to the report server database and other databases required for a report server to run. The caller is expected to connect to the SQL Server database server and execute the script.
.EXAMPLE
New-RSDatabaseRightsScript
.EXAMPLE
 
.NOTES
https://msdn.microsoft.com/en-us/library/ms155370(v=sql.110).aspx
GenerateDatabaseRightsScript(
    System.String UserName, 
    System.String DatabaseName, 
    System.Boolean IsRemote, 
    System.Boolean IsWindowsUser
)

If DatabaseName is empty then IsRemote is ignored and the report server configuration file value is used for the database name.

If IsWindowsUser is set to true, UserName should be in the format <domain>\<username>.

When IsWindowsUser is set to true, the generated script grants login rights to the user for the SQL Server, setting the report server database as the default database, and grants the RSExec role on the report server database, the report server temporary database, the master database and the MSDB system database.

When IsWindowsUser is set to true, the method accepts standard Windows SIDs as input. When a standard Windows SID or service account name is supplied, it is translated to a user name string. If the database is local, the account is translated to the correct localized representation of the account. 

If the database is remote, the account is represented as the computer’s account.

#>
    [cmdletbinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Low"
    )]
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
        $Credential,

        [string]
        $UserName,

        [string]
        $DatabaseName = 'ReportServer',

        [switch]
        $IsRemote,

        [switch]
        $IsWindowsUser
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
                UserName      = $UserName
                DatabaseName  = $DatabaseName
                IsRemote      = [bool]$IsRemote
                IsWindowsUser = [bool]$IsWindowsUser
            }

            if ($pscmdlet.ShouldProcess('GenerateDatabaseRightsScript')) 
            {
                Invoke-CimMethod -InputObject $rsSettings -MethodName GenerateDatabaseRightsScript -Arguments $CimArguments 
            }
        }
    }
}
