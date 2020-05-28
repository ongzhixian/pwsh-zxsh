# Main (basic) module

$Script:PrevPwd             = $null
$Script:BranchName          = $null
$Script:GitBranchExitCode   = $null

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
    if ($Script:PrevPwd -ne $current_path)
    {
        $Script:BranchName = $(git branch --show-current)
        $Script:GitBranchExitCode = $LASTEXITCODE
        $Script:PrevPwd = $current_path
    }    
    "`e[32m$env:USERDOMAIN>$env:USERNAME`e[39m $PWD $(if ($Script:GitBranchExitCode -eq 0) { "`e[36m($Script:BranchName)`e[39m" })`nPS> "
}


if ($null -eq (Get-Alias | Where-Object { $_.Name -like 'title' })) {
    New-Alias -Name title -Value Set-Title
}

# Module member export definitions
Export-ModuleMember -Function Set-Title, Prompt
Export-ModuleMember -Alias title
