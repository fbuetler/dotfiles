#!/usr/bin/env zsh

reload() {
    source ~/.zshrc
    source ~/.zshenv
}

brewit() {
    brew update &&
        brew upgrade &&
        brew autoremove &&
        brew cleanup -s &&
        brew doctor
}

# Parse unix epoch to ISO date
epoch() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        date --date "@$1" +"+%Y-%m-%dT%H:%M:%SZ"
    else
        date -r "$1" '+%Y-%m-%dT%H:%M:%SZ'
    fi
}

rand() {
    openssl rand -base64 "${1:-10}"
}

# Fzf all folders and cd on selection
cdi() {
    p="$(fd -t d -H | fzf)"
    if [ -n "$p" ]; then
        cd "$p"
    fi
}

# Compare json files
jsondiff() {
    delta <(jq --sort-keys . $1) <(jq --sort-keys . $2)
}

jwt-decode() {
    jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<<$1
}

# Print commits with URLs to github
ghhist() {
    local remote="$(git remote -v | awk '/^origin.*\(push\)$/ {print $2}')"
    [[ "$remote" ]] || return
    local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
    git log $* --name-status --color | awk "$(
        cat <<AWK
    /^.*commit [0-9a-f]{40}/ {sha=substr(\$2,1,7)}
    /^[MA]\t/ {printf "%s\thttps://github.com/$user_repo/blob/%s/%s\n", \$1, sha, \$2; next}
    /.*/ {print \$0}
AWK
    )" | less -F
}

# Go to repository root folder
gitroot() {
    root="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [ -n "$root" ]; then
        cd "$root"
    else
        echo "Not in a git repository"
    fi
}

kwatch() {
    watch -n 1 -d "kubectl get $1 | rg $2"
}

kcm() {
    if [ -z "$1" ]; then
        echo "No config-map supplied. \nUsage: $funcstack[1] <cm>"
    else
        kubectl get configmap "$1" \
            -o go-template='{{range $k, $v := .data }}export {{$k}}={{$v}}{{"\n"}}{{end}}'
    fi
}

dstop-all() {
    docker stop $(docker ps -aq)
}

drm-all() {
    docker rm $(docker ps -aq)
}

# Aliases
alias cat="bat --style=plain --paging=never --theme='TwoDark'"
alias duu="dust --no-percent-bars --reverse --ignore-directory '.git'"
alias tree="eza --tree --level=5 --group-directories-first --color auto"
alias k="kubectl"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'
