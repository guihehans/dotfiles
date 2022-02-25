My Windows 10 Setup & Dotfiles
==============================

Goals of this setup
-------------------

- Working on Windows 10, on WSL 2 filesystem
- Having a visually nice terminal (Windows Terminal)
- zsh as my main shell, oh-my-zsh to manage plugin
- Using IntelliJ IDEA directly from WSL 2


What's in this setup?
---------------------

- Host: Windows 10 2004+
  - Ubuntu via WSL 2 (Windows Subsystem for Linux)
- Terminal: Windows Terminal
- Systemd
- zsh
- git
- Go 
- IDE: IntelliJ IDEA, under WSL 2, used on Windows via VcXsrv
- WSL Bridge: allow exposing WSL 2 ports on the network



----------------------


Setup WSL 2
-----------

- Enable WSL 2 and update the linux kernel ([Source](https://docs.microsoft.com/en-us/windows/wsl/install-win10))

```powershell
# In PowerShell as Administrator

# Enable WSL and VirtualMachinePlatform features
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Download and install the Linux kernel update package
$wslUpdateInstallerUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$downloadFolderPath = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$wslUpdateInstallerFilePath = "$downloadFolderPath/wsl_update_x64.msi"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($wslUpdateInstallerUrl, $wslUpdateInstallerFilePath)
Start-Process -Filepath "$wslUpdateInstallerFilePath"

# Set WSL default version to 2
wsl --set-default-version 2
```

- [Install Ubuntu from Microsoft Store](https://www.microsoft.com/fr-fr/p/ubuntu/9nblggh4msv6)

Set up proxy if needed
---------------------------
If in corp environment, using corp proxy.
If in in home environment, using home proxy.

change your proxy in .bashrc

Apt proxy is required too. 
```
  vim ~/.bashrc

  # append proxy in bottom
  export HTTP_PROXY="http://web-proxy.sg.softwaregrp.net:8088"
  export http_proxy=$HTTP_PROXY
  export https_proxy=$HTTP_PROXY
  export FTP_PROXY=$HTTP_PROXY
  export RSYNC_PROXY=$HTTP_PROXY
  export no_proxy=localhost,127.0.0.1,localaddress,.localdomain.com,.hpeswlab.net,mydyumserver,mydyumserver.hpswlabs.adapps.hp.com,*.hp.com,16.59.0.0,hpswlabs.adapps.hp.com:80,*.softwaregrp.net,127.0.0.1,localhost,*.hpeswlab.net,*.hp.com,kubernetes.docker.internal,192.168.65.0/28,*.swinfra.net

  
  sudo vim /etc/apt/apt.conf.d/proxy.conf

  ## in /etc/apt/apt.conf.d/proxy.conf, add following line. change accordingly.

  Acquire::http::Proxy "http://user:password@proxy.server:port/";
  Acquire::https::Proxy "http://user:password@proxy.server:port/";
```

Set up non-password input for sudo 
---------------------------
```
  sudo visudo
  # add in the end of document. guihehans is my username
  guihehans ALL=(ALL) NOPASSWD: ALL
```

Install common dependencies
---------------------------

```shell script
#!/bin/bash

sudo apt update && sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    git \
    make \
    tig \
    tree \
    zip unzip \
    zsh
```


Setup Git
---------

```shell script
#!/bin/bash

# Set username and email for next commands
email="guihehans@gmail.com"
username="guihehans"

# Configure Git
git config --global user.email "${email}"
git config --global user.name "${username}"
git config --global core.autocrlf input
git config --global core.pager /usr/bin/less
git config --global core.excludesfile ~/.gitignore

# Generate a new SSH key
ssh-keygen -t rsa -b 4096 -C "${email}"

# Start ssh-agent and add the key to it
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa

# Display the public key ready to be copy pasted to GitHub
cat ~/.ssh/id_rsa.pub
```

- [Add the generated key to GitHub](https://github.com/settings/ssh/new)


Setup zsh and oh-my-zsh
---------

```shell script
#!/bin/zsh

# Clone the dotfiles repository
mkdir -p ~/code/personal
git clone https://github.com/guihehans/dotfiles.git ~/code/personal/dotfiles/

# Create .screen folder used by .zshrc
mkdir ~/.screen && chmod 700 ~/.screen

# Change default shell to zsh
chsh -s $(which zsh)
# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# use dot bot to install
cd ~/code/personal/dotfiles
./install

```


IntelliJ IDEA
-------------

I run IntelliJ IDEA in WSL 2, and get its GUI on Windows via X Server (VcXsrv).

### Setup VcXsrv

- [Install VcXsrv (XLaunch)](https://sourceforge.net/projects/vcxsrv/)

```shell script
windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

# Run VcXsrv at startup
cp ~/code/personal/config.xlaunch "${windowsUserProfile}/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
```

### Install IntelliJ IDEA

```shell script
#!/bin/zsh

# Install IDEA dependencies
sudo apt update && sudo apt install -y \
    fontconfig \
    libxss1 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgbm1 \
    libpangocairo-1.0-0 \
    libcups2 \
    libxkbcommon0

# Create install folder
sudo mkdir -p /opt/idea

# Allow your user to run IDEA updates from GUI
sudo chown $UID:$UID /opt/idea

# Download IntelliJ IDEA commuunity version. change if you have extra license
curl -L "https://download-cdn.jetbrains.com/idea/ideaIC-2021.3.2.tar.gz" | tar vxz -C /opt/idea --strip 1


```


Setup Windows Terminal
----------------------

- [Download and install JetBrains Mono](https://www.jetbrains.com/mono/)
- [Install Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701)

```shell script
#!/bin/zsh

windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

# Copy Windows Terminal settings
cp ~/code/personal/dotfiles/terminal-settings.json ${windowsUserProfile}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json
```


WSL Bridge
----------

When a port is listening from WSL 2, it cannot be reached.
You need to create port proxies for each port you want to use.
To avoid doing than manually each time I start my computer, I've made the `wslb` alias that will run the `wsl2bridge.ps1` script in an admin Powershell.

```shell script
#!/bin/zsh

windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

# Get the hacky network bridge script
cp ~/code/personal/dotfiles/wsl2-bridge.ps1 ${windowsUserProfile}/wsl2-bridge.ps1
```

In order to allow `wsl2-bridge.ps1` script to run, you need to update your PowerShell execution policy.

```powershell
# In PowerShell as Administrator

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
PowerShell -File $env:USERPROFILE\\wsl2-bridge.ps1
```

Then, when port forwarding does not work between WSL 2 and Windows, run `wslb` from zsh:

```shell script
#!/bin/zsh

wslb
```

Note: This is a custom alias. See [`.aliases.zsh`](.aliases.zsh) for more details


Limit WSL 2 RAM consumption
---------------------------

```shell script
#!/bin/zsh

windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

# Avoid too much RAM consumption
cp ~/code/personal/dotfiles/.wslconfig ${windowsUserProfile}/.wslconfig
```

Note: You can adjust the RAM amount in `.wslconfig` file. Personally, I set it to 32 GB.

Go
---

```shell script
#!/bin/zsh

goVersion=1.16.4
curl -L "https://golang.org/dl/go${goVersion}.linux-amd64.tar.gz" > /tmp/go${goVersion}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf /tmp/go${goVersion}.linux-amd64.tar.gz
rm /tmp/go${goVersion}.linux-amd64.tar.gz
```

[See official documentation](https://golang.org/doc/install)


Systemd
-------

Allow starting services like Docker. 
This uses [arkane-systems/genie](https://github.com/arkane-systems/genie).

```shell script
#!/bin/zsh

# Setup Microsoft repository (Genie depends on .NET)
curl -sL -o /tmp/packages-microsoft-prod.deb "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i /tmp/packages-microsoft-prod.deb
rm -f /tmp/packages-microsoft-prod.deb

# Setup Arkane Systems repository
sudo wget -O /etc/apt/trusted.gpg.d/wsl-transdebian.gpg https://arkane-systems.github.io/wsl-transdebian/apt/wsl-transdebian.gpg

sudo chmod a+r /etc/apt/trusted.gpg.d/wsl-transdebian.gpg

sudo cat << EOF > /etc/apt/sources.list.d/wsl-transdebian.list
deb https://arkane-systems.github.io/wsl-transdebian/apt/ $(lsb_release -cs) main
deb-src https://arkane-systems.github.io/wsl-transdebian/apt/ $(lsb_release -cs) main
EOF

sudo apt update

# Install Systemd Genie
sudo apt update
sudo apt install -y systemd-genie

# Mask some unwanted services
sudo systemctl mask systemd-remount-fs.service
sudo systemctl mask multipathd.socket


```