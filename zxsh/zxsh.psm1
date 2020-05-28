# Main (basic) module

########################################
# Declare script variables

$Script:PrevPwd             = $null
$Script:BranchName          = $null
$Script:GitBranchExitCode   = $null
$Script:profilePath         = $null

########################################
# Initialize script variables

$profilePath = [System.IO.Path]::GetDirectoryName($PROFILE)
if ($false -eq [System.IO.Directory]::Exists($profilePath))
{
    New-Item $profilePath -ItemType Directory
}


########################################
# Source functions into module

# zxsh-default.ps1
# 1.    Set-Title
# 2.    Prompt
. (Join-Path $PSScriptRoot zxsh-default.ps1)


# zxsh-secrets.ps1
# 1.    Get-Secrets
# 2.    
. (Join-Path $PSScriptRoot zxsh-secrets.ps1)


########################################
# Define aliases

if ($null -eq (Get-Alias | Where-Object { $_.Name -like 'title' })) {
    New-Alias -Name title -Value Set-Title
}


########################################
# Module member export definitions

# Functions
Export-ModuleMember -Function Set-Title, Prompt
Export-ModuleMember -Function Get-Secrets

# Aliases
Export-ModuleMember -Alias title
