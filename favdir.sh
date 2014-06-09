#!/bin/sh

# Only shell script for bash and zsh
if [ ! "$BASH_VERSION" -a ! "$ZSH_VERSION" ]; then
	echo "Require bash or zsh"
	exit
fi

# Declare and initialize a variable
declare favdir_dir="$HOME/.favdir"
declare favdir_list="$HOME/.favdir/favdirlist"
declare favdir_log="$HOME/.favdir/favdirlog"
declare favdir_temp="$HOME/.favdir/favdirtemp"
declare exit_usage=0

# Fix array index for ZSH
if [ "$ZSH_NAME" = "zsh" ];then
	setopt ksharrays
fi

function _favdir_usage() {
	local -i width
	width=$( stty 'size' <'/dev/tty' | cut -d' ' -f2 )
	local -a commands
	commands=('show' 'regist' 'go' 'print' 'delete')

	if [ $# -eq 0 ]; then
		echo -en "${commands[@]}\n\n"
		_favdir_usage "${commands[@]}" | ${PAGER:-less}
		return 0
	fi

	for list do
		echo -en "Usage: "
		case "$list" in
			'show')
				echo -en "show [OPTION]\n"
				echo -en "  Display all registered names and paths.\n"
				echo -en "  Need to run independently all options.\n\n"
				echo -en "Options:\n"
				echo -en "  -h, --help     display this help and exit\n"
				echo -en "  -e, --edit     edit bookmark list\n"
				echo -en "  -p, --plane    to output the bookmark list without a color\n"
				echo -en "  -R, --refresh  to update all the paths that are not valid\n\n"
				shift
				;;
			'regist')
				echo -en "reg [OPTION] [name]\n"
				echo -en "  If there is an argument, register by the argument name\n"
				echo -en "  and otherwise register it current directory name.\n\n"
				echo -en "Options:\n"
				echo -en "  -h, --help     display this help and exit\n"
				echo -en "  -t, --temp     generate the name and path as disposable element\n\n"
				shift
				;;
			'go')
				echo -en "go [name]\n"
				echo -en "  If there is an argument, go to the name of path\n"
				echo -en "  and otherwise do movement like 'show'.\n\n"
				echo -en "Options:\n"
				echo -en "  -h, --help     display this help and exit\n\n"
				shift
				;;
			'print')
				echo -en "p name\n"
				echo -en "  print the name of path.\n\n"
				echo -en "Options:\n"
				echo -en "  -h, --help     display this help and exit\n\n"
				shift
				;;
			'delete')
				echo -en "del name\n"
				echo -en "  Delete the registered name and path.\n\n"
				echo -en "Options:\n"
				echo -en "  -h, --help     display this help and exit\n\n"
				shift
				;;
		esac
		[ "$#" -ne 0 ] && for (( i=0; i<$width; i++ )); do
			echo -en "_"
		done && echo -en "\n\n"
	done

	return $exit_usage
}

function _favdir_initialize() {
	# If there is a directory,
	# the initialization function is not performed
	[ -d "$favdir_dir" ] && return 1

	local ans=
	mkdir -p "$favdir_dir"
	touch "$favdir_list" "$favdir_log" "$favdir_temp"

	unset ans 
	return 0
}

