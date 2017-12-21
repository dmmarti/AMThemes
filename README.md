# AMThemes

-------
OVERVIEW

(note, web browsers will mess up the syntax of this document, but it will be right when downloaded and reading the README.md file)

This ZIP package is intended to be used with a Raspberry Pi RetroPie/Attract Mode build.

The included shell script is setup for use with RetroPie only.

For users who are using Attract Mode as their front-end, this ZIP package contains a script that can be used to download new themes as well as change themes within Attract Mode.

------------
INSTALLATION

Once the ZIP package is downloaded and extracted, copy the amthemes.sh shell script to your Pi.

You can add this script to your existing Attract Mode build's menu into any display you want.  Just update the Attract Mode romlist accordingly.

Right now, the script itself is hardcoded to be put into the physical location of:  "/home/pi/RetroPie/attractmodemenu"

If you want to put the script into another directory, edit the script file itself and change that line to your own directory location.

Make sure to make the amthemes.sh script executable.

chmod 777 anthemes.sh

-----
USAGE

The AM Themes Utility includes a themes installer that operates in much the same way as the Emulation Station Themes manager does.  The script provides a listing of available themes for download.  Once selected, the theme will be downloaded into the AM layouts folder.

Periodically, new themes will be added into the AM Themes installer script.  Perform an update on the script to retrieve the latest theme listings.

Once new themes are installed, you will need to manually assign the various displays to use them.

The AM Themes Utility includes a built-in option to change themes.  You chose what assigned theme you want to change and then chose the replacement theme.  The script will then make a backup copy of your attract.cfg file and then change every occurrence within it to the new theme. 

Once done, you will need to restart Attract Mode for the changes to take affect.

You can also change a display's theme manually using the following process.  

Press TAB
Choose Displays
Choose an individual display
Navigate to the layout option, press <enter> and change to the newly downloaded theme.

Note: new themes will be added when theme authors submit them for inclusion

---------------
To Theme Authors

Anyone wishing to have their Attract Mode theme included needs to follow these guidelines.

1.  upload the theme to Github
2.  name the theme using this syntax
    am-theme-xxxxx     where xxxxx is the theme name
    do not include any spaces or special characters
    - and _ are valid
3.  submit a request for inclusion
    a.  make contact via Github
    b.  make contact via Youtube/Facebook/Forums
    c.  submit a Pull Request into the AMThemes repository

