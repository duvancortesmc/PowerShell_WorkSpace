# Connect to a remote Windows Server
$RemoteServer = "server.training.int"
$Credential = Get-Credential

$Session = New-PSSession -ComputerName $RemoteServer -Credential $Credential

# Perform multiple tasks on the remote server

# Task 1: Install a Windows feature (Web Server Role)
Invoke-Command -Session $Session -ScriptBlock {
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
}

# Task 2: Create a new local user
Invoke-Command -Session $Session -ScriptBlock {
    $LocalUser = New-LocalUser -Name "NewUser" -Password (ConvertTo-SecureString "Password123!" -AsPlainText -Force) -FullName "New User" -Description "New local user account"
    Add-LocalGroupMember -Group "Users" -Member $LocalUser
}

# Task 3: Set a static IP address
Invoke-Command -Session $Session -ScriptBlock {
    $Interface = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
    #New-NetIPAddress -InterfaceIndex $Interface.ifIndex -IPAddress "192.168.1.10" -PrefixLength 24 -DefaultGateway "192.168.1.1"
    #Set-DnsClientServerAddress -InterfaceIndex $Interface.ifIndex -ServerAddresses ("192.168.1.1", "8.8.8.8")
    Write-Host $Interface
}

# Task 4: Configure Windows Firewall to allow Remote Desktop Protocol (RDP)
Invoke-Command -Session $Session -ScriptBlock {
    Set-NetFirewallRule -Name "RemoteDesktop-UserMode-In-TCP" -Enabled True -Profile Any
}

# Task 5: Restart the server
Invoke-Command -Session $Session -ScriptBlock {
    Restart-Computer -Force
}

# Close the remote session
Remove-PSSession -Session $Session


Get-PSSession
