# ~/.config/zsh/conf.d/pay-respects.zsh


# export _PR_SHELL=zsh

# Inicializa o pay-respects
if (( $+commands[pay-respects] )); then
    eval "$(pay-respects zsh --alias)"
fi