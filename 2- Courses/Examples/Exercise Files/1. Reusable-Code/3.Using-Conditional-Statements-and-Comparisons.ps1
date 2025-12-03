

# Introduction to Conditional Statements and Comparisons in PowerShell

# 1. If statement
$number = 5

if ($number -gt 3) {
    Write-Host "The number is greater than 3"
}

# 2. If-Else statement
$weather = "rainy"

if ($weather -eq "sunny") {
    Write-Host "It's sunny today"
} else {
    Write-Host "It's not sunny today"
}

# 3. If-ElseIf-Else statement
$temperature = 35

if ($temperature -lt 32) {
    Write-Host "It's freezing"
} elseif ($temperature -ge 32 -and $temperature -le 50) {
    Write-Host "It's cold"
} else {
    Write-Host "It's warm"
}

# 4. Switch statement
$dayOfWeek = "Monday"

switch ($dayOfWeek) {
    "Monday"    { Write-Host "Today is Monday" }
    "Tuesday"   { Write-Host "Today is Tuesday" }
    "Wednesday" { Write-Host "Today is Wednesday" }
    "Thursday"  { Write-Host "Today is Thursday" }
    "Friday"    { Write-Host "Today is Friday" }
    "Saturday"  { Write-Host "Today is Saturday" }
    "Sunday"    { Write-Host "Today is Sunday" }
    default     { Write-Host "Invalid day of the week" }
}

# 5. Comparisons
$a = 10
$b = 20

if ($a -eq $b) {
    Write-Host "a is equal to b"
} elseif ($a -ne $b) {
    Write-Host "a is not equal to b"
}

if ($a -gt $b) {
    Write-Host "a is greater than b"
} elseif ($a -lt $b) {
    Write-Host "a is less than b"
}

if ($a -ge $b) {
    Write-Host "a is greater than or equal to b"
} elseif ($a -le $b) {
    Write-Host "a is less than or equal to b"
}



# Import JSON data from the file
$JsonData = Get-Content -Path "./Assets/Computer-Assets.json" -Raw | ConvertFrom-Json

# Iterate through the vendors and computers
foreach ($vendor in $JsonData.vendors) {
    Write-Host "Vendor: $($vendor.name)"
    
    foreach ($computer in $vendor.computers) {
        Write-Host "Computer Name: $($computer.computer_name)"
        
        # Check the OS version
        if ($computer.os -eq "Windows 10") {
            Write-Host "This computer is running Windows 10"
        } elseif ($computer.os -eq "Windows 11") {
            Write-Host "This computer is running Windows 11"
        } else {
            Write-Host "Unknown OS for this computer"
        }
        
        # Check if the computer is domain-joined and online
        if ($computer.domain_joined -and $computer.online_status) {
            Write-Host "This computer is domain-joined and online"
        } elseif (-not $computer.domain_joined -and $computer.online_status) {
            Write-Host "This computer is not domain-joined but online"
        } else {
            Write-Host "This computer is either not domain-joined or offline"
        }
        
        # Check the processor type
        switch -Wildcard ($computer.processor) {
            "*Core i3*" { Write-Host "This computer has an Intel Core i3 processor" }
            "*Core i5*" { Write-Host "This computer has an Intel Core i5 processor" }
            "*Core i7*" { Write-Host "This computer has an Intel Core i7 processor" }
            "*Core i9*" { Write-Host "This computer has an Intel Core i9 processor" }
            "*Ryzen 5*" { Write-Host "This computer has an AMD Ryzen 5 processor" }
            default     { Write-Host "Unknown processor for this computer" }
        }
        
        Write-Host "" # Empty line for better readability
    }
}
