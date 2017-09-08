$ReportPortalUri = 'http://myserver/reports/'

Write-Host "Upload an item..."
$uploadItemPath = 'C:\reports\test.rdl'
$catalogItemsUri = $ReportPortalUri + "/api/v2.0/CatalogItems"
$bytes = [System.IO.File]::ReadAllBytes($uploadItemPath)
$payload = @{
    "@odata.type" = "#Model.Report";
    "Content" = [System.Convert]::ToBase64String($bytes);
    "ContentType"="";
    "Name" = 'chart';
    "Path" = '/chart';
    } | ConvertTo-Json
Invoke-WebRequest -Uri $catalogItemsUri -Method Post -Body $payload -ContentType "application/json" -UseDefaultCredentials | Out-Null


Write-Host "Download an item..."
$item = '/test'
$downloadPath = 'C:\download\test.rdl'
$catalogItemsApi = $ReportPortalUri + "/api/v2.0/CatalogItems(Path='{0}')/Content/$value"
$url = [string]::Format($catalogItemsApi, $item)
$response = Invoke-WebRequest -Uri $url -Method Get -UseDefaultCredentials
[System.IO.File]::WriteAllBytes($downloadPath, $response.Content)


Write-Host "Delete an item..."
$item = '/test'
$url = $ReportPortalUri + "/api/v2.0/CatalogItems(Path='$item')"
Invoke-WebRequest -Uri $url -Method Delete -UseDefaultCredentials | Out-Null



