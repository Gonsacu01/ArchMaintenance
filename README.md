# ArchMaintenance

This Bash script automates various system maintenance tasks on Arch Linux, such as performing incremental backups, updating system packages with pacman, and updating Flatpak packages. The script allows you to select specific tasks or run them all at once, with configuration details loaded from an external configuration file.

## Features

- **Incremental Backup**: Perform backups to a remote server using `rsync` over SSH.

- **System Package Update**: Update system packages using `pacman`.

- **Flatpak Package Update**: Update all installed Flatpak packages.

- **Custom Configuration**: All script parameters (such as SSH user, remote server, and directories) are extracted from a configuration file, making it easy to customize and manage your settings.

- **Multiple Task Execution**: Run multiple tasks (backup, pacman update, Flatpak update) by specifying different flags.

- **Option for Running All Tasks**: Use the `-a` flag to run all tasks (backup, system update, Flatpak update) in one go.

## Installation

1. **Download the Script**:
   You can download or copy the script to your desired location, e.g., `/usr/local/bin` or any other directory in your system.

2. **Create Configuration File**:
   The script requires a `config.ini` file where you define parameters such as your SSH user, server address, and backup directories.

   Example `config.ini`:

   ```ini
   # Configuration for the maintenance script
   REMOTE_USER="your_ssh_user"           # SSH user
   REMOTE_SERVER="your_remote_server"     # Remote server address
   REMOTE_DIR="/path/to/remote/backup"    # Remote backup directory
   LOCAL_DIR="/path/to/local/backup"      # Local directory to back up
   ```
    Make sure that `config.ini` is in the same directory as the script, and add it to your `.gitignore` to avoid committing sensitive information.

3. Make the Script Executable:
    ```bash
    chmod +x maintenance.sh
    ```
## Usage
You can run the script with a variety of options. The script reads parameters from `config.ini`, so you don’t need to specify them every time you run it.

### Available Options
- `-b`: Perform an incremental backup to a remote server.

- `-p`: Update system packages using pacman.

- `-f`: Update Flatpak packages.

- `-a`: Run all maintenance tasks (backup, pacman update, Flatpak update) in one go.

- `-h`: Show this help message.

### Example Usage
- **Run All Maintenance Tasks**: To perform a backup, update pacman packages, and update Flatpak packages, run:
    ```bash
    ./maintenance.sh -a
    ```

- **Perform a Backup and Update Pacman**: To perform a backup and update your system with pacman, use:
    ```bash
    ./maintenance.sh -b -p
    ```

- **Perform a Backup and Update Flatpak**: To perform a backup and update all Flatpak packages, use:
    ```bash
    ./maintenance.sh -b -f
    ```

- **Perform Only a Backup**: To perform only an incremental backup, use:
    ```bash
    ./maintenance.sh -b
    ```

- **Display Help**: To see the usage information and available options:
    ```bash
    ./maintenance.sh -h
    ```

### Configuration File
The script requires a `config.ini` file where you define the following parameters:

- `REMOTE_USER`: Your SSH user for connecting to the remote server.

- `REMOTE_SERVER`: The address of your remote server (e.g., server.com).

- `REMOTE_DIR`: The directory on the remote server where backups will be stored.

- `LOCAL_DIR`: The local directory to be backed up.

Example `config.ini`:
```ini
# Configuration for the maintenance script

REMOTE_USER="your_ssh_user"
REMOTE_SERVER="your_remote_server"
REMOTE_DIR="/path/to/remote/backup"
LOCAL_DIR="/path/to/local/backup"
```
## How It Works
1. **Backup**: The script uses `rsync` to perform an incremental backup from your local directory to a remote server. It compares the current backup with the previous one and only transfers the changes. This makes backups more efficient. The backup process is done over SSH, so the script will use the `REMOTE_USER` and `REMOTE_SERVER` values defined in the `config.ini` file.

2. **Pacman Update**: The script updates your Arch Linux system packages using pacman. It runs the `pacman -Syu` command, which synchronizes the package database, installs any new updates, and removes unnecessary packages. The `--noconfirm` flag automatically confirms any prompts, ensuring a smooth update process.

3. **Flatpak Update**: If you have any Flatpak packages installed, the script will update them using `flatpak update -y`. The `-y` flag automatically confirms the update without prompting.

4. **Configuration**: The script reads configuration details from the `config.ini` file. This makes it easy to change your backup directories, SSH user, or remote server without modifying the script itself. Simply update the `config.ini` file with your settings.

## Notes
- Make sure you have the required tools installed:

    - `rsync` for backups.

    - `pacman` for updating system packages.

    - `flatpak` for updating Flatpak packages.

- **Security**: The script uses SSH to perform backups. Ensure that you have SSH keys set up for passwordless authentication to avoid entering your password every time the script runs.

- **Customization**: You can extend the script by adding additional tasks, such as cleaning up old backups, checking disk space, or more. Just follow the same structure for adding functions.

## Troubleshooting
- If the script can't find the configuration file, it will display an error message. Make sure `config.ini` exists in the same directory as the script and is correctly formatted.

- If the `rsync` command fails, check the SSH connection to your remote server and ensure that the remote directory exists and is writable.
