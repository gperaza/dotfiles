sudo apt install build-essential
sudo apt install git
sudo apt install atool
sudo apt install ripgrep
sudo apt install texlive-full
sudo apt install stow
sudo apt install curl
sudo apt install shellcheck
sudo apt install openjdk-11-jdk

# Make caps a ctrl.
# Add this line to /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
sudo dpkg-reconfigure keyboard-configuration

# For qalc, download and complie. Dependencies:
sudo apt-get install libqalculate6
sudo apt-get install libxml2-dev libgmp-dev
sudo apt-get build-dep qalc
sudo apt-get install libcurl4-gnutls-dev
sudo apt-get install libiconv-hook-dev

# Rofi launcher from PPA
sudo apt-get install rofi

# Latest emacs stable from ppa
sudo apt-get install emacs26

#Download and install anaconda
anaconda
pip install bibtexparser
conda install -c conda-forge bibtexparser

# Download and install google chrome
google-chrome

# Download and install exa (replacement for ls)
exa
bat

# FZF fuzzy completion for bash, follow github repo instructions,
# install from git

# TLDR pages
pip install tldr

#Download and install zotero
# move to /opt, then change ownership to allow updates. Make a symlink
sudo ln -s /opt/Zotero_linux-x86_64/zotero /usr/bin/zotero
# BEFORE SYNC
# Install zotfile extension
# Change custom location in general settings (for pdfs)
# Advance settings choose always rename.
# Now on regular zotero preferences, uncheck automatic snapshots.
# In sync, syn autmatic and full text should be checked. UNCHECK two option of sycn atachments.
# In advanced, set base directory to the same as in zotfile. Leave data dir alone.

# A better du, disk space analyzer
sudo apt-get install ncdu
