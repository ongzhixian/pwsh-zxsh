# Script use to update PowerShell Gallery
# 
$publishVersion = "0.0.8"
switch ($env:COMPUTERNAME)
{
    "ZOGA330" {
        $apiKey = (Get-Content "C:\Users\zhixian\Documents\PowerShell\powershell-gallery-zxsh-api-key.txt")
        Publish-Module -Name zxsh -NuGetApiKey $apiKey -RequiredVersion $publishVersion
        break
    }

    "SG00-L4579" {
        Write-Error "Not implemented for $($env:COMPUTERNAME)"
        break
    }

    "ACADIAN" {
        $apiKey = (Get-Content "C:\Users\zhixian\Documents\PowerShell\powershell-gallery-zxsh-api-key.txt")
        Publish-Module -Name zxsh -NuGetApiKey $apiKey
        break
    }

    "ZBK15SP" {
        Write-Host "ZBK15"
        $apiKey = (Get-Content "C:\Users\zhixian\Documents\AppSecrets\PowerShellGallery\pwsh-api-key.txt")
        Publish-Module -Name zxsh -NuGetApiKey $apiKey -RequiredVersion $publishVersion
        break
    }

    default {
        Write-Error "No setup found for $($env:COMPUTERNAME)"
    }

}