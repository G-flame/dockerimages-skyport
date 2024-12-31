#!/bin/bash
set -e

# Ensure proper terminal handling for piped input
if [ ! -t 0 ]; then
    exec </dev/tty
fi

## i hardcoded the directories to make sure that i do't make mistakes!!
## Functions

# Color definitions for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

git-pull() {
    mkdir -p /tmp/bsd
    cd /tmp/bsd
    echo -e "${GREEN}Downloading required files...${NC}"
    
    if ! curl -sSL -o "/tmp/bsd/urls.txt" "https://raw.githubusercontent.com/g-flame/dockerimages-skyport/refs/heads/main/assets/other/bedrock-server/urls.txt"; then
        echo -e "${RED}Failed to download urls.txt${NC}"
        exit 1
    fi

    if [[ -s "/tmp/bsd/urls.txt" ]]; then
        while read -r url; do
            echo "Downloading: $(basename "$url")"
            if ! curl -sSL -o "/tmp/bsd/$(basename "$url")" "$url"; then
                echo -e "${RED}Failed to download $(basename "$url")${NC}"
                exit 1
            fi
        done < "/tmp/bsd/urls.txt"
    else
        echo -e "${RED}Error: urls.txt is empty or missing.${NC}"
        exit 1
    fi
}

docker-pull() {
    echo -e "${GREEN}Pulling Docker image...${NC}"
    if ! docker pull itzg/minecraft-bedrock-server; then
        echo -e "${RED}Failed to pull Docker image${NC}"
        exit 1
    fi
    
    mkdir -p /etc/bsd/
    if ! mv /tmp/bsd/* /etc/bsd/; then
        echo -e "${RED}Failed to move files to /etc/bsd/${NC}"
        exit 1
    fi

    if ! mv /etc/bsd/bsd /usr/local/bin/; then
        echo -e "${RED}Failed to move bsd to /usr/local/bin/${NC}"
        exit 1
    fi

    chmod +x /usr/local/bin/bsd
    echo -e "${GREEN}INSTALL COMPLETE!${NC}"
    ui
}

docker-detect() {
    if command -v docker >/dev/null 2>&1; then
        echo -e "${GREEN}Docker is installed, continuing...${NC}"
    else
        echo -e "${RED}Docker not found. Installing...${NC}"
        OS=$(uname -s | tr '[:upper:]' '[:lower:]')

        case $OS in
        linux)
            source /etc/os-release
            case $ID in
            debian|ubuntu|mint)
                apt-get update
                apt-get install -y ca-certificates curl
                install -m 0755 -d /etc/apt/keyrings
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
                chmod a+r /etc/apt/keyrings/docker.asc
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
                apt-get update
                apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                systemctl start docker
                systemctl enable docker
                docker run hello-world
                ;;
            fedora|rhel|centos)
                dnf -y install dnf-plugins-core
                dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
                dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                systemctl start docker
                systemctl enable docker
                ;;
            *)
                echo -e "${RED}Unsupported OS. Please install Docker manually to continue!${NC}"
                exit 1
                ;;
            esac
            ;;
        *)
            echo -e "${RED}Unsupported OS. Please install Docker manually to continue!${NC}"
            exit 1
            ;;
        esac
    fi
}

ui() {
    clear
    echo "================================"
    echo "BEDROCK SERVER DOCKER INSTALLER V1.0"
    echo "lite cli-ui v0.01"
    echo "================================"
    echo "START INSTALL?"
    echo "1) Yes"
    echo "2) No"
    
    while true; do
        read -p "Enter your choice (1 or 2): " choice
        case $choice in
            1)
                echo "Starting installation..."
                git-pull
                docker-detect
                docker-pull
                break
                ;;
            2)
                echo "Installation cancelled."
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid selection. Please choose 1 or 2.${NC}"
                ;;
        esac
    done
}

## the actual Fing script

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo -e "${RED}This script must be run as root${NC}" 1>&2
   exit 1
fi

# Set up trap to clean up temporary files on exit
trap 'rm -rf /tmp/bsd' EXIT

# Start the installation
ui
