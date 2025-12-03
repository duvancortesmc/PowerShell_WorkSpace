
# Scheduled job using a script block and a daily trigger
$scriptBlock = { Get-Process | Out-File ".\Logs\ProcessInfo.txt" }
$trigger = New-JobTrigger -Daily -At 1pm
Register-ScheduledJob -Name "DailyProcessInfo" -ScriptBlock $scriptBlock -Trigger $trigger


# Scheduled job using a function and a weekly trigger
function Get-ServiceInfo {
    Get-Service | Out-File ".\Logs\ServiceInfo.txt"
}

$trigger = New-JobTrigger -Weekly -DaysOfWeek Monday -At 6am

Register-ScheduledJob -Name "WeeklyServiceInfo" -ScriptBlock ${function:Get-ServiceInfo} -Trigger $trigger


# Scheduled job using a script block and an interval trigger
$scriptBlock = {
    Get-Date | Out-File ".\Logs\DateTime.txt" -Append
}

$trigger = New-JobTrigger -Once -At (Get-Date).Date -RepetitionInterval (New-TimeSpan -Minutes 5) -RepeatIndefinitely

Register-ScheduledJob -Name "DateTimeEvery5Min" -ScriptBlock $scriptBlock -Trigger $trigger


# Get and Interact with the Scheduled Job
$scriptBlock = {
    Get-Date | Out-File "C:\Course\Logs\DateTime-Minute.txt" -Append
}

$trigger = New-JobTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 1) -RepeatIndefinitely

Register-ScheduledJob -Name "DateTimeEveryMinute" -ScriptBlock $scriptBlock -Trigger $trigger

# Get the job
$job = Get-ScheduledJob -Name "DateTimeEveryMinute"

# Check the status of the most recent job instance
$job | Get-Job | Select-Object -Last 1 | Format-List State

# Get the results of the most recent job instance
$job | Get-Job | Select-Object -Last 1 | Receive-Job





# Create a scheduled task to run a script every day at 9:00 AM
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument ".\Scripts\Script.ps1"
$Trigger = New-ScheduledTaskTrigger -Daily -At 9:00AM
$Settings = New-ScheduledTaskSettingsSet
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
Register-ScheduledTask -TaskName "MyScheduledTask1" -InputObject $Task -User "TRAINING\Administrator" -Password "Pass@word1"



# Create a scheduled task to run a command every week on Sunday at 5:00 PM
$Action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c ipconfig /all > C:\Course\Logs\ipconfig.txt"
$Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 5:00PM
$Settings = New-ScheduledTaskSettingsSet
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
Register-ScheduledTask -TaskName "MyScheduledTask2" -InputObject $Task -User "TRAINING\Administrator" -Password "Pass@word1"



# Scenario: An IT administrator Job
## - Run a PowerShell script every night at midnight
## - Collect event log information from multiple servers
## - Save the output to a CSV file
## - The script needs to run under a service account
## - Email the CSV file to a specified email address at completion

# Set the name of the service account to run the task under
$ServiceAccount = "TRAINING\Administrator"

# Set the path to the PowerShell script
$ScriptPath = ".\Scripts\CollectEventLog.ps1"

# Set the path to save the CSV file
$CSVPath = ".\Logs\EventLogs.csv"

# Set the email address to send the CSV file to
$EmailAddress = "user@example.com"

# Create the scheduled task action
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File $ScriptPath"

# Create the scheduled task trigger
$Trigger = New-ScheduledTaskTrigger -Daily -At 12:00AM

# Create the scheduled task settings
$Settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable

# Create the scheduled task principal
$Principal = New-ScheduledTaskPrincipal -UserID $ServiceAccount -LogonType ServiceAccount -RunLevel Highest

# Create the scheduled task
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings -Principal $Principal

# Register the scheduled task
Register-ScheduledTask -TaskName "CollectEventLog" -InputObject $Task

# Set the email parameters
$SMTPServer = "smtp.example.com"
$SMTPPort = 587
$SMTPUser = "user@example.com"
$SMTPPassword = "password"
$EmailSubject = "Event Log Collection Results"
$EmailBody = "Please find attached the CSV file with the collected event log information."

# Wait for the task to complete
Start-Sleep -Seconds 60

# Send the email with the CSV file attached
Send-MailMessage -To $EmailAddress -From $SMTPUser -Subject $EmailSubject -Body $EmailBody -Attachments $CSVPath -SmtpServer $SMTPServer -Port $SMTPPort -Credential (New-Object System.Management.Automation.PSCredential $SMTPUser, (ConvertTo-SecureString $SMTPPassword -AsPlainText -Force))

