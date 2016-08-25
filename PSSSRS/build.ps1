[cmdletbinding()]param([string[]]$TaskList)
Invoke-PSake $PSScriptRoot\psake.ps1 @PSBoundParameters