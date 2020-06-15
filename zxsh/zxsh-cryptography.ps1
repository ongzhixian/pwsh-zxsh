# Functions
# 1. Get-RandomBytes
# 2. Get-PBKDF2
# 3. ConvertTo-EncryptedBytes
# 4. ConvertFrom-EncryptedBytes (# Get-DecryptedText)



########################################
# 1.    Get-RandomBytes
<#
    .Synopsis
    Return a specified number random bytes. 

    .Description
    Return a specified number random bytes.

    .INPUTS
    length 
    Length of random bytes

    .OUTPUTS
    Array of random bytes of specified length.

    .Example
    C:\PS> get-randombytes 10
    32
    67
    234
    128
    255
    187
    159
    195
    67
    126

    Return array of 10 random bytes.

    .Link
    None
#>
function Get-RandomBytes {
    param (
        [ushort] $length = 1
    )

    Write-Debug "Get-RandomBytes[length] : $length" 

    $result = New-Object byte[] $length

    # ZX:   It sounds good in theory to make RNGCryptoServiceProvider a shared resource.
    #       But it is probably more secure to recreate it each time we need it.
    #       Leave it as it is for the time being, until such a time performance becomes an issue.
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($result)

    return $result
}



########################################
# 2.    Get-PBKDF2
<#
    .Synopsis
    Return a bytes using a passphrase based KDF.

    .Description
    Return a bytes using a passphrase based KDF.

    .INPUTS
    length 
    
    Length of random bytes

    .OUTPUTS
    Array of random bytes generated via PBKDF2

    .Example
    C:\PS> Get-PBKDF2 10
    32
    67
    234
    128
    255
    187
    159
    195
    67
    126

    Return array of 10 random bytes.

    .Link
    None
#>
function Get-PBKDF2 {
    param (
        [Parameter(Mandatory)][System.Security.SecureString] $passPhrase,
        [int] $saltBytesLength = 0,
        [uint] $itCountMax = 99999,
        [byte[]] $saltBytes = $null,
        [uint] $itCount = 0
    )

    Write-Host "Get-PBKDF2 [passPhrase]=[$passPhrase] [saltBytesLength]=[$saltBytesLength] [itCountMax]=[$itCountMax] [saltBytes]=[$saltBytes] [itCount]=[$itCount]"

    if ($null -eq $saltBytes)
    {
        $saltBytes = Get-RandomBytes $saltBytesLength
    }
    
    $saltBase64 = [Convert]::ToBase64String($saltBytes)

    if ($itCount -eq 0) 
    {
        $itCount = Get-Random -Maximum $itCountMax
    }

    Write-Debug "Salt bytes: $saltBytes"
    Write-Debug "Salt bytes: $saltBase64"
    Write-Debug "It count  : $itCount"

    $pdb = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($passPhrase, $saltBytes, $itCount)

    return @{
        "saltBase64"= $saltBase64;
        "itCount"   = $itCount;
        "pdb"       = $pdb;
    }
}


########################################
# 3.    ConvertTo-EncryptedBytes
<#
    .Synopsis
    Return a specified number random bytes. 

    .Description
    Return a specified number random bytes.

    .INPUTS
    length 
    Length of random bytes

    .OUTPUTS
    Array of random bytes of specified length.

    .Example
    C:\PS> get-randombytes 10
    32
    67
    234
    128
    255
    187
    159
    195
    67
    126

    Return array of 10 random bytes.

    .Link
    None
