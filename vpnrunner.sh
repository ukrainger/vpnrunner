#!/bin/bash

#script requires installed and configured VPN client. Such clients as nordvpn, expressvpn, pia, hotspotshield have been tested.
#для роботи скрипту необхідний встановленний та налаштований VPN-клієнт. Випробувано із nordvpn, expressvpn, pia, hotspotshield.

#script for automatic download newest version of db1000n and running it only if VPN is active
#Скрипт автоматично завантажить найновішу версію db1000n та запустить її лише коли VPN є активним

#parameters:
# $1 - VPN plugin
# $2 - executable plugin. Default: default (db1000n)
# $3 - network manager plugin. Default: default (nm)
#параметри
# $1 - VPN
# $2 - виконавча програма. Замовчування: default (db1000n)
# $3 - менеджер мережі. Замовчування: default (nm)

#the duration of the script until the VPN server is reconnected
#тривалість роботи до перепідключення із VPN-сервером
runtime="15 minute"

#heartbeatinterval between checks if still connected to VPN server. put number in seconds
#як часто перевіряти з'єднання з VPN сервером. час у секундах
heartbeatinterval=5

#if you want to use proxy leave the line on true, for using VPN change value to false
#якщо хочете використовувати проксі, залиште значення true. для використання VPN змініть на false
use_proxy=false


################ arguments and plugins  ####################

#plugin directory
pluginDir="plugins"

#ensure the right starting directory
echo "The script you are running has basename $( basename -- "$0"; ), dirname $( dirname -- "$0"; )";
cd $( dirname -- "$0"; )

#check whether the VPN parameter is passed
if [[ -z "$1" ]]; 
then

    vpnPluginNames=( $(find -type f -wholename "./${pluginDir}/plugin_vpn_*.sh") );

    tput setaf 2;
    echo "Which of the following VPN plugins should be used?"
    echo ""
    tput setaf 4;
    for curVPNPluginName in "${vpnPluginNames[@]}"
    do
        expr "$curVPNPluginName" : "./${pluginDir}/plugin_vpn_\(.*\).sh"
    done

    echo ""
    tput setaf 2;
    echo "Please type in the VPN plugin name:"
    read vpnPluginName;

else

    if [[ "$1" == "--help" ]]
    then

        echo "Usage: $0 [<VPN>] [<EXE>, default available] [<network manages> default available]";
        exit 0;

    else

        vpnPluginName="$1"

    fi

fi

#check whether the VPN plugin exists
vpnPluginFileName="${pluginDir}/plugin_vpn_$vpnPluginName.sh";
if [ -e $vpnPluginFileName ] 
then

    echo "VPN plugin for $vpnPluginName found.";

else
    
    tput setaf 1;
    echo "VPN plugin for $vpnPluginName NOT found (file $vpnPluginFileName does not exist) -> will exit.";
    exit 1;

fi

source $vpnPluginFileName

#executable
exePluginFileName="";
if [[ -z "$2" ]];
then

    echo "No exe parameter specified -> assuming default";
    exePluginFileName="${pluginDir}/plugin_exe_default.sh";

else

    #check whether the exe plugin exists
    exePluginFileName="${pluginDir}/plugin_exe_$2.sh";
    if [ -e $exePluginFileName ]
    then

        echo "Exe plugin for $2 found.";

    else

        tput setaf 1;
        echo "Exe plugin for $2 NOT found (file $exePluginFileName does not exist) -> will exit.";
        exit 1;

    fi #exe plugin check

fi # exe parameter

source $exePluginFileName

#check whether the networking parameter is passed
networkingPluginFileName="";
if [[ -z "$3" ]];
then

    echo "No networking parameter specified -> assuming default";
    networkingPluginFileName="${pluginDir}/plugin_networking_default.sh";
    
else

    #check whether the networking plugin exists
    networkingPluginFileName="${pluginDir}/plugin_networking_$3.sh";
    if [ -e $networkingPluginFileName ] 
    then

        echo "Networking plugin for $3 found.";

    else

        tput setaf 1;
        echo "Networking plugin for $3 NOT found (file $networkingPluginFileName does not exist) -> will exit.";
        exit 1;

    fi #networking plugin check

fi # networking parameter

source $networkingPluginFileName


############################################################


############### functions ##################################

function statusAttack {

    if [[ "$(statusAttackCommand)" == "1" ]]
    then
        echo "running";
    else
        echo "down";
    fi

}

function startAttack {

    tput setaf 6;

    if $use_proxy
    then
        startAttackProxyCommand
    else
        if [[ "$(statusVPN)" == "connected" ]]
        then
            startAttackCommand
        else
            tput setaf 1;
            echo "Will not start attacking because no VPN connection is setup!"
        fi
    fi

}

