<#
    .SYNOPSIS
        This script loads up all the PowerShell functions for interacting with SQL Server Reporting Services. 

    .DESCRIPTION
        This script loads up all the PowerShell functions for interacting with SQL Server Reporting Services. You need to do this every time you start a new session in PowerShell otherwise you will not be able to call any of the functions. 
#>

. $PSScriptRoot/Utilities/New-RsConfigurationSettingObject.ps1
. $PSScriptRoot/Utilities/New-RsWebServiceProxy.ps1
. $PSScriptRoot/Admin/Backup-RsEncryptionKey.ps1
. $PSScriptRoot/Admin/Register-PowerBI.ps1
. $PSScriptRoot/Admin/Restore-RsEncryptionKey.ps1
. $PSScriptRoot/Admin/Set-RsEmailSettingsAsBasicAuth.ps1
. $PSScriptRoot/Admin/Set-RsEmailSettingsAsNoAuth.ps1
. $PSScriptRoot/Admin/Set-RsEmailSettingsAsNTLMAuth.ps1
. $PSScriptRoot/CatalogItems/Download-RsCatalogItem.ps1
. $PSScriptRoot/CatalogItems/Download-RsFolderContent.ps1
. $PSScriptRoot/CatalogItems/Get-RsDataSource.ps1
. $PSScriptRoot/CatalogItems/Link-RsDataSet.ps1
. $PSScriptRoot/CatalogItems/Link-RsDataSource.ps1
. $PSScriptRoot/CatalogItems/List-RsCatalogItems.ps1
. $PSScriptRoot/CatalogItems/List-RsItemReferences.ps1
. $PSScriptRoot/CatalogItems/New-RsDataSource.ps1
. $PSScriptRoot/CatalogItems/Remove-RsCatalogItem.ps1
. $PSScriptRoot/CatalogItems/Set-RsDataSource.ps1
. $PSScriptRoot/CatalogItems/Set-RsDataSourcePassword.ps1
. $PSScriptRoot/CatalogItems/Upload-RsCatalogItem.ps1
. $PSScriptRoot/CatalogItems/Upload-RsFolderContent.ps1
. $PSScriptRoot/Security/Grant-AccessOnCatalogItem.ps1
. $PSScriptRoot/Security/Grant-AccessToRs.ps1
. $PSScriptRoot/Security/Revoke-AccessOnCatalogItem.ps1
. $PSScriptRoot/Security/Revoke-AccessToRs.ps1