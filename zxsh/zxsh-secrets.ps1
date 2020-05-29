# Functions
# 1.    Display secrets
# 2.    Get-Secret
# 3.    Add-Secret


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
    ConvertTo-Json $Script:secrets
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

    return (Get-Node $location $Script:secrets)
}


########################################
# 3.    Add-Secret
<#
    .Synopsis
    Add secret to specified location

    .Description
    Add secret to specified location

    .INPUTS
    Array of Ids

    .OUTPUTS
    Secret in table format.

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
        $key,
        $value
    )

    return (Add-Node $location $Script:secrets $key $value)
}