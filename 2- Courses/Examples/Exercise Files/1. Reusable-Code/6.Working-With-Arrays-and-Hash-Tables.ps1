




# Creating an Array
$numbers = (1, 2, 3, 4, 5)

# Accessing Array Objects by ID
$numbers = (1, 2, 3, 4, 5)
$second = $numbers[1]
Write-Host "The second element is $second"

# Looping through an Array
$names = "John", "Sarah", "Mike"
ForEach ($name in $names) {
    Write-Host "Hello, $name!"
}

# Creating a Hash Table
$ages = @{
    "John" = 30
    "Sarah" = 25
    "Mike" = 40
}

# Accessing Hash Table Objects
$ages = @{
    "John" = 30
    "Sarah" = 25
    "Mike" = 40
}
$johnAge = $ages["John"]
Write-Host "John's age is $johnAge"


# Looping through a Hash Table
$ages = @{
    "John" = 30
    "Sarah" = 25
    "Mike" = 40
}
ForEach ($person in $ages.GetEnumerator()) {
    $name = $person.Key
    $age = $person.Value
    Write-Host "$name is $age years old"
}

# Looping through a Hash Table (Concise)
$ages = @{
    John = 30
    Sarah = 25
    Mike = 40
}

$ages.GetEnumerator() | ForEach-Object {
    Write-Host "$($_.Key) is $($_.Value) years old"
}


# Retrieve all running process, filter, sort, then loop, calculate, and display
$processes = Get-Process
$largeProcesses = $processes | Where-Object { $_.WorkingSet64 -gt 100MB }
$sortedProcesses = $largeProcesses | Sort-Object -Property WorkingSet64 -Descending
$sortedProcesses[0..9] | ForEach-Object {
    $processName = $_.ProcessName
    $workingSet = [math]::Round($_.WorkingSet64 / 1MB, 2)
    Write-Host "$($processName): $($workingSet) MB"
}


# Retrieve data from JSON, populate Hash Table, sort by vendor, loop all vendors, then print all computers
$jsonData = Get-Content -Path ./Assets/Computer-Assets.json | ConvertFrom-Json
$dataByVendor = @{}

$jsonData.vendors | ForEach-Object {
    $vendorName = $_.name
    $computers = $_.computers

    $dataByVendor[$vendorName] = $computers
}
$dataByVendor = $dataByVendor.GetEnumerator() | Sort-Object -Property Key

$dataByVendor | ForEach-Object {
    $vendorName = $_.Key
    $computers = $_.Value

    Write-Host "Vendor: $vendorName"
    Write-Host "----------------"

    $computers | ForEach-Object {
        $computerName = $_.computer_name
        $os = $_.os
        $ram = $_.ram
        $processor = $_.processor
        $disk = $_.disk
        $ipAddress = $_.ip_address
        $domainJoined = $_.domain_joined
        $onlineStatus = $_.online_status
        $dateAdded = $_.date_added

        Write-Host "Computer Name: $($computerName.ToUpper())"
        Write-Host "OS: $os"
        Write-Host "RAM: $ram"
        Write-Host "Processor: $processor"
        Write-Host "Disk: $disk"
        Write-Host "IP Address: $ipAddress"
        Write-Host "Domain Joined: $domainJoined"
        Write-Host "Online Status: $onlineStatus"
        Write-Host "Date Added: $dateAdded"
        Write-Host ""
    }
}
