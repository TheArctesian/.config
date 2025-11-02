# ==============================
# Fish Configuration
# ==============================

# Paths
fish_add_path $HOME/.local/bin

# Environment Variables
set -gx EDITOR nvim
set -gx VISUAL nvim

# OMF 
set -g theme_nerd_fonts yes
set -g theme_color_scheme nord
# Initialize tools
starship init fish | zoxide init fish | source

# ==============================
# Greeting & Appearance
# ==============================
function fish_greeting
    # Set random wallpaper from nord collection
    ~/.config/hypr/scripts/random-wallpaper.sh
    # Display system info
    pfetch
end

# ==============================
# Aliases - General
# ==============================
alias vim="nvim"
alias cls="clear"
alias p="ping -c 3 gentoo.org"
alias py="python3"
alias server="browser-sync start -s -f . --no-notify --host $LOCAL_UP --port 9000"
alias clok="tty-clock -c -C 4 -S"
alias zel="zellij --layout ~/.config/zellij/pro.kdl $argv"
alias xel="zellij --layout ~/.config/zellij/codex.kdl $argv"


# Function to copy file contents to clipboard
function copy
    if test (count $argv) -eq 0
        echo "Usage: copy [filename]"
        return 1
    end

    set -l filename $argv[1]

    if not test -f $filename
        echo "Error: '$filename' is not a file"
        return 1
    end

    # Copy file contents to clipboard
    cat $filename | wl-copy

    echo "Copied contents of '$filename' to clipboard"
end
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# Paste clipboard content to a file (replacing entire file)
function past
    if test (count $argv) -eq 0
        echo "Usage: past [filename]"
        return 1
    end

    # Create backup of the original file if it exists
    set -l filename $argv[1]
    if test -f $filename
        set -l backup $filename.bak
        cp $filename $backup
        echo "Backup saved as $backup"
    end

    # Get clipboard content using wl-paste and write to file
    wl-paste > $filename
    
    # Ensure file is properly written by syncing filesystem
    sync
    
    # Display the file content with bat
    echo "Content pasted to $filename:"
end

# Function to copy directory contents to clipboard
function copydir
    if test (count $argv) -eq 0
        echo "Usage: copydir [directory]"
        return 1
    end

    set -l target_dir $argv[1]
    
    if not test -d $target_dir
        echo "Error: '$target_dir' is not a directory"
        return 1
    end

    # Create a temporary file
    set -l temp_file (mktemp)
    
    # Find all files recursively and process them
    fd --type f . $target_dir | sort | while read -l file
        # Get relative path to make header cleaner
        set -l rel_path (realpath --relative-to=(pwd) $file)
        
        # Add file header with name and extension
        echo "# $rel_path" >> $temp_file
        
        # Add file content
        cat $file >> $temp_file
        
        # Add newline separator
        echo "" >> $temp_file
    end

    # Copy to clipboard using wl-copy
    cat $temp_file | wl-copy
    
    # Count files processed
    set -l file_count (fd --type f . $target_dir | wc -l)
    echo "Copied contents of $file_count files from '$target_dir' to clipboard"
    
    # Clean up
    rm $temp_file
end
# ==============================
# Aliases - Improved CLI Tools
# ==============================
# alias ls="exa"
alias ls="lsd"
alias cat="bat -p"
alias curl="xh"
alias tmux="zellij"
alias du="dust"
alias find="fd"
alias cowsay="neo-cowsay"
alias cp="xcp"

# ==============================
# Aliases - Directory Shortcuts
# ==============================
alias down="cd $HOME/Downloads"
alias conf="cd $HOME/.config"

# Documents
alias sec="cd $HOME/Second\ Brain/"
alias uni="cd $HOME/Second\ Brain/Uni/"

# Scripts
alias skl="cd $HOME/Scripts/School"
alias per="cd $HOME/Scripts/Personal"
alias wrk="cd $HOME/Scripts/Work"
alias pro="cd $HOME/Scripts/Project"
alias org="cd $HOME/Scripts/Organising"

# ==============================
# Aliases - Nix OS
# ==============================

alias nixconf="sudo vim /etc/nixos/configuration.nix"
alias nixrs="sudo nixos-rebuild switch --flake /etc/nixos#nixos"
alias nixrsug="sudo nixos-rebuild switch --upgrade"
alias nixclean="sudo nix-collect-garbage -d --delete-older-than 10d"
alias nixup="sudo nix-channel --update"
alias svim="sudo vim"
# ==============================
# Aliases - Git
# ==============================
alias pull="git pull"
alias pus="git push"

