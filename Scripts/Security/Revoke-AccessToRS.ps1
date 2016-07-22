# Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
# Licensed under the MIT License (MIT)

function Revoke-AccessToRS
{
    <#
    .SYNOPSIS
        This script revokes access to SQL Server Reporting Services Instance from users/groups.

    .DESCRIPTION
        This script revokes all access on the SQL Server Reporting Services Instance located at the specified Report Server URI from the specified user/group. 

    .PARAMETER ReportServerUri 
        Specify the Report Server URL to your SQL Server Reporting Services Instance.

    .PARAMETER ReportServerUsername
        Specify the user name to use when connecting to your SQL Server Reporting Services Instance.

    .PARAMETER ReportServerPassword
        Specify the password to use when connecting to your SQL Server Reporting Services Instance.

    .PARAMETER UserOrGroupName
        Specify the user or group name to revoke access from.  
    #>

    param(
        [string]$ReportServerUri = 'http://localhost/reportserver',
        [string]$ReportServerUsername,
        [string]$ReportServerPassword,
        
        [Parameter(Mandatory=$True)]
        [string]$UserOrGroupName
    )

    # creating proxy
    $global:proxy = New-RSWebServiceProxy -ReportServerUri $ReportServerUri -Username $ReportServerUsername -Password $ReportServerPassword

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
        if ($originalPolicy.GroupUserName.Equals($UserOrGroupName, [StringComparison]::OrdinalIgnoreCase))
        {
            continue;
        }
        $policyList.Add($originalPolicy)
    }

    # updating policies on the item
    try
    {
        Write-Debug "Revoking all access from $UserOrGroupName..." 
        $proxy.SetSystemPolicies($policyList.ToArray())
        Write-Host "Revoked all access from $UserOrGroupName!"
    }
    catch [System.Web.Services.Protocols.SoapException]
    {
        Write-Error "Error occurred while revoking all access from $UserOrGroupName! `n$($_.Exception.Message)"
        Exit 2
    }
}
