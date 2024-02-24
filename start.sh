#!/bin/bash

echo "Starting auto-install..."

# Variables
TARGET_USER="backup"
SERVICE_FILE="backup.service"
TIMER_FILE="backup.timer"
SYSTEMD_PATH="/etc/systemd/system/"
SCRIPT_PATH="/usr/local/bin/"

# Check if the user exists
if id "$TARGET_USER" &>/dev/null; then
    echo "User $TARGET_USER already exists."
else
    # Creating a user for operations and file storage
    sudo adduser "$TARGET_USER"
    echo "User $TARGET_USER created."
fi

# Creating log-folders
mkdir /var/log/backup
echo "Created folder for logs"

# Copy the service file to systemd path
if chmod +x *.sh && \
   sudo cp "$SERVICE_FILE" "$SYSTEMD_PATH" && \
   sudo cp "$TIMER_FILE" "$SYSTEMD_PATH" && \
   sudo cp *.sh "$SCRIPT_PATH"; then
    echo "Files made executable."
    echo "Copied $SERVICE_FILE and $TIMER_FILE to $SYSTEMD_PATH"
    echo "Copied scripts to $SCRIPT_PATH"
    sudo systemctl enable $SERVICE_FILE
    sudo systemctl enable $TIMER_FILE
    sudo systemctl start $SERVICE_FILE
    sudo systemctl start $TIMER_FILE
    # Check if the services started successfully
    if [ $? -eq 0 ]; then
        echo "Services enabled and started successfully."
    else
        echo "Error starting services. Please check systemctl status for more information."
    fi
else
    echo "Error copying files. Please check permissions or file paths."
fi
