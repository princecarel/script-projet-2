# Activer PowerShell Remoting
Enable-PSRemoting -Force

# Assurez-vous que le service WinRM est en cours d'exécution
Start-Service WinRM
Set-Service -Name WinRM -StartupType Automatic

# Ajouter une règle de pare-feu pour autoriser les connexions WinRM
New-NetFirewallRule -Name "WinRM-HTTP" -DisplayName "WinRM over HTTP" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 5985

# Fonction pour gérer les utilisateurs sur Machine 2
function Manage-Users-Machine2 {
    param (
        [string]$Action
    )
    $username = Read-Host "Entrez le nom d'utilisateur"
    $password = Read-Host "Entrez le mot de passe" -AsSecureString

    if ($Action -eq "Create") {
        $command = {
            param ($username, $password)
            New-LocalUser -Name $username -Password $password
        }
    } elseif ($Action -eq "Remove") {
        $command = {
            param ($username)
            Remove-LocalUser -Name $username
        }
    }

    Invoke-Command -Session $sessionToMachine2 -ScriptBlock $command -ArgumentList $username, $password
}

# Créer une nouvelle session PowerShell à distance vers Machine 2
$sessionToMachine2 = New-PSSession -ComputerName DESKTOP-AB29COR -Credential (Get-Credential -UserName "wilder")

# Exécuter des commandes à distance sur Machine 2
$result1 = Invoke-Command -ScriptBlock { hostname; whoami } -Session $sessionToMachine2
$result1

# Gérer les utilisateurs sur Machine 2
Write-Host "1. Créer un utilisateur"
Write-Host "2. Supprimer un utilisateur"
$userAction = Read-Host "Choisissez une option"

switch ($userAction) {
    1 { Manage-Users-Machine2 "Create" }
    2 { Manage-Users-Machine2 "Remove" }
}

# Fermer la session PowerShell
Remove-PSSession -Session $sessionToMachine2
