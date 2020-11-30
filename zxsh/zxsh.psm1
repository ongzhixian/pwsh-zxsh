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
$Script:DevCmds             = $null


########################################
# 2.  Script variable(s) initialization

$Script:profilePath = [System.IO.Path]::GetDirectoryName($PROFILE)
if ($false -eq [System.IO.Directory]::Exists($Script:profilePath))
{
    New-Item $Script:profilePath -ItemType Directory
}

$devCmdsFilePath = Join-Path $Script:profilePath "devCmds.json"

if (Test-Path $devCmdsFilePath)
{
    $Script:DevCmds = ConvertFrom-Json (Get-Content $devCmdsFilePath -Raw) -AsHashTable
}
else
{
    Write-Host "File $devCmdsFilePath not found."

    if (Assert-AdminRights)
    {
        # Write-Host "User has no administrative rights which are required for this script to work correctly."
        $Script:DevCmds = Build-DevCmds

        Write-Host "Output to $devCmdsFilePath"

        ConvertTo-Json $Script:DevCmds  | Out-File $devCmdsFilePath

        Write-Host "$devCmdsFilePath saved."
        
    } else {
        Write-Host "User has no administrative rights which are required for Build-DevCmds; Skipping Build-DevCmds"
    }
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


########################################
# 5.  Module member export definitions

# Functions
Export-ModuleMember -Function Set-Title, Prompt, Get-EmptyFolders, Reset-Color

# Aliases
Export-ModuleMember -Alias title
