set cmd_notification_threshold 5000

function have_focus
    # sadly no generic wayland way of querying this
    if test -n "$NIRI_SOCKET"
        set focused_pid (niri msg --json focused-window | jq -r '.pid // empty')
        test -n "$(pstree -p $fish_pid | grep "$focused_pid" | grep -v grep)"
    else if test "$XDG_SESSION_TYPE" = "x11"
        test "$(xdotool getwindowfocus)" -eq "$WINDOWID"
    else
        return 0
    end
end

function fish_prompt --description 'Write out the prompt'
    set cmd_status $status
    if test $CMD_DURATION -ge $cmd_notification_threshold; and not have_focus
      set cmd_seconds (echo "$CMD_DURATION/1000" | bc)
      set duration_formatted $(date -u -d @$cmd_seconds +"%Hh %Mm %Ss" | sed -E 's/00[a-z] //g' | sed -E 's/(^|\s)0/\1/g')
      notify-send $history[1] 'Finished in '$duration_formatted'\nExit status '$cmd_status
      set CMD_DURATION 0
    end

    #add blank line
    echo ""

    set -l last_status $status
    set -l normal (set_color normal)
    set -l status_color (set_color brgreen)
    set -l cwd_color (set_color $fish_color_cwd)
    set -l vcs_color (set_color brpurple)
    set -l prompt_status ""

    # Since we display the prompt on a new line allow the directory names to be longer.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    # Color the prompt differently when we're root
    set -l suffix '❯'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set cwd_color (set_color $fish_color_cwd_root)
        end
        set suffix '#'
    end

    # Color the prompt in red on error
    if test $last_status -ne 0
        set status_color (set_color $fish_color_error)
        set prompt_status $status_color "[" $last_status "]" $normal
    end

    echo -s (prompt_login) ' ' $cwd_color (prompt_pwd) $vcs_color (fish_vcs_prompt) $normal ' ' $prompt_status
    

    # EDIT
    switch $fish_bind_mode
    case default
        set_color --bold red
        set mode_ind 'N '
    case insert
        set_color --bold green
        set mode_ind 'I '
    case replace
    case replace_one
        set_color --bold green
        set mode_ind 'R '
    case visual
        set_color --bold brmagenta
        set mode_ind 'V '
    case '*'
        echo $fish_bind_mode
        set_color --bold red
        set mode_ind '? '
    end
    echo -n -s $mode_ind $status_color $suffix ' ' $normal
end
