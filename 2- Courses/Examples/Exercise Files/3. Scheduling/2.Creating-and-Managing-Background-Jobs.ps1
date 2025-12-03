## Creating and Managing Background Jobs

# Start a new background job
$Job = Start-Job -ScriptBlock { Get-Process }

# Get list of all background jobs
Get-Job

# Waits for a background job to complete before continuing the script
$Job = Start-Job -ScriptBlock { Get-Process }
Wait-Job $Job

# Removes a background job
$Job = Start-Job -ScriptBlock { Get-Process }
Remove-Job $Job

# Remove all completed background jobs
Get-Job | Remove-Job

# Create a new job and retrieve the returned information
$ScriptBlock = {
    $NetworkInfo = Get-NetAdapter | Select-Object Name, InterfaceDescription, Status, MacAddress
    return $NetworkInfo
}

$Job = Start-Job -ScriptBlock $ScriptBlock


# Using a Script or Function in a Background Job
# Define the function
function Get-Double {
    param($Number)
    return $Number*2
}

# Export the function to a script block
$ScriptBlock = { . ./Get-Double.ps1; Get-Double -Number 7 }

# Start the background job
$Job = Start-Job -ScriptBlock $ScriptBlock

# Retrieve the output
Receive-Job -Job $Job -Wait



