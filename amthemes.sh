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

# Welcome
 dialog --backtitle "Attract Mode" --title "Attract Mode Themes Downloader Menu" \
    --yesno "\nAttract Mode Themes Downloader Menu.\n\nThis utility will provide an easy way to download and update Attract Mode themes (layouts).\n\nSome themes have two different variants.\n\nthemename_menu = used for Main Menu Display and nested displays (Arcades, Consoles, etc)\n\nthemename_systems = used for individual system displays (Atari 2600, Atari 7800, etc)\n\n---------------------------------------\n\nYou can easily change a displays theme by pressing\n\nTAB > Displays > displayname > Layout\n\nThen cycle through the available layouts to use.\n\nYou can also change themes using this utility (option C).\n\n\nDo you want to proceed?" \
    25 100 2>&1 > /dev/tty \
    || exit

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
    rm -rf "/home/pi/.attract/layouts/$theme"
    mkdir -p "/home/pi/.attract/layouts"
    git clone "https://github.com/$repo/am-theme-$theme.git" "/home/pi/.attract/layouts/$theme"
}

function uninstall_theme_amthemes() {
    local theme="$1"
    if [[ -d "/home/pi/.attract/layouts/$theme" ]]; then
        rm -rf "/home/pi/.attract/layouts/$theme"
    fi
}

function gui_amthemes() {
    local themes=(
        'dmmarti unified_menu'
        'dmmarti unified_systems'
        'dmmarti unified_systems_overview'
        'dmmarti 80s_arcades'
        'dmmarti 80s_menu'
        'dmmarti 80s_systems'
        'dmmarti arcade1up_menu'
        'dmmarti arcade1up_systems'
        'dmmarti arcadeops'
        'dmmarti arcaderefried'
        'dmmarti beyond_basics_menu'
        'dmmarti beyond_basics_systems'
        'dmmarti bigcade'
        'dmmarti comiccrazytoo_menu'
        'dmmarti comiccrazytoo_systems'
        'dmmarti cosmicrise_menu'
        'dmmarti cosmicrise_systems'
        'dmmarti graffiti_menu'
        'dmmarti graffiti_systems'
        'dmmarti hurstyblue_menu'
        'dmmarti hurstyblue_systems'
        'dmmarti hyperflash'
        'dmmarti hyperflash54'
        'dmmarti hyper_menu'
        'dmmarti hyper_systems'
        'dmmarti mvsops'
        'dmmarti neon_menu'
        'dmmarti neon_systems'
        'dmmarti silky_menu'
        'dmmarti silky_systems'
        'dmmarti smooth'
        'dmmarti space_deck_menu'
        'dmmarti space_deck_systems'
        'dmmarti stirling_menu'
        'dmmarti stirling_systems'
    )
    while true; do
        local theme
        local installed_themes=()
        local repo
        local options=()
        local status=()
        local default

        options+=(C "Change theme - change currently used theme to another one")
        options+=(U "Update install script - script will exit when updated")
        options+=(V "View or update theme gallery")

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
            C)  #change to new theme
                changetheme
                ;;
            U)  #update install script to get new theme listings
                cd "/home/pi/RetroPie/attractmodemenu" 
                mv "amthemes.sh" "amthemes.sh.bkp" 
                wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/amthemes.sh" 
                chmod 777 "amthemes.sh" 
                download_themesamples
                exit
                ;;
            V)  #view theme samples
                view_styles
                ;;
            *)  #install or update themes
                theme=(${themes[choice-1]})
                repo="${theme[0]}"
                theme="${theme[1]}"
#                if [[ "${status[choice]}" == "i" ]]; then
                if [[ -d "/home/pi/.attract/layouts/$theme" ]]; then
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

