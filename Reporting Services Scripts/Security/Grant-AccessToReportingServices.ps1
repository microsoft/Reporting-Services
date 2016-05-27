param(
    [string]$reportServerUri,
    [string]$reportServerUsername,
    [string]$reportServerPassword,
    
    [Parameter(Mandatory=$True)]
    [string]$userOrGroupName,
    
    [Parameter(Mandatory=$True)]
    [string]$roleName
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

# retrieving roles from the proxy 
Write-Debug "Retrieving valid roles for System Policies..."
$roles = $proxy.ListRoles("System", $null)

# validating the role name provided by user
Write-Debug "Validating role name specified: $roleName..."
$isRoleValid = $false
foreach ($role in $roles)
{
    if ($role.Name.Equals($roleName, [StringComparison]::OrdinalIgnoreCase))
    {
        $isRoleValid = $true
        break
    }
}

if (!$isRoleValid)
{
    $errorMessage = "Role name is not valid. Valid options are: "
    foreach ($role in $roles)
    {
        $errorMessage = $errorMessage + $role.Name + ', ' 
    }
    Write-Error $errorMessage
    Exit 1
}

# retrieving existing system policies
try
{
    Write-Debug "Retrieving system policies..."
    $originalPolicies = $proxy.GetSystemPolicies()
    
    Write-Debug "Policies retrieved: $($originalPolicies.Length)!"
    foreach ($policy in $originalPolicies)
    {
        Write-Debug "Policy: $($policy.GroupUserName) is $($policy.Roles[0].Name)" 
    }
}
catch [System.Web.Services.Protocols.SoapException]
{
    Write-Error "Error retrieving existing system policies! `n$($_.Exception.Message)"
    Exit 2
}

# determining namespace of the proxy and the names of needed data types 
$namespace = $proxy.GetType().Namespace
$policyDataType = ($namespace + '.Policy')
$roleDataType = ($namespace + '.Role')

# copying all the original policies so that we don't lose them
$numPolicies = $originalPolicies.Length + 1
$policies = New-Object ($policyDataType + '[]')$numPolicies
$index = 0
foreach ($originalPolicy in $originalPolicies)
{
    $policies[$index++] = $originalPolicy
}

# creating new policy
$policy = New-Object ($policyDataType)
$policy.GroupUserName = $userOrGroupName

# creating new role
$role = New-Object ($roleDataType)
$role.Name = $roleName

# associating role to the policy
$numRoles = 1
$policy.Roles = New-Object($roleDataType + '[]')$numRoles
$policy.Roles[0] = $role

# adding new policy to the policies array
$policies[$originalPolicies.Length] = $policy

# updating policies on the item
try
{
    Write-Debug "Granting $($role.Name) to $($policy.GroupUserName)..." 
    $proxy.SetSystemPolicies($policies)
    Write-Host "Granted $($role.Name) to $($policy.GroupUserName)!"
}
catch [System.Web.Services.Protocols.SoapException]
{
    Write-Error "Error occurred while granting $($role.Name) to $($policy.GroupUserName)! `n$($_.Exception.Message)"
    Exit 3
}