function _favdir_show() {
	[ -f "$favdir_list" ] || { echo "$(basename $favdir_list): no exist"; return 1; }

	local opt=
	for opt in "$@"
	do
		case "$opt" in
			'-h'|'--help' )
				_favdir_usage 'show'
				return $exit_usage
				;;
			'-e'|'--edit' )
				${EDITOR:-vi} $favdir_list
				shift 1
				return 0
				;;
			'-p'|'--plane' )
				cat $favdir_list | sed "s $HOME ~ g"
				shift 1
				return 0
				;;
			'-R'|'--refresh' )
				if _favdir_refresh; then
					return 0
				else
					return 1
				fi
				;;
			'--' )
				shift 1
				param+=( "$@" )
				break
				;;
			-*)
				echo "show: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
				return 1
				;;
			*)
				if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
					param+=( "$1" )
					shift 1
				fi
				;;
		esac
	done

	[ ! -f "$favdir_list" ] && touch "$favdir_list"
	[ ! -f "$favdir_log" ]  && touch "$favdir_log"
	[ ! -f "$favdir_temp" ] && touch "$favdir_temp"

	local -i i
	local -a fname
	fname=( `awk '{print $1}' "$favdir_list"` )
	local -a fpath
	fpath=( `awk '{print $2}' "$favdir_list"` )

	for (( i=0; i<${#fname[*]}; i++ )); do
		if grep -w "${fname[i]}" "$favdir_log" >/dev/null
		then
			printf "\033[31m%-15s\033[m%s\n" "${fname[i]}" "${fpath[i]}"

		elif grep -w "${fname[i]}" "$favdir_temp" >/dev/null
		then
			printf "\033[01;36m%-15s\033[m%s\n" "${fname[i]}" "${fpath[i]}"

		else
			printf "\033[33m%-15s\033[m%s\n" "${fname[i]}" "${fpath[i]}"
		fi
	done | sed "s $HOME ~ g"

	unset fname fpath i opt
}

function _favdir_regist() {
	[ -f $favdir_list ] || touch $favdir_list

	local opt=
	for opt in "$@"
	do
		case "$opt" in
			'-h'|'--help' )
				_favdir_usage 'regist'
				return $exit_usage
				;;
			'-t'|'--temp' )
				shift 1 
				local -i option_t=1
				;;
			'--' )
				shift 1
				param+=( "$@" )
				break
				;;
			-*)
				echo "reg: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
				return 1
				;;
		esac
	done

	local -i limit
	limit=$(( $( stty 'size' <'/dev/tty' | cut -d' ' -f1 ) - 2 ))
	[ $( wc -l <"$favdir_list" ) -ge "$limit" ] && {
		echo "The maximum number that can enroll in a bookmark list is $limit cases."
		return 1
	}

	local -i i=
	local fname=

	[ $# -eq 0 ] && fname=${PWD##*/} || fname="$1"
	[ ${#fname} -gt 14 ] && { echo "Please input 14 characters or less."; return 1; }

	if awk '{print $1}' "$favdir_list" | grep -w "$fname" >/dev/null; then
		echo "$fname: Already exist"
		return 1
	else
		[ "$option_t" ] && printf "%-15s%s\n" $fname "$PWD" >>$favdir_temp
		printf "%-15s%s\n" $fname "$PWD" >>$favdir_list
		return 0
	fi
	unset limit i fname opt option_t
}

function _favdir_go() {
	[ "$1" = "-h" ] || [ "$1" = "--help" ] && { _favdir_usage 'go'; return $exit_usage; }

	local fname
	fname=$( awk '{print $1}' $favdir_list | command grep -w -E "^$1$" )
	local fpath
	fpath=$( awk '$1 ~ /'"^$1"'$/' $favdir_list | awk '{print $2}' )

	if [ $# -eq 0 ]; then
		echo "go: too few arguments"
		echo "Try 'go --help' for more information."
		return 1
	else
		# case of unregistered
		if [ -z "$fname" ]; then
			echo "$1: No such path in $(basename $favdir_list)"
			return 1
		# case of registered
		else
			if cd "$fpath" 2>/dev/null; then
				echo "$(date '+%Y-%m-%d %H:%M:%S')	$1" >>$favdir_log
				# case of -t option
				if [ -f $favdir_temp ]; then
					if awk '{print $2}' $favdir_temp | grep -x $fpath >/dev/null; then
						_favdir_delete $fname
						sed -i '' "/^$1$/d" $favdir_temp
					fi
				fi
				return 0
			else
				# case of not existing
				echo "$fpath: an invalid pass"
				_favdir_delete "$fname"
				echo "$fname: Deleted now"
				return 1
			fi
		fi
	fi
	unset fname fpath
}

function _favdir_delete() {
	[ -f $favdir_list ] || { echo "$(basename $bookmarklist): No exist"; return 1; }
	[ "$1" = "-h" ] || [ "$1" = "--help" ] && { _favdir_usage 'delete'; return $exit_usage; }
	[ "$1" = "-r" ] || [ "$1" = "--refresh" ] && { _favdir_refresh; return 0; }

	[ -s $favdir_list ] || { echo "$(basename $favdir_list) is empty."; return 1; }
	[ $# -eq 0 ] && {
		echo "del: too few arguments"
		echo "Try 'del --help' for more information."
		return 1
	}

	local    f
	local -i i
	local -a fname
	local -a fpath

	for f do
		fname=( $( awk '{print $1}' $favdir_list | command grep -ivw -E "^$f" ) )
		fpath=( $( command grep -ivw -E "^$f" $favdir_list | awk '{print $2}' ) )

		if awk '{print $1}' $favdir_list | command grep -w -E "^$f" >/dev/null; then
			# (main) delete from list
			for (( i=0; i<${#fname[*]}; i++ )); do
				printf "%-15s%s\n" ${fname[i]} ${fpath[i]}
			done >$favdir_list

			# delete the history
			sed -i '' "/"$'\t'"$f$/d" $favdir_log 2>/dev/null

			# case of using -t option
			if [ -f $favdir_temp ]; then
				if awk '{print $1}' $favdir_temp | grep -w "$f" >/dev/null; then
					sed -i '' "/^$f/d" $favdir_temp
				fi
			fi
		else
			echo "$1: No such path in $(basename $favdir_list)"
			return 1
		fi
		unset f i fname fpath
	done
}

function _favdir_print() {
	[ "$1" = "-h" ] || [ "$1" = "--help" ] && { _favdir_usage 'print'; return $exit_usage; }

	local fname
	fname=$( awk '{print $1}' $favdir_list | command grep -w -E "^$1$" )
	local fpath
	fpath=$( awk '$1 ~ /'"^$1"'$/' $favdir_list | awk '{print $2}' )

	if [ $# -eq 0 ]; then
		echo "p: too few arguments"
		echo "Try 'p --help' for more information."
		return 1
	else
		if [ -z "$fname" ]; then
			echo "$1: No such path in $(basename $favdir_list)"
			return 1
		else
			if ( cd "$fpath" >/dev/null 2>&1 ); then
				echo "$fpath"
				return 0
			else
				echo "$fpath: an invalid pass"
				_favdir_delete "$fname"
				echo "$fname: deleted"
				return 1
			fi
		fi
	fi
	unset fname fpath
}

function _favdir_refresh() {
	local -i i=
	local -i count=
	local -a fname
	fname=( $( awk '{print $1}' $favdir_list ) )
	local -a fpath
	fpath=( $( awk '{print $2}' $favdir_list ) )
	local line
	line=$( wc -l <$favdir_list )
	local -a str
	
	cp -f $favdir_list ${favdir_list}.bak
	for (( i=0; i<$line; i++ )); do
		if [ -d "${fpath[i]}" ]; then
			let count++
		else
			_favdir_delete "${fname[i]}"
			str=("${str[@]}" "${fname[i]}")
		fi
	done

	if [ $count -eq $line ]; then
		#echo "All paths are available."
		return 1
	else
		echo "have removed ${#str[*]} items that do not exist"
		diff -u ${favdir_list}.bak $favdir_list
		return 0
	fi

	unset i count fname fpath line str
}

function _favdir_complement() {
	if [ "$BASH_VERSION" ]; then
		local curw
		COMPREPLY=()
		curw=${COMP_WORDS[COMP_CWORD]}
		COMPREPLY=( $( compgen -W "`echo $( awk '{print $1}' $favdir_list )`" -- $curw ) )
	elif [ "$ZSH_VERSION" ]; then
		if (( CURRENT == 2 )); then
			compadd `awk '{print $1}' $favdir_list`
		fi
	fi
	return 0
}

# coding part
[ -d "$favdir_dir" ] && unset _favdir_initialize || _favdir_initialize

alias favdir='_favdir_usage'
alias show='_favdir_show'
alias reg='_favdir_regist'
alias go='_favdir_go'
alias del='_favdir_delete'
alias p='_favdir_print'

if [ "$BASH_VERSION" ]; then
	complete -F _favdir_complement go
	complete -F _favdir_complement del
	complete -F _favdir_complement p
elif [ "$ZSH_VERSION" ]; then
	autoload -U compinit
	compinit -u
	compdef _favdir_complement go
	compdef _favdir_complement del
	compdef _favdir_complement p
fi
