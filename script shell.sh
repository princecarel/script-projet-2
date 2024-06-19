#!/bin/bash

# Fonction pour ajouter un utilisateur
function add_user {
    local username=$1
    local password=$2
    local hostname=$3

    ssh "$hostname" "sudo useradd -m -p $(openssl passwd -1 $password) $username && sudo usermod -aG sudo $username && echo 'Utilisateur $username ajouté avec succès.'"
}

# Fonction pour supprimer un utilisateur
function remove_user {
    local username=$1
    local hostname=$2

    ssh "$hostname" "sudo userdel -r $username && echo 'Utilisateur $username supprimé avec succès.'"
}

# Fonction pour lister les utilisateurs
function list_users {
    local hostname=$1

    ssh "$hostname" "getent passwd | awk -F: '\$3 >= 1000 {print \$1}'"
}

# Menu principal
while true; do
    echo "Choisissez une action:"
    echo "1. Ajouter un utilisateur"
    echo "2. Supprimer un utilisateur"
    echo "3. Voir tous les utilisateurs"
    echo "4. Quitter"
    read -p "Entrez votre choix (1, 2, 3 ou 4): " action

    if [ "$action" == "4" ]; then
        echo "Au revoir!"
        break
    fi

    read -p "Entrez le nom ou l'adresse IP de l'ordinateur distant: " hostname

    if [ "$action" == "1" ]; then
        read -p "Entrez le nom de l'utilisateur à ajouter: " username
        read -sp "Entrez le mot de passe pour l'utilisateur: " password
        echo
        add_user "$username" "$password" "$hostname"
    elif [ "$action" == "2" ]; then
        read -p "Entrez le nom de l'utilisateur à supprimer: " username
        remove_user "$username" "$hostname"
    elif [ "$action" == "3" ]; then
        list_users "$hostname"
    else
        echo "Choix invalide. Veuillez exécuter le script à nouveau et choisir 1, 2, 3 ou 4."
    fi
done
