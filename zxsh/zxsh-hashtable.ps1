# Functions
# 1. Get-HashtableEntry
# 2. Add-HashtableEntry
# 3. Update-HashtableEntry
# 4. Remove-HashtableEntry

function Get-HashtableEntry {
    param (
        [Parameter(Mandatory)][System.Collections.Hashtable] $ht,
        [Parameter(Mandatory)][object[]] $branch
    )
    $result = $null

    Write-Host "Get-HashtableEntry [location]=[$branch]"

    # Not needed anymore; handled by [Parameter(Mandatory)]
    # if ($branch.Length -le 0)
    # {
    #     return $null
    # }

    if ($ht.ContainsKey($branch[0]))
    {
        $result = $ht[$branch[0]]

        for ($i = 1; $i -lt $branch.Length; $i++) 
        {
            if ($result.ContainsKey($branch[$i]))
            {
                $result = $result[$branch[$i]]
            }
            else 
            {
                return $null
            }
        }
    }
    
    return $result
}


function Add-HashtableEntry {
    param (
        [Parameter(Mandatory)][System.Collections.Hashtable] $ht,
        [Parameter(Mandatory)][object[]] $branch,
        [Parameter(Mandatory)] $key,
        [Parameter(Mandatory)] $value
    )

    Write-Host "Add-HashtableEntry [location]=[$branch] [key]=[$key] [value]=[$value]"

    $node = $null
    if ([string]::IsNullOrEmpty($branch[0]))
    {
        $node = $ht
        
    }
    else
    {
        $node = Get-HashtableEntry $ht $branch
        if ($null -eq $node)
        {
            return
        }
    }
    
    $node[$key] = $value
}


function Update-HashtableEntry {
    param (
        [Parameter(Mandatory)][System.Collections.Hashtable] $ht,
        [Parameter(Mandatory)][object[]] $branch,
        [Parameter(Mandatory)]$key,
        [Parameter(Mandatory)]$value
    )

    Write-Host "Update-HashtableEntry [location]=[$branch] [key]=[$key] [value]=[$value]"

    $node = $null

    if ([string]::IsNullOrEmpty($branch[0]))
    {
        $node = $ht
    }
    else
    {
        $node = Get-HashtableEntry $ht $branch
        if ($null -eq $node)
        {
            return
        }
    }

    if ($node.ContainsKey($key))
    {
        $node[$key] = $value
    }
}


function Remove-HashtableEntry {
    param (
        [Parameter(Mandatory)][System.Collections.Hashtable] $ht,
        [Parameter(Mandatory)][object[]] $branch,
        [Parameter(Mandatory)] $key
    )

    Write-Host "Remove-HashtableEntry [location]=[$branch] [key]=[$key]"

    $node = $null

    if ([string]::IsNullOrEmpty($branch[0]))
    {
        $node = $ht
    }
    else
    {
        $node = Get-HashtableEntry $ht $branch
        if ($null -eq $node)
        {
            return
        }
    }

    if ($node.ContainsKey($key))
    {
        $node.Remove($key)
    }
}
