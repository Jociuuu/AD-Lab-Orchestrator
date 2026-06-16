Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   Active Directory Data Fuzzer v1.0     " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

Import-Module ActiveDirectory

# Automatycznie pobieramy ścieżkę nowej domeny (np. DC=test1,DC=local)
$DomainDN = (Get-ADDomain).DistinguishedName
$DomainName = (Get-ADDomain).Name

Write-Host "[*] Target Domain: $DomainDN" -ForegroundColor Yellow

# 1. Tworzenie struktury firmy (Organizational Units)
$OUs = @("HR", "IT", "Sales", "Management")
Write-Host "[*] Creating Organizational Units (OUs)..."
foreach ($OU in $OUs) {
    New-ADOrganizationalUnit -Name $OU -Path $DomainDN -ErrorAction SilentlyContinue | Out-Null
}

# 2. Generowanie 50 pracowników
Write-Host "[*] Generating 50 dummy users..."
$Password = ConvertTo-SecureString "CyberTest!2026" -AsPlainText -Force

for ($i=1; $i -le 50; $i++) {
    $UserName = "Employee$i"
    # Rozrzucamy pracowników po równo do różnych działów
    $TargetOU = $OUs[$i % 4] 
    
    New-ADUser -Name $UserName -SamAccountName $UserName -UserPrincipalName "$UserName@$DomainName" -Path "OU=$TargetOU,$DomainDN" -AccountPassword $Password -Enabled $true -ErrorAction SilentlyContinue
}

# 3. RED TEAM BONUS: Konto podatne na atak (AS-REP Roasting)
Write-Host "[*] Creating vulnerable account (AS-REP Roasting target)..." -ForegroundColor Magenta
New-ADUser -Name "Svc_Backup" -SamAccountName "svc_backup" -UserPrincipalName "svc_backup@$DomainName" -Path "OU=IT,$DomainDN" -AccountPassword $Password -Enabled $true -DoesNotRequirePreAuth $true -ErrorAction SilentlyContinue

Write-Host "[+] Fuzzing complete! AD is ready for testing." -ForegroundColor Green