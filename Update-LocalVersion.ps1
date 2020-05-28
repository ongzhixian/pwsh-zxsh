#
#
# 
# Register-PSRepository -Name 'pwsh-repository' -SourceLocation 'C:\Apps\PwshRepository'
# Set-PSRepository -Name 'pwsh-repository' -InstallationPolicy Trusted

Get-ChildItem 'C:\Apps\PwshRepository' | Where-Object { $_.Name -like 'zxsh*' } | ForEach-Object { Remove-Item $_ }
Publish-Module -Path 'C:\src\github.com\ongzhixian\pwsh-zxsh\code\zxsh' -Repository 'pwsh-repository' -Force
Install-Module 'zxsh' -Repository 'pwsh-repository' -Force -AllowClobber
Import-Module zxsh -Force
