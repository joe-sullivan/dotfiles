# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
else
	alias ls='ls -G'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

man() { # colored man output
	LESS_TERMCAP_md=$'\e[01;31m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_se=$'\e[0m' \
	LESS_TERMCAP_so=$'\e[01;44;33m' \
	LESS_TERMCAP_ue=$'\e[0m' \
	LESS_TERMCAP_us=$'\e[01;32m' \
	command man "$@"
}

eval "$(thefuck --alias)"

take() { # make path and go into
	mkdir -p "$1";
	cd "$1"
}

alias psg='ps -ef | grep '

alias root='sudo -sE'

alias watch='watch -c'

alias sshconfig="vim ~/.ssh/config"
alias bashrc="vim ~/.bash_profile"
alias realias='source ~/.bash_aliases'
alias reload='source ~/.bash_profile'

# ===== Platform Dependent =====
case "$(uname -s)" in
	Darwin)
		# Add an "alert" alias for long running commands.  Use like so:
		#   sleep 10;alert
		alias alert='terminal-notifier -title "$([ $? -eq 0 ] && echo Complete || echo Error)" -message "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
		;;
	Linux)
		# open things more easily
		alias open='xdg-open &> /dev/null'

		# Add an "alert" alias for long running commands.  Use like so:
		#   sleep 10; alert
		alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
		;;
esac
