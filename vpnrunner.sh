#!/bin/bash

#script requires installed and configured VPN client. Such clients as nordvpn, expressvpn, pia, hotspotshield have been tested.
#для роботи скрипту необхідний встановленний та налаштований VPN-клієнт. Випробувано із nordvpn, expressvpn, pia, hotspotshield.

#script for automatic download newest version of db1000n and running it only if VPN is active
#Скрипт автоматично завантажить найновішу версію db1000n та запустить її лише коли VPN є активним

#parameters:
# --vpn - VPN plugin
# --exe - executable plugin. Default: default (db1000n)
# --network-manager - network manager plugin. Default: default (nm)
#параметри
# --vpn - VPN
# --exe - виконавча програма. Замовчування: default (db1000n)
# --network-manager - менеджер мережі. Замовчування: default (nm)

#the duration of the script until the VPN server is reconnected
#тривалість роботи до перепідключення із VPN-сервером
runtime="15 minute"

vpnInfoUpdateInterval="3 minute"

#heartbeatinterval between checks if still connected to VPN server. put number in seconds
#як часто перевіряти з'єднання з VPN сервером. час у секундах
heartbeatinterval=5

#if you want to use proxy leave the line on true, for using VPN change value to false (note, --use-proxy)
#якщо хочете використовувати проксі, залиште значення true. для використання VPN змініть на false (--use-proxy)
use_proxy=false

#force binaries reinstall
forceExeReinstall=false

################ arguments and plugins  ####################

#plugin directory
pluginDir="plugins"
exePluginFileName="${pluginDir}/plugin_exe_default.sh"
networkingPluginFileName="${pluginDir}/plugin_networking_default.sh"

#ensure the right starting directory
#echo "The script you are running has basename $( basename -- "$0"; ), dirname $( dirname -- "$0"; )";
cd $( dirname -- "$0"; )

#help
function printHelp {

    tput setaf 2;
    echo ""
    echo "Usage: $0 [arguments ...]"
    echo ""
    echo "Example: $0 --vpn hotspotshield"
    echo "Example: $0 --vpn nordvpn --exe distress"
    echo "Example: $0 --vpn expressvpn --exe db1000n --network-manager nm"
    echo ""
    echo "  --help                - [u] show this help info"
    echo "  --vpn                 - [b] VPN plugin to use (some are available, one must be selected)"
    echo "  --exe                 - [b] executable plugin to use (default available)"
    echo "  --use-proxy           - [u] asks the exe to use proxy, if supported (default $use_proxy)"
    echo "  --network-manager     - [b] network manager plugin to use (default available)"
    echo "  --heartbeat-interval  - [b] interval to check the VPN status, in seconds (default is $heartbeatinterval)"
    echo "  --restart-interval    - [b] interval to restart the run, in minutes (default is $runtime)"
    echo "  --force-exe-reinstall - [u] executable will be removed and reinstalled (default is $forceExeReinstall)"
    echo ""
    echo "[u] - does not require any parameter value, [b] - requires parameter value."
    echo ""
    echo "Note, executables will be downloaded automatically if not available."
    echo ""
    tput setaf 4;

}

#parsing arguments
argidx=1;
for arg in $@
do
    #echo "arg: $arg"
    args[$argidx]=$arg
    argidx=$(( $argidx+1 ));
done

args=$@

