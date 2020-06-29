#!/bin/bash

# Global variables, leave empty those you do not want to use
GSTREAMHOSTNO="1" #Number of the game streaming server from the Moonlight.conf that you want to use (default=1)
GLOBALSETTINGS="Yes" #"Yes" to use global settings from GUI or "No"/empty to use local settings below 
MOONLIGHT_PATH="/home/pi/RetroPie/roms/moonlight-qt" #Path to RetroPie Moonlight ROMS folder
STREAMINGHOST="$(cat ~/.config/Moonlight\ Game\ Streaming\ Project/Moonlight.conf | grep "^$GSTREAMINGHOSTNO" | grep "\\localaddress=" | cut -d "=" -f2 | sed "s/ *$//g")"
#STREAMINGHOST="192.168.0.10" #Game streaming server's IP adress or hostname
RESOLUTION="1080" #720/1080/4K
FPS="60" #30/60/120
BITRATE="" #Bitrate in Kbps
VSYNC="Yes" #"Yes" for VSYNC, "No"/empty otherwise
FRAMEPACING="Yes" #"Yes" for frame pacing, "No"/empty otherwise
VIDEOCODEC="auto" #H.264/HEVC/auto
VIDEODECODER="auto" #auto/hardware/software
REMOTE="Yes" #"Yes" or 1 for remote optimization, empty otherwise
AUDIO="local" #"local" for local audio, empty for audio on remote host
AUDIOCONFIG="stereo" #"5.1-surround" for surround, "stereo"/empty for stereo
MULTICONTROLLER="Yes" #"Yes" for multiple controller support, "No"/empty otherwise
MOUSEACCELERATION="Yes" #"Yes" for mouse acceleration, "No"/empty otherwise
QUITAPPAFTER="Yes" #"Yes" or 1 for quitting app after ending streaming session, empty otherwise


#Check for "list" parameter to list streamable game titles from FIRST game streaming server in file ~/.config/Moonlight\ Game\ Streaming\ Project/Moonlight.conf
#sudo -u pi timeout 2 moonlight list $STREAMINGHOST | grep '^[0-9][0-9.]' | cut -d "." -f2 | sed 's/^ \(.*\)$/\1/' | if ! IFS= read -r
if [ "$1" = "list" ]
then
    printf "$(cat ~/.config/Moonlight\ Game\ Streaming\ Project/Moonlight.conf | grep "^$GSTREAMHOSTNO" | grep '\\name=' | cut -d "=" -f2 | sed "s/\\\x/\\\u/g" | sed "s/\"/\ /g" | sed 's/^ \(.*\)$/\1/' | sed "s/ *$//g")\n" /e
    exit 1

elif [ "$1" != "" ]
then 
    echo "Invalid argument\n"
    exit 1

