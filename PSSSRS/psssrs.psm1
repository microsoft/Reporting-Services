[String]$FTPServerTranscript = ""

$moduleRoot = Split-Path -Path $MyInvocation.MyCommand.Path

Write-Verbose "Importing Functions"
# Import everything in the functions folders
$publicFunctions = LS "$moduleRoot\public-functions\*.ps1" |
  Where-Object { -not ($_.FullName.Contains(".Tests.")) } 
 
$publicFunctions | ForEach-Object { Write-Verbose "Public Function: $($_.FullName)"; . $_.FullName} 
  
$privateFunctions = LS "$moduleRoot\private-functions\*.ps1" |
  Where-Object { -not ($_.FullName.Contains(".Tests.")) } 
 
$privateFunctions | ForEach-Object { Write-Verbose "Private Function: $($_.FullName)"; . $_.FullName} 
  
Write-Verbose 'Export all public functions'
Export-ModuleMember -Function $publicFunctions.BaseName
Export-ModuleMember -Variable FTPServerTranscript
