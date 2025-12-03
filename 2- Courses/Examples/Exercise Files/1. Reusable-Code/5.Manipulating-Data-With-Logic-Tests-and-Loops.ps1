#######################
## Basic Maipulation ##
#######################

# Filtering Data
Get-ChildItem -Path ./Assets | Where-Object { $_.Extension -eq ".csv" }

# Sorting Objects
Get-ChildItem -Path ./Assets | Sort-Object -Property Length

# Combined Filtering and Sorting
Get-ChildItem -Path ./Assets | Where-Object { $_.Extension -eq ".csv" } | Sort-Object -Property LastWriteTime

# Calculating Values
$numbers = 100, 25, 30, 400, 55
$sum = ($numbers | Measure-Object -Sum).Sum
Write-Host "The sum is $sum"



#############
## Looping ##
#############

# Load Syslog Entries
$syslogentries = Get-Content ./Assets/Syslog-Assets.json | ConvertFrom-Json

# ForEach-Object with Switch
$syslogentries | ForEach-Object {
    Write-Host "Timestamp: $($_.timestamp)"
    Write-Host "Severity: $($_.event_severity)" 
    Write-Host "Protocol (Port): $($_.protocol)/$($_.port)"
    Write-Host "Internal IP: $($_.internal_ip)"
    Write-Host "External IP: $($_.external_ip)"

    switch ($_.connection_status.ToUpper()) {
        "SUCCESS" { $color = "Green" }
        "CLOSED" { $color = "Blue" }
        "OPEN" { $color = "Cyan" }
        "FAILED" { $color = "Red" }
        default { $color = "Yellow" }
    }

    Write-Host "Connection Status: $($_.connection_status)" -ForegroundColor $color
}


# ForEach-Object with Ternary Operator
$syslogentries | ForEach-Object {
    Write-Host "Timestamp: $($_.timestamp)"
    Write-Host "Severity: $($_.event_severity)" 
    Write-Host "Protocol (Port): $($_.protocol)/$($_.port)"
    Write-Host "Internal IP: $($_.internal_ip)"
    Write-Host "External IP: $($_.external_ip)"

    $color = @{
        "SUCCESS" = "Green"
        "CLOSED" = "Blue"
        "OPEN" = "Cyan"
        "FAILED" = "Red"
    }[$_.connection_status.ToUpper()] ?? "Yellow"

    Write-Host "Connection Status: $($_.connection_status)" -ForegroundColor $color 
}


# ForEach-Object with Where-Object
$syslogentries | ForEach-Object {
    Write-Host "Timestamp: $($_.timestamp)"
    Write-Host "Severity: $($_.event_severity)" 
    Write-Host "Protocol (Port): $($_.protocol)/$($_.port)"
    Write-Host "Internal IP: $($_.internal_ip)"
    Write-Host "External IP: $($_.external_ip)"

    $colors = @{
        "SUCCESS" = "Green"
        "CLOSED" = "Blue"
        "OPEN" = "Cyan"
        "FAILED" = "Red"
    }

    $status = $_.connection_status.ToUpper()

    $color = $colors.GetEnumerator() | Where-Object { $_.Name -eq $status } | Select-Object -ExpandProperty Value

    if (-not $color) {
        $color = "Yellow"
    }

    Write-Host "Connection Status: $($_.connection_status)" -ForegroundColor $color
}


# ForEach-Object with Where-Object
$syslogentries = Get-Content ./Assets/Syslog-Assets.json | ConvertFrom-Json

$syslogentries | ForEach-Object {
    $color = "Yellow"

    $status = $_.connection_status.ToUpper()

    if ($status -eq "SUCCESS") {
        $color = "Green"
    }
    elseif ($status -eq "CLOSED") {
        $color = "Blue"
    }
    elseif ($status -eq "OPEN") {
        $color = "Cyan"
    }
    elseif ($status -eq "FAILED") {
        $color = "Red"
    }

    Write-Host "Timestamp: $($_.timestamp)"
    Write-Host "Severity: $($_.event_severity)"
    Write-Host "Protocol (Port): $($_.protocol)/$($_.port)"
    Write-Host "Internal IP: $($_.internal_ip)"
    Write-Host "External IP: $($_.external_ip)"
    Write-Host "Connection Status: $($_.connection_status)" -ForegroundColor $color
}