#check for mandatory arguments
vpnArgSpecified=false;
proxyArgSpecified=false;
for (( i=1 ; i <= $# ; ++i ))
do

    if [[ "${args[$i]}" == "--vpn" ]]; then

         vpnArgSpecified=true;

    elif [[ "${args[$i]}" == "--use-proxy" ]]; then

        proxyArgSpecified=true;

    fi

done

for (( i=1 ; i <= $# ; ++i ))
do

    if [[ "${args[$i]}" == "--help" ]] ; then

        printHelp;
        exit

    elif [[ "${args[$i]}" == "--use-proxy" ]] ; then

        use_proxy=true;

    elif [[ "${args[$i]}" == "--force-exe-reinstall" ]]; then

        forceExeReinstall=true;

    else

        if [[ $i == $# && "${args[$i]:0:1}" == "-" || "${args[$i]:0:1}" == "-" && "${args[$(( $i+1 ))]:0:1}" == "-" ]]
        then

            echo "No proper argument value for argument ${args[$i]} -> exit";
            exit 1
            #continue;

        fi

        if [[ "${args[$i]:0:1}" != "-" ]]
        then

            echo "Not a proper argument name ${args[$i]} -> exit";
            exit 1
            #continue;

        fi

        argName=${args[$i]};
        i=$(( $i+1 ));
        argValue=${args[$i]}

        #process the arguments

        if [[ "$argName" == "--vpn" ]]; then

            echo "parsed argument $argName: ${argValue}"

            vpnPluginName=$argValue;

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

        elif [[ "$argName" == "--exe" ]]; then

            echo "parsed argument $argName: ${argValue}"

            #check whether the exe plugin exists
            exePluginFileName="${pluginDir}/plugin_exe_$argValue.sh";
            if [ -e $exePluginFileName ]
            then

                echo "Exe plugin for $argValue found.";

            else

                tput setaf 1;
                echo "Exe plugin for $argValue NOT found (file $exePluginFileName does not exist) -> will exit.";
                exit 1;

            fi #exe plugin check


        elif [[ "$argName" == "--network-manager" ]]; then

            echo "parsed argument $argName: ${argValue}"

            #check whether the networking plugin exists
            networkingPluginFileName="${pluginDir}/plugin_networking_$argValue.sh";
            if [ -e $networkingPluginFileName ]
            then

                echo "Networking plugin for $argValue found.";

            else

                tput setaf 1;
                echo "Networking plugin for $argValue NOT found (file $networkingPluginFileName does not exist) -> will exit.";
                exit 1;

            fi #networking plugin check

        elif [[ "$argName" == "--heartbeat-interval" ]]; then

            echo "parsed argument $argName: ${argValue}"

            heartbeatinterval=${argValue}

        elif [[ "$argName" == "--restart-interval" ]]; then

            echo "parsed argument $argName: ${argValue}"

            #check whether the networking plugin exists
            runtime="${argValue} minute"

        fi #parameters

    fi #unary vs binary arguments

done


if (! $vpnArgSpecified) && (! $proxyArgSpecified) ; then

    vpnPluginNames=( $(find -type f -wholename "./${pluginDir}/plugin_vpn_*.sh") );

    tput setaf 2;
    echo "Please specify --use-proxy or the --vpn argument for one of the following available VPN plugins:";
    echo ""
    tput setaf 4;
    for curVPNPluginName in "${vpnPluginNames[@]}"
    do
        expr "$curVPNPluginName" : "./${pluginDir}/plugin_vpn_\(.*\).sh"
    done

    echo ""
    tput setaf 2;

    exit 1;

fi

source ${pluginDir}/plugin_utilities.sh

if $vpnArgSpecified ; then

    source $vpnPluginFileName

fi

source $exePluginFileName

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

exeInfoString="";
function startAttack {

    tput setaf 6;

    #get connection stats if available
    if [[ $(type -t exeInfoCommand) == function ]] ; then
        exeInfoString="$(exeInfoCommand)"
    else
        exeInfoString="";
    fi

    if $vpnArgSpecified ; then

        if [[ "$(statusVPN)" == "connected" ]] ; then

            if $use_proxy ; then

                startAttackProxyCommand

            else

                startAttackCommand

            fi

        else

            tput setaf 1;
            echo "Will not start attacking because no VPN connection is setup!"

        fi

    else #use at least proxy

        if $use_proxy ; then

            startAttackProxyCommand

        else

            tput setaf 1;
            echo "Will not start attacking because no VPN connection is setup and no proxy is used!"

        fi #use proxy

    fi #vpn connected

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

    exeInfoString="";

    echo -ne "\033[20B"

}

function exitScript {

    stopAttack;

    echo "Exiting the script..."

    sleep 3s;

    echo -e "\033[2J";

}

trap exitScript EXIT

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

    statOffset=10;
    statHeight=8; # must equal the number of output rows

    #clean
    local i; # important to have it as local here, otherwise it leads to issues in the main loop
    for (( i=1 ; i<= $(( ${statHeight} + ${statOffset} )) ; ++i ))
    do
        echo -ne "\033[K\r\n"
    done

    echo -ne "\033[${statHeight}A"

    nCols=$(tput cols);

    tput setaf 2;
    for (( j=1 ; j<=${nCols} ; ++j )); do echo -n "-"; done
    echo -e " Run status:\t\t${wipIndicator}\t\t"
    if $vpnArgSpecified ; then
        if ! $use_proxy ; then
            echo -e " VPN:\t\t\t${vpnPluginName} ($connectionVPNInfoString)"
        else
            echo -e " VPN+proxy:\t\t${vpnPluginName} ($connectionVPNInfoString)"
        fi
    else
        echo -e " proxy:\t\t\tusing proxy"
    fi
    echo -e " Exe:\t\t\t${EXE} ( $exeInfoString )\t\t"
    echo -e " Time:\t\t\t$(date +%T)\t\t"
    echo -e " Next restart:\t\t$(date -d @${endtime} +"%T")\t\t"
    echo -e " Total run duration:\t$(( ${seconds}/3600/24 )) d $(date -ud @$seconds +'%H h %M m %S s')\t"
    for (( j=1 ; j<=${nCols} ; ++j )); do echo -ne "-"; done; echo ""
    tput setaf 6;

    echo -ne "\033[$(( ${statHeight} + ${statOffset} ))A"

}

function checkAttackHeartBeat {

    updateWIPIndicator

    seconds=0;

    if [[ $(statusAttack) == "running" ]] ; then

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

connectionVPNInfoString="";

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

    connectionVPNInfoString="";

    #sleep 10s;
    
}

function connectionVPNInfoStringUpdate {

    #get connection stats if available
    if [[ $(type -t connectionVPNInfoCommand) == function ]] ; then

        if [[ ($connectionVPNInfoString == "") || ($connectionVPNInfoString =~ \?+) ]] ; then

            connectionVPNInfoString="$(connectionVPNInfoCommand)"

        fi;
        #echo "###############  function exists  ############## $connectionVPNInfoString"

    else

        connectionVPNInfoString="";
        #echo "###############  function DOES NOT EXIST  ############## $connectionVPNInfoString"

    fi

}

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
            
                connectVPNFallbackCommand ${location[$die1]}
            
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

    connectionVPNInfoStringUpdate
    
}

############################################################


############### init #######################################

#clrscr
echo -e "\033[2J"

# check prerequisites
if [[ $(type -t checkVPNPrerequisitesCommand) == function ]] ; then

    checkVPNPrerequisitesCommand;

else

    echo "checkVPNPrerequisitesCommand not defined -> will skip VPN-relevant checks.";

fi

# initialize the EXE
initEXECommand

# at startup 
stopAttack

if $vpnArgSpecified; then

    disconnectVPN

fi

# stats
globalStartDate=$(date +%s);

############################################################

############### main #######################################

# main loop
while true ; do

	if (! $use_proxy) || ($proxyArgSpecified && $vpnArgSpecified) ; then
	
      	endtime=$(date -ud "$runtime" +%s)
      	vpnInfoUpdateTime=$(date -ud "$vpnInfoUpdateInterval" +%s)
		
		while [[ $(date -u +%s) -le $endtime ]] ; do

			if [[ "$(statusNetwork)" != "connected" ]] ;then

                tput setaf 5;
                echo "Network seems not to be connected. Will try to reconnect..."

                stopAttack
                reconnectNetwork

			fi
			
			if [[ "$(statusVPN)" != "connected" ]] ; then
                
                tput setaf 4;
                echo "VPN is not connected! Will try to reconnect and restart the attack..."

                stopAttack;
                                
                connectVPN;
                
                startAttack;
              	
            else # VPN connected
                    
                for (( i=1; i<=$(( $heartbeatinterval * 2 )); i++ )) ; do

                    checkAttackHeartBeat;

                    sleep 0.5s;

                    if [[ $(date -u +%s) -ge $endtime ]] ; then

                        break;

                    fi

                done

                #sleep $heartbeatinterval

            fi # VPN connected

            # update vpn info
            if [[ $(date -u +%s) -ge $vpnInfoUpdateTime ]] ; then

                connectionVPNInfoStringUpdate

                # get the next time point for VPN info update
                vpnInfoUpdateTime=$(date -ud "$vpnInfoUpdateInterval" +%s)

            fi # vpn info update

        done # attack duration
        
        tput setaf 7; tput setab 4;
        echo "$(date +%T) disconnecting from VPN server loop"; 
        tput setaf 6; tput setab 0;
        echo "----------------------------------------------";
        
        stopAttack;
        disconnectVPN;
    
    else # use_proxy only
    
        endtime=$(date -ud "$runtime" +%s)

        while [[ $(date -u +%s) -le $endtime ]] ; do

            for (( i=1; i<=$(( $heartbeatinterval * 2 )); i++ )) ; do

                checkAttackHeartBeat;

                sleep 0.5s;

                if [[ $(date -u +%s) -ge $endtime ]] ; then

                    break;

                fi

            done

        done #running

        tput setaf 7; tput setab 4;
        echo "$(date +%T) restarting the loop";
        tput setaf 6; tput setab 0;
        echo "----------------------------------------------";

        stopAttack

    fi # use_proxy

    printStatus;

done #global loop

############################################################
