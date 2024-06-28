# Chemin du fichier de log
$logFilePath = "C:\Windows\System32\LogFiles\log_evt.log"

# Fonction de journalisation
function Write-Log {
    param (
        [string]$event
    )
    $dateTime = Get-Date -Format "yyyyMMdd-HHmmss"
    $user = $env:USERNAME
    $logEntry = "$dateTime-$user-$event"
    Add-Content -Path $logFilePath -Value $logEntry
}

# Fonction pour afficher le menu principal
function Show-Menu {
    Write-Host "1. Gérer les utilisateurs de DESKTOP-AB29COR"
    Write-Host "2. Gérer les ordinateurs"
    Write-Host "3. Quitter"
}

# Fonction pour gérer les utilisateurs de DESKTOP-AB29COR
function Manage-Users {
    Write-Host "1. Créer un compte utilisateur"
    Write-Host "2. Supprimer un compte utilisateur"
    Write-Host "3. Retour au menu principal"
    $choice = Read-Host "Choisissez une option"
    switch ($choice) {
        1 {
            $username = Read-Host "Entrez le nom d'utilisateur"
            $password = Read-Host "Entrez le mot de passe"
            $command = "New-LocalUser -Name $username -Password (ConvertTo-SecureString '$password' -AsPlainText -Force)"
            $session = New-PSSession -ComputerName "DESKTOP-AB29COR" -Authentication Kerberos -Credential (Get-Credential)
            Invoke-Command -Session $session -ScriptBlock { param($command) Invoke-Expression $command } -ArgumentList $command
            Write-Log "Création de l'utilisateur $username sur DESKTOP-AB29COR"
            Remove-PSSession -Session $session
        }
        2 {
            $username = Read-Host "Entrez le nom d'utilisateur"
            $command = "Remove-LocalUser -Name $username"
            $session = New-PSSession -ComputerName "DESKTOP-AB29COR" -Authentication Kerberos -Credential (Get-Credential)
            Invoke-Command -Session $session -ScriptBlock { param($command) Invoke-Expression $command } -ArgumentList $command
            Write-Log "Suppression de l'utilisateur $username sur DESKTOP-AB29COR"
            Remove-PSSession -Session $session
        }
        3 {
            return
        }
    }
}

# Fonction pour gérer les ordinateurs
function Manage-Computers {
    Write-Host "1. Arrêter l'ordinateur"
    Write-Host "2. Redémarrer l'ordinateur"
    Write-Host "3. Retour au menu principal"
    $choice = Read-Host "Choisissez une option"
    switch ($choice) {
        1 {
            $computerName = Read-Host "Entrez le nom complet ou l'adresse IP de l'ordinateur"
            $command = "Stop-Computer -ComputerName $computerName -Force"
            Invoke-Command -ComputerName $computerName -ScriptBlock { Stop-Computer -Force } -Authentication Kerberos -Credential (Get-Credential)
            Write-Log "Arrêt de l'ordinateur $computerName"
        }
        2 {
            $computerName = Read-Host "Entrez le nom complet ou l'adresse IP de l'ordinateur"
            $command = "Restart-Computer -ComputerName $computerName -Force"
            Invoke-Command -ComputerName $computerName -ScriptBlock { Restart-Computer -Force } -Authentication Kerberos -Credential (Get-Credential)
            Write-Log "Redémarrage de l'ordinateur $computerName"
        }
        3 {
            return
        }
    }
}

# Fonction principale
function Main {
    Write-Log "********StartScript********"
    while ($true) {
        Show-Menu
        $choice = Read-Host "Choisissez une option"
        switch ($choice) {
            1 { Manage-Users }
            2 { Manage-Computers }
            3 { 
                Write-Log "*********EndScript*********"
                exit 
            }
        }
    }
}

# Exécution du script principa
