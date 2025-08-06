# ==============================
# Fish Configuration
# ==============================

# Paths
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.spicetify
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.emacs.d/bin

# Initialize tools
starship init fish | zoxide init fish | source

# ==============================
# Greeting & Appearance
# ==============================
function fish_greeting
    pfetch
    feh --bg-fill --randomize $HOME/Pictures/wallpaper/*
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
alias copy="xclip -sel c <"
alias zel="zellij --layout ~/.config/zellij/pro.kdl $argv"

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

    # Get clipboard content
    set -l clipboard_content (xclip -sel c -o)
    
    # Write to file
    echo $clipboard_content > $filename
    
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

    # Copy to clipboard
    cat $temp_file | xclip -sel c
    
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

# ==============================
# Aliases - Nix OS
# ==============================

alias nixconf="sudo vim /etc/nixos/configuration.nix"
alias nixrs="sudo nixos-rebuild switch"
alias nixrsug="sudo nixos-rebuild switch --upgrade"
alias nixclean="sudo nix-collect-garbage -d --delete-older-than 10d"
alias nixup="sudo nix-channel --update"
alias svim="sudo vim"
# ==============================
# Aliases - Git
# ==============================
alias pull="git pull"
alias pus="git push"

# ==============================
# Aliases - Applications
# ==============================
alias doom="$HOME/.emacs.d/bin/doom"
