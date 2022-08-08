#!/bin/bash


#checking for installation
#виконавча програма
EXEDir=uashield
EXE=shield
shieldVersion=1.0.10


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

        wget -O ${EXE}.tar.gz https://github.com/opengs/uashield/releases/download/v${shieldVersion}/${fileDLD}.tar.gz

        tar -xvf "${EXE}.tar.gz"

        cd ${fileDLD}

        cp -r * ../

        cd ..

        chmod +x ${EXE}

        cd ..;

        sleep 2s;

    fi

}

############################################################

