source /opt/homebrew/opt/kube-ps1/share/kube-ps1.sh
KUBE_PS1_PREFIX=''
KUBE_PS1_SUFFIX=''
KUBE_PS1_SYMBOL_ENABLE=false
KUBE_PS1_SYMBOL_PADDING=false
KUBE_PS1_SYMBOL_COLOR=''
KUBE_PS1_CTX_COLOR=''
KUBE_PS1_NS_COLOR=''
KUBE_PS1_PREFIX_COLOR=''
KUBE_PS1_SYMBOL_COLOR=''	
KUBE_PS1_SUFFIX_COLOR=''
KUBE_PS1_NS_COLOR=''
KUBE_PS1_BG_COLOR=''

function theme_precmd {
  local TERMWIDTH=$(( COLUMNS - ${ZLE_RPROMPT_INDENT:-1} ))

  PR_FILLBAR=""
  PR_PWDLEN=""

  KUBE_INFO=$(kube_ps1)
  KUBE_INFO=$KUBE_INFO:gs/%{%f%}/
  DATE_INFO=$(date)

  local promptsize=${#${(%):---(@ .$KUBE_INFO @ .$CONDA_DEFAULT_ENV @ $DATE_INFO)---()--}}
  local rubypromptsize=${#${(%)$(ruby_prompt_info)}}
  local pwdsize=${#${(%):-%~}}

  # Truncate the path if it's too long.
  if (( promptsize + rubypromptsize + pwdsize > TERMWIDTH )); then
    (( PR_PWDLEN = TERMWIDTH - promptsize ))
  elif [[ "${langinfo[CODESET]}" = UTF-8 ]]; then
    PR_FILLBAR="\${(l:$(( TERMWIDTH - (promptsize + rubypromptsize + pwdsize) ))::${PR_HBAR}:)}"
  else
    PR_FILLBAR="${PR_SHIFT_IN}\${(l:$(( TERMWIDTH - (promptsize + rubypromptsize + pwdsize) ))::${altchar[q]:--}:)}${PR_SHIFT_OUT}"
  fi
}

function theme_preexec {
  setopt local_options extended_glob
  if [[ "$TERM" = "screen" ]]; then
    local CMD=${1[(wr)^(*=*|sudo|-*)]}
    echo -n "\ek$CMD\e\\"
  fi
}




autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd
add-zsh-hook preexec theme_preexec


# Set the prompt

# Need this so the prompt will work.
setopt prompt_subst

# See if we can use colors.
autoload zsh/terminfo
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE GREY; do
  typeset -g PR_$color="%{$terminfo[bold]$fg[${(L)color}]%}"
  typeset -g PR_LIGHT_$color="%{$fg[${(L)color}]%}"
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

# Modify Git prompt
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} %{%G✚%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} %{%G✹%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} %{%G✖%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} %{%G➜%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} %{%G═%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} %{%G✭%}"

# Use extended characters to look nicer if supported.
if [[ "${langinfo[CODESET]}" = UTF-8 ]]; then
  PR_SET_CHARSET=""
  PR_HBAR="─"
  PR_ULCORNER="┌"
  PR_LLCORNER="└"
  PR_LRCORNER="┘"
  PR_URCORNER="┐"
else
  typeset -g -A altchar
  set -A altchar ${(s..)terminfo[acsc]}
  # Some stuff to help us draw nice lines
  PR_SET_CHARSET="%{$terminfo[enacs]%}"
  PR_SHIFT_IN="%{$terminfo[smacs]%}"
  PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
  PR_HBAR="${PR_SHIFT_IN}${altchar[q]:--}${PR_SHIFT_OUT}"
  PR_ULCORNER="${PR_SHIFT_IN}${altchar[l]:--}${PR_SHIFT_OUT}"
  PR_LLCORNER="${PR_SHIFT_IN}${altchar[m]:--}${PR_SHIFT_OUT}"
  PR_LRCORNER="${PR_SHIFT_IN}${altchar[j]:--}${PR_SHIFT_OUT}"
  PR_URCORNER="${PR_SHIFT_IN}${altchar[k]:--}${PR_SHIFT_OUT}"
fi

# Decide if we need to set titlebar text.
case $TERM in
  xterm*)
    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
    ;;
  screen)
    PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
    ;;
  *)
    PR_TITLEBAR=""
    ;;
esac

# Decide whether to set a screen title
if [[ "$TERM" = "screen" ]]; then
  PR_STITLE=$'%{\ekzsh\e\\%}'
else
  PR_STITLE=""
fi


# Finally, the prompt.
PROMPT='${PR_SET_CHARSET}${PR_STITLE}${(e)PR_TITLEBAR}\
${PR_CYAN}${PR_ULCORNER}${PR_HBAR}${PR_GREY}(\
${PR_GREEN}%${PR_PWDLEN}<...<%~%<<\
${PR_GREY})$(ruby_prompt_info)${PR_CYAN}${PR_HBAR}${PR_HBAR}${(e)PR_FILLBAR}${PR_HBAR}${PR_GREY}(\
☸️  ${PR_CYAN}$(kube_ps1) 🐍${PR_CYAN} $CONDA_DEFAULT_ENV 📅 ${PR_YELLOW}$(date)\
${PR_GREY})${PR_CYAN}${PR_HBAR}${PR_URCORNER}\

${PR_CYAN}${PR_LLCORNER}${PR_BLUE}${PR_HBAR}(\
${PR_LIGHT_BLUE}%{$reset_color%}$(git_prompt_info)$(git_prompt_status)${PR_BLUE})${PR_CYAN}${PR_HBAR}\
${PR_HBAR}\
>${PR_NO_COLOUR} '

# display exitcode on the right when > 0
return_code="%(?..%{$fg[red]%}%? ↵ %{$reset_color%})"
RPROMPT=' $return_code'

PS2='${PR_CYAN}${PR_HBAR}\
${PR_BLUE}${PR_HBAR}(\
${PR_LIGHT_GREEN}%_${PR_BLUE})${PR_HBAR}\
${PR_CYAN}${PR_HBAR}${PR_NO_COLOUR} '
