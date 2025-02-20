if [[ -n "$TMUX" ]]; then 
	export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --tmux center,50%"
fi


if [[ -f "Makefile" ]]; then
    result=$(grep ".PHONY" Makefile | sed "s/[.]PHONY://g" | sed "s/\s\+/ /g" | tr ' ' '\n' | awk NF | sort | fzf --reverse)
    if [[ -n "$result" ]]; then
		make $result
	else
		echo "No target selected"
		exit 1
	fi
else 
    echo "Makefile not found"
    exit 1
fi


