#!/usr/bin/env bash
# filepath: /home/jkyon/.config/awesome/autorun.sh

# Lista de aplicativos e seus comandos de inicialização
APPS=(
    "picom -b"
    "xfce4-clipman"
    "libinput-gestures"
    "light-locker"
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
)

# Função que inicia o aplicativo se ele não estiver em execução
start_app() {
    local app_cmd="$1"
    # Captura o nome do executável (primeiro token do comando)
    local proc_name
    proc_name=$(echo "$app_cmd" | awk '{print $1}')
    
    if pgrep -x "$(basename "$proc_name")" > /dev/null; then
        echo "$proc_name já está em execução."
    else
        echo "Iniciando $proc_name..."
        eval "$app_cmd" &
    fi
}

# Itera sobre a lista e inicia cada aplicativo
for app in "${APPS[@]}"; do
    start_app "$app"
done

exit 0