$eventData = Import-Csv -Path ".\events.csv"

# for ($i = 0; $i -lt $eventData.Length; $i++) {
#   if ($eventData[$i].Notes) {
#     Write-Host "$($eventData[$i].Name) - $($eventData[$i].DateTime)  $($eventData[$i].Notes)"
#   } else {
#     Write-Host "$($eventData[$i].Name) - $($eventData[$i].DateTime)"
#   }
# }

$eventDataWithParsed = foreach ($event in $eventData) {
  $parsed = $null
  try{
    $parsed = [DateTime]::ParseExact(
      $event.DateTime,
      "yyyy-MM-dd HH:mm",
      $null
    )
  } catch {
    $parsed = $null
  }

  [PSCustomObject]@{
    Name = $event.Name
    DateTime = $event.DateTime
    Type = $event.Type
    Notes = $event.Notes
    ParsedDateTime = $parsed
  }
}

$now = Get-Date
$upcomingEvents = $eventDataWithParsed | Where-Object { $_.ParsedDateTime -ne $null -and $_.ParsedDateTime -gt $now}
$sorted = $upcomingEvents | Sort-Object -Property ParsedDateTime

$i = 0
while ($i -lt 3 -and $i -lt $sorted.Length){
  $e = $sorted[$i]

  $line = "- {0} - {1}" -f `
  $e.Name,
  $e.ParsedDateTime.ToString("ddd MMM d h:mm tt")

  if ($e.Type) {
    $line += " [$($e.Type)]"
  }

  if ($e.Notes) {
    $line += " - $($e.Notes)"
  }

  Write-Host $line

  $i++
}