function New-RSConfigurationSession
{
<#
.SYNOPSIS

.EXAMPLE
New-RSConfigurationSession -ComputerName server
.EXAMPLE
 
.NOTES

#>
    [cmdletbinding()]
    param(
        # Name of remote server
        [Parameter(
            HelpMessage       = 'Enter hostname of the computer',
            Position          = 0,
            ValueFromPipeline = $true
            )]
        [Alias('Server')]
        [string[]]$ComputerName = $env:computername,

        [string]
        $InstanceName='MSSQLSERVER',

        [pscredential]
        $Credential
    )

    process
    {
        foreach($node in $ComputerName)
        {
            Write-Verbose "Enumerating WMI namspaces on $node"
            $common = @{
                Computername = $node
            }

            if($credential){
                $common.Credential = $Credential
            }

            $namespace = "root\Microsoft\SqlServer\ReportServer\RS_$InstanceName"# \v$SqlServerVersion\Admin"
            $version = Get-WmiObject -namespace $namespace -class "__Namespace" -ErrorAction Stop @common

            $namespace = "$namespace\$($version.name)\Admin"

            Write-Verbose "Using namespace: $namespace"
            $RSConfig = Get-WmiObject -namespace $namespace -class MSReportServer_ConfigurationSetting -ErrorAction Stop @common

            Write-Output $RSConfig
        }
    }
}