# Main (basic) module

########################################
# Declare script variables

$Script:PrevPwd             = $null
$Script:BranchName          = $null
$Script:GitBranchExitCode   = $null
$Script:profilePath         = $null
$Script:secretFilePath      = $null
$Script:secrets             = $null

[System.Security.SecureString] 
$Script:passPhrase          = $null

########################################
# Initialize script variables

$Script:profilePath = [System.IO.Path]::GetDirectoryName($PROFILE)
if ($false -eq [System.IO.Directory]::Exists($Script:profilePath))
{
    New-Item $Script:profilePath -ItemType Directory
}

$Script:secretFilePath = Join-Path $Script:profilePath "test-zxsh-secrets.json"
# if ([System.IO.File]::Exists($Script:secretFilePath))
# {
#     $Script:secrets = Import-Clixml -Path $Script:secretFilePath
# }
# else {
#     $Script:secrets = @{}
#     $Script:secrets = @{
#         "GoDaddy" = @{
#             "ote" = @{
#                 "zhixian" = "asddsa";
#                 "account2" = "asdad";
#             };
#             "production" = @{
    
#             };
#         };
#         "Google" = @{
#             "Dummy"= "dummy-value";
#         };
    
#         "Status" = "Done";
#     }
# }

########################################
# Source functions into module

# zxsh-default.ps1
# 1.    Set-Title
# 2.    Prompt
. (Join-Path $PSScriptRoot zxsh-default.ps1)

# Functions
# 1. Get-HashtableEntry
# 2. Add-HashtableEntry
# 3. Update-HashtableEntry
# 4. Remove-HashtableEntry
. (Join-Path $PSScriptRoot zxsh-hashtable.ps1)

# Functions
# 1. Get-Secret
# 2. Add-Secret
# 3. Update-Secret
# 4. Remove-Secret
. (Join-Path $PSScriptRoot zxsh-secrets.ps1)

# Functions
. (Join-Path $PSScriptRoot zxsh-cryptography.ps1)


########################################
# Define aliases

if ($null -eq (Get-Alias | Where-Object { $_.Name -like 'title' })) {
    New-Alias -Name title -Value Set-Title
}


########################################
# Module member export definitions

# Functions
Export-ModuleMember -Function Set-Title, Prompt
Export-ModuleMember -Function Get-Secrets, Get-Secret, Add-Secret, Update-Secret, Remove-Secret
Export-ModuleMember -Function Get-RandomBytes

# Aliases
Export-ModuleMember -Alias title
