#####################
## General Looping ##
#####################

# For Loop
for ($i = 1; $i -le 10; $i++) {
    Write-Host $i
}


# ForEach Loop
$fruits = @("apple", "banana", "orange", "grape")

foreach ($fruit in $fruits) {
    Write-Host $fruit
}


# While Loop
$count = 0

while ($count -lt 10) {
    Write-Host $count
    $count++
}


# Do-While Loop
$count = 0
do {
    Write-Host $count
    $count++
} while ($count -lt 10)


do {
    $num = Read-Host "Enter a number greater than 10"
} while ($num -le 10)
Write-Host "You entered $num" -ForegroundColor Green



# For-Each-Object Loop
Get-ChildItem ./Assets | ForEach-Object {
    Write-Host $_.Name
}

 

#######################
## Looping with Data ##
#######################

# Variables
$colors = "Black", "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow", "Gray", "DarkGray", "Blue", "Green", "Cyan", "Red", "Magenta", "Yellow", "White"

# Load Syslog Entries
$syslogentries = Get-Content ./Assets/Syslog-Assets.json | ConvertFrom-Json

# ForEach Loop
ForEach ($entry in $syslogentries) {
    $color = Get-Random $colors
    if ($colors -contains $color) {
        Write-Host "Timestamp: $($entry.timestamp)" -ForegroundColor $color
        Write-Host "Severity: $($entry.event_severity)" -ForegroundColor $color
        Write-Host "Protocol (Port): $($entry.protocol)/$($entry.port)" -ForegroundColor $color
        Write-Host "Internal IP: $($entry.internal_ip)" -ForegroundColor $color
        Write-Host "External IP: $($entry.external_ip)" -ForegroundColor $color
        Write-Host "Connection Status: $($entry.connection_status)" -ForegroundColor $color
    }
}


# For Loop
for ($i = 0; $i -lt $syslogentries.Count; $i++) {
    $color = Get-Random $colors
    if ($colors -contains $color) {
        Write-Host "Timestamp: $($syslogentries[$i].timestamp)" -ForegroundColor $color
        Write-Host "Severity: $($syslogentries[$i].event_severity)" -ForegroundColor $color
        Write-Host "Protocol (Port): $($syslogentries[$i].protocol)/$($syslogentries[$i].port)" -ForegroundColor $color
        Write-Host "Internal IP: $($syslogentries[$i].internal_ip)" -ForegroundColor $color
        Write-Host "External IP: $($syslogentries[$i].external_ip)" -ForegroundColor $color
        Write-Host "Connection Status: $($syslogentries[$i].connection_status)" -ForegroundColor $color
    }
}


# While Loop
$i = 0
while ($i -lt $syslogentries.Count) {
    $color = Get-Random $colors
    if ($colors -contains $color) {
        $entry = $syslogentries[$i]
        Write-Host "Timestamp: $($entry.timestamp)" -ForegroundColor $color
        Write-Host "Severity: $($entry.event_severity)" -ForegroundColor $color
        Write-Host "Protocol (Port): $($entry.protocol)/$($entry.port)" -ForegroundColor $color
        Write-Host "Internal IP: $($entry.internal_ip)" -ForegroundColor $color
        Write-Host "External IP: $($entry.external_ip)" -ForegroundColor $color
        Write-Host "Connection Status: $($entry.connection_status)" -ForegroundColor $color
        $i++
    }
}


# Do-While Loop
$i = 0
do {
    $color = Get-Random $colors
    if ($colors -contains $color) {
        $entry = $syslogentries[$i]
        Write-Host "Timestamp: $($entry.timestamp)" -ForegroundColor $color
        Write-Host "Severity: $($entry.event_severity)" -ForegroundColor $color
        Write-Host "Protocol (Port): $($entry.protocol)/$($entry.port)" -ForegroundColor $color
        Write-Host "Internal IP: $($entry.internal_ip)" -ForegroundColor $color
        Write-Host "External IP: $($entry.external_ip)" -ForegroundColor $color
        Write-Host "Connection Status: $($entry.connection_status)" -ForegroundColor $color
        $i++
    }
} while ($i -lt $syslogentries.Count)


# Do-Until Loop
$i = 0
do {
    $color = Get-Random $colors
    if ($colors -contains $color) {
        $entry = $syslogentries[$i]
        Write-Host "Timestamp: $($entry.timestamp)" -ForegroundColor $color
        Write-Host "Severity: $($entry.event_severity)" -ForegroundColor $color
        Write-Host "Protocol (Port): $($entry.protocol)/$($entry.port)" -ForegroundColor $color
        Write-Host "Internal IP: $($entry.internal_ip)" -ForegroundColor $color
        Write-Host "External IP: $($entry.external_ip)" -ForegroundColor $color
        Write-Host "Connection Status: $($entry.connection_status)" -ForegroundColor $color
        $i++
    }
} until ($i -ge $syslogentries.Count)


# ForEach-Object
$syslogentries | ForEach-Object {
    $color = Get-Random $colors
    if ($colors -contains $color) {
        Write-Host "Timestamp: $($_.timestamp)" -ForegroundColor $color
        Write-Host "Severity: $($_.event_severity)" -ForegroundColor $color
        Write-Host "Protocol (Port): $($_.protocol)/$($_.port)" -ForegroundColor $color
        Write-Host "Internal IP: $($_.internal_ip)" -ForegroundColor $color
        Write-Host "External IP: $($_.external_ip)" -ForegroundColor $color
        Write-Host "Connection Status: $($_.connection_status)" -ForegroundColor $color
    }
}

# ForEach-Object with Out-GridView
$syslogentries | ForEach-Object {
    $color = Get-Random $colors
    if ($colors -contains $color) {
        Write-Host "Timestamp: $($_.timestamp)" -ForegroundColor $color
        Write-Host "Severity: $($_.event_severity)" -ForegroundColor $color
        Write-Host "Protocol (Port): $($_.protocol)/$($_.port)" -ForegroundColor $color
        Write-Host "Internal IP: $($_.internal_ip)" -ForegroundColor $color
        Write-Host "External IP: $($_.external_ip)" -ForegroundColor $color
        Write-Host "Connection Status: $($_.connection_status)" -ForegroundColor $color
    }
}