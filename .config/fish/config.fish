set -g fish_greeting

if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source 
    starship init fish | source

    set -gx EDITOR nvim

    alias ls='eza -A --icons=auto --group-directories-first'

    abbr .. 'cd ..'
    abbr mkdir 'mkdir -p'
    alias s='z'
    alias zed="zeditor"
end

