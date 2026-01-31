# DailyDashboard

## Functionality
Running this Powershell script will by default give you the Date the temperature in College Park MD (Can be changed to your location) along with sunrise and sunset. It can also tell you last and next game of your favorite sports teams along with which events are closest to being due on your to do file.

## Configuration & Customization

This script is designed to be easily personalized.
Below are the main places you’ll want to edit to make the dashboard your own.

---

### 1. Your Name (Greeting)

At the top of the script, update the `$name` variable:

```powershell
$name = "Jackson"
```

Change this to your name.
It’s used in the “Good Morning” greeting.

---

### 2. Location (Weather & Sunrise/Sunset)

By default, the script uses College Park, MD.
You can change this in two ways.

#### Option A: Edit the defaults in the script

Modify these values near the top:

```powershell
$lat = $env:LAT ?? 38.9896
$lng = $env:LNG ?? -76.9371
$areaCode = $env:CODE ?? 20740
```

- `lat` / `lng` → latitude & longitude of your city
- `areaCode` → ZIP code used for weather

#### Option B: Use environment variables (recommended)

You can override the defaults without editing the script:

```powershell
$env:LAT=40.7128
$env:LNG=-74.0060
$env:CODE=10001
```

---

### 3. Favorite Sports Teams

Teams are configured using the `Get-ESPNTeamPrevNext` function.

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

To change teams:

- `Sport` → "soccer", "basketball", "football", etc.
- `League` → ESPN league code (e.g. nba, nfl, eng.1)
- `TeamKey` → team name, short name, or abbreviation

You can duplicate these blocks to track additional teams.

---

### 4. Events & To-Do Items

Events are loaded from the `events.csv` file:

```powershell
$eventData = Import-Csv -Path ".\events.csv"
```

#### CSV Format

Your `events.csv` should look like this:

```csv
Name,DateTime,Type,Notes
Homework 3,2026-02-01 23:59,School,Canvas submission
Doctor Appointment,2026-02-02 10:30,Personal,Bring insurance card
```

Important formatting rules:

- `DateTime` must be in `yyyy-MM-dd HH:mm` format
- `Type` is optional
- `Notes` is optional
- Only upcoming events are shown
- The script displays the next 3 upcoming events

---

### 5. Running Automatically (Optional)

You can configure this script to run on startup.

- Windows: Use Task Scheduler to run the PowerShell script on login
- macOS/Linux (PowerShell Core): Add to shell startup or use a scheduled task

This turns the dashboard into a daily morning briefing.


<!-- Gives daily update with sports scores, weather and even starts up some music!  
  
This script is designed to automate your morning routine running automatically when you start up your computer to deliver all your essential info in one place. It can be customized to include different data sources, notifications, or launch specific apps to make your day easier
-->
