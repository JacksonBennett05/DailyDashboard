$time = Get-Date -Format "dddd, MMM dd yyyy"
$lat = 38.9896
$lng = -76.9371
$name = "Jackson"
$weather = Invoke-WebRequest "https://wttr.in/20740?format=%C+%t"
$response = Invoke-RestMethod "https://api.sunrise-sunset.org/json?lat=$lat&lng=$lng&tzid=America/New_York"
$sunrise = $response.results.sunrise
$sunset  = $response.results.sunset



Write-Host "========== Good Morning $name =========="
Write-Host "Todays Date is: $time"
Write-Host "The weather in College Park is $($weather.Content)"
Write-Host "Sunrise will be at $sunrise"
Write-Host "Sunset will be at $sunset"
Write-Host "-----------------------------------"
