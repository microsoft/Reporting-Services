<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function New-RSDatabaseCreationScript
{
<#
.SYNOPSIS
Generates a SQL Script that can be used to create a report server database.
.EXAMPLE
ew-RSDatabaseCreationScript
.EXAMPLE
 
.NOTES
https://msdn.microsoft.com/en-us/library/ms152823(v=sql.110).aspx
GenerateDatabaseCreationScript(
    System.String DatabaseName, 
    System.Int32 Lcid, 
    System.Boolean IsSharePointMode
)

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
                Lcid              = (Get-Culture).Lcid
                IsSharePointMode  = [bool]$false      
            }

            Write-Verbose 'GenerateDatabaseCreationScript'
            Invoke-CimMethod -InputObject $rsSettings -MethodName GenerateDatabaseCreationScript -Arguments $CimArguments
        }
    }
}
