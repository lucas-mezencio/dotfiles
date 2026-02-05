# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export KUBECONFIG=~/.kube/config
export KUBE_EDITOR="nvim"
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
export PATH=$PATH:$HOME/.local/bin



ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

fpath=(/opt/vagrant/embedded/gems/gems/vagrant-2.4.7/contrib/zsh $fpath)
fpath=(~/.zsh/completions $fpath)

# Load completitions
autoload -U compinit && compinit
zinit cdreplay -q

# Aliases
alias k=kubectl
alias vim='nvim'
alias c='clear'
alias bat='batcat'
alias lg='lazygit'
if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias la='eza -la --icons=auto'
  alias lt='eza --tree --level=2 --icons'
else
  alias ls='ls --color=auto'
  alias la='ls -la'
fi

# Shell integrations
# Sources
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)
[ -f ~/.local/share/bob/env/env.sh ] && source ~/.local/share/bob/env/env.sh
[ -f ~/.cargo/env ] && source $HOME/.cargo/env
[ -f ~/.envs/env ] && source $HOME/.envs/env

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
  # Se quiser o comportamento do 'zd' que você tinha no bash:
  alias cd='z'
  alias zi='z -i' # Busca interativa com fzf
fi

eval "$(ssh-agent -s)" > /dev/null

source <(kubectl completion zsh)

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/lucas/.lmstudio/bin"
# End of LM Studio CLI section

