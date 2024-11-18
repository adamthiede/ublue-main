#!/bin/sh
# mine
rpm-ostree override remove \
	firefox firefox-langpacks \
	virtualbox-guest-additions \
	nano nano-default-editor \
	gnome-software plocate \
	yelp gnome-tour \
	--install vim-default-editor

rpm-ostree install mpv ffmpeg yt-dlp \
	fzf git curl htop neovim vim tmux go \
	wl-clipboard w3m aerc bemenu \
	android-tools aria2 btop cargo rust discount \
	fastfetch flashrom imv isync \
	jq keepassxc mosh mousepad mpc ncmpcpp \
	ncdu nethack newsboat nmap rsync seahorse \
	gvfs-nfs virt-manager \
	waybar river alacritty bemenu j4-dmenu-desktop \
	NetworkManager-tui syncthing tailscale
