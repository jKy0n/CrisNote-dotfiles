# Modo de edição (emacs ou vi)
bindkey -e  # Usando modo emacs

# Navegação em linhas
bindkey "^[[H"  beginning-of-line    # Home
bindkey "^[[F"  end-of-line          # End
bindkey "^[[3~" delete-char          # Delete

# Navegação por palavras
bindkey "^[[1;5D" backward-word      # Ctrl + ←
bindkey "^[[1;5C" forward-word       # Ctrl + →

# Atalhos específicos
bindkey "^H"    backward-kill-word    # Alt + Backspace
bindkey "^[[1;3B" menu-complete        # Alt + ↓ (rotação de completions)
bindkey "^[^[[C"  autosuggest-accept   # Aceitar sugestão (→)