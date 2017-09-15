# Getting started
This project demonstrates examples to upload/download/delete an item in the Report Server API (August 2017 Preview). 

## Setting up CORS & CSRF
By default, the report server follows a Same-Origin policy and requires every request to include a XSRF token. To run the sample, localhost must be added to the list of allowed origins and the XSRF check must be disabled.

Set the values of the following configuration settings in your server:

|Property Name| New Value|
|-------------|----------|
|AccessControlAllowCredentials|True|
|AccessControlAllowHeaders|*|
|AccessControlAllowMethods|*|
|AccessControlAllowOrigin|http://localhost:8080|
|EnableXsrfValidation|False|

To learn how to change the configuration settings, go to the [Reporting Services Documentation](https://docs.microsoft.com/en-us/sql/reporting-services/tools/server-properties-advanced-page-reporting-services)

## Getting the source code and running the sample
```bash
# clone repo
git clone https://github.com/Microsoft/Reporting-Services  RS-Samples

# navigate to typescript source
cd RS-Samples/APISamples/powershell

# copy your report in this folder and change the name or type of the test report in powershellSamples.ps1
.powershellSamples.ps1
```
The samples assumes that the report server instance is running in localhost.
# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.