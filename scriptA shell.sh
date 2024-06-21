#!/bin/bash

# Chemin du fichier de log
LOG_FILE="/var/log/log_evt.log"

# Fonction de journalisation
write_log() {
    local event="$1"
    local datetime=$(date '+%Y%m%d-%H%M%S')
    local user=$(whoami)
    echo "$datetime-$user-$event" >> $LOG_FILE
}

# Fonction pour afficher le menu principal
show_menu() {
    echo "1. Gérer les utilisateurs"
    echo "2. Gérer les ordinateurs"
    echo "3. Quitter"
}

# Fonction pour gérer les utilisateurs
manage_users() {
    echo "1. Créer un compte utilisateur"
    echo "2. Supprimer un compte utilisateur"
    echo "3. Retour au menu principal"
    read -p "Choisissez une option: " choice
    case $choice in
        1)
            read -p "Entrez le nom d'utilisateur: " username
            read -sp "Entrez le mot de passe: " password
            ssh root@172.16.10.30 "sudo useradd -m -p $(openssl passwd -1 $password) $username"
            write_log "Création de l'utilisateur $username"
            ;;
        2)
            read -p "Entrez le nom d'utilisateur: " username
            ssh root@172.16.10.30 "sudo userdel -r $username"
            write_log "Suppression de l'utilisateur $username"
            ;;
        3)
            return
            ;;
    esac
}

# Fonction pour gérer les ordinateurs
manage_computers() {
    echo "1. Arrêter l'ordinateur"
    echo "2. Redémarrer l'ordinateur"
    echo "3. Retour au menu principal"
    read -p "Choisissez une option: " choice
    case $choice in
        1)
            read -p "Entrez le nom complet ou l'adresse IP de l'ordinateur: " computerName
            ssh root@$computerName "sudo shutdown now"
            write_log "Arrêt de l'ordinateur $computerName"
            ;;
        2)
            read -p "Entrez le nom complet ou l'adresse IP de l'ordinateur: " computerName
            ssh root@$computerName "sudo reboot"
            write_log "Redémarrage de l'ordinateur $computerName"
            ;;
        3)
            return
            ;;
    esac
}

# Fonction principale
main() {
    write_log "********StartScript********"
    while true; do
        show_menu
        read -p "Choisissez une option: " choice
        case $choice in
            1) manage_users ;;
            2) manage_computers ;;
            3)
                write_log "*********EndScript*********"
                exit 0
                ;;
        esac
    done
}

# Exécution du script principal
main
