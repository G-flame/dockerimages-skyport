# Bedrock Server Docker (BSD)

BSD is a lightweight installer that sets up Docker and configures a Bedrock server container with all necessary files and volumes.

## Features

- Automates Docker installation and setup.
- Configures Bedrock server container for seamless operation.
- Stores configuration files in `/etc/bsd`.
- Provides an easy-to-use command-line interface for managing the server.

## Usage

After installation, use the `bsd` command to manage the server the bsd command needs root so use sudo are run as root user for it to work:

- `bsd start` - Start the Bedrock server container.
- `bsd stop` - Stop the container.
- `bsd logs` - View logs for the server container.

## Installation

1. Run the installer script as root:

   ```bash
   sudo bash -c "$(curl -fsSL https://github.com/g-flame/dockerimages-skyport/raw/refs/heads/main/assets/other/bedrock-server/bsd-installer.sh)"
   ```

   or wget

   ```bash
   sudo bash -c "$(wget -qO- https://github.com/g-flame/dockerimages-skyport/raw/refs/heads/main/assets/other/bedrock-server/bsd-installer.sh)"

   ```

Follow the prompts to complete the setup.
Directory Structure
Configuration Files: /etc/bsd
Command Utility: bsd
