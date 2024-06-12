#!/bin/bash

# Affiche un menu pour l'utilisateur
echo "Choisissez une action:"
echo "1. Ajouter un utilisateur"
echo "2. Supprimer un utilisateur"

# Lit le choix de l'utilisateur
read -p "Entrez votre choix (1 ou 2): " action

# Vérifie le choix de l'utilisateur
if [ "$action" == "1" ]; then
    # Si l'utilisateur choisit d'ajouter un utilisateur
    read -p "Entrez le nom de l'utilisateur à ajouter: " username
    # Ajoute l'utilisateur avec la commande adduser
    sudo adduser $username
    echo "Utilisateur $username ajouté avec succès."
elif [ "$action" == "2" ]; then
    # Si l'utilisateur choisit de supprimer un utilisateur
    read -p "Entrez le nom de l'utilisateur à supprimer: " username
    # Supprime l'utilisateur avec la commande deluser
    sudo deluser $username
    echo "Utilisateur $username supprimé avec succès."
else
    # Si l'utilisateur entre un choix invalide
    echo "Choix invalide. Veuillez exécuter le script à nouveau et choisir 1 ou 2."
fi
