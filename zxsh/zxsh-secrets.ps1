# Functions
# 1. Get-Secret
# 2. Add-Secret
# 3. Update-Secret
# 4. Remove-Secret

function Hide-Secrets {
    $Script:secrets = $null
}
function Save-Secrets {
    Write-Host "Save secrets"

    ConvertTo-Json $Script:secrets

    ConvertTo-Json $Script:secrets | Out-File $Script:secretFilePath

}
function Restore-Secrets {
    # Function to load secrets from file

    # Create secrets file if it does not exists
    if (-not [System.IO.File]::Exists($Script:secretFilePath))
    {
        $Script:secrets = @{}
        #ConvertTo-Json $Script:secrets | Out-File $Script:secretFilePath
        Save-Secrets
    }

    # ZX: Oops! Forgot we are not working with JSON directly.
    # We want hashtables
    # Load JSON from file as a PSCustomObject
    $psObj = ConvertFrom-Json (Get-Content $Script:secretFilePath -Raw )

    # Then, convert PSCustomObject to a HashTable
    $Script:secrets = @{}
    foreach($property in $psObj.PSObject.Properties.Name)
    {
        $Script:secrets[$property] = $psObj.$property
    }

    # $Script:secrets = Import-Clixml -Path $Script:secretFilePath
    # else {
        
    #     $Script:secrets = @{
    #         "GoDaddy" = @{
    #             "ote" = @{
    #                 "zhixian" = "asddsa";
    #                 "account2" = "asdad";
    #             };
    #             "production" = @{
        
    #             };
    #         };
    #         "Google" = @{
    #             "Dummy"= "dummy-value";
    #         };
        
    #         "Status" = "Done";
    #     }
    # }
}


########################################
# 1.    Display secrets
<#
    .Synopsis
    Display all stored secrets as JSON.

    .Description
    Display all stored secrets as JSON.

    .INPUTS
    None.

    .OUTPUTS
    Secrets in JSON format.

    .Example
    C:\PS> Get-Secrets
    {
        "GoDaddy": {
            "production": {},
            "ote": {
                "account2": "asdad",
                "zhixian": "asddsa"
            }
        },
        "Status": "Done",
        "Google": {
            "Dummy": "dummy-value"
        }
    }

    .Link
    None
#>
function Get-Secrets {
    Restore-Secrets

    ConvertTo-Json $Script:secrets

    Hide-Secrets
}


########################################
# 2.    Get-Secret
<#
    .Synopsis
    Display value stored at location

    .Description
    Display all stored secrets as JSON.

    .INPUTS
    Array of Ids

    .OUTPUTS
    Secret in table format.

    .Example
    C:\PS> Get-Secret GoDaddy

    Name                           Value
    ----                           -----
    production                     {}
    ote                            {account2, zhixian}

    Display the secret stored under GoDaddy.

    .Example
    C:\PS> Get-Secret GoDaddy, ote

    Name                           Value
    ----                           -----
    account2                       asdad
    zhixian                        asddsa

    Display the secret under GoDaddy, ote.

    .Example
    C:\PS> Get-Secret @("GoDaddy", "ote")

    Name                           Value
    ----                           -----
    account2                       asdad
    zhixian                        asddsa

    Alternative syntax to display the secret under GoDaddy, ote.

    .Link
    None
#>
function Get-Secret {
    param (
        [Parameter(Mandatory)]
        [object[]] $location
    )

    return (Get-HashtableEntry $Script:secrets $location)
}


########################################
# 3.    Add-Secret
<#
    .Synopsis
    Add secret to specified location

    .Description
    Add secret to specified location

    .INPUTS
    Array of Ids for the location to add secret
    Name of key
    Value

    .OUTPUTS
    N/A

    .Example
    C:\PS> Add-Secret @("GoDaddy", "ote") "NewNode" "NewNodeValue"
    C:\PS> Get-Secrets
    {
        "Google": {
            "Dummy": "dummy-value"
        },
        "Status": "Done",
        "GoDaddy": {
            "production": {},
            "ote": {
                "NewNode": "NewNodeValue",
                "account2": "asdad",
                "zhixian": "asddsa"
            }
        }
    }

    Add a new key-value pair under GoDaddy, ote.

    .Link
    None
#>
function Add-Secret {
    param (
        [Parameter(Mandatory)]
        [object[]] $location,
        [Parameter(Mandatory)]
        $key,
        $value = $null
    )
    
    try {
        
        Restore-Secrets
        Write-Host "Adding to [$(ConvertTo-Json $Script:secrets)]"
        
        $result = (Add-HashtableEntry $Script:secrets $location $key $value)
        Save-Secrets
        return $result
    }
    catch {
        Write-Error $_.Exception
    }
    finally {
        Hide-Secrets
    }
}


########################################
# 3. Update-Secret
<#
    .Synopsis
    Update secret at specified location

    .Description
    Update secret to specified location

    .INPUTS
    Array of Ids for the location to add secret
    Name of key
    Value

    .OUTPUTS
    N/A

    .Example
    C:\PS> Update-Secret @("GoDaddy", "ote")  "NewNode" "SomeUpdatedNewNodeValue"
    C:\PS> Get-Secrets
    {
        "GoDaddy": {
            "ote": {
                "NewNode": "SomeUpdatedNewNodeValue",
                "account2": "asdad",
                "zhixian": "asddsa"
            },
            "production": {}
        },
        "Google": {
            "Dummy": "dummy-value"
        },
        "Status": "Done"
    }

    Update value of key "NewNode" to "SomeUpdatedNewNodeValue" under GoDaddy, ote.

    .Link
    None
#>
function Update-Secret {
    param (
        [Parameter(Mandatory)]
        [object[]] $location,
        [Parameter(Mandatory)]
        $key,
        $value = $null
    )

    return (Update-HashtableEntry $Script:secrets $location $key $value)
}


########################################
# 4. Remove-Secret
<#
    .Synopsis
    Remove secret at specified location

    .Description
    Remove secret to specified location

    .INPUTS
    Array of Ids for the location to add secret
    Name of key
    Value

    .OUTPUTS
    N/A

    .Example
    C:\PS> Remove-Secret @("GoDaddy", "ote") "Zhixian"
    C:\PS> Get-Secrets
    {
        "GoDaddy": {
            "ote": {
                "NewNode": "SomeUpdatedNewNodeValue",
                "account2": "asdad",
                "zhixian": "asddsa"
            },
            "production": {}
        },
        "Google": {
            "Dummy": "dummy-value"
        },
        "Status": "Done"
    }

    Remove the key-value pair with key "zhixian" under GoDaddy, ote.

    .Link
    None
#>
function Remove-Secret {
    param (
        [Parameter(Mandatory)]
        [object[]] $location,
        [Parameter(Mandatory)]
        $key
    )

    return (Remove-HashtableEntry $Script:secrets $location $key)
}