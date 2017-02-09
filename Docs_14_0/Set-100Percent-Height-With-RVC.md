# How to set 100% height on the new Report Viewer 2016 control
The new Report Viewer 2016 control is optimized for HTML5 Standards mode pages and works on all modern browsers. In the past with the old RVC control when you set the 100% height property it worked even if none of the ancestors had height specified. This behavior has changed in HTML5. When you set this property on the new RVC control, it will work correctly only if the parent element has a defined height, i.e. not a value of auto, or all the ancestors of RVC have 100% height too.

Below are the two examples to do this

### By setting the height of all the parent elements to 100%

```html
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">    
<head runat="server">
    <style>
        html,body,form,#div1 {
            height: 100%; 
        }
    </style>
   </head>
<body >
    <form id="form1" runat="server">
    <div id="div1" >
        <asp:ScriptManager runat="server"></asp:ScriptManager>        
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" ProcessingMode="Remote" Height="100%" Width="100%">
            <ServerReport ReportServerUrl="http://test/ReportServer" ReportPath="/testreport" />
        </rsweb:ReportViewer>
    </div>
    </form>
</body>
</html>
```

### By setting the style height attribute on the parent of the reportviewer control

```html
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">    
<head runat="server">
</head>
<body >
    <form id="form1" runat="server">
    <div style="height:100vh;">
        <asp:ScriptManager runat="server"></asp:ScriptManager>        
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" ProcessingMode="Remote" Height="100%" Width="100%">
            <ServerReport ReportServerUrl="http://test/ReportServer" ReportPath="/testreport" />
        </rsweb:ReportViewer>
    </div>
    </form>
</body>
</html>
```