function stopAttack {

    if [[ "$(statusAttack)" == "running" ]]
    then

        tput setaf 2;
        echo "Stopping $EXE";
        tput setaf 6;

        stopAttackCommand

    else

        tput setaf 3;
        echo "$EXE is not running"
        tput setaf 6;

    fi

}
trap stopAttack EXIT

wipIndicator="[       ]"
function updateWIPIndicator {

    if [[ $wipIndicator ==  "[       ]" ]]
    then

        wipIndicator="[*      ]";

    elif [[ $wipIndicator ==  "[*      ]" ]]
    then

        wipIndicator="[**     ]";

    elif [[ $wipIndicator ==  "[**     ]" ]]
    then

        wipIndicator="[***    ]";

    elif [[ $wipIndicator ==  "[***    ]" ]]
    then

        wipIndicator="[ ***   ]";

    elif [[ $wipIndicator ==  "[ ***   ]" ]]
    then

        wipIndicator="[  ***  ]";

    elif [[ $wipIndicator ==  "[ ***   ]" ]]
    then

        wipIndicator="[   *** ]";

    elif [[ $wipIndicator ==  "[  ***  ]" ]]
    then

        wipIndicator="[   *** ]";

    elif [[ $wipIndicator ==  "[   *** ]" ]]
    then

        wipIndicator="[    ***]";

    elif [[ $wipIndicator ==  "[    ***]" ]]
    then

        wipIndicator="[     **]";

    elif [[ $wipIndicator ==  "[     **]" ]]
    then

        wipIndicator="[      *]";

    elif [[ $wipIndicator ==  "[      *]" ]]
    then

        wipIndicator="[       ]";

    fi

}

function printStatus {

    statOffset=7;
    statHeight=8; # must equal the number of output rows

    #clean
    for (( i=1 ; i<= $(( ${statHeight} + ${statOffset} )) ; ++i ))
    do
        echo -ne "\033[K\r\n"
    done

    echo -ne "\033[${statHeight}A"

    nCols=$(tput cols);

    tput setaf 2;
    for (( j=1 ; j<=${nCols} ; ++j )); do echo -n "-"; done
    echo -e " Run status:\t\t${wipIndicator}\t\t"
    echo -e " VPN:\t\t\t${vpnPluginName} ($connectionVPNInfoString)"
    echo -e " Exe:\t\t\t${EXE}\t\t\t"
    echo -e " Time:\t\t\t$(date +%T)\t\t"
    echo -e " Next restart:\t\t$(date -d @${endtime} +"%T")\t\t"
    echo -e " Total run duration:\t$(( ${seconds}/3600/24 )) d $(date -ud @$seconds +'%H h %M m %S s')\t"
    for (( j=1 ; j<=${nCols} ; ++j )); do echo -ne "-"; done; echo ""
    tput setaf 6;

    echo -ne "\033[$(( ${statHeight} + ${statOffset} ))A"

}

function checkAttackHeartBeat {

    updateWIPIndicator

    if [[ $(statusAttack) == "running" ]]
    then

        #tput setaf 2;
        seconds=$(( $(date +%s)-$globalStartDate ));
        #echo -ne "Status: ${wipIndicator} $(date +%T): $EXE is running. Next restart at $(date -d @${endtime} +"%T"). Total run duration is $(( ${seconds}/3600/24 )) d $(date -ud @$seconds +'%H h %M m %S s').\r"
        printStatus
        #tput setaf 6;

        #sleep $heartbeatinterval

    else # attack not running

        tput setaf 2;
        echo ""
        echo "$(date +%T) $EXE gets started." "Next restart at $(date -d @${endtime} +"%T")"
        tput setaf 6;

        startAttack

    fi # attack status

}

function statusNetworking {

    if [[ "$(statusNetworkingEnabledCheckCommand)" == "1" ]]
    then
        echo "enabled"
    else
        echo "disabled"
    fi

}

function statusConnectivity {

    if [[ "$(statusConnectivityEnabledCheckCommand)" == "1" ]]
    then
        echo "enabled"
    else
        echo "disabled"
    fi

}

function statusNetwork {

    if [[ "$(statusNetworkConnectedCheckCommand)" == "1" ]]
    then
        echo "connected"
    else
        echo "disconnected"
    fi

}

function connectNetwork {

    #echo "statusNetwork: ${statusNetwork}"
    #echo "statusNetworking: ${statusNetworking}"
    #echo "statusNetworkConnectedCheckCommand: ${statusNetworkConnectedCheckCommand}"

    tput setaf 5;
    echo "Connecting network..."
    
    while [[ "$(statusNetworking)" != "enabled" ]]
    do
    
        tput setaf 5;
        echo "Networking not enabled! Trying to connect."
 
        connectNetworkCommand
        
    done

    tput setaf 5;
    echo "Connected network."
    
}

