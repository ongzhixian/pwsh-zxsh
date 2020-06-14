########################################
# Declare functions
# 1.    Set-Title
# 2.    Prompt

########################################
# 1.    Set-Title
<#
    .Synopsis
    Set title of console Window

    .Description
    Set title of console Window

    .Parameter $args
    Set title of console Window to $args

    .INPUTS
    $args. Your arguments will be displayed as title of the window.
    
    .OUTPUTS
    None.
    
    .Example
    C:\PS> title ps7
    
    Set title of console window to 'ps7'

    .Link
    None
#>
function Set-Title {
    (Get-Host).UI.RawUI.WindowTitle = $args
}


########################################
# 2.    Prompt
<#
    .Synopsis
    Set the prompt of PowerShell host

    .Description
    Set the format of the prompt of PowerShell host

    .INPUTS
    None.

    .OUTPUTS
    None.

    .Link
    None
#>
function Prompt {
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