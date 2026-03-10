#! /bin/bash
set -euo pipefail


# Vars general
SSH_CONFIG="/home/student/.ssh/"
BASHRC="/home/student/.bashrc"

# Vars for direct downloads
MZMINE="https://github.com/mzmine/mzmine/releases/download/v4.9.0/mzmine_4.9.0_amd64.deb"
JETBRAINS="jetbrains-toolbox-3.3.1.75249"
JAVA="openjdk-21-jdk"
CYTOSCAPE="https://github.com/cytoscape/cytoscape/releases/download/3.10.4/Cytoscape_3_10_4_unix.sh"

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
    element-desktop

echo "##########################################"
echo "Installing Uv (Python package manager)"
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "##########################################"
echo "Installing JetBrains Toolbox (Pycharm)"
mkdir -p ./jetbrains
curl -L https://download.jetbrains.com/toolbox/"$JETBRAINS".tar.gz -o /tmp/jetbrains.tar.gz
tar -xvf /tmp/jetbrains.tar.gz -C ./jetbrains
./jetbrains/"$JETBRAINS"/bin/jetbrains-toolbox
chown -R student:student ./jetbrains
chmod 700 ./jetbrains

echo "##########################################"
echo "Installing Obsidian"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub md.obsidian.Obsidian

echo "##########################################"
echo "Installing MZmine4"
curl -L "$MZMINE" -o /tmp/mzmine.deb
apt install -y /tmp/mzmine.deb

echo "##########################################"
echo "Installing Cytoscape"
apt install "$JAVA"
curl -L "$CYTOSCAPE" -o /tmp/cytoscape.deb
apt install -y /tmp/cytoscape.deb

echo "##########################################"
echo "Setting up .ssh directory"
mkdir -p "$SSH_CONFIG"
chown student:student "$SSH_CONFIG"
chmod 700 "$SSH_CONFIG"
cat <<EOF > "$SSH_CONFIG"config
Host *
	ForwardX11      yes
	ForwardX11Trusted yes
	ServerAliveInterval 30

Host github.com
	User git
	IdentityFile "$SSH_CONFIG"id_rsa
EOF

echo "##########################################"
echo "Setting up .bashrc file"
cat <<EOF >> "$BASHRC"
# enable an alias for python -> python3 (who is using python2 anyway nowadays)
alias python="python3"
EOF


