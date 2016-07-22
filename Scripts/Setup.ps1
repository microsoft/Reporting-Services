<#
    .SYNOPSIS
        This script loads up all the PowerShell functions for interacting with SQL Server Reporting Services. 

    .DESCRIPTION
        This script loads up all the PowerShell functions for interacting with SQL Server Reporting Services. You need to do this every time you start a new session in PowerShell otherwise you will not be able to call any of the functions. 
#>

. $PSScriptRoot/Utilities/New-RSConfigurationSettingObject.ps1
. $PSScriptRoot/Utilities/New-RSWebServiceProxy.ps1
. $PSScriptRoot/Admin/Backup-RSEncryptionKey.ps1
. $PSScriptRoot/Admin/Register-PowerBI.ps1
. $PSScriptRoot/Admin/Restore-RSEncryptionKey.ps1
. $PSScriptRoot/Security/Grant-AccessOnCatalogItem.ps1
. $PSScriptRoot/Security/Grant-AccessToRS.ps1
. $PSScriptRoot/Security/Revoke-AccessOnCatalogItem.ps1
. $PSScriptRoot/Security/Revoke-AccessToRS.ps1
