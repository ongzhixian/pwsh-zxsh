Describe "/api/echo" {

    It "?msg=asd" {
        $a = Invoke-RestMethod -Uri "http://localhost:8080/api/echo?msg=asd"
        $a | Should Be "re:asd"
    }

    It "?msg=hello world" {
        $a = Invoke-RestMethod -Uri "http://localhost:8080/api/echo?msg=hello world"
        $a | Should Be "re:hello world"
    }

    It "no-querystring" {
        try {
            $a = Invoke-RestMethod -Uri "http://localhost:8080/api/echo"
        }
        catch [Microsoft.PowerShell.Commands.HttpResponseException] {
            $ex = $_.Exception
            $ex.Response.StatusCode -eq 400 | Should Be $true
        }
    }

    It "no-querystring2" {
        {
            $a = Invoke-RestMethod -Uri "http://localhost:8080/api/echo" 
        } | Should Throw "Response status code does not indicate success: 400 (BAD REQUEST)."
    }
}