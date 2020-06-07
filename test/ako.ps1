$url = ""
# $headers = @{
#     Authorization=$oauthHeaders
# }

# $a = Invoke-RestMethod -Method Post -Headers $headers -Uri $url

$a = Invoke-RestMethod -Uri "http://localhost:8080/api/echo?msg=asd"
$a 