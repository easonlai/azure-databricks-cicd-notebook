Function Import-DatabricksFolder
{
    [cmdletbinding()]
    param (
        [parameter(Mandatory=$true)][string]$BearerToken,
        [parameter(Mandatory=$true)][string]$Region,
        [parameter(Mandatory=$true)][string]$LocalPath,
        [parameter(Mandatory=$true)][string]$DatabricksPath
    )
<#
.SYNOPSIS
Pushes the contents of a local folder (and subfolders) to Databricks

.DESCRIPTION
Use to deploy code from a repo

.PARAMETER BearerToken
Your Databricks Bearer token to authenticate to your workspace (see User Settings in Datatbricks WebUI)

.PARAMETER Region
Azure Region - must match the URL of your Databricks workspace, example northeurope

.PARAMETER LocalPath
Path to your repo/local files that you would like to deploy to Databricks (should be in Source format)

.PARAMETER DatabricksPath
The Databricks folder to target

.NOTES
Author: Simon D'Morias / Data Thirst Ltd 

"format": "SOURCE", "format": "JUPYTER"
$FileType = @{".py"="PYTHON";".scala"="SCALA";".r"="R";".sql"="SQL";".ipynb"="PYTHON" } ADDED ".ipynb"="PYTHON" for Jupyter Notebook.

https://docs.azuredatabricks.net/api/latest/examples.html
#>  
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $InternalBearerToken = Format-BearerToken($BearerToken)

    $Files = Get-ChildItem $LocalPath -Recurse -Attributes !D
    ForEach ($FileToPush In $Files)
    {
        $Path = $FileToPush.DirectoryName
        $LocalPath = $LocalPath.Replace("/","\")

        # Build relative Databricks path $Path = $DatabricksPath + ($Path.Replace($LocalPath,"").Replace("\","/"))
        $Path = $DatabricksPath

        # Create folder in Databricks
        Add-DatabricksFolder -Bearer $BearerToken -Region $Region -Path $Path

        $BinaryContents = [System.IO.File]::ReadAllBytes($FileToPush.FullName)
        $EncodedContents = [System.Convert]::ToBase64String($BinaryContents)
        $TargetPath = $Path + "/" + $FileToPush.BaseName

        $FileType = @{".py"="PYTHON";".scala"="SCALA";".r"="R";".sql"="SQL";".ipynb"="PYTHON" }
        $FileFormat = $FileType[$FileToPush.Extension]

        $Body = @"
{
    "format": "JUPYTER",
    "content": "$EncodedContents",
    "path": "$TargetPath",
    "overwrite": "true",
    "language": "$FileFormat"
}
"@
        if($null -eq $FileFormat)
        {
            Write-Warning "File $FileToPush has an unknown extension - skipping file"
        }
        else{
            Write-Output "Pushing file $FileToPush to $TargetPath"
            Invoke-RestMethod -Uri "https://$Region.azuredatabricks.net/api/2.0/workspace/import" -Body $Body -Method 'POST' -Headers @{Authorization = $InternalBearerToken}
        }
    }
}
