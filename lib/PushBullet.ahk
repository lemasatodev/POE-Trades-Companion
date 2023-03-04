/*
    HTTP Status Code	
    200 OK - Everything worked as expected.
    400 Bad Request - Usually this results from missing a required parameter.
    401 Unauthorized - No valid access token provided.
    403 Forbidden - The access token is not valid for that request.
    404 Not Found - The requested item doesn't exist.
    429 Too Many Requests - You have been ratelimited for making too many requests to the server.
    5XX Server Error - Something went wrong on Pushbullet's side. If this error is from an intermediate server, it may not be valid JSON.
*/

PB_PushNote(_token, _title, _msg) {

    pbMsg := StrReplace(_msg, "`n", "\n"), pbMsg := StrReplace(pbMsg, "`r", "\r"), pbMsg := StrReplace(pbMsg, "`t", "\t"), pbMsg := StrReplace(pbMsg, A_Tab, "\t")

    data := "{""type"": ""note"", ""title"": """ _title """, ""body"": """ pbMsg """}"
    headers := "Access-Token: " _token
    . "`n" "Content-Type: application/json"

    WinHttpRequest_cURL("https://api.pushbullet.com/v2/pushes", data, headers)

    RegExMatch(headers, "O)HTTP\/1\.1 (.*)`n", outVar)
        statusCode := outVar.1
        
    return {Data:data, Headers:headers, Status:statusCode}
}
