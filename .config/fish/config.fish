if status is-interactive
    # change default greeting
    function fish_greeting
    end
    # remove default vi mode prompt
    function fish_mode_prompt; end
    # Commands to run in interactive sessions can go here
    function up_dir
        cd ..
        fish_prompt
    end

    bind -M normal \cU up_dir
    bind -M insert \cU up_dir
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
    set -gx EDITOR nvim

    export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
    export PATH="$PATH:$HOME/.config/emacs/bin"
    export PATH="/usr/local/texlive/2024/bin/x86_64-linux:$PATH"
    zoxide init fish | source
end

