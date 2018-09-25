# Enhanced Powershell Module for Azure Databricks CI/CD (working with Jupyter Notebook)

This is an enhanced Powershell module to help you to setup CI/CD with Azure Databricks workspace. Original module (https://www.powershellgallery.com/packages/azure.databricks.cicd.tools/1.0.5) only able to work with script file like .py, .scala, .r and .sql.

This enhanced Powershell module has been modified to make it able to push JUPYTER notebook format files.

https://docs.azuredatabricks.net/api/latest/examples.html

Usage:

psmodule\Import-DatabricksFolder.tests.ps1 <-- Sample Powershell script to import enhanced Powershell module. This is an example for CI/CD with Azure DevOps + Azure Databricks.

psmodule\Tests\Import-DatabricksFolder.tests.ps1 <-- Sample Powershell script to import enhanced Powershell module. This is an example for run it from local development workstation.

MyBearerToken.txt <-- Please input your Azure Databricks API access key here.

notebook\ <-- Please paste your Jupyter notebook files in here.

