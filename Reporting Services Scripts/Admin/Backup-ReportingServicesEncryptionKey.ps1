param(
    [string]$sqlServerInstance,
    
    [Parameter(Mandatory=$True)]
    [string]$password,
    
    [Parameter(Mandatory=$True)]
    [string]$keyPath    
)

$namespace = '';
if ([string]::IsNullOrEmpty($sqlServerInstance)) {
    $namespace = 'root\Microsoft\SqlServer\ReportServer\RS_MSSQLSERVER\v13\Admin';
} else {
    $namespace = "root\Microsoft\SqlServer\ReportServer\RS_$sqlServerInstance\v13\Admin";
}

$rsWmiObject = Get-WmiObject -namespace $namespace -class MSReportServer_ConfigurationSetting -ErrorAction Stop

Write-Host "Retrieving encryption key..."
$encryptionKeyResult = $rsWmiObject.BackupEncryptionKey($password)

if ($encryptionKeyResult.HRESULT -eq 0) {
    Write-Host "Success!";
} else {
    Write-Error "Fail! `n Errors: $($encryptionKeyResult.ExtendedErrors)";
    Exit 1
}

Write-Host "Writing key to file..."
[System.IO.File]::WriteAllBytes($keyPath, $encryptionKeyResult.KeyFile)
Write-Host "Success!"
