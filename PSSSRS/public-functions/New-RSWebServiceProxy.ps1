<#
Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
Licensed under the MIT License (MIT)
#>

function New-RSWebServiceProxy
{
    <#
    .SYNOPSIS
        This script creates a web service proxy object to the Reporting Services SOAP endpoint.

    .DESCRIPTION
        This script creates a web service proxy object to the Reporting Services SOAP endpoint associated to the Report Server URI specified by the user. 

    .PARAMETER ComputerName (optional)
        Specify the server hosting your SQL Server Reporting Services Instance.

    .PARAMETER ReportServerUri (optional)
        Specify the Report Server URL to your SQL Server Reporting Services Instance.

    .PARAMETER Credential (optional)
        Specify the credentials to use when connecting to your SQL Server Reporting Services Instance.

    .EXAMPLE 
        New-RSWebServiceProxy 
        Description
        -----------
        This command will create and return a web service proxy to the Report Server located at http://localhost/reportserver using current user's credentials.
        
    .EXAMPLE 
        New-RSWebServiceProxy -ReportServerUri http://myserver/reportserver_sql2012
        Description
        -----------
        This command will create and return a web service proxy to the Report Server located at http://myserver/reportserver_sql2012 using current user's credentials.
    
    .EXAMPLE 
        New-RSWebServiceProxy -Credential (Get-Credential)
        Description
        -----------
        This command will create and return a web service proxy to the Report Server located at http://localhost/reportserver using the provided credentials.
    #>

    [cmdletbinding(DefaultParameterSetName='Default')]
    param
    (
        [Parameter(
            HelpMessage = 'The computer hosting SSRS',
            Position    = 0,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Default'
        )]
        [Alias('Server')]
        [string]
        $ComputerName = 'localhost',

        [PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter(
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Uri'
        )]
        [string]
        $ReportServerUri = 'http://localhost/reportserver'
    )

    process
    {
        if($PSCmdlet.ParameterSetName = 'Default')
        {
            $ReportServerUri = "http://$ComputerName/reportserver"
        }

        # forming the full URL to the SOAP Proxy of ReportServerUri 
        if ($ReportServerUri[$ReportServerUri.Length - 1] -ne '/') 
        {
            $ReportServerUri = $ReportServerUri + '/'
        }

        $reportServerUriObject = New-Object System.Uri($ReportServerUri)
        $soapEndpointUriObject = New-Object System.Uri($reportServerUriObject, 'ReportService2010.asmx')
        $ReportServerUri       = $soapEndPointUriObject.ToString()

        $proxyParams = @{
            Uri         = $ReportServerUri
            ErrorAction = 'Stop'
        }

        # creating proxy either using specified credentials or default credentials
        if ($Credential) 
        {
            $proxyParams.Credential = $Credential 
        }
        else
        {
            $proxyParams.useDefaultCredential = $true
        }

        Write-Output (New-WebServiceProxy @proxyParams)
    }
}