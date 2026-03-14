param(
    [string]$OutputFile = "recon_output.txt"
)

function Write-Section {
    param($title)
    $line = "================ $title ================"
    Write-Host "`n$line" -ForegroundColor Cyan
    Add-Content -Path $OutputFile -Value "`n$line"
}

function Run-Command {
    param($command)

    try {
        $result = Invoke-Expression $command
        $result | Out-String | Tee-Object -FilePath $OutputFile -Append
    }
    catch {
        Write-Host "Error running $command"
    }
}

Clear-Content $OutputFile -ErrorAction SilentlyContinue

Write-Section "SYSTEM INFORMATION"
Run-Command "systeminfo"

Write-Section "CURRENT USER"
Run-Command "whoami"

Write-Section "USER PRIVILEGES"
Run-Command "whoami /priv"

Write-Section "LOGGED USERS"
Run-Command "query user"

Write-Section "LOCAL USERS"
Run-Command "Get-LocalUser"

Write-Section "LOCAL GROUPS"
Run-Command "Get-LocalGroup"

Write-Section "ADMINISTRATOR MEMBERS"
Run-Command "Get-LocalGroupMember Administrators"

Write-Section "NETWORK CONFIGURATION"
Run-Command "ipconfig /all"

Write-Section "ROUTING TABLE"
Run-Command "route print"

Write-Section "OPEN PORTS"
Run-Command "netstat -ano"

Write-Section "RUNNING PROCESSES"
Run-Command "Get-Process | Select Name,Id,Path"

Write-Section "RUNNING SERVICES"
Run-Command "Get-Service | Where-Object Status -eq 'Running'"

Write-Section "SCHEDULED TASKS"
Run-Command "schtasks /query /fo LIST /v"

Write-Section "STARTUP PROGRAMS"
Run-Command "Get-CimInstance Win32_StartupCommand"

Write-Section "INSTALLED SOFTWARE"
Run-Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select DisplayName,DisplayVersion"

Write-Section "FIREWALL STATUS"
Run-Command "Get-NetFirewallProfile"

Write-Section "WINDOWS DEFENDER STATUS"
Run-Command "Get-MpComputerStatus"

Write-Section "SHARED FOLDERS"
Run-Command "Get-SmbShare"

Write-Section "PATCHES / HOTFIXES"
Run-Command "Get-HotFix"

Write-Section "SAVED CREDENTIALS"
Run-Command "cmdkey /list"

Write-Section "DOMAIN INFORMATION"
Run-Command "Get-WmiObject Win32_ComputerSystem | Select Domain,PartOfDomain"

Write-Section "DOMAIN CONTROLLERS"
Run-Command "nltest /dclist:"

Write-Host "`nEnumeration complete. Results saved to $OutputFile"