
# If not running interactively, don't do anything
case $- in
	*i*) ;;
		*) return;;
esac

# ===== History =====
HISTCONTROL=ignoreboth       # don't duplicate lines

shopt -s histappend          # append to the history file, don't overwrite it

HISTSIZE=1000                # number of commands store in current session
HISTFILESIZE=2000            # number of commands to store between sessions


# ===== Terminal Window Stuff =====
shopt -s checkwinsize        # if necessary, update values of LINES and COLUMNS

# ===== Make Less More Friendly =====
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ===== Prompt =====
function prompt_command { # context sensitive prompt
	# change symbol color based on exit code of last command (this must be first!)
	local status=$([[ $? -eq 0 ]] && tput setaf 2 || tput setaf 3)

	# -- default symbol --
	local symbol="λ"

	# -- colors --
	local black=$(tput setaf 0)
	local red=$(tput setaf 1)
	local green=$(tput setaf 2)
	local yellow=$(tput setaf 3)
	local blue=$(tput setaf 4)
	local magenta=$(tput setaf 5)
	local cyan=$(tput setaf 6)
	local white=$(tput setaf 7)
	local reset=$(tput sgr0)

	# -- symbol modifiers --
	# if git directory (other than home) then change symbol
	if [[ $PWD != ~ && -d .git ]]; then
		local changed=$(git diff-index --name-only HEAD -- 2> /dev/null)
		local status=$([[ $changed ]] && tput setaf 1 || tput setaf 2)
		local symbol=" "
		# INFO: how to get git character
		# 1. install FontAwesome (http://fortawesome.github.io/Font-Awesome)
		# 2. run: fc-cache -fv ~/.local/share/fonts
		# 3. create ~/.fonts.conf file to setup fallback font
		# more: https://github.com/gabrielelana/awesome-terminal-fonts
	fi

	# python virtual environment
	if [[ $VIRTUAL_ENV ]]; then
		local status=$blue
	fi

	# root user (this should overwrite all other symbols)
	if [ $(id -u) -eq 0 ]; then
		case "$(uname -s)" in
			Darwin) # apple
				local symbol=""
				;;
			Linux) # tux
				local symbol=""
				;;
			*) # skull and crossbones
				local symbol="☠"
				;;
		esac
	fi

	# -- the prompt --
	PS1="\[${magenta}\]\w \[${reset}\]\[${status}\]${symbol}\[${reset}\] "

	# -- prompt modifiers --
	# show hostname if using ssh
	if [[ $SSH_CLIENT ]]; then
		PS1="\[${cyan}\][\h]\[${reset}\]:$PS1"
	fi
}
PROMPT_COMMAND=prompt_command # ~ λ

# ===== Alias definitions =====
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# ===== Completion =====
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
			. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi
# SSH auto-completion based on entries in known_hosts and config file
_complete_ssh_hosts () {
	COMPREPLY=()
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local comp_ssh_hosts=$(
		cat ~/.ssh/known_hosts | \
			cut -f 1 -d ' ' | \
			sed -e s/,.*//g | \
			grep -v ^# | \
			uniq | \
			grep -v "\[" ;
		cat ~/.ssh/config | \
			grep "^Host " | \
			awk '{print $2}' | \
			grep -v "*"
	)
	COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
	return 0
}
complete -F _complete_ssh_hosts ssh
