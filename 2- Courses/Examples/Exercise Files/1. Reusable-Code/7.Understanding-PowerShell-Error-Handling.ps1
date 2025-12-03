####################
## Error Handling ##
####################

# Get-Process command with Try/Catch block
Try {
    # Attempt to retrieve a list of processes
    $processes = Get-Process -Name "SomeProcessThatDoesNotExist"
    Write-Host $processes
} Catch {
    # Handle the error
    Write-Error "An error occurred: $($_.Exception.Message)"
}


# Get-Service command with ErrorAction parameter
$services = Get-Service -Name "SomeServiceThatDoesNotExist" -ErrorAction SilentlyContinue
if (!$services) {
    Write-Host "An error occurred: The service 'SomeServiceThatDoesNotExist' could not be found." -ForegroundColor Red
}


# Get-CimInstance command with Throw statement and Finally block
Try {
    $instance = Get-CimInstance -ClassName "Win32_Processor" -ComputerName "NonexistentComputer"
    if (!$instance) {
        Throw "An error occurred: The Win32_Processor instance could not be retrieved."
    }
} Catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
} Finally {
    Write-Host "Finished executing the command." -ForegroundColor Green
}


# Retrieving data from an API with Invoke-RestMethod
$apiurl = "https://swapi.dev/api/films"
Try {
    $data = Invoke-RestMethod -Uri $apiurl -Method Get -ErrorAction Stop
    Write-Host "The titles of the Star Wars films are:"
    $data.results.title | ForEach-Object { Write-Host $_ }
} Catch {
    If ($_.Exception.Response.StatusCode.value__ -eq 401) {
        Write-Error "An error occurred while retrieving data from the SWAPI: Unauthorized access."
    } ElseIf ($_.Exception.Response.StatusCode.value__ -eq 404) {
        Write-Error "An error occurred while retrieving data from the SWAPI: Resource not found."
    } Else {
        Write-Error "An unknown error occurred while retrieving data from the SWAPI: $($_.Exception.Message)"
    }
}


# Retrieving data from an API with Invoke-RestMethod (Fails)
$apiurl = "https://swapi.dev/api/filmsxyz"
Try {
    $data = Invoke-RestMethod -Uri $apiurl -Method Get -ErrorAction Stop
    Write-Host "The titles of the Star Wars films are:"
    $data.results.title | ForEach-Object { Write-Host $_ }
} Catch {
    If ($_.Exception.Response.StatusCode.value__ -eq 401) {
        Write-Error "An error occurred while retrieving data from the SWAPI: Unauthorized access."
    } ElseIf ($_.Exception.Response.StatusCode.value__ -eq 404) {
        Write-Error "An error occurred while retrieving data from the SWAPI: Resource not found."
    } Else {
        Write-Error "An unknown error occurred while retrieving data from the SWAPI: $($_.Exception.Message)"
    }
}


# Run script to connect to a network device and retrieve information (Fails)
Try {
    $result = Invoke-Command -ComputerName Device1 -ScriptBlock { Get-NetAdapter }
    Write-Host $result
} Catch {
    Write-Host "An error occurred: $($Error[0].Exception.Message)" -ForegroundColor Red
    Write-Host "Stack trace: $($Error[0].Exception.StackTrace)" -ForegroundColor Gray
}


# Set ErrorActionPreference, then run script that configures a network device (Fail)
$ErrorActionPreference = 'Stop'

Try {
    Set-NetAdapter -Name Ethernet1 -Speed 1000
    Set-NetIPAddress -IPAddress 192.168.1.100 -InterfaceAlias Ethernet1
    Set-DnsClientServerAddress -InterfaceAlias Ethernet1 -ServerAddresses 8.8.8.8
} Catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
}


# Set ErrorView, then run script that retrieves information from multiple network devices
$ErrorView = 'DetailedView'

$devices = 'Device1', 'Device2', 'Device3'

foreach ($device in $devices) {
    Try {
        $result = Invoke-Command -ComputerName $device -ScriptBlock { Get-NetAdapter }

        Write-Host "Network adapters on $($device):"
        $result | Select-Object Name, InterfaceDescription, Status, IPAddress
    } Catch {
        Write-Error "An error occurred on $($device): $($_.Exception.Message)"
    }
}


# Load ports from a file, then test the local computer, handling all errors
function Test-LocalPorts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$PortListPath
    )
    try {
        $Ports = Import-Csv -Path "./Assets/Port-Assets.json"
    }
    catch {
        Write-Error "Failed to load port list from '$PortListPath'. Error: $_"
        return
    }

    foreach ($Port in $Ports) {
        try {
            $Result = Test-NetConnection -Port $Port -InformationLevel Quiet
            if ($Result.TcpTestSucceeded) {
                Write-Output "Port $($Result.RemotePort) is open."
            }
            else {
                Write-Output "Port $($Result.RemotePort) is closed."
            }
        }
        catch {
            Write-Error "Failed to test port $($Port). Error: $_"
        }
    }
}

# Load ports from a file, then test the local computer, handling all errors - FIXED
function Test-LocalPorts {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$PortListPath
    )
    try {
        $Ports = Get-Content -Path $PortListPath -Raw | ConvertFrom-Json
    }
    catch {
        Write-Error "Failed to load port list from '$PortListPath'. Error: $_"
        return
    }

    foreach ($Port in $Ports) {
        try {
            $Result = Test-NetConnection -Port $Port.Port -InformationLevel Quiet
            if ($Result.TcpTestSucceeded) {
                Write-Output "Port $($Result.RemotePort) is open."
            }
            else {
                Write-Output "Port $($Result.RemotePort) is closed."
            }
        }
        catch {
            Write-Error "Failed to test port $($Port.Port). Error: $_"
        }
    }
}





