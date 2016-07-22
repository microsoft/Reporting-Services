# Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
# Licensed under the MIT License (MIT)

function New-RSConfigurationSettingObject
{
    <#
    .SYNOPSIS
        This script creates a new WMI Object that is connected to Reporting Services WMI Provider.

    .DESCRIPTION
        This script creates a new WMI Object that is connected to Reporting Services WMI Provider. 

    .PARAMETER SqlServerInstance 
        Specify the name of the SQL Server Reporting Services Instance.
    
    .PARAMETER SqlServerVersion 
        Specify the version of the SQL Server Reporting Services Instance. 13 for SQL Server 2016, 12 for SQL Server 2014, 11 for SQL Server 2012
    #>
    param(
        [string]$SqlServerInstance='MSSQLSERVER',
        [string]$SqlServerVersion='13'
    )

    $namespace = "root\Microsoft\SqlServer\ReportServer\RS_$SqlServerInstance\v$SqlServerVersion\Admin";
    return Get-WmiObject -namespace $namespace -class MSReportServer_ConfigurationSetting -ErrorAction Stop
}