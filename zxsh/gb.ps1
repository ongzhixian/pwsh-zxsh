# Script to setup GB development environment
# Assumes the following tools are available:
# 1. npm
# 2. angular
# 3. dotnet
# 4. msbuild

$devenv_filepath = "devenv.json"
$devenv = $null

# Probes if user is has administrator rights (running with elevated privileges)
# ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

function SaveDevEnv 
{
    ConvertTo-Json $devenv | Out-File $devenv_filepath

    Write-Host "$devenv_filepath saved."
}

function LoadDevEnv
{
    if (Test-Path $devenv_filepath)
    {
        $devenv = ConvertFrom-Json (Get-Content $devenv_filepath -Raw) -AsHashTable
    }
    else
    {
        Write-Host "File $devenv_filepath not found."
    }
}

function ProbeCmd
{
    param (
        [Parameter(Mandatory)]
        [string] $cmd_name
    )

    # Assuming on Windows (so we use `where.exe` instead of `which`)
    $cmd_path = where.exe $cmd_name
    if ($LASTEXITCODE -eq 0)
    {
        
        Write-Host "Appcmd found at $cmd_path"
        return $cmd_path
    }
    else
    {
        Write-Host "Appcmd not found in local system."
        return $null
    }
}

function ProbeDevEnv 
{
    $devenv = @{}
    Write-Host "Probing"
    
    $computerName = $env:COMPUTERNAME
    $devenv[$computerName] = @{}
    Write-Host "Computer name is $computerName"

    # $devenv[$computerName]["cmd"] = @{}
    
    $cmd_name = "node"
    $cmd_path = ProbeCmd $cmd_name
    if ($cmd_path -ne $null)
    {
        $devenv[$computerName][$cmd_name] = @{}

        $devenv[$computerName][$cmd_name]["path"] = $cmd_path

        $version = Invoke-Expression "$cmd_name --version"
        $devenv[$computerName][$cmd_name]["version"] = $version
        Write-Host "$cmd_name version is $version"
    }

    $cmd_name = "npm"
    $cmd_path = ProbeCmd $cmd_name
    if ($cmd_path -ne $null)
    {
        $devenv[$computerName][$cmd_name] = @{}
        $devenv[$computerName][$cmd_name]["path"] = $cmd_path
        $version = Invoke-Expression "$cmd_name --version"
        $devenv[$computerName][$cmd_name]["version"] = $version
        Write-Host "$cmd_name version is $version"
    }

    $cmd_name = "appcmd"
    $cmd_path = ProbeCmd $cmd_name
    if ($cmd_path -ne $null)
    {
        $devenv[$computerName][$cmd_name] = @{}
        $devenv[$computerName][$cmd_name]["path"] = $cmd_path
    }

    return $devenv
}


################################################################################
# Main script


# Probes if user is has administrator rights (running with elevated privileges)
$hasAdminRights = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($hasAdminRights -eq $false)
{
    Write-Host "User has no administrative rights which are required for this script to work correctly."
    exit(0)
}

LoadDevEnv

if ($devenv -eq $null)
{
    $devenv = ProbeDevEnv
    SaveDevEnv
}

$devenv
# SaveDevEnv
# $devenv.GetType().ToString()