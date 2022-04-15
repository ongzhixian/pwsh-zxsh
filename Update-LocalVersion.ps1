# Script use to update local PowerShell repository (for development)
# 
# Notes:
# Register-PSRepository -Name 'pwsh-repository' -SourceLocation 'C:\Apps\PwshRepository'
# Set-PSRepository -Name 'pwsh-repository' -InstallationPolicy Trusted
#
switch ($env:COMPUTERNAME)
{
    "ZOGA330" {
        Get-ChildItem 'C:\Apps\PwshRepository' | Where-Object { $_.Name -like 'zxsh*' } | ForEach-Object { Remove-Item $_ }
        Publish-Module -Path 'E:\src\github.com\ongzhixian\pwsh-zxsh\code\zxsh' -Repository 'pwsh-repository' -Force
        Install-Module 'zxsh' -Repository 'pwsh-repository' -Force -AllowClobber
        Import-Module zxsh -Force
        break
    }

    "SG00-L4579" {
        Get-ChildItem 'C:\Apps\PwshRepository' | Where-Object { $_.Name -like 'zxsh*' } | ForEach-Object { Remove-Item $_ }
        Publish-Module -Path 'C:\src\pwsh-zxsh\code\zxsh' -Repository 'pwsh-repository' -Force
        Install-Module 'zxsh' -Repository 'pwsh-repository' -Force -AllowClobber
        Import-Module zxsh -Force
        break
    }

    "ACADIAN" {
        Get-ChildItem 'D:\Apps\PwshRepository' | Where-Object { $_.Name -like 'zxsh*' } | ForEach-Object { Remove-Item $_ }
        Publish-Module -Path 'D:\src\github.com\ongzhixian\pwsh-zxsh\code\zxsh' -Repository 'pwsh-repository' -Force
        Install-Module 'zxsh' -Repository 'pwsh-repository' -Force -AllowClobber
        Import-Module zxsh -Force
        break
    }

    "ZBK15SP" {
        Get-ChildItem 'C:\Apps\PwshRepository' | Where-Object { $_.Name -like 'zxsh*' } | ForEach-Object { Remove-Item $_ }
        Publish-Module -Path 'C:\src\github.com\ongzhixian\zxsh\zxsh' -Repository 'pwsh-repository' -Force
        Install-Module 'zxsh' -Repository 'pwsh-repository' -Force -AllowClobber
        Import-Module zxsh -Force
        break
    }

    default {
        Write-Error "No setup found for $($env:COMPUTERNAME)"
    }

}