# Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
# Licensed under the MIT License (MIT)

<#============================================================================
  File:     powershellSamples.ps1
  Summary:  Demonstrates examples to upload/download/delete an item in RS. 
--------------------------------------------------------------------
    
 This source code is intended only as a supplement to Microsoft
 Development Tools and/or on-line documentation. See these other
 materials for detailed information regarding Microsoft code 
 samples.
 THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
 ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
 PARTICULAR PURPOSE.
===========================================================================#>

$ReportPortalUri = 'http://myserver/reports'

Write-Host "Upload an item..."
$uploadItemPath = 'C:\reports\test.rdl'
$catalogItemsUri = $ReportPortalUri + "/api/v2.0/CatalogItems"
$bytes = [System.IO.File]::ReadAllBytes($uploadItemPath)
$payload = @{
    "@odata.type" = "#Model.Report";
    "Content" = [System.Convert]::ToBase64String($bytes);
    "ContentType"="";
    "Name" = 'test';
    "Path" = '/test';
    } | ConvertTo-Json
Invoke-WebRequest -Uri $catalogItemsUri -Method Post -Body $payload -ContentType "application/json" -UseDefaultCredentials | Out-Null


Write-Host "Download an item..."
$downloadPath = 'C:\download\test.rdl'
$catalogItemsApi = $ReportPortalUri + "/api/v2.0/CatalogItems(Path='/test')/Content/$value"
$url = [string]::Format($catalogItemsApi, $item)
$response = Invoke-WebRequest -Uri $url -Method Get -UseDefaultCredentials
[System.IO.File]::WriteAllBytes($downloadPath, $response.Content)


Write-Host "Delete an item..."
$url = $ReportPortalUri + "/api/v2.0/CatalogItems(Path='/test')"
Invoke-WebRequest -Uri $url -Method Delete -UseDefaultCredentials | Out-Null



