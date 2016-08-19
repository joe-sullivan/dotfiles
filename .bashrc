
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
	local exit_status=$([[ $? -eq 0 ]] && tput setaf 2 || tput setaf 3)
	local symbol="\[${exit_status}\]λ" # default symbol

	# colors
	local black=$(tput setaf 0)
	local red=$(tput setaf 1)
	local green=$(tput setaf 2)
	local yellow=$(tput setaf 3)
	local blue=$(tput setaf 4)
	local magenta=$(tput setaf 5)
	local cyan=$(tput setaf 6)
	local white=$(tput setaf 7)
	local reset=$(tput sgr0)

	# if git directory (other than home) then change symbol
	if [[ $PWD != ~ && -d .git ]]; then
		local changed=$(git diff-index --name-only HEAD -- 2> /dev/null)
		local git_status=$([[ $changed ]] && tput setaf 1 || tput setaf 2)
		local symbol="\[${git_status}\] "
		# INFO: how to get git character
		# 1. install FontAwesome (http://fortawesome.github.io/Font-Awesome)
		# 2. run: fc-cache -fv ~/.local/share/fonts
		# 3. create ~/.fonts.conf file to setup fallback font
		# more: https://github.com/gabrielelana/awesome-terminal-fonts
	fi

	# show hostname if using ssh
	if [[ $SSH_CLIENT ]]; then
		local host="\[${cyan}\][\h]\[${reset}\]:"
	fi

	# root user (this should overwrite all other symbols)
	if [ $(id -u) -eq 0 ]; then
		case "$(uname -s)" in
			Darwin) # apple
				local symbol="\[${exit_status}\]"
				;;
			Linux) # tux
				local symbol="\[${exit_status}\]"
				;;
			*) # skull and crossbones
				local symbol="\[${exit_status}\]☠"
				;;
		esac
	fi

	PS1="$host\[${magenta}\]\w \[${reset}\]${symbol}\[${reset}\] "
}
PROMPT_COMMAND=prompt_command # [~]λ

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
