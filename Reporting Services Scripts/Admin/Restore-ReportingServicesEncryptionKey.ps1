param(
    [string]$sqlServerInstance,
    
    [Parameter(Mandatory=$True)]
    [string]$password,
    
    [Parameter(Mandatory=$True)]
    [string]$keyPath    
)

$namespace = '';
$reportServerService = 'ReportServer';
if ([string]::IsNullOrEmpty($sqlServerInstance)) {
    $namespace = 'root\Microsoft\SqlServer\ReportServer\RS_MSSQLSERVER\v13\Admin';
} else {
    $namespace = "root\Microsoft\SqlServer\ReportServer\RS_$sqlServerInstance\v13\Admin";
    $reportServerService = $reportServerService + '$' + $sqlServerInstance;
}

$rsWmiObject = Get-WmiObject -namespace $namespace -class MSReportServer_ConfigurationSetting -ErrorAction Stop

Write-Debug "Checking if key file path is valid..."
if (![System.IO.File]::Exists($keyPath)) {
    Write-Error "No key was found at the specified location: $path"
    Exit 1
}

$keyBytes = [System.IO.File]::ReadAllBytes($keyPath)

Write-Host "Restoring encryption key..."
$restoreKeyResult = $rsWmiObject.RestoreEncryptionKey($keyBytes, $keyBytes.Length, $password)

if ($restoreKeyResult.HRESULT -eq 0) {
    Write-Host "Success!";
} else {
    Write-Error "Fail! `n Errors: $($restoreKeyResult.ExtendedErrors)";
    Exit 2
}

Write-Host "Stopping Reporting Services Service..."
Stop-Service $reportServerService -ErrorAction Stop

Write-Host "Starting Reporting Services Service..."
Start-Service $reportServerService -ErrorAction Stop
