function Set-RSDatabaseQueryTimeout
{
<#
.SYNOPSIS
Specifies the default time-out value for report server database queries.
.EXAMPLE
Set-RSDatabaseQueryTimeout -QueryTimeout 120
.EXAMPLE
 
.NOTES
https://msdn.microsoft.com/en-us/library/ms155080(v=sql.110).aspx
SetDatabaseQueryTimeout(System.Int32 QueryTimeout)

#>
    [cmdletbinding()]
    param
    (
        [Parameter(
            HelpMessage = 'The computer hosting SSRS',
            Position    = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('Server')]
        [string[]]$ComputerName = 'localhost',

        [string]
        $InstanceName='MSSQLSERVER',

        [PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [int32]
        $QueryTimeout = 120
    )

    begin
    {
        # Build a hashtable for spallting that takes into account optional values
        $rsParam = @{}
        if($PSBoundParameters.Instancename)
        {
            $rsParam.Instancename = $PSBoundParameters.Instancename
        }
        if($PSBoundParameters.Credential)
        {
            $rsParam.Credential = $PSBoundParameters.Credential
        }
    }
    process
    {
        foreach($node in $ComputerName) 
        {
            Write-Verbose $node
            $rsParam.ComputerName = $node         
            $rsSettings = Get-RSConfigurationSettings @rsParam 

            $CimArguments = [ordered]@{
                QueryTimeout = $QueryTimeout  
            }

            Write-Verbose 'SetDatabaseQueryTimeout'
            Invoke-CimMethod -InputObject $rsSettings -MethodName SetDatabaseQueryTimeout -Arguments $CimArguments | Out-Null
        }
    }
}


