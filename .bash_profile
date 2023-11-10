# Set up Guix Home profile
if [ -f ~/.profile ]; then . ~/.profile; fi

# Honor per-interactive-shell startup file
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

# Merge search-paths from multiple profiles, the order matters.
eval "$(guix package --search-paths \
-p $HOME/.config/guix/current \
-p $HOME/.guix-profile \
-p $HOME/.guix-home/profile \
-p /run/current-system/profile)"

# Prepend setuid programs.
export PATH=/run/setuid-programs:$PATH

export XDG_DATA_DIRS="$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share"
export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share"