function view_styles() {

    local choice

    while true; do
        choice=$(dialog --backtitle "Attract Mode Themes" --title " View Theme Gallery " \
            --ok-label OK --cancel-label Exit \
            --menu "Chose an option to see the theme gallery (10 second timeout)" 25 75 20 \
            1 "Download or update theme gallery images" \
            2 "Unified theme" \
            3 "80s theme" \
            4 "Arcade1Up 5:4 theme" \
            5 "ArcadeOPS theme" \
            6 "Arcade Refried theme" \
            7 "Beyond Basics theme" \
            8 "BigCade theme" \
            9 "Comic Crazy Too theme" \
            10 "Cosmic Rise theme" \
            11 "Graffiti theme" \
            12 "HurstyBlue theme" \
            13 "HyperFlash theme" \
            14 "Hyper theme" \
            15 "MVSOPS theme" \
            16 "Neon theme" \
            17 "Silky theme" \
            18 "Smooth theme" \
            19 "Space Deck theme" \
            20 "Stirling theme" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) download_themesamples  ;;
            2) show_theme unified_theme  ;;
            3) show_theme 80s_theme  ;;
            4) show_theme arcade1up_theme  ;;
            5) show_theme arcadeops_theme  ;;
            6) show_theme arcaderefried_theme  ;;
            7) show_theme beyondbasics_theme  ;;
            8) show_theme bigcade_theme  ;;
            9) show_theme comiccrazytoo_theme  ;;
            10) show_theme cosmicrise_theme  ;;
            11) show_theme graffiti_theme  ;;
            12) show_theme hurstyblue_theme  ;;
            13) show_theme hyperflash_theme  ;;
            14) show_theme hyper_theme  ;;
            15) show_theme mvsops_theme  ;;
            16) show_theme neon_theme  ;;
            17) show_theme silky_theme  ;;
            18) show_theme smooth_theme  ;;
            19) show_theme spacedeck_theme  ;;
            20) show_theme stirling_theme  ;;
            *)  break ;;
        esac
    done
}

function show_theme() {
local themesample="$1"
sudo fbi -T 2 --timeout 10 --once --autozoom "/home/pi/RetroPie/attractmodemenu/$themesample.png"
}

function download_themesamples() {
rm 80s_theme.png
rm arcade1up_theme.png
rm arcadeops_theme.png
rm arcaderefried_theme.png
rm beyondbasics_theme.png
rm bigcade_theme.png
rm comiccrazytoo_theme.png
rm cosmicrise_theme.png
rm graffiti_theme.png
rm hurstyblue_theme.png
rm hyperflash_theme.png
rm hyper_theme.png
rm mvsops_theme.png
rm neon_theme.png
rm silky_theme.png
rm smooth_theme.png
rm spacedeck_theme.png
rm stirling_theme.png
rm unified_theme.png
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/80s_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/arcade1up_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/arcadeops_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/arcaderefried_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/beyondbasics_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/bigcade_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/comiccrazytoo_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/cosmicrise_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/graffiti_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/hurstyblue_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/hyperflash_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/hyper_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/mvsops_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/neon_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/silky_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/smooth_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/spacedeck_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/stirling_theme.png"
wget "https://raw.githubusercontent.com/dmmarti/AMThemes/master/unified_theme.png"
}

function changetheme() {
# Welcome
 dialog --backtitle "Attract Mode" --title "Attract Mode Theme Change Utility Menu" \
    --yesno "\nAttract Mode Theme Change Utility menu.\n\nThis utility will provide a quick way to change the layout(theme) for displays within Attract Mode.\n\nAfter making the chagnesu will need to restart in order for the changes to take affect.\n\nDo you want to proceed?" \
    20 80 2>&1 > /dev/tty \
    || exit

cat /home/pi/.attract/attract.cfg |grep layout |grep -v "menu_" |grep -v "toggle_layout" |grep -v param |sort -u |awk '{print $2}' > /tmp/current
ls /home/pi/.attract/layouts > /tmp/layouts
ls /usr/local/share/attract/layouts >> /tmp/layouts

let i=0 # define counting variable
W=() # define working array
while read -r line; do # process file by file
    let i=$i+1
    W+=($i "$line")
done < <(cat /tmp/current)

CURTHEME=$(dialog --title "Attract Mode Theme Change Utility" --menu "Currently used layouts - choose the one to change." 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3)

clear

if [ -z $CURTHEME ]; then
   return
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
    return
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
    elif [[ $line == *"menu_layout"*"${currenttheme}" ]]; then
      echo -e "\tmenu_layout               ${newtheme}" >> /tmp/temp.cfg
    elif [[ $line == *"layout"*"${currenttheme}" && $line != "menu_layout"* ]]; then
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


gui_amthemes
