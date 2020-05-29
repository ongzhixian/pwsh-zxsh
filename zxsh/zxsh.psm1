# Main (basic) module

########################################
# Declare script variables

$Script:PrevPwd             = $null
$Script:BranchName          = $null
$Script:GitBranchExitCode   = $null
$Script:profilePath         = $null
$Script:secretFilePath      = $null
$Script:secrets             = $null

########################################
# Initialize script variables

$Script:profilePath = [System.IO.Path]::GetDirectoryName($PROFILE)
if ($false -eq [System.IO.Directory]::Exists($Script:profilePath))
{
    New-Item $Script:profilePath -ItemType Directory
}

$Script:secretFilePath = Join-Path $Script:profilePath "zxsh-secrets.jsonx"
if ([System.IO.File]::Exists($Script:secretFilePath))
{
    $Script:secrets = Import-Clixml -Path $Script:secretFilePath
}
else {
    $Script:secrets = @{}
    $Script:secrets = @{
        "GoDaddy" = @{
            "ote" = @{
                "zhixian" = "asddsa";
                "account2" = "asdad";
            };
            "production" = @{
    
            };
        };
        "Google" = @{
            "Dummy"= "dummy-value";
        };
    
        "Status" = "Done";
    }
}

########################################
# Source functions into module

# zxsh-default.ps1
# 1.    Set-Title
# 2.    Prompt
. (Join-Path $PSScriptRoot zxsh-default.ps1)

# zxsh-hashtable.ps1
# 1.    Get-Secrets
# 2.    
. (Join-Path $PSScriptRoot zxsh-hashtable.ps1)

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
Export-ModuleMember -Function Get-Secrets, Get-Secret, Add-Secret

# Aliases
Export-ModuleMember -Alias title
