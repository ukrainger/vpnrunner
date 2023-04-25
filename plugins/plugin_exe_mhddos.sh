#!/bin/bash


#checking for installation
#виконавча програма
EXEDir=mhddos_proxy
EXE=mhddos_proxy


############### functions ##################################

function statusAttackCommand {

    #pgrep -f "vpnrunner_process_${EXE}" > /dev/null; echo $(($?==0));
    pgrep -x "$EXE" > /dev/null; echo $(($?==0));

}

function startAttackProxyCommand {

    cd $EXEDir;

    #python3 runner.py --itarmy "vpnrunner_process_${EXE}"&
    ./${EXE}&

    cd ..;


}
 
function startAttackCommand {

    cd $EXEDir

    #python3 runner.py --itarmy --vpn 0 "vpnrunner_process_${EXE}"&

    ./${EXE} --vpn&

    cd ..

}

function stopAttackCommand {

    echo "Stopping the processes:"
    #pgrep -f "vpnrunner_process_${EXE}";

    #pgrep -f "vpnrunner_process_${EXE}" | xargs pkill -TERM -P
    #pgrep -f "vpnrunner_process_${EXE}" | xargs kill -9; sleep 2s;  \

    #pgrep -x "$EXE" | xargs kill -9; sleep 2s;  \

    pkill --signal SIGTERM --full "$EXE"; sleep 2s;


    rm -r /tmp/_MEI*

}

#some statistics
function exeInfoCommand { echo ""; }

############################################################


############### init #######################################

function initEXECommand {

    if $forceExeReinstall ; then

        tput setaf 3; echo "Forcing exe reinstall -> will delete the folder $EXEDir";tput setaf 6
        rm -f -r "$EXEDir"

    fi

    #download and install the EXE if not available
    if [ -d "$EXEDir" ] ; then

        tput setaf 3; echo "$EXEDir already exists -> nothing to do.";tput setaf 6
        echo ""

    else

        tput setaf 3; echo "Exe dir does not exist -> will create one by checking out from GIT...";tput setaf 6
        echo ""

        #git clone https://github.com/porthole-ascend-cinnamon/$EXEDir

        #cd $EXEDir;

        #python3 -m pip install -r requirements.txt

        #cd ..;

        mkdir $EXEDir

        tput setaf 6;

        cd $EXEDir;

        echo "OS type: $(osType)"
        echo "OS Architecture: $(osArch)"

        local DEXE;
        #the link should be adapted because the exe names are not regular
        if [[ "$(osArch)" =~ ^("x86_64"|"aarch64"|"i686")$ && "$(osType)" == "linux" ]] ; then
            DEXE=mhddos_proxy_$(osType)
        elif [[ "$(osArch)" =~ ^("arm"|"arm64")$ && "$(osType)" == "linux" ]] ; then
            DEXE=mhddos_proxy_$(osType)_$(osArch)
        elif [[ "$(osArch)" =~ ^("x86_64")$ && "$(osType)" == "windows" ]] ; then
            DEXE=mhddos_proxy_win.exe
        elif [[ "$(osArch)" =~ ^("i386"|"i686")$ && "$(osType)" == "windows" ]] ; then
            DEXE=mhddos_proxy_win_x86.exe
        elif [[ "$(osArch)" =~ ^("x86_64"|"aarch64")$ && "$(osType)" == "darwin" ]] ; then
            DEXE=mhddos_proxy_mac
        fi

        echo "Determined EXE name is $EXE"

        wget -O ${EXE} https://github.com/porthole-ascend-cinnamon/mhddos_proxy_releases/releases/latest/download/${DEXE}

        chmod +x ${EXE}

        cd ..;

        sleep 2s;

    fi

}

############################################################

