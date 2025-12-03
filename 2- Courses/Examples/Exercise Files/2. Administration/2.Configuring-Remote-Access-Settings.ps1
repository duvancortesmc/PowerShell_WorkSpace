Enable-PSRemoting -Force

# Create a new PowerShell module directory
New-Item -Path ".\Delegated\JEABlocking" -ItemType Directory -Force

# Create a role capabilities directory
New-Item -Path ".\Delegated\JEABlocking\RoleCapabilities" -ItemType Directory -Force

# Create a new role capability file
New-PSRoleCapabilityFile `
    -Path ".\Delegated\JEABlocking\RoleCapabilities\Capability.psrc" `
    -VisibleCmdlets @('Get-Service', 'Get-Process')

# Create a session configuration file
New-PSSessionConfigurationFile `
    -Path ".\Delegated\JEABlocking\JEABlocking.pssc" `
    -SessionType RestrictedRemoteServer `
    -RunAsVirtualAccount `
    -RoleDefinitions @{
        "TRAINING\DelegatedAdminGroup" = @{ RoleCapabilities = 'Capability' }
}

# Register the JEA configuration
Register-PSSessionConfiguration -Name "JEABlocking" -Path ".\Delegated\JEABlocking\JEABlocking.pssc" -Force

# Create a new module manifest
New-ModuleManifest `
    -Path ".\Delegated\JEABlocking\JEABlocking.psd1" `
    -RootModule JEABlocking `
    -RequiredAssemblies JEABlocking `
    -NestedModules JEABlocking `
    -CmdletsToExport @('Get-Service', 'Get-Process')

# Create a PS Session using the JEA configuration
$credentials = Get-Credential
Enter-PSSession -ComputerName localhost -ConfigurationName "JEABlocking" -Credential $credentials







# Undo Changes
# Unregister the JEA configuration
Unregister-PSSessionConfiguration -Name "JEABlocking" -Force

# Remove the module manifest file
Remove-Item -Path ".\Delegated\JEABlocking\JEABlocking.psd1" -Force

# Remove the module directory
Remove-Item -Path ".\Delegated\JEABlocking" -Recurse -Force

# Remove the role capabilities directory
Remove-Item -Path ".\Delegated\JEABlocking\RoleCapabilities" -Recurse -Force

# Remove the role capability file
Remove-Item -Path ".\Delegated\JEABlocking\RoleCapabilities\Capability.psrc" -Force

# Remove the session configuration file
Remove-Item -Path ".\JEABlocking.pssc" -Force