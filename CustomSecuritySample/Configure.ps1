Write-Host "Creating the User Store Database"
& sqlcmd -S "." -i "Setup\CreateUserStore.Sql"

Write-Host "Copying Logon.aspx page"
Copy-Item -Path Logon.aspx -Destination "C:\Program Files\Microsoft Power BI Report Server\PBIRS\ReportServer\"

Write-Host "Copying Microsoft.Samples.ReportingServices.CustomSecurity.dll"
Copy-Item -Path Microsoft.Samples.ReportingServices.CustomSecurity.dll -Destination "C:\Program Files\Microsoft Power BI Report Server\PBIRS\ReportServer\Bin\"
Copy-Item -Path Microsoft.Samples.ReportingServices.CustomSecurity.dll -Destination "C:\Program Files\Microsoft Power BI Report Server\PBIRS\Portal\"
Copy-Item -Path Microsoft.Samples.ReportingServices.CustomSecurity.dll -Destination "C:\Program Files\Microsoft Power BI Report Server\PBIRS\PowerBi"

Write-Host "Copying Microsoft.Samples.ReportingServices.CustomSecurity.pdb"
Copy-Item -Path Microsoft.Samples.ReportingServices.CustomSecurity.pdb -Destination "C:\Program Files\Microsoft Power BI Report Server\PBIRS\ReportServer\Bin\"
Copy-Item -Path Microsoft.Samples.ReportingServices.CustomSecurity.pdb -Destination "C:\Program Files\Microsoft Power BI Report Server\PBIRS\Portal\"
Copy-Item -Path Microsoft.Samples.ReportingServices.CustomSecurity.pdb -Destination "C:\Program Files\Microsoft Power BI Report Server\PBIRS\PowerBi"

Write-Host "Updating rsreportserver.config"
$rsConfigFilePath = "C:\Program Files\Microsoft Power BI Report Server\PBIRS\ReportServer\rsreportserver.config"
[xml]$rsConfigFile = (Get-Content $rsConfigFilePath)
Write-Host "Copy of the original config file in $rsConfigFilePath.backup"
$rsConfigFile.Save("$rsConfigFilePath.backup")
$rsConfigFile.Configuration.Authentication.AuthenticationTypes.InnerXml = "<Custom />"
$extension = $rsConfigFile.CreateElement("Extension")
$extension.SetAttribute("Name","Forms")
$extension.SetAttribute("Type","Microsoft.Samples.ReportingServices.CustomSecurity.Authorization, Microsoft.Samples.ReportingServices.CustomSecurity")
$configuration =$rsConfigFile.CreateElement("Configuration")
$configuration.InnerXml="<AdminConfiguration>`n<UserName>username</UserName>`n</AdminConfiguration>"
$extension.AppendChild($configuration)
$rsConfigFile.Configuration.Extensions.Security.AppendChild($extension)
$rsConfigFile.Save($rsConfigFilePath)

Write-Host "Updating RSSrvPolicy.config"
$rsPolicyFilePath = "C:\Program Files\Microsoft Power BI Report Server\PBIRS\ReportServer\rssrvpolicy.config"
[xml]$rsPolicy = (Get-Content $rsPolicyFilePath)
Write-Host "Copy of the original config file in $rsPolicyFilePath.backup"
$rsPolicy.Save("$rsPolicyFilePath.backup")

$codeGroup = $rsPolicy.CreateElement("CodeGroup")
$codeGroup.SetAttribute("class","UnionCodeGroup")
$codeGroup.SetAttribute("version","1")
$codeGroup.SetAttribute("Name","SecurityExtensionCodeGroup")
$codeGroup.SetAttribute("Description","Code group for the sample security extension")
$codeGroup.SetAttribute("PermissionSetName","FullTrust")
$codeGroup.InnerXml ="<IMembershipCondition class=""UrlMembershipCondition"" version=""1"" Url=""C:\Program Files\Microsoft Power BI Report Server\PBIRS\ReportServer\bin\Microsoft.Samples.ReportingServices.CustomSecurity.dll""/>"
$rsPolicy.Configuration.mscorlib.security.policy.policylevel.CodeGroup.CodeGroup.AppendChild($codeGroup)
$rsPolicy.Save($rsPolicyFilePath)


Write-Host "Updating web.config"
$webConfigFilePath = "C:\Program Files\Microsoft Power BI Report Server\PBIRS\ReportServer\web.config"
[xml]$webConfig = (Get-Content $webConfigFilePath)
Write-Host "Copy of the original config file in $webConfigFilePath.backup"
$webConfig.Save("$webConfigFilePath.backup")


 $webConfig.configuration.'system.web'.identity.impersonate="false"



$codeGroup = $rsPolicy.CreateElement("CodeGroup")
$codeGroup.SetAttribute("class","UnionCodeGroup")
$codeGroup.SetAttribute("version","1")
$codeGroup.SetAttribute("Name","SecurityExtensionCodeGroup")
$codeGroup.SetAttribute("Description","Code group for the sample security extension")
$codeGroup.SetAttribute("PermissionSetName","FullTrust")
$codeGroup.InnerXml ="<IMembershipCondition class=""UrlMembershipCondition"" version=""1"" Url=""C:\Program Files\Microsoft Power BI Report Server\PBIRS\ReportServer\bin\Microsoft.Samples.ReportingServices.CustomSecurity.dll""/>"
$rsPolicy.Configuration.mscorlib.security.policy.policylevel.CodeGroup.CodeGroup.AppendChild($codeGroup)



$webConfig.Save($webConfigFilePath)




