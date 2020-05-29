# Functions
# 1. Get-Node
# 2. Add-Node
# 3. Update-Node
# 4. Remove-Node

function Get-Node {
    param (
        [Parameter(Mandatory)]
        [object[]] $nodeName,
        [Parameter(Mandatory)]
        [System.Collections.Hashtable] $tree
    )

    $result = $null

    Write-Debug "location is $nodeName, $($nodeName.GetType().ToString()), length is $($nodeName.Length)"

    if ($nodeName.Length -le 0)
    {
        return $null
    }

    if ($tree.ContainsKey($nodeName[0]))
    {
        $result = $tree[$nodeName[0]]

        for ($i = 1; $i -lt $nodeName.Length; $i++) 
        {
            if ($result.ContainsKey($nodeName[$i]))
            {
                $result = $result[$nodeName[$i]]
            }
            else 
            {
                return $null
            }
        }
    }
    
    return $result
}


function Add-Node {
    param (
        [Parameter(Mandatory)]
        [object[]] $nodeName,
        [Parameter(Mandatory)]
        [System.Collections.Hashtable] $tree,
        $key,
        $value
    )

    Write-Debug "In Add-Node"
    Write-Debug "Add-Node[location]  $nodeName"
    Write-Debug "Add-Node[key]       $key"
    Write-Debug "Add-Node[value]     $value"

    $node = Get-Node $nodeName $tree
    if ($null -eq $node)
    {
        Write-Error "Target node not found."
        return
    }

    $node[$key] = $value
}