function disconnectNetwork {

    tput setaf 5;
    echo "Disconnecting network..."

    while [[ "$(statusNetworking)" == "enabled" ]]
    do
    
        tput setaf 5;
        echo "Networking still enabled. Trying to disconnect.";

        disconnectNetworkCommand
        
    done

    tput setaf 5;
    echo "Disconnected network."

}

function reconnectNetwork {

    tput setaf 5;
    echo "Reconnecting network..."

    disconnectNetwork
    
    connectNetwork

    tput setaf 5;
    echo "Reconnected network."

}
    
function statusVPN {

    local res="undefined";

    if [[ "$(statusVPNConnectedCheckCommand)" == "1" ]]
    then
    
        res="connected"
    
    else 
           
        res="disconnected"
        
    fi

    echo $res
    
}

function disconnectVPN {

    tput setaf 4;
    echo "Disconnecting VPN..."
        
    if [[ "$(statusVPN)" == "disconnected" ]]
    then
        tput setaf 4;
        echo "VPN already disconnected"
    fi
    
    while [[ "$(statusVPN)" != "disconnected" ]]
    do
    
        #tput setaf 4;
        #echo "Trying to disconnect VPN..."
        
        
        # command to disconnect VPN
        disconnectVPNCommand
        
        #tput setaf 4;
        #echo "VPN status: $(statusVPN)"
        
    done
    
    tput setaf 4;
    echo "Disconnected VPN."

    sleep 10s;
    
}

connectionVPNInfoString="-";
function connectVPN {

    tput setaf 4;
    echo "Connecting VPN..."

    if [[ "$(statusNetwork)" == "connected" ]]
    then
    
        while [[ "$(statusNetwork)" == "connected" && "$(statusVPN)" != "connected" ]]
        do

            die1=$((RANDOM % ${#location[*]}))
            
            tput setaf 4;
            echo "Trying to connect VPN to ${location[$die1]}"
            
            
            # command to connect to VPN
            connectVPNCommand ${location[$die1]}
            
            if [[ "$(statusVPN)" != "connected" ]]
            then
            
                tput setaf 1;
                echo "Some trouble connecting to VPN... Will try again using the fall-back option..."
            
                connectVPNFallbackCommand
            
                if [[ "$(statusVPN)" != "connected" ]]
                then

                    tput setaf 1;
                    echo "The fall-back option did not work! Will try again from the beginning..."

                else

                    tput setaf 4;
                    echo "Successfully connected to VPN using the fall-back option!"

                fi

            else
            
                tput setaf 4;
                echo "Successfully connected to VPN!"
            
            fi
        
        done
        
        #tput setaf 4;
        #echo "Connected VPN."

    else # network not connected
    
        tput setaf 1;
        echo "Will not connect to VPN because no network connection is setup!";
        
    fi

    #get connection stats if available
    if [[ $(type -t connectionVPNInfo) == function ]]
    then
        connectionVPNInfoString="$(connectionVPNInfo)"
        #echo "###############  function exists  ############## $connectionVPNInfoString"
    else
        connectionVPNInfoString="";
        #echo "###############  function DOES NOT EXIST  ############## $connectionVPNInfoString"
    fi
    
}

############################################################


############### init #######################################

echo -e "\033[2J"

initEXECommand

# at startup 
stopAttack
disconnectVPN

# stats
globalStartDate=$(date +%s);

############################################################

############### main #######################################

# main loop
while true
do

	if ! $use_proxy 
	then
	
      	endtime=$(date -ud "$runtime" +%s)
		
		while [[ $(date -u +%s) -le $endtime ]]
		do
			
			if [[ "$(statusNetwork)" != "connected" ]]
			then

                tput setaf 5;
                echo "Network seems not to be connected. Will try to reconnect..."

                stopAttack
                reconnectNetwork

			fi
			
			if [[ "$(statusVPN)" != "connected" ]] 
			then
                
                tput setaf 4;
                echo "VPN is not connected! Will try to reconnect and restart the attack..."

                stopAttack;
                                
                connectVPN;
                
                startAttack;
              	
            else # VPN connected
                    
                for (( i=1; i<=$heartbeatinterval; i++ ))
                do

                    checkAttackHeartBeat;

                    sleep 1s;

                done

                #sleep $heartbeatinterval

            fi # VPN connected

        done # attack duration
        
        tput setaf 7; tput setab 4;
        echo "$(date +%T) disconnecting from VPN server loop"; 
        tput setaf 6; tput setab 0;
        echo "----------------------------------------------";
        
        stopAttack;
        disconnectVPN;
    
    else # use_proxy
    
		for (( i=1; i<=$heartbeatinterval; i++ ))
        do

            checkAttackHeartBeat;

            sleep 1s;

        done

		#sleep $heartbeatinterval

    fi # use_proxy

    printStatus;

done #global loop

############################################################
