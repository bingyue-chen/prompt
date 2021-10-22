function fish_prompt --description 'Write out the prompt'
    # Make a local copy of the status code of last command. This should be first thing in the script.
    set -l status_copy $status

    # If any of the colour variables aren't defined they're set to 'normal' colour
    for color in $fish_color_cwd $fish_color_cwd_root $fish_color_error $fish_color_host $fish_color_operator $fish_color_user
        if set -q color
            set color normal
        end
    end

    # Reset color
    set_color normal

    # Prefix symbol
    echo -esn "❄ "

    # Switch colour variables based on current user
    switch $USER
        case root
        set_color $fish_color_cwd_root
        case "*"
        set_color $fish_color_cwd
    end
    echo -sn (prompt_pwd)

    # Git information if cwd is a git repo
    if set -l branch_name (git_branch_name)
        set -l git_glyph " ⎮ "
        set -l branch_glyph
        # Using custom colours since there aren't defined variables for git stuff
        set -l branch_color 0fc -o

        if git_is_detached_head
            set git_glyph " detached "
        end

        if git_is_touched
            set branch_color cc3

            if git_is_staged
                if git_is_dirty
                    set branch_glyph " ±"
                else
                    set branch_glyph " +"
                end
            else
                set branch_glyph " *"
            end
        end

        if test (git_untracked_files) -gt 0
            set branch_glyph "$branch_glyph …"
        end

        set -l git_ahead (command git rev-list --left-right --count 'HEAD..master' 2> /dev/null | awk '
            $1 > 0 { printf("↑") }
            $2 > 0 { printf("↓") }
        ')

        if git_is_stashed
            set branch_name "{$branch_name}"
        end

        echo -sn (set_color fff) "$git_glyph" (set_color normal)
        echo -sn (set_color $branch_color) "$branch_name" (set_color normal)

        if test ! -z "$git_ahead"
            echo -sn (set_color fff) " $git_ahead" (set_color normal)
        end

        echo -sn (set_color fff) "$branch_glyph" (set_color normal)
    end
    set_color normal

    # Operator at the end to show the end of prompt
    set_color $fish_color_operator

    if test -n $fish_operator
        if test "$status_copy" -ne 0
            set_color red
            set fish_operator " ✗ "
        else
            set fish_operator " ⟩ "
        end
    end

    echo -sn $fish_operator
    set_color normal
end
