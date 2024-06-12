# Fonction pour ajouter un utilisateur
function Add-User {
    param (
        [string]$username
    )

    $password = Read-Host "Entrez le mot de passe pour l'utilisateur" -AsSecureString
    New-LocalUser -Name $username -Password $password -FullName $username -Description "User added by script"
    Add-LocalGroupMember -Group "Users" -Member $username
    Write-Host "Utilisateur $username ajouté avec succès."
}

# Fonction pour supprimer un utilisateur
function Remove-User {
    param (
        [string]$username
    )

    Remove-LocalUser -Name $username
    Write-Host "Utilisateur $username supprimé avec succès."
}

# Menu principal
Write-Host "Choisissez une action:"
Write-Host "1. Ajouter un utilisateur"
Write-Host "2. Supprimer un utilisateur"
$action = Read-Host "Entrez votre choix (1 ou 2)"

if ($action -eq "1") {
    $username = Read-Host "Entrez le nom de l'utilisateur à ajouter"
    Add-User -username $username
} elseif ($action -eq "2") {
    $username = Read-Host "Entrez le nom de l'utilisateur à supprimer"
    Remove-User -username $username
} else {
    Write-Host "Choix invalide. Veuillez exécuter le script à nouveau et choisir 1 ou 2."
}

