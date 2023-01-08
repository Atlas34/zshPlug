#!/usr/bin/env zsh

export ZSHPLUG_DIR="${HOME}/.local/share/zshPlug"
export ZSHPLUG_PLUGIN_DIR="${ZSHPLUG_DIR}/plugins"
export ZSHPLUG_ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

# Variables
CYAN="\e[96m"
GREEN="\e[92m"
NC="\e[0m"

fpath=($ZSHPLUG_DIR/completion $fpath)

load()
{
    loaded=false
    local plugin_name="$1"
    local plugin_files_names=("${plugin_name}.plugin.zsh"
        "${plugin_name}.zsh"
        "${plugin_name}.zsh-theme"
        "${plugin_name#zsh-}.zsh")

    for p in "${plugin_files_names[@]}"
    do
        local plugin_file_name=${ZSHPLUG_PLUGIN_DIR}/${plugin_name}/${p}
        if [ -e "${plugin_file_name}" ]
        then
            source "${plugin_file_name}" 
            loaded=true
            break
        fi
    done
}

use()
{
    plugin="$1"
    if [ -f "${plugin}" ]
    then
        source "${plugin}"
    else
        local plugin_name=$(echo "${plugin}" | cut -d "/" -f2)
        local plugin_dir="${ZSHPLUG_PLUGIN_DIR}/${plugin_name}"

        if [ -d "${plugin_dir}" ]
        then
            load ${plugin_name}
        else
            echo "❌ Failed to load ${plugin}"
        fi
    fi
}

install()
{
    local plugins=$(\grep -E '^[^#]*use ".+"' ${ZSHPLUG_ZSHRC} | cut -d\" -f2)

    for full_plugin_name in ${(f)plugins}
    do
        local plugin_name=$(echo "${full_plugin_name}" | cut -d "/" -f 2)
        local plugin_dir="${ZSHPLUG_PLUGIN_DIR}/${plugin_name}"
        local git_refs=$(\grep -E "^[^#]*use \"${p}\"" ${ZSHPLUG_ZSHRC} | cut -d\" -f3)

        if [ ! -d "${plugin_dir}" ]
        then
            echo " ${plugin_name}"
            git clone "https://github.com/${full_plugin_name}.git" --depth 1 "$plugin_dir" > /dev/null 2>&1

            if [ $? -ne 0 ]
            then
                echo "❌ Failed to clone ${plugin_name}" && return 1
            fi

            if [ -n "${git_ref}" ]
            then
                git -C "${plugin_dir}" checkout "${git_ref}" > /dev/null 2>&1

                if [ $? -ne 0 ]
                then 
                    echo "❌ Failed to checkout ${git_ref}" && return 1
                fi
            fi
            echo -e "✅ ${plugin_name}"

            load ${plugin_name}

            if [[ ${loaded} == false ]]
            then
                echo "❌ Failed to load ${full_plugin_name}"
            fi
        fi
    done
}

pull()
{
    echo -e "  $1"
    git pull > /dev/null 2>&1

    if [ $? -ne 0 ]
    then
      echo "❌ Failed to update $1" && exit 1
    fi
    echo -e "✅ $1"
}

clean()
{
    unused_plugins=()
    for i in "${ZSHPLUG_PLUGIN_DIR}"/*
    do
        local plugin_name=$(basename "$i")
        local regexp="^ *use \".+/${plugin_name}\""
        local res=$(\grep -E "${regexp}" ${ZSHPLUG_ZSHRC})
        if [ -z "${res}" ]
        then
            unused_plugins+=("${plugin_name}")
        fi
    done

    if [ ${#unused_plugins[@]} -eq 0 ]
    then
        echo "✅ No plugin to remove"
    else
        for plugin in ${unused_plugins[@]}
        do
            echo -n "Remove: ${plugin}? (y/n): "
            read answer
            if [[ ${answer} == "y" ]]
            then
                rm -rf "${ZSHPLUG_PLUGIN_DIR}/${plugin}"
                echo "✅ removed: ${plugin}"
            fi
        done
    fi
}

update()
{
    local plugins=$(\grep -E '^[^#]*use ".+"' ${ZSHPLUG_ZSHRC} | cut -d\" -f2 | awk 'BEGIN { FS = "\n" } { print " " int((NR)) echo "   " $1 }')
    echo -e " 0  zshPlug"
    echo "${plugins} \n"
    echo -n " Plugin Number | (a) All Plugins | (0) zshPlug Itself: "
    read choice
    pwd=$(pwd)
    echo ""
    
    if [[ ${choice} == "a" ]]
    then
        cd "${ZSHPLUG_PLUGIN_DIR}"
        for fff in *
        do
            cd ${fff}
            pull ${fff}
            cd "${ZSHPLUG_PLUGIN_DIR}"
        done
        cd ${pwd} > /dev/null 2>&1
    elif [[ ${choice} == "0" ]]
    then
        cd "${ZSHPLUG_DIR}"
        pull 'zshPlug'
        cd ${pwd}
    else
        for plug in ${plugins}
        do
            selected=$(echo ${plug} | \grep -E "^ ${choice}" | awk 'BEGIN { FS = "[ /]" } { print $6 }')
            cd "${ZSHPLUG_PLUGIN_DIR}/${selected}"
            pull ${selected}
            cd - > /dev/null 2>&1
        done
    fi
}

help()
{
  \cat << EOF
zshPlug [options]

OPTIONS:
    help     help
    version  version
    install  install plugin(s)
    update   update plugin(s)
    clean    clean plugin(s)
EOF
}

version()
{
    echo "zshPlug Version v0.1.0"
}

typeset -A opts
opts=(
    help "help"
    install "install"
    update "update"
    clean "clean"
    version "version"
)

zshPlug()
{
    emulate -L zsh
    if [[ -z "$opts[$1]" ]]
    then
        help
        return 1
    fi
    opt="${opts[$1]}"
    $opt
}

# vim: ft=bash ts=4 sw=4 sts=4 et
