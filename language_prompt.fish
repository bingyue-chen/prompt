function language_prompt --description 'Write out language version prompt'
    # Language

    set -q language_prompt_last_pwd; or set -g language_prompt_last_pwd ""

    set __language_prompt \
        (php_prompt) \
        (laravel_prompt) \
        (node_prompt) \
        (golang_prompt) \
        (python_prompt)

    set -g language_prompt_last_pwd (pwd)
    
    echo (string join " " $__language_prompt)
end

function php_prompt
    type -q php; or return

    if not test -f composer.json \
        -o (count *.php) -gt 0
        return
    end

    if test $language_prompt_last_pwd != (pwd)
        set -g language_prompt_php_version (string replace "PHP " "" (php -v | grep -o "PHP [0-9][0-9.]*") 2> /dev/null)
    end

    set_color magenta
    echo -sn "PHP v" $language_prompt_php_version
    set_color normal
end

function laravel_prompt
    type -q php; or return

    if not test -f artisan
        return
    end

    if test $language_prompt_last_pwd != (pwd)
        set -g language_prompt_laravel_version (php artisan -V | grep -o "[0-9][0-9.]*" 2> /dev/null)
    end

    set_color magenta
    echo -sn "LARAVEL v" $language_prompt_laravel_version
    set_color normal
end

function node_prompt
    type -q node; or return

    if not test -f ./package.json \
        -o -d ./node_modules \
        -o (count *.js) -gt 0
        return
    end

    if test $language_prompt_last_pwd != (pwd)
        set -g language_prompt_node_version (node -v 2>/dev/null)
    end

    set_color magenta
    echo -sn "NODE " $language_prompt_node_version
    set_color normal
end

function golang_prompt
    type -q go; or return

    if not test -f ./go.mod \
        -o -f ./vendor/vendor.json \
        -o (count *.go) -gt 0
        return
    end

    if test $language_prompt_last_pwd != (pwd)
        set -g language_prompt_go_version (string replace "go" "" (go version | cut -d ' ' -f 3) 2> /dev/null)
    end

    set_color magenta
    echo -sn "GO " $language_prompt_go_version
    set_color normal
end

function python_prompt
    type -q python3; or return

    if not test (count *.py) -gt 0 \
        -o -f ./.style.yapf
        return
    end

    if test $language_prompt_last_pwd != (pwd)
        set -g language_prompt_python_version (python3 -V | cut -d ' ' -f 2 2> /dev/null)
    end

    set_color magenta
    echo -sn "PYTHON v" $language_prompt_python_version
    set_color normal
end

