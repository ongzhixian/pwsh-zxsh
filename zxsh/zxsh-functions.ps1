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
<#
    .SYNOPSIS
    Assert-AdminRights

    .DESCRIPTION
    Returns true if current account is a Windows administrative account

    .EXAMPLE
    # Show if current user has administrative rights
    Assert-AdminRights
#>
Function Assert-AdminRights {
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Function Find-DevCmd {
    param (
        [Parameter(Mandatory)]
        [string] $cmd_name
    )

    # Assuming on Windows (so we use `where.exe` instead of `which`)
    $cmd_path = where.exe $cmd_name
    if ($LASTEXITCODE -eq 0)
    {
        Write-Host "$cmd_name found at $cmd_path"
        return $cmd_path
    }
    else
    {
        Write-Host "$cmd_name not found in local system."
        return $null
    }
}

Function Get-DevCmdVersion {
    param (
        [Parameter(Mandatory)]
        [string] $cmd_name
    )

    switch ($cmd_name)
    {
        "node"      { return Invoke-Expression "$cmd_name --version"; break}
        "npm"       { return Invoke-Expression "$cmd_name --version"; break}
        "certbot"   { return Invoke-Expression "$cmd_name --version"; break}
        "python"    { return Invoke-Expression "$cmd_name --version"; break}
        "dart"      { return Invoke-Expression "$cmd_name --version"; break}
        "git"       { return Invoke-Expression "$cmd_name --version"; break}
        "javac"      { return Invoke-Expression "$cmd_name -version"; break}
        "go"        { return Invoke-Expression "$cmd_name version"; break}
        default     { return "n/a" } # sc, cmdkey, appcmd(?)
    }
}


Function Build-DevCmds {

    $devCmds = @{}
    Write-Host "Probing"
   
    $computerName = $env:COMPUTERNAME
    $devCmds[$computerName] = @{}
    Write-Host "Computer name is $computerName"

    $cmdList = @("node", "npm", "appcmd", "sc", "cmdkey", "python", "go", "dart", "git", "javac")
    # TODO: flutter, code, azuredatastudio, gpg, gradle, inspectcode, dotcover, java

    foreach ($cmd_name in $cmdList) {
        $cmd_path = Find-DevCmd $cmd_name
        if ($cmd_path -ne $null)
        {
            $devCmds[$computerName][$cmd_name] = @{}
            $devCmds[$computerName][$cmd_name]["path"] = $cmd_path

            $version = Get-DevCmdVersion $cmd_name

            $devCmds[$computerName][$cmd_name]["version"] = $version
            Write-Host "$cmd_name version is $version"
        }
    }
    
    return $devCmds
}

Function Get-MultiInput {
    param (
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string[]] $line
    )
    return $line
}

Function Test-Sqlite {
    param (
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string[]] $userInput
    )

    $Script:ModulePath
    
    $dllPath = Join-Path $Script:ModulePath "DLLs\System.Data.SQLite.dll"

    Add-Type -Path $dllPath

    return $userInput
}



Function Get-MachineArchitecture {
    param (
        
    )

    switch ($env:OS)
    {
        "WINDOWS_NT" {
            if ([System.Environment]::Is64BitOperatingSystem) {
                return "win-x64"
            }
            else {
                return "win-x86"
            }
        }

        "OSX" {
            if ([System.Environment]::Is64BitOperatingSystem) {
                return "osx-x64"
            }
            else {
                return "osx-x86"
            }
        }

        "LINUX" {
            if ([System.Environment]::Is64BitOperatingSystem) {
                return "linux-x64"
            }
            else {
                return "linux-x86"
            }
        }

        default {
            throw "Invalid $hash"
        }
    }

    Write-Host "$hash-$result"
}
            throw "Get-MachineArchitecture found unknown operating system: $env:OS"
        }
    }
}

function Deploy-Dll {
    param (
        [Parameter(Mandatory)]
        [string] $dllModulePath
        ,
        [Parameter(Mandatory)]
        [string] $dllName
    )

    $arch = Get-MachineArchitecture
    $dllPath = Join-Path $Script:ModulePath $dllModulePath $arch $dllName

    if (-not (Test-Path $dllPath))
    {
        throw "$dllName cannot be found at $dllPath"
    }

    # Check if DLL exists in $PSHOME
    $destinationPath = Join-Path $PSHOME $dllName
    if (Test-Path $destinationPath)
    {
        return
    }

    Copy-Item -Path $dllPath -Destination $destinationPath
}
