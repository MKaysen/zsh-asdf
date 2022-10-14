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
  
  if [[ ${zsh_loaded_plugins[-1]} != */completions && -z ${fpath[(r)${0:h}/functions]} ]] {
    fpath+=( "${Plugins[ZSH_ASDF_DIR]}/functions" )
  }
}

asdf-setup
