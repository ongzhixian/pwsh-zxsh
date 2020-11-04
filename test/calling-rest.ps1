$url = ""
# $headers = @{
#     Authorization=$oauthHeaders
# }

# $a = Invoke-RestMethod -Method Post -Headers $headers -Uri $url

# $a = Invoke-RestMethod -Uri "http://localhost:8080/api/echo?msg=asd"
# $a 

try {
    $a = Invoke-RestMethod -Uri "http://localhost:8080/api/echo"
}
catch [Microsoft.PowerShell.Commands.HttpResponseException] {
    Write-Error "HttpResponseException"
    $ex = $_.Exception
    $ex.GetType().ToString()
    $ex.Response
    $ex.Response.StatusCode
    $ex.Response.StatusCode -eq 400
}