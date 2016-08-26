<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function New-RSDatabaseUpgradeScript
{
<#
.SYNOPSIS
Generates a script that can be used to upgrade the report server database to the SQL Server 2008 schema.
.EXAMPLE
New-RSDatabaseUpgradeScript
.EXAMPLE
 
.NOTES
https://msdn.microsoft.com/en-us/library/ms154641(v=sql.110).aspx
GenerateDatabaseUpgradeScript(
    System.String DatabaseName, 
    System.String ServerVersion
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

        [Alias('UserName')]
        [PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [string]
        $DatabaseName = 'ReportServer'
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
                DatabaseName      = $DatabaseName
                ServerVersion     = $rsSettings.Version
            }

            Write-Verbose 'GenerateDatabaseUpgradeScript'
            Invoke-CimMethod -InputObject $rsSettings -MethodName GenerateDatabaseUpgradeScript -Arguments $CimArguments 
        }
    }
}
