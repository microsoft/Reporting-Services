param(
    [string]$reportServerUri,
    [string]$reportServerUsername,
    [string]$reportServerPassword,
    
    [Parameter(Mandatory=$True)]
    [string]$userOrGroupName
)

# initializing report server uri if not specified
if ([string]::IsNullOrEmpty($reportServerUri))
{
    $reportServerUri = "http://localhost/reportserver/ReportService2010.asmx"    
}

# creating proxy either using specified credentials or default credentials
if (![string]::IsNullOrEmpty($reportServerUsername) -and ![string]::IsNullOrEmpty($reportServerPassword)) 
{
    $credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, (ConvertTo-SecureString $password -AsPlainText -Force)
    $global:proxy = New-WebServiceProxy -Uri $ReportServerUri -Credential $credentials -ErrorAction Stop   
}
else
{
    $global:proxy = New-WebServiceProxy -Uri $reportServerUri -useDefaultCredential -ErrorAction Stop
}

# retrieving existing policies for the current item
try
{
    Write-Debug "Retrieving system policies..."
    $originalPolicies = $proxy.GetSystemPolicies()
    
    Write-Debug "Policies retrieved: $($originalPolicies.Length)!"
}
catch [System.Web.Services.Protocols.SoapException]
{
    Write-Error "Error retrieving existing system policies! `n$($_.Exception.Message)"
    Exit 1
}

# determining namespace of the proxy and the names of needed data types 
$namespace = $proxy.GetType().Namespace
$policyDataType = ($namespace + '.Policy')

# keeping only those policies where userOrGroupName is not explicitly mentioned
$policyList = New-Object ("System.Collections.Generic.List[$policyDataType]")
foreach ($originalPolicy in $originalPolicies)
{
    if ($originalPolicy.GroupUserName.Equals($userOrGroupName, [StringComparison]::OrdinalIgnoreCase))
    {
        continue;
    }
    $policyList.Add($originalPolicy)
}

# updating policies on the item
try
{
    Write-Debug "Revoking all access from $userOrGroupName..." 
    $proxy.SetSystemPolicies($policyList.ToArray())
    Write-Host "Revoked all access from $userOrGroupName!"
}
catch [System.Web.Services.Protocols.SoapException]
{
    Write-Error "Error occurred while revoking all access from $userOrGroupName! `n$($_.Exception.Message)"
    Exit 2
}
