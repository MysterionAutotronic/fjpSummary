#!/bin/sh

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    echo -n "Installing... "
    while kill -0 $pid 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    echo ""
}

progress_message() {
    echo -e "\n\033[1;34m$1...\033[0m"
}

progress_message "Starting pandoc installation"

# Update package list in the background
sudo apt update > /dev/null 2>&1 &
spinner $!

# Run the installation command
progress_message "Installing required packages"
sudo apt install -y pandoc texlive-core 2>&1 | tee install.log &
spinner $!

# Check for success
if [ $? -eq 0 ]; then
    echo -e "\n\033[1;32mInstallation completed successfully!\033[0m"
else
    echo -e "\n\033[1;31mInstallation failed. Check install.log for details.\033[0m"
fi