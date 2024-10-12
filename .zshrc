export LANG=en_US.UTF-8
export STARSHIP_CONFIG=~/.dotfiles/starship.toml
# ------------------------------------ PLUGIN SETUP ------------------------------------
eval "$(starship init zsh)"
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# ------------------------------------ HISTORY SETUP ------------------------------------
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify


# ------------------------------------ ALIAS SETUP ------------------------------------
alias ls="eza --icons=always --all --long --no-user"
alias ws="cd /Users/artsmp/Documents/workspace"
alias ss="cd /Users/artsmp/Documents/studyspace"
alias c="cursor"
alias zsh="c ~/.zshrc"
alias pn="pnpm"
alias d="nr dev"
alias b="nr build"
alias t="nr test"
alias cat="bat"
alias gcp="git cherry-pick"
alias gaa="git add ."
alias gcm="git commit -m"
alias gpl="git pull"
alias gps="git push"
alias gc="git clone"
alias gcam='git add -A && git commit -m'
alias gcvm='git add -A && git commit --no-verify -m'
alias gfrb='git fetch origin && git rebase origin/master'
alias bz='rm -rf dist.zip && rm -rf dist/ && pnpm run build:test && zip -r dist.zip dist'
# Go to project root
alias grt='cd "$(git rev-parse --show-toplevel)"'



# ------------------------------------ ZOXIDE (better cd) ------------------------------------
eval "$(zoxide init zsh)"
alias cd="z"


# ------------------------------------ FNM ------------------------------------
eval "$(fnm env --use-on-cd --shell zsh)"


# ------------------------------------ BAT (better cat) ------------------------------------
export BAT_THEME=tokyonight_night


# ------------------------------------ FZF ------------------------------------
source <(fzf --zsh)
# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"
export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
export FZF_COMPLETION_TRIGGER=''
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --max-depth 1 --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --max-depth 1 --hidden --strip-cwd-prefix --exclude .git"
# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --max-depth 1 --hidden --exclude .git . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --max-depth 1 --type=d --hidden --exclude .git . "$1"
}
source ~/fzf-git.sh/fzf-git.sh
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always --icons=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}


# ------------------------------------ THEFUCK ------------------------------------
eval $(thefuck --alias)
eval $(thefuck --alias fk)
# pnpm
export PNPM_HOME="/Users/artsmp/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
