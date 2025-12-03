## Server Monitoring
# Get system performance information
Get-Counter -Counter "\Processor(_Total)\% Processor Time", "\Memory\Available MBytes", "\LogicalDisk(_Total)\% Free Space"


## Windows Updates and Patch Management
# Install available Windows updates
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot


## Backup and Restore
# Create a backup of a specific folder
Backup-File -Path "C:\ImportantData" -Destination "C:\Backups\ImportantDataBackup"


## Installing and Configuring Roles and Features
# Install the Web Server (IIS) role
Install-WindowsFeature -Name Web-Server -IncludeManagementTools


## Managing and Configuring Storage
# Create a new partition on Disk 1
New-Partition -DiskNumber 1 -UseMaximumSize -AssignDriveLetter


## Network Configuration
# Set a static IP address
New-NetIPAddress -InterfaceIndex 2 -IPAddress "192.168.1.100" -PrefixLength 24 -DefaultGateway "192.168.1.1"


## Security Management
# Enable the Windows Firewall for the domain profile
Set-NetFirewallProfile -Profile Domain -Enabled True


## Remote Desktop Services (RDS) Management
# Enable Remote Desktop
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0


## Troubleshooting and Problem Resolution
# Review the System event log for errors
Get-WinEvent -LogName System -MaxEvents 100 | Where-Object { $_.LevelDisplayName -eq 'Error' }

$results = Invoke-Command -Session $Session -ScriptBlock { Get-WinEvent -LogName System -MaxEvents 100 }
$results | Out-File -FilePath "C:\Course\Remote-and-Delegated-Administration\System.log"
