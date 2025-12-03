## Monitoring and Retrieving Background Job Results

# Retrieve the output of a background job
$Job = Start-Job -ScriptBlock { Get-Process }
Receive-Job $Job

# Retrieve the output of all completed background jobs
$Job = Start-Job -ScriptBlock { Get-Process }
Get-Job | Receive-Job

# After creating a job, wait for it to complete and then retrieve the returned information
Wait-Job $Job
$NetworkInfo = Receive-Job $Job
Write-Output $NetworkInfo


# Retrieve the results of a specific job using its ID
$Job = Start-Job -ScriptBlock { Get-Process }
Receive-Job -Id $Job.Id

# Retrieve the results of a job and automatically remove the job
$Job = Start-Job -ScriptBlock { Get-Process }
Receive-Job -Id $Job.Id -AutoRemoveJob

# Retrieve the results of a job and keep the job results in memory for further retrieval
$Job = Start-Job -ScriptBlock { Get-Process }
Receive-Job -Id $Job.Id -Keep

# Monitor the state of all jobs
Get-Job | Format-Table -Property Id, Name, State


# Retrieve the error records that were generated during the execution of a background job
# Start a new background job that will result in an error
$Job = Start-Job -ScriptBlock { 
    # Trying to stop a process that doesn't exist will throw an error
    Stop-Process -Name "NonExistentProcess" -ErrorAction Stop
}

# Wait for the job to complete
Wait-Job $Job

# Retrieve the error message
$ErrorMessage = $Job.ChildJobs[0].JobStateInfo.Reason.Message

# Print the error message
$ErrorMessage




# Execute a command on a remote computer as a background job
$Job = Invoke-Command -ComputerName "client.training.int" -ScriptBlock { Get-Process } -AsJob

# Wait for the job to complete before continuing
Wait-Job -Id $Job.Id

# Retrieve the results from the background job
$Results = Receive-Job -Id $Job.Id

# Output the results
$Results



## Throttle Background Jobs

# Define the maximum number of jobs
$MaxJobs = 2

# Define the script block
$ScriptBlock = { Get-CimInstance -ClassName Win32_OperatingSystem  }

# Define the list of computers
$Computers = "WS-RND5472", "TSK-AGZ9263", "CMP-LMN8571", "DSK-RST4925", "WKS-XYZ6813"

foreach ($Computer in $Computers) {
    # Wait if there are already max jobs running
    while ((Get-Job | Where-Object { $_.State -eq 'Running' }).Count -ge $MaxJobs) {
        Start-Sleep -Seconds 1
    }

    # Start the job
    Start-Job -ScriptBlock $ScriptBlock -ArgumentList $Computer
}

# Wait for all jobs to complete
Get-Job | Wait-Job

# Retrieve and display results
Get-Job | Receive-Job

