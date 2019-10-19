function fish_right_prompt --description 'Write out the right prompt'
    for color in $fish_color_error
        # If any of the colour variables aren't defined they're set to 'normal' colour

        if set -q color
            set color normal
        end
    end

    set color normal
    language_prompt
    set color normal
    echo -sn " "

    set -l status_copy $status
    set -l status_color 0fc

    if test "$status_copy" -ne 0
        set status_color $fish_color_error
    end

    if test -n "$CMD_DURATION" -a "$CMD_DURATION" -gt 100
        set -l duration_copy $CMD_DURATION
        set -l duration (echo $CMD_DURATION | humanize_duration)

        echo -sn (set_color $status_color) "$duration" (set_color normal)

    else if set -l last_job_id (jobs -l | command awk '/^[0-9]+\t/ { print pid = $2 } END { exit !pid }')
        echo -sn (set_color $status_color) "%$last_job_id" (set_color normal)
    else
        echo -sn (set_color 555) (date "+%H:%M") (set_color normal)
    end
end
