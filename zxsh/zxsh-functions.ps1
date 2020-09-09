<#
    .Description
    This script defines the functions that are integrated in the usage of zxsh.
    
    Declared functions:
    1.    Set-Title
    2.    Prompt
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
    Get-DateTimeDiff

    .DESCRIPTION
    Return a timespan

    .EXAMPLE
    # 
    Get-DateTimeDiff

    .EXAMPLE
    # 
    Get-DateTimeDiff "2020-04-01 07:24:21.28276"

    .EXAMPLE
    # 
    Get-DateTimeDiff "2020-04-01 07:24:21.28276" "2020-04-01 07:24:39.74670"
    
    .EXAMPLE
    # 
    Get-DateTimeDiff "2020-04-01 07:24:39.74670" "2020-04-01 07:24:21.28276" 
    
#>
Function Get-DateTimeDiff {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $StartDateTime,
        [Parameter()]
        [string] $EndDateTime=$null
    )

    [DateTime] $dt1 = [DateTime]::MaxValue
    [DateTime] $dt2 = [DateTime]::MaxValue

    try {
        $dt1 = [DateTime]::Parse($StartDateTime)
    }
    catch {
        Write-Host "Invalid date-time string [$StartDateTime]"
        exit(-1)        
    }

    if ($EndDateTime)
    {
        try {
            $dt2 = [DateTime]::Parse($EndDateTime)
        }
        catch {
            Write-Host "Invalid date-time string [$EndDateTime]"
            exit(-1)        
        }
    }
    
    # Write-Host $dt1 $dt2

    if ($dt1 -ge $dt2) 
    {
        # Write-Host "1 > 2"
        # Write-Host $dt1-$dt2
        return ($dt1-$dt2)
    }
    else {
        return ($dt2-$dt1)
    }
}