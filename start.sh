#!/bin/bash

echo "Starting auto-install..."

TARGET_USER="backup"
SERVICE_FILE="backup.service"
TIMER_FILE="backup.timer"
SYSTEMD_PATH="/etc/systemd/system/"
SCRIPT_PATH="/usr/local/bin/"

# Check if the user exists
if id "$TARGET_USER" &>/dev/null; then
    echo "User $TARGET_USER already exists."
else
    # Create the user
    sudo adduser "$TARGET_USER"
    echo "User $TARGET_USER created."
fi

chmod +x *.sh
echo "Making scripts executable."

# Copy the service file to systemd path
if sudo cp "$SERVICE_FILE" "$SYSTEMD_PATH" && \
   sudo cp "$TIMER_FILE" "$SYSTEMD_PATH" && \
   sudo cp *.sh "$SCRIPT_PATH"; then
    echo "Copied $SERVICE_FILE and $TIMER_FILE to $SYSTEMD_PATH"
    echo "Copied scripts to $SCRIPT_PATH"
    sudo systemctl enable backup.sh
    sudo systemctl enable backup.timer
    sudo systemctl start backup.sh
    sudo systemctl start backup.timer
    echo "Systemd service and timer enabled and started."
else
    echo "Error copying files. Please check permissions or file paths."
fi

   






