<#
    .Description
    Main (basic) module

    Sections:

    1.  Script variable(s) declaration
    2.  Script variable(s) initialization
    3.  Source function(s)
    4.  Define alias(es)
    5.  Module member export definitions
    
#>

########################################
# 1.  Script variable(s) declaration

$Script:PrevPwd             = $null
$Script:BranchName          = $null
$Script:GitBranchExitCode   = $null


########################################
# 2.  Script variable(s) initialization

$Script:profilePath = [System.IO.Path]::GetDirectoryName($PROFILE)
if ($false -eq [System.IO.Directory]::Exists($Script:profilePath))
{
    New-Item $Script:profilePath -ItemType Directory
}


########################################
# 3.  Source function(s)

# zxsh-functions.ps1
# 1.    Set-Title
# 2.    Prompt
. (Join-Path $PSScriptRoot zxsh-functions.ps1)


########################################
# 4.  Define alias(es)

if ($null -eq (Get-Alias | Where-Object { $_.Name -like 'title' })) {
    New-Alias -Name title -Value Set-Title
}
if ($null -eq (Get-Alias | Where-Object { $_.Name -like 'isadmin' })) {
    New-Alias -Name isadmin -Value Test-IsAdmin
}


########################################
# 5.  Module member export definitions

# Functions
Export-ModuleMember -Function Set-Title, Prompt, Get-EmptyFolders, Reset-Color, Get-IntegrityHash, ConvertTo-IntId, Test-IsAdmin

# Aliases
Export-ModuleMember -Alias title, isadmin
