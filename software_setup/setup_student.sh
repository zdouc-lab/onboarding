#! /bin/bash
set -euo pipefail


# Vars general
SSH_CONFIG="/home/student/.ssh/"
BASHRC="/home/student/.bashrc"

# Vars for direct downloads
MZMINE="https://github.com/mzmine/mzmine/releases/download/v4.9.0/mzmine_4.9.0_amd64.deb"
JETBRAINS="jetbrains-toolbox-3.3.1.75249.tar.gz" 
JAVA="openjdk-21-jdk"
CYTOSCAPE="https://github.com/cytoscape/cytoscape/releases/download/3.10.4/Cytoscape_3_10_4_unix.sh"

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (sudo ./setup.sh)"
  exit 1
fi

echo "Started package installation"

echo "Adding repositories"
add-apt-repository universe
add-apt-repository ppa:inkscape.dev/stable
add-apt-repository ppa:safeeyes-team/safeeyes

echo "Installing the basics"
apt-get update && \
    apt-get install -y --no-install-recommends \
    libfuse2 \
    curl \
    geany \
    apt-transport-https \
rm -rf /var/lib/apt/lists/*


echo "Installing Element"
wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg 
echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | tee /etc/apt/sources.list.d/element-io.list 


echo "Installing programs via apt"
apt-get update && \
    apt-get install -y --no-install-recommends \
    chromium-browser \
    flatpak \
    inkscape \
    safeeyes \
    element-desktop 
rm -rf /var/lib/apt/lists/*


echo "Installing Uv (Python package manager)"
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "Installing JetBrains Toolbox (Pycharm)"
mkdir -p ./jetbrains
curl -L https://download.jetbrains.com/toolbox/"$JETBRAINS" -o /tmp/jetbrains.tar.gz
tar -xvf /tmp/jetbrains.tar.gz -C ./jetbrains
sh ./jetbrains/bin/jetbrains-toolbox
chown -R student:student ./jetbrains
chmod 700 ./jetbrains


echo "Installing Obsidian"
flatpak install -y flathub md.obsidian.Obsidian

echo "Installing MZmine4"
curl -L "$MZMINE" -o /tmp/mzmine.deb
apt install -y /tmp/mzmine.deb

echo "Installing Cytoscape"
apt install "$JAVA"
curl -L "$CYTOSCAPE" -o /tmp/cytoscape.deb
apt install -y /tmp/cytoscape.deb

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

echo "Setting up .bashrc file"
cat <<EOF >> "$BASHRC"
# enable an alias for python -> python3 (who is using python2 anyway nowadays)
alias python="python3"
EOF


