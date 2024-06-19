# Fonction pour ajouter un utilisateur
function Add-User {
    param (
        [string]$username,
        [string]$password,
        [string]$computerName
    )

    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force

    $scriptBlock = {
        param ($username, $securePassword)
        New-LocalUser -Name $username -Password $securePassword -FullName $username -Description "User added by script"
        Add-LocalGroupMember -Group "Users" -Member $username
        Write-Host "Utilisateur $username ajouté avec succès."
    }

    Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock -ArgumentList $username, $securePassword
}

# Fonction pour supprimer un utilisateur
function Remove-User {
    param (
        [string]$username,
        [string]$computerName
    )

    $scriptBlock = {
        param ($username)
        Remove-LocalUser -Name $username
        Write-Host "Utilisateur $username supprimé avec succès."
    }

    Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock -ArgumentList $username
}

# Fonction pour lister les utilisateurs
function List-Users {
    param (
        [string]$computerName
    )

    $scriptBlock = {
        Get-LocalUser | Select-Object Name, Enabled, LastLogon
    }

    Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock
}

# Menu principal
while ($true) {
    Write-Host "Choisissez une action:"
    Write-Host "1. Ajouter un utilisateur"
    Write-Host "2. Supprimer un utilisateur"
    Write-Host "3. Voir tous les utilisateurs"
    Write-Host "4. Quitter"
    $action = Read-Host "Entrez votre choix (1, 2, 3 ou 4)"
    
    if ($action -eq "4") {
        Write-Host "Au revoir!"
        break
    }

    $computerName = Read-Host "Entrez le nom ou l'adresse IP de l'ordinateur distant"

    if ($action -eq "1") {
        $username = Read-Host "Entrez le nom de l'utilisateur à ajouter"
        $password = Read-Host "Entrez le mot de passe pour l'utilisateur"
        Add-User -username $username -password $password -computerName $computerName
    } elseif ($action -eq "2") {
        $username = Read-Host "Entrez le nom de l'utilisateur à supprimer"
        Remove-User -username $username -computerName $computerName
    } elseif ($action -eq "3") {
        List-Users -computerName $computerName
    } else {
        Write-Host "Choix invalide. Veuillez exécuter le script à nouveau et choisir 1, 2, 3 ou 4."
    }
}


