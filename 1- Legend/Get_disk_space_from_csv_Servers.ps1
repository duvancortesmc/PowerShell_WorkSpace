# Disk Space Inventory Script
# Gets all disk information from servers including name, total space, and free space

# Define paths
$inputFile = "G:\SQL_Backup\Servers.csv"
$outputFolder = "G:\SQL_Backup\results"
$outputFile = "$outputFolder\Disk_Space_Report_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

# Create output folder if it doesn't exist
if (-not (Test-Path $outputFolder)) {
    New-Item -Path $outputFolder -ItemType Directory -Force | Out-Null
    Write-Host "Created output folder: $outputFolder" -ForegroundColor Green
}

# Verify input file exists
if (-not (Test-Path $inputFile)) {
    Write-Host "ERROR: Input file not found: $inputFile" -ForegroundColor Red
    exit
}

# Initialize results array
$results = @()

# Read server list from CSV
Write-Host "Reading servers from: $inputFile" -ForegroundColor Green
$serverData = Import-Csv -Path $inputFile

# Verify ServerName column exists
if (-not ($serverData[0].PSObject.Properties.Name -contains "ServerName")) {
    Write-Host "ERROR: 'ServerName' column not found in CSV file" -ForegroundColor Red
    exit
}

Write-Host "Total servers to process: $($serverData.Count)" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Green

foreach ($serverRow in $serverData) {
    $serverName = $serverRow.ServerName.Trim()
    
    if ([string]::IsNullOrWhiteSpace($serverName)) {
        continue
    }
    
    Write-Host "Processing server: $serverName" -ForegroundColor Cyan
    
    try {
        # Test connection first
        if (Test-Connection -ComputerName $serverName -Count 1 -Quiet) {
            
            # Get all disk information using WMI
            $disks = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $serverName -Filter "DriveType=3" -ErrorAction Stop
            
            if ($disks) {
                foreach ($disk in $disks) {
                    # Get volume label (disk name)
                    $diskLabel = $disk.VolumeName
                    $driveLetter = $disk.DeviceID
                    
                    # Format disk name as "Label (Letter)" or just "Letter" if no label
                    if ([string]::IsNullOrWhiteSpace($diskLabel)) {
                        $diskName = $driveLetter
                    } else {
                        $diskName = "$diskLabel ($driveLetter)"
                    }
                    
                    # Convert bytes to GB (rounded to 2 decimals)
                    $totalGB = [math]::Round($disk.Size / 1GB, 2)
                    $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
                    
                    Write-Host "  Disk: $diskName - Total: $totalGB GB, Free: $freeGB GB" -ForegroundColor Green
                    
                    # Add to results
                    $result = [PSCustomObject]@{
                        ServerName = $serverName
                        DiskName = $diskName
                        TotalDisk = $totalGB
                        FreeSpace = $freeGB
                    }
                    
                    $results += $result
                }
            } else {
                Write-Host "  No fixed disks found" -ForegroundColor Yellow
                
                $result = [PSCustomObject]@{
                    ServerName = $serverName
                    DiskName = "N/A"
                    TotalDisk = 0
                    FreeSpace = 0
                }
                $results += $result
            }
            
        } else {
            Write-Host "  Server not reachable (ping failed)" -ForegroundColor Red
            
            $result = [PSCustomObject]@{
                ServerName = $serverName
                DiskName = "Server Unreachable"
                TotalDisk = 0
                FreeSpace = 0
            }
            $results += $result
        }
        
    } catch {
        Write-Host "  Error accessing server: $($_.Exception.Message)" -ForegroundColor Red
        
        $result = [PSCustomObject]@{
            ServerName = $serverName
            DiskName = "Error: $($_.Exception.Message)"
            TotalDisk = 0
            FreeSpace = 0
        }
        $results += $result
    }
    
    Write-Host ""
}

# Export results to CSV
Write-Host "========================================" -ForegroundColor Green
Write-Host "Exporting results to CSV..." -ForegroundColor Green
$results | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Host "Report saved to: $outputFile" -ForegroundColor Green
Write-Host "Total records: $($results.Count)" -ForegroundColor Yellow

# Display summary
$successCount = ($results | Where-Object { $_.TotalDisk -gt 0 }).Count
$errorCount = ($results | Where-Object { $_.TotalDisk -eq 0 }).Count
$totalSpace = ($results | Where-Object { $_.TotalDisk -gt 0 } | Measure-Object -Property TotalDisk -Sum).Sum
$totalFree = ($results | Where-Object { $_.FreeSpace -gt 0 } | Measure-Object -Property FreeSpace -Sum).Sum

Write-Host "`nSummary:" -ForegroundColor Cyan
Write-Host "  Successful disk queries: $successCount" -ForegroundColor Green
Write-Host "  Failed queries: $errorCount" -ForegroundColor Red
Write-Host "  Total disk space: $([math]::Round($totalSpace, 2)) GB" -ForegroundColor Yellow
Write-Host "  Total free space: $([math]::Round($totalFree, 2)) GB" -ForegroundColor Yellow
Write-Host "  Total used space: $([math]::Round($totalSpace - $totalFree, 2)) GB" -ForegroundColor Yellow

if ($totalSpace -gt 0) {
    $usedPercent = [math]::Round((($totalSpace - $totalFree) / $totalSpace) * 100, 2)
    Write-Host "  Overall usage: $usedPercent%" -ForegroundColor Yellow
}

Write-Host "========================================" -ForegroundColor Green

# Display first 15 results as preview
if ($results.Count -gt 0) {
    Write-Host "`nPreview of results (first 15 rows):" -ForegroundColor Cyan
    $results | Select-Object -First 15 | Format-Table -AutoSize
}