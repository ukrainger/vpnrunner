#!/bin/bash


#checking for installation
#виконавча програма
EXEDir=uashield
EXE=shield
shieldVersion=1.0.11


############### functions ##################################

function statusAttackCommand {

    #pgrep -f "vpnrunner_process_${EXE}" > /dev/null; echo $(($?==0));
    pgrep -x "$EXE" > /dev/null; echo $(($?==0));

}

function startAttackProxyCommand {

    cd $EXEDir;

    ./${EXE} --withProxy &

    cd ..;


}
 
function startAttackCommand {

    cd $EXEDir

    ./${EXE} &

    cd ..

}

function stopAttackCommand {

    while [[ "$(statusAttackCommand)" == "1" ]] ; do

        echo "Stopping the processes:"
        pgrep --exact "$EXE" --oldest;

        pkill --signal SIGTERM --exact "$EXE" --oldest;

        sleep 2s;

    done

    rm -r /tmp/scoped_dir*

    #pgrep -f "vpnrunner_process_${EXE}" | xargs pkill -TERM -P
    #pgrep -f "vpnrunner_process_${EXE}" | xargs kill -9; sleep 2s;  \

    #pgrep -x "$EXE" | xargs kill -9; sleep 2s;  \

}

#some statistics
function exeInfoCommand { echo "version: $(expr "$(./$EXEDir/${EXE} --version 2>&1 | tr '\n\t' ' ')" : '.*arguments \(.*\) ')"; }

############################################################


############### init #######################################

function initEXECommand {


    initEXECommandSucceeded=true

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

        mkdir $EXEDir

        tput setaf 6;

        cd $EXEDir;

        echo "OS type: $(osType)"
        echo "OS Architecture: $(osArch)"

        local fileDLD;
        #the link should be adapted because the exe names are not regular
        if [[ "$(osArch)" =~ ^("x86_64")$ && "$(osType)" == "linux" ]] ; then
            fileDLD=shield-$shieldVersion
        elif [[ "$(osArch)" =~ ^("arm64")$ && "$(osType)" == "linux" ]] ; then
            fileDLD=mshield-$shieldVersion-arm64
        elif [[ "$(osArch)" =~ ^("arm")$ && "$(osType)" == "linux" ]] ; then
            fileDLD=mshield-$shieldVersion-armv7l
        elif [[ "$(osArch)" =~ ^("i386"|"i686")$ && "$(osType)" == "linux" ]] ; then
            fileDLD=fileDLD=mshield-$shieldVersion-ia32
        fi

        echo "Determined EXE name is $EXE"

        wget -O "${EXE}_arch" https://github.com/opengs/uashield/releases/download/v${shieldVersion}/${fileDLD}.tar.gz

        if [[ ! -f "${EXE}_arch" ||  ! -s "${EXE}_arch" ]]; then

            tput setaf 1; echo "Failed to download ${EXE}!"; tput setaf 6;
            initEXECommandSucceeded=false

        else

            tput setaf 3; echo "Successfully downloaded ${EXE}!"; tput setaf 6;

            tar -xvf "${EXE}_arch"

            cd ${fileDLD}

            cp -r * ../

            cd ..

            chmod +x ${EXE}

        fi

        cd ..;

        sleep 2s;

    fi


}

############################################################