#>
function ConvertTo-EncryptedBytes {
    param (
        [Parameter(Mandatory)][string] $algorithmName,    
        [Parameter(Mandatory)][System.Security.SecureString] $passPhrase,
        [Parameter(Mandatory)][string] $plainText
    )
    
    Write-Host "Get-EncryptedBytes [algorithmName]=[$algorithmName] [passPhrase]=[$passPhrase] [plainText]=[$plainText]"

    [System.Security.Cryptography.SymmetricAlgorithm] $alg = $null
    [System.Collections.Hashtable] $pbkdf2 = $null 
    $saltBase64 = $null
    $itCount = $null
    [System.Security.Cryptography.Rfc2898DeriveBytes] $pdb = $null
    $ivBase64 = $null
    $cipherBase64 = $null

    [System.Security.Cryptography.ICryptoTransform] $encryptor = $null
    [System.IO.MemoryStream] $ms = $null
    [System.Security.Cryptography.CryptoStream] $encryptionStream = $null
    [System.IO.StreamWriter] $sw = $null

    $alg = [System.Security.Cryptography.SymmetricAlgorithm]::Create($algorithmName)
    if ($null -eq $alg)
    {
        Write-Error "Invalid algorithm name. Ensure that its one of the following: [AES, DES, RC2, Rijndael, 3DES]"
        return
    }
    
    $pbkdf2     = Get-PBKDF2 $passPhrase ($alg.BlockSize / 8)
    $saltBase64 = $pbkdf2["saltBase64"]
    $itCount    = $pbkdf2["itCount"]
    $pdb        = $pbkdf2["pdb"]

    $alg.Key    = $pdb.GetBytes($alg.KeySize / 8)

    Write-Host "EncKey $([Convert]::ToBase64String($alg.Key))"
    Write-Host "EncKey $([Convert]::ToBase64String($alg.IV))"

    try {
        $encryptor = $alg.CreateEncryptor($alg.Key, $alg.IV)

        $ms = [System.IO.MemoryStream]::new()
        $encryptionStream = [System.Security.Cryptography.CryptoStream]::new($ms, $encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
        $sw = [System.IO.StreamWriter]::new($encryptionStream)

        $sw.AutoFlush = $true
        $sw.Write($plainText)
        $sw.Flush()

        $sw.Close()
        $encryptionStream.Close()
        $ms.Close()

        $ivBase64 = [Convert]::ToBase64String($alg.IV)
        $cipherBase64 = [Convert]::ToBase64String($ms.ToArray())

        return [ordered]@{
            "Alg"   = $algorithmName;
            "Salt"  = $saltBase64;
            "It"    = $itCount;
            "IV"    = $ivBase64;
            "Cipher"= $cipherBase64;
        }
    }
    catch {
        Write-Error $_.Exception
    }
    finally
    {
        if ($null -ne $sw)
        {
            $sw.Close()
        }
        
        if ($null -ne $encryptionStream)
        {
            $encryptionStream.Close()
        }
        
        if ($null -ne $ms)
        {
            $ms.Close()
        }
    }

    return $null
}


########################################
# 4.    ConvertFrom-EncryptedBytes
<#
    .Synopsis
    Return a specified number random bytes. 

    .Description
    Return a specified number random bytes.

    .INPUTS
    length 
    Length of random bytes

    .OUTPUTS
    Array of random bytes of specified length.

    .Example
    C:\PS> get-randombytes 10
    32
    67
    234
    128
    255
    187
    159
    195
    67
    126

    Return array of 10 random bytes.

    .Link
    None
#>
function ConvertFrom-EncryptedBytes
{
    param (
        [Parameter(Mandatory)][string] $algorithmName,    
        [Parameter(Mandatory)][System.Security.SecureString] $passPhrase,
        [Parameter(Mandatory)][string]  $cipherText,
        [Parameter(Mandatory)][int]     $itCount,
        [Parameter(Mandatory)][string]  $saltBase64,
        [Parameter(Mandatory)][string]  $ivBase64
    )

    Write-Host "Get-DecryptedText [algorithmName]=[$algorithmName] [passPhrase]=[$passPhrase] [cipherText]=[$cipherText]"

    [System.Security.Cryptography.SymmetricAlgorithm] $alg = $null
    [System.Collections.Hashtable] $pbkdf2 = $null 
    [System.Security.Cryptography.Rfc2898DeriveBytes] $pdb = $null

    $plainText = $null
    [System.Security.Cryptography.ICryptoTransform] $decryptor = $null
    [System.IO.MemoryStream] $ms = $null
    [System.Security.Cryptography.CryptoStream] $decryptionStream = $null
    [System.IO.StreamReader] $sr = $null

    $alg = [System.Security.Cryptography.SymmetricAlgorithm]::Create($algorithmName)
    if ($null -eq $alg)
    {
        Write-Error "Invalid algorithm name. Ensure that its one of the following: [AES, DES, RC2, Rijndael, 3DES]"
        return
    }

    # Restore pbkdf2
    $pbkdf2     = Get-PBKDF2 $passPhrase -itCount $itCount -saltBytes ([Convert]::FromBase64String($saltBase64))
    $pdb        = $pbkdf2["pdb"]

    # Restore symmetric encryption algorithm 
    $alg.Key = $pdb.GetBytes($alg.KeySize / 8)
    $alg.IV = [Convert]::FromBase64String($ivBase64)

    Write-Host "ResKey $([Convert]::ToBase64String($alg.Key))"
    Write-Host "ResKey $([Convert]::ToBase64String($alg.IV))"

    # Decrypting...
    try {
        $decryptor = $alg.CreateDecryptor($alg.Key, $alg.IV)

        [byte[]] $cipherBytes = [Convert]::FromBase64String($cipherText)
        $ms = [System.IO.MemoryStream]::new($cipherBytes)
        $decryptionStream = [System.Security.Cryptography.CryptoStream]::new($ms, $decryptor, [System.Security.Cryptography.CryptoStreamMode]::Read)
        $sr = [System.IO.StreamReader]::new($decryptionStream)
        $plainText = $sr.ReadToEnd()

        $sr.Close()
        $decryptionStream.Close()
        $ms.Close()
        
        return $plainText
    }
    catch [System.Security.Cryptography.CryptographicException]
    {
        Write-Error "Cannot decrypt content. Please check password."
    }
    catch {
        Write-Error "Error" $_.Exception
    }

    return $plainText
}