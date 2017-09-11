# Getting started
This project showcases the use of the Report Server API to build a simple website that lists CatalogItems in the report server, uploads new items, and gets the current user info.

The sample uses Typescript, React and Webpack to generate a SPA web app. 

## Setting up CORS
By default, the report server blocks requests comming form third-party domains such as this one. To be able to communitate with the API we need to first add the sample host to the origin whitelist.

## Setting up CSRF
TODO: Explain why they need to disable CSRF and how to do it.

## Getting the source code and running the sample
```bash
# clone repo
git clone https://github.com/Microsoft/vscode-react-sample.git  API

# navigate to repo
cd react-todo

# install deps
npm install

# run the sample
npm run dev
```

The sample runs in 

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