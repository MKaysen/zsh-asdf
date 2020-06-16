# -*- mode: sh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-

# Copyright (c) 2020 Mikkel Kaysen

# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0=${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}
0=${${(M)0:#/*}:-$PWD/$0}

# Then ${0:h} to get plugin's directory

if [[ ${zsh_loaded_plugins[-1]} != */zsh-asdf && -z ${fpath[(r)${0:h}]} ]] {
    fpath+=( "${0:h}" )
}

# Standard hash for plugins, to not pollute the namespace
typeset -gA Plugins
Plugins[ZSH_ASDF_DIR]=${${ASDF_DIR}:-${HOME}/.asdf}

function .asdf-setup-dir {
   if [[ -e ${Plugins[ZSH_ASDF_DIR]}/asdf.sh ]]; then
       return 0
   elif [[ ! -e ${Plugins[ZSH_ASDF_DIR]}/asdf.sh && ${+commands[brew]} ]]; then
       Plugins[ZSH_ASDF_DIR]=$(brew --prefix asdf)
       return 0
   fi
   return 1
}

function asdf-setup {
    .asdf-setup-dir
    source ${Plugins[ZSH_ASDF_DIR]}/asdf.sh
}

asdf-setup

# Use alternate vim marks [[[ and ]]] as the original ones can
# confuse nested substitutions, e.g.: ${${${VAR}}}

# vim:ft=zsh:tw=80:sw=4:sts=4:et:foldmarker=[[[,]]]
