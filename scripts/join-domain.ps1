param(
    [string]$TargetHostname = "WS-Guest",
    [string]$EnableDefender = "$true",
    [string]$InstallSysmon = "$false"
)

$DomainName = "corplab.local"
$DC_IP = "192.168.50.10"
$AdminUser = "Administrator"
$AdminPass = "P@ssw0rd_Admin_123!"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   KONFIGURACJA STACJI ROBOCZEJ (CLIENT)  " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

if ($EnableDefender -eq "$false" -or $EnableDefender -eq "False") {
    Write-Host "[*] RED TEAM MODE: Wylaczam Windows Defender..." -ForegroundColor Yellow
    Set-MpPreference -DisableRealtimeMonitoring $true
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1 -PropertyType DWORD -Force -ErrorAction SilentlyContinue | Out-Null
} else {
    Write-Host "[*] BLUE TEAM MODE: Windows Defender pozostaje wlaczony." -ForegroundColor Green
}

Write-Host "[*] Konfiguruje routing DNS na karcie LAN..." -ForegroundColor Cyan
$LanAdapter = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like "192.168.50.*" }

if ($LanAdapter) {
    Set-DnsClientServerAddress -InterfaceIndex $LanAdapter.InterfaceIndex -ServerAddresses $DC_IP
    Set-NetIPInterface -InterfaceIndex $LanAdapter.InterfaceIndex -InterfaceMetric 10
    Clear-DnsClientCache
} else {
    Write-Error "[!] Krytyczny blad: Nie znaleziono karty sieciowej z IP 192.168.50.X"
    exit
}

Write-Host "[*] Szukam Kontrolera Domeny ($DomainName)..." -ForegroundColor Cyan
$MaxRetries = 240
$RetryCount = 0
$DomainReady = $false

while ($RetryCount -lt $MaxRetries -and -not $DomainReady) {
    try {
        $DnsCheck = Resolve-DnsName -Name $DomainName -Server $DC_IP -ErrorAction Stop
        if ($DnsCheck) {
            $DomainReady = $true
            Write-Host "[+] Sukces! Serwer zyje i poprawnie rozwiazuje nazwe domeny." -ForegroundColor Green
        }
    } catch {
        Write-Host "[-] Serwer mieli instalacje AD. Czekam 15s... (Proba: $RetryCount / $MaxRetries)" -ForegroundColor Yellow
        Start-Sleep -Seconds 15
        $RetryCount++
    }
}

if (-not $DomainReady) {
    Write-Error "[!] KRYTYCZNY BLAD: Domena nie odpowiedziala w oczekiwanym czasie."
    exit
}

Start-Sleep -Seconds 30

Write-Host "[*] Kontroler gotowy. Dolaczam stacje do domeny $DomainName..." -ForegroundColor Cyan
$secpasswd = ConvertTo-SecureString $AdminPass -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("$DomainName\$AdminUser", $secpasswd)

try {
    Add-Computer -DomainName $DomainName -NewName $TargetHostname -Credential $mycreds -Force
    Write-Host "[+] DOLACZONO DO DOMENY I ZMIENIONO NAZWE! System zrestartuje sie w tle za 15 sekund..." -ForegroundColor Green
    Start-Process "shutdown.exe" -ArgumentList "/r /t 15" -WindowStyle Hidden
} catch {
    Write-Error "[-] Nie udalo sie dodac maszyny do domeny."
    Write-Error $_.Exception.Message
}