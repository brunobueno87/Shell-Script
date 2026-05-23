# Adicione isso no final do seu ~/.bashrc para que você consiga ver no seu terminal
# a branch atual que você esta atuando, data e hora corrente e em caso de estar ussando/administrando
# clusters kubernetes ele mostra em qual cluster você esta "pendurado"
###MINHAS MODIFICACOES

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


_update_ps1() {
  # ANSI color codes
  RED='\[\033[0;31m\]'
  GREEN='\[\033[0;32m\]'
  YELLOW='\[\033[0;33m\]'
  BLUE='\[\033[0;34m\]'
  MAGENTA='\[\033[0;35m\]'
  CYAN='\[\033[0;36m\]'
  RESET='\[\033[0m\]'

  # Date/time
  date_time=$(date "+%d/%m/%Y %H:%M:%S")

  # Kubernetes context
  if command -v kubectl &>/dev/null; then
    kube_context=$(kubectl config current-context 2>/dev/null || echo "none")
    kube_namespace=$(kubectl config view --minify --output jsonpath="{..namespace}" 2>/dev/null || echo "default")
    kube_info="${kube_context}:${kube_namespace}"
  else
    kube_info=""
  fi

  # Git branch
  if git rev-parse --git-dir &>/dev/null; then
    git_branch=" ($(git rev-parse --abbrev-ref HEAD 2>/dev/null))"
  else
    git_branch=""
  fi

  # First line: date/time and kube context
  PS1="${RED}${date_time} ${CYAN}[${kube_info}]${RESET}\n"
  # Second line: user@host, current dir, git branch
  PS1+="${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}${YELLOW}${git_branch}${RESET} \$ "
}
PROMPT_COMMAND=_update_ps1
