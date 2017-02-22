#Unable to load DLL 'SqlServerSpatial140.dll'?
Whenever your Report contains a control that requires SQL Server Types, your project will need to load this assembly at runtime. 

#How to load SqlServerSpatial140.dll?
When you installed the Report Viewer Control nuget package, you would have noticed a new folder called SqlServerTypes was added to your project. In this folder, you will find 2 sub-folders (x86 and x64), which each contain the SqlServerSpatial140.dll. Since it is difficult for us to predict which type of architecture your application will be running in, we added both versions to your project. The instructions for loading this assembly depends on what type of application (ASP.NET Website vs ASP.NET Web Application) you are running.

##ASP.NET Web Sites
For ASP.NET Web Sites, add the following block of code to the code behind file of the Web Form where you have added Report Viewer Control:
```
    Default.aspx.cs:

    public partial class _Default : System.Web.UI.Page
    {
        static bool _isSqlTypesLoaded = false;

        public _Default()
        {
            if (!_isSqlTypesLoaded)
            {
                SqlServerTypes.Utilities.LoadNativeAssemblies(Server.MapPath("~"));
                _isSqlTypesLoaded = true;
            }
        }
    }
```

##ASP.NET Web Applications
For ASP.NET Web Applications, add the following line of code to the Application_Start method in Global.asax.cs:
```
    SqlServerTypes.Utilities.LoadNativeAssemblies(Server.MapPath("~/bin"));
```
