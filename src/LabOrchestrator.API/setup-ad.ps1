param(
    [string]$DomainName = "corp.local",
    [string]$NetBiosName = "CORP",
    [string]$AdminPass = "Admin123!",
    [string]$UsersCount = "10",
    [string]$Kerberoast = "$false",
    [string]$AsRep = "$false",
    [string]$InstallADCS = "$false"
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   KONFIGURACJA KONTROLERA DOMENY (AD)    " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$SafeModePassword = ConvertTo-SecureString $AdminPass -AsPlainText -Force

# 1. Instalacja Roli (To dziala normalnie)
Write-Host "[*] Pobieranie i instalowanie roli AD DS..." -ForegroundColor Yellow
Set-LocalUser -Name "Administrator" -Password $SafeModePassword
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools | Out-Null

# 2. Hakerski trick: Promowanie w tle jako SYSTEM
Write-Host "[*] Zlecam promowanie serwera w tle (Obejscie bledu zerwania WinRM)..." -ForegroundColor Yellow

$scriptPath = "$env:TEMP\promote.ps1"
$psCommand = "Start-Sleep -Seconds 60; Install-ADDSForest -DomainName '$DomainName' -DomainNetbiosName '$NetBiosName' -SafeModeAdministratorPassword (ConvertTo-SecureString '$AdminPass' -AsPlainText -Force) -InstallDns:`$true -Force:`$true -NoRebootOnCompletion:`$false"
Set-Content -Path $scriptPath -Value $psCommand

# Tworzymy i natychmiast odpalamy zadanie w tle, po czym zamykamy ten skrypt!
$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File $scriptPath"
Register-ScheduledTask -TaskName "AD-Promotion" -Action $Action -User "NT AUTHORITY\SYSTEM" -RunLevel Highest -Force | Out-Null
Start-ScheduledTask -TaskName "AD-Promotion"

Write-Host "[+] SUKCES! Instalacja rusza w tle. Serwer za kilka minut zrestartuje sie sam." -ForegroundColor Green
Write-Host "[*] Oddaje kontrole Vagrantowi bez bledu!" -ForegroundColor Cyan