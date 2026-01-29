$time = Get-Date -Format "dddd, MMM dd yyyy"
# Coordinates for College Park MD
$lat = $env:LAT ?? 38.9896
$lng = $env:LNG ?? -76.9371
$areaCode = $env:CODE ?? 20740
$fmt = "?format=%C%20%t"
$name = "Jackson"
$weather = Invoke-WebRequest "https://wttr.in/$areaCode$fmt"
$response = Invoke-RestMethod "https://api.sunrise-sunset.org/json?lat=$lat&lng=$lng&tzid=America/New_York"
$sunrise = $response.results.sunrise
$sunset  = $response.results.sunset


Write-Host " "
Write-Host "========== Good Morning $name =========="
Write-Host "Todays Date is: $time"
Write-Host "The weather in College Park is $($weather.Content)"
Write-Host "Sunrise will be at $sunrise"
Write-Host "Sunset will be at $sunset"
Write-Host " "


function Get-ESPNTeamPrevNext {
  param(
    [Parameter(Mandatory)][string]$Sport,   # e.g. "soccer" or "basketball"
    [Parameter(Mandatory)][string]$League,  # e.g. "eng.1" or "nba"
    [Parameter(Mandatory)][string]$TeamKey, # "Arsenal", "ARS", "Boston Celtics", "BOS"
    [int]$DaysBack = 30,
    [int]$DaysForward = 60
  )

  $today = Get-Date
  $start = $today.AddDays(-$DaysBack).ToString("yyyyMMdd")
  $end   = $today.AddDays($DaysForward).ToString("yyyyMMdd")

  $url = "https://site.api.espn.com/apis/site/v2/sports/$Sport/$League/scoreboard?dates=$start-$end&limit=500"

  try {
    $data = Invoke-RestMethod -Uri $url
  } catch {
    Write-Output "Failed to fetch ESPN data for $Sport/$League"
    return $null
  }

  if (-not $data.events) { return $null }

  $games = foreach ($ev in $data.events) {
    $comp = $ev.competitions[0]
    if (-not $comp -or -not $comp.competitors) { continue }

    # Find if this event involves the team
    $involvesTeam = $false
    foreach ($c in $comp.competitors) {
      $t = $c.team
      if ($t.displayName -eq $TeamKey -or $t.shortDisplayName -eq $TeamKey -or $t.abbreviation -eq $TeamKey) {
        $involvesTeam = $true
        break
      }
    }
    if (-not $involvesTeam) { continue }

    $homeTeam = $comp.competitors | Where-Object { $_.homeAway -eq "home" } | Select-Object -First 1
    $awayTeam = $comp.competitors | Where-Object { $_.homeAway -eq "away" } | Select-Object -First 1
    if (-not $homeTeam -or -not $awayTeam) { continue }

    $dt = [DateTimeOffset]::Parse($ev.date).LocalDateTime

    # Normalize display fields
    $homeName = $homeTeam.team.shortDisplayName
    $awayName = $awayTeam.team.shortDisplayName
    $statusState = $ev.status.type.state
    $statusDetail = $ev.status.type.detail
    $scoreLine = $null

    if ($statusState -eq "post") {
      $scoreLine = "$awayName $($awayTeam.score) @ $homeName $($homeTeam.score) ($statusDetail)"
    } elseif ($statusState -eq "in") {
      $scoreLine = "$awayName $($awayTeam.score) @ $homeName $($homeTeam.score) ($statusDetail)"
    } else {
      $scoreLine = "$awayName @ $homeName ($statusDetail)"
    }

    [PSCustomObject]@{
      DateTime = $dt
      State    = $statusState
      Summary  = $scoreLine
    }
  }

  if (-not $games) { return $null }

  $gamesSorted = $games | Sort-Object DateTime

  $prev = $gamesSorted | Where-Object { $_.DateTime -lt $today } | Select-Object -Last 1
  $next = $gamesSorted | Where-Object { $_.DateTime -gt $today } | Select-Object -First 1

  return [PSCustomObject]@{
    Previous = $prev
    Next     = $next
  }
}

# --- Arsenal (Premier League) ---
$ars = Get-ESPNTeamPrevNext -Sport "soccer" -League "eng.1" -TeamKey "Arsenal"

Write-Output "=== Arsenal ==="
if ($ars.Previous) { Write-Output ("Previous: " + $ars.Previous.DateTime.ToString("ddd MMM d h:mm tt") + " — " + $ars.Previous.Summary) } else { Write-Output "Previous: (none found)" }
if ($ars.Next)     { Write-Output ("Next:     " + $ars.Next.DateTime.ToString("ddd MMM d h:mm tt") + " — " + $ars.Next.Summary) }     else { Write-Output "Next: (none found)" }

Write-Output ""

# --- Celtics (NBA) ---
$bos = Get-ESPNTeamPrevNext -Sport "basketball" -League "nba" -TeamKey "BOS"

Write-Output "=== Boston Celtics ==="
if ($bos.Previous) { Write-Output ("Previous: " + $bos.Previous.DateTime.ToString("ddd MMM d h:mm tt") + " — " + $bos.Previous.Summary) } else { Write-Output "Previous: (none found)" }
if ($bos.Next)     { Write-Output ("Next:     " + $bos.Next.DateTime.ToString("ddd MMM d h:mm tt") + " — " + $bos.Next.Summary) }     else { Write-Output "Next: (none found)" }

Write-Host "-----------------------------------"