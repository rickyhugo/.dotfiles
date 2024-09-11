# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# HACK: prevent 'zsh-vi-mode' from overriding keybindings
ZVM_INIT_MODE=sourcing

# 📥
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# 🔌
zinit wait lucid for \
  Aloxaf/fzf-tab \
  OMZP::tmux \
  OMZP::git \
  OMZP::ubuntu \
  OMZL::directories.zsh \
  OMZL::theme-and-appearance.zsh

# NOTE: https://github.com/zdharma-continuum/fast-syntax-highlighting?tab=readme-ov-file#zinit
zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
    OMZP::colored-man-pages \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode

# 📦
zinit pack"default+keys" for fzf

# 💅
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ⚡
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias lzg='lazygit'
alias lzd='lazydocker'
alias cat='batcat'
alias up='aguu -y && agar -y'

# 📚
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

# ⚙️
export FZF_DEFAULT_COMMAND="rg -uu --files -H"
export FZF_PREVIEW_ADVANCED=true 
export FZF_COMPLETION_TRIGGER=';'

# ⏩
export PATH="$PATH:$HOME/.local/bin" # misc
export PATH="$HOME/.cargo/bin:$PATH" # rust

# 🧰
eval "$(zoxide init zsh)"
eval "$(~/.local/bin/mise activate zsh)"

# 🤖
# pnpm
export PNPM_HOME="/home/huen/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
