#! /bin/bash
set -euo pipefail

# Vars for direct downloads
MZMINE="https://github.com/mzmine/mzmine/releases/download/v4.9.0/mzmine_4.9.0_amd64.deb"
UV="https://astral.sh/uv/install.sh"
CYTOSCAPE="https://github.com/cytoscape/cytoscape/releases/download/3.10.4/Cytoscape_3_10_4_unix.sh"
DOCKER="https://get.docker.com/"


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
echo "Installing Docker"
curl -L "$DOCKER" -o /tmp/docker.sh
chmod +x /tmp/docker.sh
sh /tmp/docker.sh
usermod -aG docker student

echo "##########################################"
echo "Installing Cytoscape"
apt install -y openjdk-17-jre
curl -L "$CYTOSCAPE" -o /tmp/cytoscape.sh
chmod +x /tmp/cytoscape.sh
sh -q /tmp/cytoscape.sh -q

echo "##########################################"
echo "Installing Pycharm via Flatpak"
flatpak -y install flathub com.jetbrains.PyCharm-Professional


mkdir -p ./jetbrains
curl -L https://download.jetbrains.com/toolbox/"$JETBRAINS".tar.gz -o /tmp/jetbrains.tar.gz
tar -xvf /tmp/jetbrains.tar.gz -C ./jetbrains
./jetbrains/"$JETBRAINS"/bin/jetbrains-toolbox
chown -R student:student ./jetbrains
chmod 700 ./jetbrains

