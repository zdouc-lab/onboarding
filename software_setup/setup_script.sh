#! /bin/bash
set -euo pipefail

# Vars for direct downloads
MZMINE="https://github.com/mzmine/mzmine/releases/download/v4.9.0/mzmine_4.9.0_amd64.deb"
JETBRAINS="jetbrains-toolbox-3.3.1.75249"
UV="https://astral.sh/uv/install.sh"
CYTOSCAPE="https://github.com/cytoscape/cytoscape/releases/download/3.10.4/Cytoscape_3_10_4_unix.sh"
DOCKER_DESKTOP="https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64"


if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo ./setup.sh)"
  exit 1
fi

echo "Started package installation"

echo "##########################################"
echo "Adding repositories"
add-apt-repository -y universe
add-apt-repository -y ppa:inkscape.dev/stable
add-apt-repository -y ppa:safeeyes-team/safeeyes

echo "##########################################"
echo "Installing the basics"
apt-get update && \
    apt-get install -y \
    libfuse2 \
    curl \
    geany \
    apt-transport-https

echo "##########################################"
echo "Installing Element"
wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg 
echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | tee /etc/apt/sources.list.d/element-io.list 


echo "##########################################"
echo "Installing programs via apt"
apt-get update && \
    apt-get install -y \
    chromium-browser \
    flatpak \
    inkscape \
    safeeyes \
    element-desktop \
    htop

echo "##########################################"
echo "Installing Uv (Python package manager)"
curl -LsSf "$UV" | sh

echo "##########################################"
echo "Installing Obsidian"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub md.obsidian.Obsidian

echo "##########################################"
echo "Installing MZmine4"
curl -L "$MZMINE" -o /tmp/mzmine.deb
apt install -y /tmp/mzmine.deb

echo "##########################################"
echo "Installing Docker Desktop Linux"
apt update
apt install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
curl -LsSf "DOCKER_DESKTOP" | sh

echo "##########################################"
echo "Installing Cytoscape"
curl -LsSf "$CYTOSCAPE" | sh

echo "##########################################"
echo "Installing JetBrains Toolbox (Pycharm)"
mkdir -p ./jetbrains
curl -L https://download.jetbrains.com/toolbox/"$JETBRAINS".tar.gz -o /tmp/jetbrains.tar.gz
tar -xvf /tmp/jetbrains.tar.gz -C ./jetbrains
./jetbrains/"$JETBRAINS"/bin/jetbrains-toolbox
chown -R student:student ./jetbrains
chmod 700 ./jetbrains

