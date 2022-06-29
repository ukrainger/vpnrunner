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

    ./$EXEDir/${EXE} -c 2048 -u 0&

}
 
function startAttackCommand {

    ./$EXEDir/${EXE} -c 2048 -u 100&

}

function stopAttackCommand {

    pgrep -x "$EXE" | xargs kill -9; sleep 2s;  \

}


############################################################


############### init #######################################

function initEXECommand {

    if [ -d "$EXEDir" ]
    then
        echo ""
    else
        echo "Exe dir does not exist -> will create one"
        mkdir $EXEDir
    fi

    #download and install the EXE if not available
    if [ -e "$EXEDir/$EXE" ]
    then
        tput setaf 3; echo "Application already downloaded";tput setaf 6
    else

        tput setaf 3; echo "Downloading the application";tput setaf 6
        until [ -f $EXEDir/${EXE} ]
        do

            tput setaf 6;

            cd $EXEDir;

            wget -O ${EXE} https://github.com/Yneth/distress-releases/releases/latest/download/distress_x86_64-unknown-linux-musl

            chmod +x ${EXE}

            cd ..;

            #rm ${EXE}_*
            sleep 2s;

        done
    fi

}

############################################################

