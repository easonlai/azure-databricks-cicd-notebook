Import-Module "..\azure.databricks.cicd.tools.psm1" -Force

$BearerToken = Get-Content "..\MyBearerToken.txt"  # Create this file in the Tests folder with just your bearer token in
$Region = "southeastasia"
$LocalPath = "../../notebook"
$DatabricksPath = "/Shared/test01/keras-mnist-cnn-sample03"

Import-DatabricksFolder -BearerToken $BearerToken -Region $Region -LocalPath $LocalPath -DatabricksPath $DatabricksPath #-Verbose