else
    # Set script variables
    _STREAMINGHOST=""
    if [ "$STREAMINGHOST" != "" ]
    then
    _STREAMINGHOST=" $STREAMINGHOST"
    fi
    _RESOLUTION=""
    if [ "$RESOLUTION" != "" ]
    then
        _RESOLUTION=" --$RESOLUTION"
    fi
    _FPS=""
    if [ "$FPS" != "" ]
    then
        _FPS=" --fps $FPS"
    fi
    _BITRATE=""
    if [ "$BITRATE" != "" ]
    then
        _BITRATE=" --bitrate $BITRATE"
    fi
    _VSYNC=""
    if [ "$VSYNC" = "YES" ] || [ "$VSYNC" = 1 ] || [ "$VSYNC" = "Yes" ] || [ "$VSYNC" = "yes" ]
    then
        _VSYNC=" --vsync"
    else
        -VSYNC=" --no-vsync"
    fi
    _FRAMEPACING=""
    if [ "$FRAMEPACING" = "YES" ] || [ "$FRAMEPACING" = 1 ] || [ "$FRAMEPACING" = "Yes" ] || [ "$FRAMEPACING" = "yes" ]
    then
        _FRAMEPACING=" --frame-pacing"
    else
        _FRAMEPACING=" --no-frame-pacing"
    fi
    _VIDEOCODEC=""
    if [ "$VIDEOCODEC" != "" ]
    then
        _VIDEOCODEC=" --video-codec $VIDEOCODEC"
    fi
    _VIDEODECODER=""
    if [ "$VIDEODECODER" != "" ]
    then
        _VIDEODECODER=" --video-decoder $VIDEODECODER"
    fi
    _REMOTE=""
    if [ "$REMOTE" = "YES" ] || [ "$REMOTE" = 1 ] || [ "$REMOTE" = "Yes" ] || [ "$REMOTE" = "yes" ]
    then
        _REMOTE=" --game-optimization"
    else
        _REMOTE=" --no-game-optimization"
    fi
    _AUDIO=""
    if [ "$AUDIO" = "local" ]
    then
        _AUDIO=" --no-audio-on-host"
    else
        _AUDIO=" --audio-on-host"
    fi
    _AUDIOCONFIG=""
    if [ "$AUDIOCONFIG" != "" ]
    then
        _AUDIOCONFIG=" --audio-config $AUDIOCONFIG"
    fi
    _MULTICONTROLLER=""
    if [ "$MULTICONTROLLER" = "YES" ] || [ "$MULTICONTROLLER" = 1 ] || [ "$MULTICONTROLLER" = "Yes" ] || [ "$MULTICONTROLLER" = "yes" ]
    then
        _MULTICONTROLLER=" --multi-controller"
    else
        _MULTICONTROLLER=" --no-multi-controller"
    fi
    _MOUSEACCELERATION=""
    if [ "$MOUSEACCELERATION" = "YES" ] || [ "$MOUSEACCELERATION" = 1 ] || [ "$MOUSEACCELERATION" = "Yes" ] || [ "$MOUSEACCELERATION" = "yes" ]
    then
        _MOUSEACCELERATION=" --mouse-acceleration"
    else
        _MOUSEACCELERATION=" --no-mouse-acceleration"
    fi
    _QUITAPPAFTER=""
    if [ "$QUITAPPAFTER" = "YES" ] || [ "$QUITAPPAFTER" = 1 ] || [ "$QUITAPPAFTER" = "Yes" ] || [ "$QUITAPPAFTER" = "yes" ]
    then
        _QUITAPPAFTER=" --quit-after"
    else
        _QUITAPPAFTER=" --no-quit-after"
    fi


    #Delete old and existing script generated Moonlight game files
    OLD_IFS="$IFS"
    IFS=
    echo "Deleting...:"
    grep -l --exclude="_UpdateMoonlightQtGamesList.sh" "#Autocreated by UpdateMoonlightQtGamesList.sh" $MOONLIGHT_PATH/*.sh | while read -r LINE; do
        sudo rm $LINE
        echo $LINE
    done
    IFS="$OLD_IFS"
    echo ""

    #Make list of moonlight games borrowed from https://github.com/rpf16rj/moonlight_script_retropie
    # sudo -u pi moonlight list | grep '^[0-9][0-9.]' | cut -d "." -f2 | sed 's/^ \(.*\)$/\1/' >> gamesreal.txt
    # sudo -u pi moonlight list | grep '^[0-9][0-9.]' | cut -d "." -f2 | sed 's/[^a-z A-Z 0-9 -]//g' >> games.txt


    #Generate new script files from Moonlight listed games on game server
    OLD_IFS="$IFS"
    IFS= #Make read command reade entire lines and not divide into words
    CNTR=0
    CNTR2=0
    CNTR3=0
    ARR1[0]=""
    ARR2[0]=""
    while read -r LINE ;do
        echo $LINE".sh:"
        
        #Check if file already exists and exclude
        if IFS= read -r ;then 
            ARR1[$CNTR]=$LINE
            ((CNTR++))
            echo $LINE" already exists and was created from another source, will not overwrite."
        
        #If file doesn't exist, create new file
        else
            ARR2[$CNTR2]=$LINE
            echo "#!/bin/bash" | sudo tee -a $MOONLIGHT_PATH/$LINE.sh
            echo "#Autocreated by UpdateMoonlightQtGamesList.sh" | sudo tee -a $MOONLIGHT_PATH/$LINE.sh
            if [ "$GLOBALSETTINGS" = "YES" ] || [ "$GLOBALSETTINGS" = 1 ] || [ "$GLOBALSETTINGS" = "Yes" ] || [ "$GLOBALSETTINGS" = "yes" ]
            then
                echo "moonlight-qt stream"$_STREAMINGHOST" \"$LINE\"" | sudo tee -a $MOONLIGHT_PATH/$LINE.sh
            else
                echo "moonlight-qt"$_RESOLUTION$_FPS$_BITRATE$_VSYNC$_FRAMEPACING$_VIDEOCODEC$_VIDEODECODER$_REMOTE$_AUDIO$_AUDIOCONFIG$_MULTICONTROLLER$_MOUSEACCELERATION$_QUITAPPAFTER" stream"$_STREAMINGHOST" \"$LINE\"" | sudo tee -a $MOONLIGHT_PATH/$LINE.sh
            fi
            ((CNTR2++))
        fi< <(find $MOONLIGHT_PATH -name $LINE".sh")
        ((CNTR3++))
    #ProcessSubstitution to prevent subshell and thereby being able to use variables from while loop outside the loop
    done < <(printf "$(cat ~/.config/Moonlight\ Game\ Streaming\ Project/Moonlight.conf | grep "^$GSTREAMHOSTNO" | grep '\\name=' | cut -d "=" -f2 | sed "s/\\\x/\\\u/g" | sed "s/\"/\ /g" | sed 's/^ \(.*\)$/\1/' | sed "s/ *$//g")\n" /e) 
    
    
    #Sum up and print operations
    echo ""
    echo $CNTR"/"$CNTR3" game files were not created from Moonlight, because the files already existed or were created from another source:"
    for ITEM in ${ARR1[*]}
    do
        printf "   %s\n" $ITEM".sh"
    done
    echo ""
    echo $CNTR2"/"$CNTR3" game files were created from Moonlight:"
    for ITEM in ${ARR2[*]}
    do
        printf "   %s\n" $ITEM".sh"
    done
    IFS="$OLD_IFS"


    #Exit script and restart Emulationstation to update Moonlight games list
    echo""
    echo "Now restarting EmulationStation..."
    sudo -u pi touch /tmp/es-restart
    sudo -u pi kill $(pgrep -l -n emulationstatio | awk '!/grep/ {printf "%s ",$1}')
    sleep 3
    #sudo -u pi rm /tmp/es-restart

fi
