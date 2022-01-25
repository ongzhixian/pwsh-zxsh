<#
    .Description
    This script defines the functions that are integrated in the usage of zxsh.
    
    Declared functions:
    1.  Set-Title
    2.  Prompt
    3.  Get-EmptyFolders
    4.  Reset-Color
    5.  Get-IntegrityHash
#>


<#
    .SYNOPSIS
    Set-Title

    .DESCRIPTION
    Set title of console Window

    .PARAMETER $args
    Set title of console Window to $args

    .EXAMPLE
    # Set title of console Window to 'ps7'
    Title ps7
#>
Function Set-Title {
    (Get-Host).UI.RawUI.WindowTitle = $args
}


<#
    .SYNOPSIS
    Prompt

    .DESCRIPTION
    Defines the prompt in zxsh; Used internally.
#>
Function Prompt {
    $current_path = (Get-Location).Path
    $last_command = (Get-History -Count 1)
    if ((($null -ne $last_command) -And ($last_command.CommandLine.Trim().ToLowerInvariant() -match "git\s+checkout\s+.+")) -Or ($Script:PrevPwd -ne $current_path)) 
    {
        $Script:BranchName = $(git branch --show-current)
        $Script:GitBranchExitCode = $LASTEXITCODE
        $Script:PrevPwd = $current_path
    }
    "`e[32m$env:USERDOMAIN>$env:USERNAME`e[39m $PWD $(if ($Script:GitBranchExitCode -eq 0) { "`e[36m($Script:BranchName)`e[39m" })`nPS> "
}

<#
    .SYNOPSIS
    Get-EmptyFolders

    .DESCRIPTION
    List all empty folders in a given path recursively.

    .EXAMPLE
    # Recursively list all empty folders starting from current folder  
    Get-EmptyFolders

    .EXAMPLE
    # Recursively list all empty folders starting from stated folder C:\temp
    Get-EmptyFolders C:\temp
#>
Function Get-EmptyFolders {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidDefaultValueSwitchParameter', Scope='Function', Target='Recurse', 
        Justification='We intentionally want this to be the default behaviour')]
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $Path = ".",
        [Parameter()]
        [switch] $Recurse = $true
    )
    
    Get-ChildItem -Path $Path -Directory -Recurse:$Recurse | Where-Object { ($_.GetFiles().Count -eq 0) -and ($_.GetDirectories().Count -eq 0) } | Sort-Object { $_.FullName } | Select-Object FullName
}


<#
    .SYNOPSIS
    Reset-Color

    .DESCRIPTION
    Reset the color of the console to default

    .EXAMPLE
    # Reset the color of the console to default
    Reset-Color
#>
Function Reset-Color {
    [Console]::ResetColor()
}


<#
    .SYNOPSIS
    Get-IntegrityHash

    .DESCRIPTION
    Get the integrity hash for URL

    .EXAMPLE
    # Get SHA256 (default) hash for integrity attribute 
    Get-IntegrityHash "https://unpkg.com/react@17/umd/react.development.js"
    # Get SHA384 hash for integrity attribute
    Get-IntegrityHash "https://unpkg.com/react@17/umd/react.development.js" "sha384"
#>
function Get-IntegrityHash {
    param (
        [string] $url="",
        [string] $hash="sha256"
    )

    switch ($hash.ToLowerInvariant())
    {
        "sha1" {
            try {
                $result = [Convert]::ToBase64String(
                    [System.Security.Cryptography.SHA1]::Create().ComputeHash(
                        [System.Net.WebClient]::new().DownloadData($url)
                    )
                )
            }
            catch {
                Write-Error $_
            }
        }

        "sha256" {
            try {
                $result = [Convert]::ToBase64String(
                    [System.Security.Cryptography.SHA256]::Create().ComputeHash(
                        [System.Net.WebClient]::new().DownloadData($url)
                    )
                )
            }
            catch {
                Write-Error $_
            }
        }

        "sha384" {
            try {
                $result = [Convert]::ToBase64String(
                    [System.Security.Cryptography.SHA384]::Create().ComputeHash(
                        [System.Net.WebClient]::new().DownloadData($url)
                    )
                )
            }
            catch {
                Write-Error $_
            }
        }

        "sha512" {
            try {
                $result = [Convert]::ToBase64String(
                    [System.Security.Cryptography.SHA512]::Create().ComputeHash(
                        [System.Net.WebClient]::new().DownloadData($url)
                    )
                )
            }
            catch {
                Write-Error $_
            }
        }

        default {
            throw "Invalid $hash"
        }
    }

    Write-Host "$hash-$result"
}


<#
    .SYNOPSIS
    ConvertTo-IntId

    .DESCRIPTION
    Compute a string into an integer

    .EXAMPLE
    # Compute a string "MiniTools.Web.Controllers.LoginController" into an integer 
    ConvertTo-IntId MiniTools.Web.Controllers.LoginController
#>
Function ConvertTo-IntId {
    param (
        [string] $text=""
    )

    if ($text.Length -eq 0) {
        Write-Host "Usage: ConvertTo-IntId 'MiniTools.Web.Controllers.LoginController' (Should yield result 251394) "
        return
    }

    $w,$s=0; [System.Security.Cryptography.SHA1CryptoServiceProvider]::new().ComputeHash([Text.Encoding]::UTF8.GetBytes($text)).ForEach({$_*++$w}).ForEach({$s+=$_});"$s$($s%11)"
}
