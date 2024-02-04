if status is-interactive
    # change default greeting
    function fish_greeting
        #echo "\
#⠀⠀⠀⠀⠀⠀⠀⢠⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣦⠀⠀⠀⠀⠀⠀⠀⠀⢺⣷⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⢸⣿⡄⠀⠀⠀⠀⠀⠀⠀⢸⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡆⠀⠀⠀⠀⠀⠀⠀⣾⣿⠁⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠘⣿⣧⡀⠀⠀⠀⠀⠀⢠⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣷⡀⠀⠀⠀⠀⠀⣰⣿⡟⠀⠀⠀⠀⠀⠀⠀
#⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣷⣄⡀⠀⢀⣴⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣦⣀⠀⣀⣴⣿⠟⠀⠀⢀⣀⣀⡀⠀⠀
#⠀⢀⠴⠒⠉⠉⠉⠲⢄⠈⠻⢿⣿⣿⣿⡿⠟⠁⠀⠀⢠⡆⠀⠀⠀⠀⠀⠀⢰⣶⠀⠀⠀⠀⠙⠿⣿⣿⡿⠟⠋⣠⠔⠊⠁⠀⠀⠈⠲⡄
#⢠⠃⠀⠀⠀⠀⠀⠀⠀⠱⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠀⢠⣤⡀⢀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠘
#⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣷⣴⣿⢿⣿⣾⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀
#⢀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠁⠀⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⡰
#⠈⠢⠀⠀⠀⠀⠀⣀⠔⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⢄⡀⠀⠀⠀⡠⠔⠁
#" # | lolcat
    end
    # remove default vi mode prompt
    function fish_mode_prompt; end
    # Commands to run in interactive sessions can go here

    fish_vi_key_bindings
    #fish_default_key_bindings

    # Set the normal and visual mode cursors to a block
    set fish_cursor_default block
    # Set the insert mode cursor to a line
    set fish_cursor_insert line
    # Set the replace mode cursor to an underscore
    set fish_cursor_replace_one underscore

    alias ll="eza --icons -la --group-directories-first"
    alias emacs="emacsclient -c -a 'emacs'"
    alias drive="rclone mount --daemon --vfs-cache-mode full martijn-google-drive:/ ~/Documents/drive/"
    set -gx EDITOR nvim

    export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
    export PATH="$PATH:$HOME/.config/emacs/bin"
    #starship init fish | source
    #should be at the eof
    zoxide init fish | source
end

