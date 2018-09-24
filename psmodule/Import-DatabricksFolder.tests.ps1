$env:PSModulePath = "$env:BUILD_SOURCESDIRECTORY\psmodule" # Define the PSModule directory manually. 
# $env:PSModulePath
# Get-ChildItem -File $env:PSModulePath
Import-Module -Name "$env:PSModulePath\azuredatabrickscicdTools.psm1" -Force
$env:MYNotebookPath = "$env:BUILD_SOURCESDIRECTORY\notebook" # Path to my Notebook folder which would like to push to Azure Databricks workspace.

$BearerToken = Get-Content "$env:PSModulePath\MyBearerToken.txt"  # Create this file in the Tests folder with just your bearer token in
$Region = "southeastasia" # Please input your Azure Databricks regions. I use Southeast Asia (Singapore) as an example.
$LocalPath = "$env:MYNotebookPath"
$DatabricksPath = "/Shared/WORKSPACE_FOLDER_NAME/WORKSPACE_SUB_FOLDER_NAME"

Import-DatabricksFolder -BearerToken $BearerToken -Region $Region -LocalPath $LocalPath -DatabricksPath $DatabricksPath #-Verbose

