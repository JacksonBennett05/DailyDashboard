# DailyDashboard

## Overview
DailyDashboard is a PowerShell-based personal dashboard that provides a quick daily briefing directly in your terminal.
When run, it displays the current date, local weather and temperature, sunrise and sunset times, recent and upcoming games for your favorite sports teams, and the nearest upcoming events from your to-do list.

The script is designed to be lightweight, customizable, and automation-friendly so it can run manually or as part of a daily routine.

---

## Functionality
Running this PowerShell script will by default display:
- The current date
- The temperature in College Park, MD (can be changed to any location)
- Sunrise and sunset times
- Sunrise and sunset times
- The most recent and next game for selected sports teams
- The next three upcoming events from your events.csv file

---

## Configuration & Customization
This script is designed to be easily personalized. Below are the main places you will want to edit to make the dashboard your own.

---

### 1. Your Name (Greeting)
At the top of the script, update the $name variable:

```powershell
$name = "Jackson"
```

Change this to your name. It is used in the greeting displayed when the dashboard runs.

---

### 2. Location (Weather & Sunrise and Sunset)
By default, the script uses College Park, MD. You can change this in two ways.

#### Option A: Edit the defaults in the script
Modify these values near the top of the script:

```powershell
$lat = $env:LAT ?? 38.9896
$lng = $env:LNG ?? -76.9371
$areaCode = $env:CODE ?? 20740
```

- lat and lng represent the latitude and longitude of your city
- areaCode is the ZIP code used for weather lookups

#### Option B: Use environment variables (recommended)
You can override the defaults without editing the script itself:

```powershell
$env:LAT=40.7128
$env:LNG=-74.0060
$env:CODE=10001
```

---

### 3. Favorite Sports Teams
Sports teams are configured using the Get-ESPNTeamPrevNext function.

#### Example: Arsenal (Premier League)
```powershell
$ars = Get-ESPNTeamPrevNext `
  -Sport "soccer" `
  -League "eng.1" `
  -TeamKey "Arsenal"
```

#### Example: Boston Celtics (NBA)
```powershell
$bos = Get-ESPNTeamPrevNext `
  -Sport "basketball" `
  -League "nba" `
  -TeamKey "BOS"
```

You can duplicate these blocks to track additional teams.

---

### 4. Events and To-Do Items
Events are loaded from the events.csv file:

```powershell
$eventData = Import-Csv -Path ".\events.csv"
```

---

## Automation

### Basic Daily Automation (Optional)
DailyDashboard can be run automatically once per day using OS-level automation tools.

On macOS, this is typically done using **Shortcuts**:
- Create a Shortcut that runs `pwsh DailyDashboard.ps1`
- Set it to run daily at a time of your choice
- Add a notification action so you are alerted when the dashboard runs
- Optionally link the notification to a follow-up Shortcut that displays or opens the output

This provides a daily briefing without needing to manually run the script.

On Windows, similar behavior can be achieved using **Task Scheduler** with an optional notification step.

---

### If You Do Not Want Automation or Notifications
Automation is completely optional. If you prefer to run the script manually:

You can safely:
- Delete or ignore any Shortcut or scheduled task you created
- Remove any notification-related steps from your automation
- Run the script directly in the terminal using:

```powershell
pwsh ./DailyDashboard.ps1
```

No code changes are required for manual use. The dashboard will function normally without automation or notifications.

---

## Notes
- The script works with or without automation
- No background scheduler is required by default
- Environment variables are optional but recommended
- The script is designed to fail gracefully if optional data is missing

---

## License
Personal project. Free to modify and adapt for personal use.
