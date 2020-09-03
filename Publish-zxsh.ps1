# Script use to update PowerShell Gallery
# 
switch ($env:COMPUTERNAME)
{
    "ZOGA330" {
        $apiKey = (Get-Content "C:\Users\zhixian\Documents\PowerShell\powershell-gallery-zxsh-api-key.txt")
        Publish-Module -Name zxsh -NuGetApiKey $apiKey
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

    default {
        Write-Error "No setup found for $($env:COMPUTERNAME)"
    }

}