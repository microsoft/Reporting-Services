# Next steps - READ!

* If deploying the control on an intranet site make sure that the page is targeting HTML5.


## Adding the Report Viewer Control to a new project

1. Create a new ASP.Net empty web site, or open an existing ASP.Net project 
![New web project](Get-Started-With-RVC/NewAspWebSite.png)

2. Install the Report Viewer Control Nuget package via the Nuget package manager console
```
Install-Package Microsoft.ReportingServices.ReportViewerControl.WebForms
```
3. Add a new .aspx page to the project and register the Report Viewer Control assembly for use within the page
```
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>
```
4. Add a ScriptManagerControl to the page
5. Add the Report Viewer control to the page. The below snippet can be updated to reference a report hosted on a remote Report Server
```
<rsweb:ReportViewer ID="ReportViewer1" runat="server" ProcessingMode="Remote">
   <ServerReport ReportPath="" ReportServerUrl="" />
</rsweb:ReportViewer>
```

The final page should look like
```
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="Sample" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" /> 
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server"></asp:ScriptManager>        
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" ProcessingMode="Remote">
            <ServerReport ReportServerUrl="http://AContosoDepartment/ReportServer" ReportPath="/LatestSales" />
        </rsweb:ReportViewer>
    </form>
</body>
</html>
```

## Updating an existing project to use the Report Viewer Control

To make use of the Report Viewer Control in an existing project add the control via Nuget, and update assembly references to version 14.0.0.0. This will include updating the project’s web.config and all .aspx pages that reference the Report Viewer Control.

**Sample web.config changes**

```
<?xml version="1.0"?>
<!--
  For more information on how to configure your ASP.NET application, please visit
  http://go.microsoft.com/fwlink/?LinkId=169433
  -->
<configuration>
  <system.web>
    <compilation debug="true" targetFramework="4.5.2">
      <assemblies>
        <add assembly="Microsoft.ReportViewer.Common, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91"/>
        <add assembly="Microsoft.ReportViewer.DataVisualization, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91"/>
        <add assembly="Microsoft.ReportViewer.Design, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91"/>
        <add assembly="Microsoft.ReportViewer.ProcessingObjectModel, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91"/>
        <add assembly="Microsoft.ReportViewer.WebDesign, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91"/>
        <add assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91"/>
        <add assembly="Microsoft.ReportViewer.WinForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91"/>
      </assemblies>
      <buildProviders>
        <add extension=".rdlc"
          type="Microsoft.Reporting.RdlBuildProvider, Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91"/>
      </buildProviders>
    </compilation>
    <httpRuntime targetFramework="4.5.2"/>
    <httpHandlers>
      <add path="Reserved.ReportViewerWebControl.axd" verb="*"
        type="Microsoft.Reporting.WebForms.HttpHandler, Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91"
        validate="false"/>
    </httpHandlers>
  </system.web>
  <system.webServer>
    <validation validateIntegratedModeConfiguration="false"/>
    <modules runAllManagedModulesForAllRequests="true"/>
    <handlers>
      <add name="ReportViewerWebControlHandler" verb="*" path="Reserved.ReportViewerWebControl.axd" preCondition="integratedMode"
        type="Microsoft.Reporting.WebForms.HttpHandler, Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845DCD8080CC91"/>
    </handlers>
  </system.webServer>
</configuration>
```

**Sample .aspx**

```
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="SampleAspx" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html>
```


## Common issues

### Page is rendering in intranet compatability mode

The Report Viewer Control is designed to be used with modern browsers, the control may not function if browsers render the web page in an IE compatibility mode. Intranet sites may require a '<meta http-equiv="X-UA-Compatible" content="IE=edge" />' tag to override setting which encourage rendering intranet pages in compatibility mode.

### How to set 100% height on the new Report Viewer control
For detailed instructions [click here](http://htmlpreview.github.io/?https://github.com/Microsoft/Reporting-Services/blob/master/Docs_14_0/Set-100Percent-Height-With-RVC.html)

### Unable to load DLL 'SqlServerSpatial140.dll': The specified module could not be found. (Exception from HRESULT: 0x8007007E)
For detailed instructions, [click here](http://htmlpreview.github.io/?https://github.com/Microsoft/Reporting-Services/blob/master/Docs_14_0/Set-Reference-To-Sql-Server-Spatial.html).
