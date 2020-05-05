<#
 .Synopsis
  Set title of console Window

 .Description
  Set title of console Window

 .Parameter $args
  Set title of console Window to $args

 .Example
   # Set title of console Window to 'ps7'
   Title ps7
#>

$Script:PrevPwd = $null
$Script:BranchName = $null
$Script:GitBranchExitCode = $null

Function Set-Title { (Get-Host).UI.RawUI.WindowTitle = $args }

Function Prompt {
    $current_path = (Get-Location).Path
    if ($Script:PrevPwd -ne $current_path)
    {
        $Script:BranchName = $(git branch --show-current)
        $Script:GitBranchExitCode = $LASTEXITCODE
        $Script:PrevPwd = $current_path
    }    
    "`e[32m$env:USERDOMAIN>$env:USERNAME`e[39m $PWD $(if ($Script:GitBranchExitCode -eq 0) { "`e[36m($Script:BranchName)`e[39m" })`nPS> "
}

New-Alias -Name title -Value Set-Title

# Module member export definitions
Export-ModuleMember -Function Set-Title, Prompt
Export-ModuleMember -Alias title
