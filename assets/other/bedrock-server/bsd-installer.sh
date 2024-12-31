#!/bin/bash
set -e
## i hardcoded the directories to make sure that i do't make mistakes!!
## Functions
git-pull() {
    mkdir -p /tmp/bsd
    cd /tmp/bsd
 curl -o "/tmp/bsd/urls.txt" https://raw.githubusercontent.com/g-flame/dockerimages-skyport/refs/heads/main/assets/other/bedrock-server/urls.txt

    if [[ -s "/tmp/bsd/urls.txt" ]]; then
        while read -r url; do
            curl -o "/tmp/bsd/$(basename "$url")" "$url"
        done < "/tmp/bsd/urls.txt"
    else
        echo "Error: urls.txt is empty or missing."
        exit 1
    fi
}

docker-pull() {
    docker pull itzg/minecraft-bedrock-server
    mkdir -p /etc/bsd/
    mv /tmp/bsd/* /etc/bsd/
    mv /etc/bsd/bsd /usr/local/bin/
    echo "INSTALL COMPLETE!"
    ui
}

docker-detect() {
    DOCKER_CMD=$(which docker)
    if [[ ! -z $DOCKER_CMD ]]; then
        echo "Docker is installed, continuing..."
    else
        echo "Docker not found. Installing..."
        OS=$(uname -s | tr 'A-Z' 'a-z')

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
                docker run hello-world
                ;;
            fedora|rhel|centos)
                yum update -y
                yum install -y dnf-plugins-core
                dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
                dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                systemctl enable --now docker
                ;;
            *)
                echo "Unsupported OS. Please install Docker manually to continue!"
                exit 1
                ;;
            esac
            ;;
        *)
            echo "Unsupported OS. Please install Docker manually to continue!"
            exit 1
            ;;
        esac
    fi
}

ui() {
#!/bin/bash
set -e
## i hardcoded the directories to make sure that i do't make mistakes!!
## Functions
git-pull() {
    mkdir -p /tmp/bsd
    cd /tmp/bsd
 curl -o "/tmp/bsd/urls.txt" https://raw.githubusercontent.com/g-flame/dockerimages-skyport/refs/heads/main/assets/other/bedrock-server/urls.txt

    if [[ -s "/tmp/bsd/urls.txt" ]]; then
        while read -r url; do
            curl -o "/tmp/bsd/$(basename "$url")" "$url"
        done < "/tmp/bsd/urls.txt"
    else
        echo "Error: urls.txt is empty or missing."
        exit 1
    fi
}

docker-pull() {
    docker pull itzg/minecraft-bedrock-server
    mkdir -p /etc/bsd/
    mv /tmp/bsd/* /etc/bsd/
    mv /etc/bsd/bsd /usr/local/bin/
    echo "INSTALL COMPLETE!"
    ui
}

docker-detect() {
    DOCKER_CMD=$(which docker)
    if [[ ! -z $DOCKER_CMD ]]; then
        echo "Docker is installed, continuing..."
    else
        echo "Docker not found. Installing..."
        OS=$(uname -s | tr 'A-Z' 'a-z')

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
                docker run hello-world
                ;;
            fedora|rhel|centos)
                yum update -y
                yum install -y dnf-plugins-core
                dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
                dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                systemctl enable --now docker
                ;;
            *)
                echo "Unsupported OS. Please install Docker manually to continue!"
                exit 1
                ;;
            esac
            ;;
        *)
            echo "Unsupported OS. Please install Docker manually to continue!"
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
##
# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo -e "${RED}This script must be run as root${NC}" 1>&2
   exit 1
fi

ui
}
## the actual Fing script

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo -e "${RED}This script must be run as root${NC}" 1>&2
   exit 1
fi

ui
