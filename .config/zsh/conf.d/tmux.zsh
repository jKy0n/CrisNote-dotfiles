# ~/.config/zsh/conf.d/tmux.zsh

# Inicia o tmux apenas se:
# 1. Estiver em um terminal interativo
# 2. Tmux estiver instalado
# 3. Não estiver dentro de uma sessão tmux
# 4. Estiver em um terminal "real" (não IDE/VSCode)
# if [[ -t 0 ]] && \
#    [[ -x "$(command -v tmux)" ]] && \
#    [[ -z "$TMUX" ]] && \
#    [[ $- == *i* ]] && \
#    [[ "$TERM_PROGRAM" != "vscode" ]]; then
   
#   # Gera nome da sessão numérico sequencial
#   session_number=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | 
#                   grep '^[0-9]\+$' | 
#                   sort -n | 
#                   tail -n 1 | 
#                   awk '{print $1 + 1}')
  
#   # Se não houver sessões numéricas, começa em 1
#   [[ -z "$session_number" ]] && session_number=1

#   # Cria nova sessão com tratamento de erros
#   if ! tmux new-session -s "$session_number" >/dev/null 2>&1; then
#     echo "Erro ao criar sessão tmux! Verifique:"
#     echo "1. Permissões do servidor tmux"
#     echo "2. Conflitos de nome de sessão"
#     echo "3. Versão do tmux (requer >= 2.4)"
#     echo "Carregando tmux.zsh"
#     echo "Terminal interativo"
#     echo "Tmux instalado"
#     echo "Não está dentro de uma sessão tmux"
#     echo "Terminal interativo (flag i)"
#     echo "Não está no VSCode"
#   fi
# fi

# Iniciar o Tmux automaticamente, se não estiver dentro de uma sessão
# if [[ -t 1 ]]; then
#     if command -v tmux >/dev/null 2>&1; then
#         if [[ -z "$TMUX" ]]; then
#             # Cria uma nova sessão numerada sempre
#             tmux new-session
#         fi
#     fi
# fi