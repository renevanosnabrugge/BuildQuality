param
(
    [string] $RestToken="",
    [string] $BuildID="",
    [string] $BuildTags=""
)

$buildTagsArray = $BuildTags.Split(";");
$baseurl = "$($env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI)DefaultCollection/$($env:SYSTEM_TEAMPROJECT)/_apis"

$token =""
IF([string]::IsNullOrEmpty($env:System_AccessToken)) {
    Write-Host "No System Access Token. Sending RESTToken"

    $userpass = ":$($RestToken)"
    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($userpass))
    $token = "Basic $encodedCreds"
}
else 
{
    Write-Host "System Access Token Found."
    $token = "Bearer $($env:System_AccessToken)"
       Write-Host $token
}


Write-Host "BaseURL: [$baseurl]"
Write-Host "tagURL: [$tagURL]"
Write-Host "token: [$token]"

if ($buildTagsArray.Count -gt 0) {

    foreach($tag in $buildTagsArray)
    {
        $tagURL = "$baseurl/build/builds/$BuildID/tags/$tag`?api-version=2.0"
        $response = Invoke-RestMethod -Uri $tagURL -Headers @{Authorization = $token}  -Method Put
        Write-Host $response

    }
}