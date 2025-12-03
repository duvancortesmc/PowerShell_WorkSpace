# Define the servers to collect the event log information from
$Servers = "Server1", "Server2", "Server3"

# Define the CSV file path
$CSVPath = "C:\Course\Logs\EventLogs.csv"

# Collect the event log information and save it to the CSV file
$Results = foreach ($Server in $Servers) {
    Get-EventLog -LogName System -EntryType Error, Warning -Newest 100 -ComputerName $Server
}

$Results | Export-Csv -Path $CSVPath -NoTypeInformation

# Define the email parameters
$SMTPServer = "smtp.example.com"
$SMTPPort = 587
$SMTPUser = "user@example.com"
$SMTPPassword = "password"
$EmailSubject = "Event Log Collection Results"
$EmailBody = "Please find attached the CSV file with the collected event log information."

# Send the email with the CSV file attached
Send-MailMessage -To $EmailAddress -From $SMTPUser -Subject $EmailSubject -Body $EmailBody -Attachments $CSVPath -SmtpServer $SMTPServer -Port $SMTPPort -Credential (New-Object System.Management.Automation.PSCredential $SMTPUser, (ConvertTo-SecureString $SMTPPassword -AsPlainText -Force))
