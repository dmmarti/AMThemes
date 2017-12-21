#!/usr/bin/env bash

# This file is NOT part of The RetroPie Project
#
# This script is a third party script to install Attract Mode themes
# onto a RetroPie build.
#
# Theme creators will upload their Attract Mode themes to Github and
# this install script will contain the links to them.
#
# The main Attract Mode Theme installer script will contain the links
# to the various creators Github pages for inclusion.  End users will
# then be able to easily download new themes for use.
#

function depends_amthemes() {
    if isPlatform "x11"; then
        getDepends feh
    else
        getDepends fbi
    fi
}

function install_theme_amthemes() {
    local theme="$1"
    local repo="$2"
    if [[ -z "$repo" ]]; then
        repo="default"
    fi
    if [[ -z "$theme" ]]; then
        theme="default"
        repo="default"
    fi
    mkdir -p "/home/pi/.attract/layouts"
    git clone "https://github.com/$repo/am-theme-$theme.git" "/home/pi/.attract/layouts/$theme"
}

function uninstall_theme_amthemes() {
    local theme="$1"
    if [[ -d "/home/pi/.attract/layouts/$theme" ]]; then
        rm -rf "/home/pi/.attract/layouts/$theme"
    fi
}

function changetheme() {
# Welcome
 dialog --backtitle "Attract Mode" --title "Attract Mode Theme Change Utility Menu" \
    --yesno "\nAttract Mode Theme Change Utility menu.\n\nThis utility will provide a quick way to change the layout(theme) for displays within Attract Mode.\n\nAfter making the chagnesu will need to restart in order for the changes to take affect.\n\nDo you want to proceed?" \
    20 80 2>&1 > /dev/tty \
    || exit

cat /home/pi/.attract/attract.cfg |grep layout |grep -v "menu_" |grep -v param |sort -u |awk '{print $2}' > /tmp/current
ls /home/pi/.attract/layouts > /tmp/layouts
ls /opt/retropie/supplementary/attractmode/share/attract/layouts >> /tmp/layouts

let i=0 # define counting variable
W=() # define working array
while read -r line; do # process file by file
    let i=$i+1
    W+=($i "$line")
done < <(cat /tmp/current)

CURTHEME=$(dialog --title "Attract Mode Theme Change Utility" --menu "Currently used layouts - choose the one to change." 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3)

clear

if [ -z $CURTHEME ]; then
   exit
else
  clear
  let i=0 # define counting variable
  W=() # define working array
  while read -r line; do # process file by file
      let i=$i+1
      W+=($i "$line")
  done < <(cat /tmp/layouts)
  currenttheme=`sed -n ${CURTHEME}p /tmp/current`
  NEWTHEME=$(dialog --title "Attract Mode Theme Change Utility" --menu "Chose the replacement theme for ${currenttheme}." 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3)

  if [ -z $NEWTHEME ]; then
    exit
  else
    newtheme=`sed -n ${NEWTHEME}p /tmp/layouts`
    #echo "Going to replace ${currenttheme} with ${newtheme}"

    cp /home/pi/.attract/attract.cfg /home/pi/.attract/attract.cfg.bkp
    cp /home/pi/.attract/attract.cfg /tmp/temp_attract.cfg
    rm /tmp/temp.cfg  2> /dev/null

    while read line
    do
    if [[ $line == "display"* && $line != "displays_menu"* ]]; then
      echo $line >> /tmp/temp.cfg
    elif [[ $line == *"layout"* ]]; then
      echo -e "\tlayout               ${newtheme}" >> /tmp/temp.cfg
    elif [[ $line == "rule"* ]]; then
      echo -e "\t\t${line}" >> /tmp/temp.cfg
    elif [[ $line == "sound" ]]; then
      echo $line >> /tmp/temp.cfg
    elif [[ $line == "input_map" ]]; then
      echo $line >> /tmp/temp.cfg
    elif [[ $line == "general" ]]; then
      echo $line >> /tmp/temp.cfg
    elif [[ $line == "saver_config" ]]; then
      echo $line >> /tmp/temp.cfg
    elif [[ $line == "layout_config"* ]]; then
      echo $line >> /tmp/temp.cfg
    elif [[ $line == "intro_config" ]]; then
      echo $line >> /tmp/temp.cfg
    elif [[ $line == "#"* ]]; then
      echo $line >> /tmp/temp.cfg
    else
      echo -e "\t${line}" >> /tmp/temp.cfg
    fi
    done < /tmp/temp_attract.cfg
  fi
  
  rm /tmp/temp_attract.cfg
  mv /tmp/temp.cfg /home/pi/.attract/attract.cfg

fi

#rm /tmp/current
#rm /tmp/layouts
}

function gui_amthemes() {
    local themes=(
        'dmmarti robospin'
        'dmmarti hurstyblue_system'
        'dmmarti hurstyblue_main'
        'dmmarti hurstyblue_nds'
        'RetroHursty69 comiccrazy'
        'RetroHursty69 comiccrazy_menu'
        'RetroHursty69 unifiedsnazzy'
    )
    while true; do
        local theme
        local installed_themes=()
        local repo
        local options=()
        local status=()
        local default

        options+=(U "Update install script - script will exit when updated")
        options+=(C "Change theme - restart Attract Mode afterwards")

        local i=1
        for theme in "${themes[@]}"; do
            theme=($theme)
            repo="${theme[0]}"
            theme="${theme[1]}"
            if [[ -d "/home/pi/.attract/layouts/$theme" ]]; then
                status+=("i")
                options+=("$i" "Update or Uninstall $theme (installed)")
                installed_themes+=("$theme $repo")
            else
                status+=("n")
                options+=("$i" "Install $theme (not installed)")
            fi
            ((i++))
        done
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "Attract Mode Theme Installer - Choose an option" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        [[ -z "$choice" ]] && break
        case "$choice" in
            U)  #update install script to get new theme listings
                cd "/home/pi/RetroPie/attractmodemenu" 
                mv "amthemes.sh" "amthemes.sh.bkp" 
                wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/amthemes.sh" 
                chmod 777 "amthemes.sh" 
                exit
                ;;
            C)  #change theme
                changetheme
                ;;
            *)  #install or update themes
                theme=(${themes[choice-1]})
                repo="${theme[0]}"
                theme="${theme[1]}"
                if [[ "${status[choice]}" == "i" ]]; then
                    options=(1 "Update $theme" 2 "Uninstall $theme")
                    cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option for theme" 12 40 06)
                    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                    case "$choice" in
                        1)
                            install_theme_amthemes "$theme" "$repo"
                            ;;
                        2)
                            uninstall_theme_amthemes "$theme"
                            ;;
                    esac
                else
                    install_theme_amthemes "$theme" "$repo"
                fi
                ;;
        esac
    done
}

gui_amthemes
