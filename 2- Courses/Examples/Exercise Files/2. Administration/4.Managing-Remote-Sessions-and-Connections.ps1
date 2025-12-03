# Introduction to Managing Remote Sessions and Connections in PowerShell

# 1. Create a PSSession to a remote computer
$credentials = Get-Credential
$RemoteComputer = "server.training.int"
$Session = New-PSSession -ComputerName $RemoteComputer -Credential $credentials

# 2. Execute a command on the remote computer using Invoke-Command
Invoke-Command -Session $Session -ScriptBlock { Get-Service }

# 3. Run multiple commands on the remote computer using a single script block
Invoke-Command -Session $Session -ScriptBlock {
    $OS = Get-WmiObject -Class Win32_OperatingSystem
    $SystemInfo = Get-WmiObject -Class Win32_ComputerSystem
    [PSCustomObject]@{
        "OperatingSystem" = $OS.Caption
        "Manufacturer" = $SystemInfo.Manufacturer
        "Model" = $SystemInfo.Model
    }
}

# 4. Import commands from a remote session to the local session
Import-PSSession -Session $Session -Module ActiveDirectory

# 5. Execute a command on multiple remote computers
$RemoteComputers = "RemotePC1", "RemotePC2", "RemotePC3"
Invoke-Command -ComputerName $RemoteComputers -ScriptBlock { Get-Process }

# 6. Establish a remote session with a Linux machine using SSH
$LinuxUsername = "your_username"
$LinuxHostname = "your_linux_hostname_or_ip"
$SecurePassword = ConvertTo-SecureString "your_password" -AsPlainText -Force
$LinuxCredential = New-Object System.Management.Automation.PSCredential ($LinuxUsername, $SecurePassword)

Enter-PSSession -HostName $LinuxHostname -UserName $LinuxUsername -Credential $LinuxCredential

# 7. Close a remote session
Remove-PSSession -Session $Session
