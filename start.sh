#!/bin/bash

echo "Starting auto-install..."

# Variables
TARGET_USER="backup"
SERVICE_FILE="backup.service"
TIMER_FILE="backup.timer"
SYSTEMD_PATH="/etc/systemd/system/"
SCRIPT_PATH="/usr/local/bin/"

echo 'Enter directory you want to copy:'
while true; do
    read -p '(For example - /home/user/) >>> ' SrcDir

    if [ -d "$SrcDir" ]; then
        echo 'OK!'
        break  # Exit the loop if the directory exists
    else
        echo 'There is no such directory. Try again.'
    fi
done

echo 'Enter storage directory:'
while true; do
    read -p '(For example - /home/user/backups/) >>> ' PathToStore

    if [ -d "$PathToStore" ]; then
        echo 'OK!'
        break  # Exit the loop if the directory exists
    else
        echo 'There is no such directory. Should I create it? (y/n)'
        read createDirectory

        if [ "$createDirectory" = "y" ]; then
            mkdir -p "$PathToStore"
            echo 'Directory created.'
            break  # Exit the loop after creating the directory
        elif [ "$createDirectory" = "n" ]; then
            echo 'Please enter a valid directory.'
        else
            echo 'Invalid response. Try again.'
        fi
    fi
done

# Replacing variable values ​​in file
sed -i "s|^SrcDir=.*|SrcDir=\"$SrcDir\"|" variables
sed -i "s|^PathToStore=.*|PathToStore=\"$PathToStore\"|" variables


# Check if the user exists
if id "$TARGET_USER" &>/dev/null; then
    echo "User $TARGET_USER already exists."
else
    # Creating a user for operations and file storage
    adduser "$TARGET_USER"
    echo "User $TARGET_USER created."
fi

# Creating log-folders
mkdir /var/log/backup
echo "Created folder for logs"

# Copy the service file to systemd path
if chmod +x *.sh && \
   cp "$SERVICE_FILE" "$SYSTEMD_PATH" && \
   cp "$TIMER_FILE" "$SYSTEMD_PATH" && \
   cp *.sh "$SCRIPT_PATH" && \
   cp variables "$SCRIPT_PATH"; then
    echo "Files made executable."
    echo "Copied $SERVICE_FILE and $TIMER_FILE to $SYSTEMD_PATH"
    echo "Copied scripts to $SCRIPT_PATH"
    systemctl enable $SERVICE_FILE
    systemctl enable $TIMER_FILE
    systemctl start $SERVICE_FILE
    systemctl start $TIMER_FILE
    # Check if the services started successfully
    if [ $? -eq 0 ]; then
        echo "Services enabled and started successfully."
    else
        echo "Error starting services. Please check systemctl status for more information."
    fi
else
    echo "Error copying files. Please check permissions or file paths."
fi
