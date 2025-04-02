#!/bin/bash

# Function to show help
show_help() {
    echo "System maintenance script for Arch Linux"
    echo ""
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -b    Perform an incremental backup to a remote server"
    echo "  -p    Update system packages using pacman"
    echo "  -f    Update Flatpak packages"
    echo "  -a    Run all maintenance tasks (backup, pacman update, flatpak update)"
    echo "  -h    Show this help message"
    echo ""
    echo "Example usage:"
    echo "$0 -a   # Perform all tasks"
    echo "$0 -b -p # Perform backup and update pacman"
}

# Load configuration from the config.ini file
source ./config.ini

# Check if config.ini is present and has necessary variables
if [ -z "$REMOTE_USER" ] || [ -z "$REMOTE_SERVER" ] || [ -z "$REMOTE_DIR" ] || [ -z "$LOCAL_DIR" ]; then
    echo "Error: Configuration file 'config.ini' is missing required parameters."
    exit 1
fi

# Function to perform the backup
do_backup() {
    echo "Starting incremental backup..."
    
    # Using rsync for incremental backup
    rsync -avz --delete --link-dest=$LOCAL_DIR/previous-backup $LOCAL_DIR $REMOTE_USER@$REMOTE_SERVER:$REMOTE_DIR
    
    # Update the reference for the previous backup
    mv $LOCAL_DIR $LOCAL_DIR/previous-backup

    echo "Backup completed."
}

# Function to update packages using pacman
do_pacman_update() {
    echo "Updating pacman packages..."
    sudo pacman -Syu --noconfirm
    echo "Pacman packages updated."
}

# Function to update packages using Flatpak
do_flatpak_update() {
    echo "Updating Flatpak packages..."
    flatpak update -y
    echo "Flatpak packages updated."
}

# Process command-line options
while getopts "bpfha" opt; do
    case $opt in
        b)
            do_backup
            ;;
        p)
            do_pacman_update
            ;;
        f)
            do_flatpak_update
            ;;
        a)
            # Run all tasks if -a is selected
            do_backup
            do_pacman_update
            do_flatpak_update
            ;;
        h)
            show_help
            exit 0
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

# If no options were provided
if [ $OPTIND -eq 1 ]; then
    show_help
fi
