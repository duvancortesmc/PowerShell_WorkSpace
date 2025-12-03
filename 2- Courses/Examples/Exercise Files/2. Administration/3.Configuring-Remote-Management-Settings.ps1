# Windows 11
Enable-PSRemoting -Force
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP" -RemoteAddress Any

Add-WindowsCapability -Online -Name "OpenSSH.Client~~~~0.0.1.0"

# Ubuntu
$Username = "trainer"
$UbuntuIPAddress = "192.168.127.147"

# Install PowerShell
ssh $Username@$UbuntuIPAddress "wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb; sudo dpkg -i packages-microsoft-prod.deb; sudo apt-get update; sudo add-apt-repository universe; sudo apt-get install -y powershell"

# Install OpenSSH Server
ssh $Username@$UbuntuIPAddress "sudo apt-get install -y openssh-server"

# Enable and start the SSH service
ssh $Username@$UbuntuIPAddress "sudo systemctl enable ssh; sudo systemctl start ssh"







# Remoting from Windows 11 to Ubuntu
$Username = "trainer"
$UbuntuIPAddress = "192.168.127.147"
$SecurePassword = ConvertTo-SecureString "Pass@word1" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

Enter-PSSession -HostName $UbuntuIPAddress -UserName $Username


