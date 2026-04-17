# annotated by dave eddy (@yousuckatprogramming)
# explained - https://youtu.be/D0sG2fj0G4Y
# borrowed heavily from https://grml.org

# Begin blinking text mode
# Catppuccin Mocha: Pink #f5c2e7
export LESS_TERMCAP_mb=$'\e[1;38;2;245;194;231m'

# Begin bold text mode
# Catppuccin Mocha: Pink #f5c2e7
export LESS_TERMCAP_md=$'\e[1;38;2;245;194;231m'

# End all special formatting started by mb/md/etc.
export LESS_TERMCAP_me=$'\e[0m'

# End standout mode
export LESS_TERMCAP_se=$'\e[0m'

# Begin standout mode
# Catppuccin Mocha: Yellow #f9e2af on Surface1 #45475a
export LESS_TERMCAP_so=$'\e[1;38;2;249;226;175;48;2;69;71;90m'

# End underline mode
export LESS_TERMCAP_ue=$'\e[0m'

# Begin underline mode
# Catppuccin Mocha: Green #a6e3a1
export LESS_TERMCAP_us=$'\e[4;1;38;2;166;227;161m'

# Begin reverse-video mode
export LESS_TERMCAP_mr=$'\e[7m'

# Begin dim/half-bright mode
export LESS_TERMCAP_mh=$'\e[2m'

# Begin subscript mode
# (probably isn't supported)
export LESS_TERMCAP_ZN=$'\e[74m'

# End subscript mode
# (probably isn't supported)
export LESS_TERMCAP_ZV=$'\e[75m'

# Begin superscript mode
# (probably isn't supported)
export LESS_TERMCAP_ZO=$'\e[73m'

# End superscript mode
# (probably isn't supported)
export LESS_TERMCAP_ZW=$'\e[75m'

# Finally wire up `man` to use `less`
# this is usually the default but let's just be sure
export MANPAGER='less'

export LESS=-R
export GROFF_NO_SGR=1

