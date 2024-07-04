# Activer PowerShell Remoting
Enable-PSRemoting -Force

# Assurez-vous que le service WinRM est en cours d'exécution
Start-Service WinRM
Set-Service -Name WinRM -StartupType Automatic

# Ajouter une règle de pare-feu pour autoriser les connexions WinRM
New-NetFirewallRule -Name "WinRM-HTTP" -DisplayName "WinRM over HTTP" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 5985

# Fonction pour gérer les utilisateurs sur Machine 1
function Manage-Users-Machine1 {
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
    } elseif ($Action -eq "ShowAll") {
        $command = {
            Get-LocalUser
        }
    }

    Invoke-Command -Session $sessionToMachine1 -ScriptBlock $command -ArgumentList $username, $password
}

# Créer une nouvelle session PowerShell à distance vers Machine 1
$sessionToMachine1 = New-PSSession -ComputerName WINSERV -Credential (Get-Credential -UserName "Administrator")

# Exécuter des commandes à distance sur Machine 1
$result2 = Invoke-Command -ScriptBlock { hostname; whoami } -Session $sessionToMachine1
$result2

# Menu pour gérer les utilisateurs sur Machine 1
$continue = $true
while ($continue) {
    Write-Host "`nMenu de gestion des utilisateurs sur Machine 1:`n"
    Write-Host "1. Créer un utilisateur"
    Write-Host "2. Supprimer un utilisateur"
    Write-Host "3. Afficher tous les utilisateurs"
    Write-Host "4. Quitter"

    $userAction = Read-Host "Choisissez une option"

    switch ($userAction) {
        1 { Manage-Users-Machine1 "Create" }
        2 { Manage-Users-Machine1 "Remove" }
        3 { Manage-Users-Machine1 "ShowAll" }
        4 { $continue = $false }
        default { Write-Host "Option invalide. Veuillez choisir une option valide." }
    }
}

# Fermer la session PowerShell
Remove-PSSession -Session $sessionToMachine1
