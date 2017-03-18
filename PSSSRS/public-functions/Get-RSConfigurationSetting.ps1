<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function Get-RSConfigurationSetting
{
<#
.SYNOPSIS

.EXAMPLE
Get-RSConfigurationSession -ComputerName server
.EXAMPLE
 
.NOTES

#>
    [cmdletbinding()]
    param(
        # Name of remote server
        [Parameter(
            HelpMessage = 'Enter hostname of the computer',
            Position    = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('Server')]
        [string[]]$ComputerName = 'localhost',

        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $InstanceName='MSSQLSERVER',

        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    process
    {
        foreach($node in $ComputerName)
        {
            $session = Get-CimSession -ComputerName $node -ea 0

            if(-not $session)
            {
                Write-Verbose "creating cim session to $node"
                $common = @{
                    Computername = $node
                }

                if($credential){
                    $common.Credential = $Credential
                }
                
                $session = New-CimSession @common
            }
            Write-Debug "Enumerating namspaces on $node"
            
            $namespace = "root\Microsoft\SqlServer\ReportServer\RS_$InstanceName"# \v$SqlServerVersion\Admin"

            $CimParams = @{
                Namespace = $namespace
                Class = "__Namespace"
                CimSession = $session
                Verbose = $false
            }
            $version = Get-CimInstance  @CimParams

            $namespace = "$namespace\$($version.name)\Admin"
            Write-Debug "Using namespace: $namespace"

            $CimParams.Namespace = $namespace
            $CimParams.Class = 'MSReportServer_ConfigurationSetting'
            
            $RSConfig = Get-CimInstance @CimParams
            $RSConfig.psobject.TypeNames.Insert(0, "PSSSRS.ConfigurationSettings")

            Write-Output $RSConfig
        }
    }
}