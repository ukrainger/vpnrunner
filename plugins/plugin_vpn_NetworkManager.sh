#!/bin/bash

#NetworkManager connection names for VPN. Regex possible.
#Назви з'єднань для VPN у NetworkManager
#location=( "armenia" "hungary" "^us_.*$" )
#location=( "^us_.*$" )
location=( ".*" ) # ".*" means that any openvpn or wireguard connection from NM will be used. Modify the list if you need a different behavior.


# VPN client. Note, connections will be managed by NetworkManager.
vpnEXE="nmcli"


################ VPN init ##################################

# relevant NM connections
nmVPNConnectionNames=()

# relevant NM connections
function nmVPNConnectionNamesCommand {

    curNMVPNConnectionNames=$(nmcli -g NAME connection);

    i=1;
    for curNMVPNConnectionName in ${curNMVPNConnectionNames[@]}
    do

        #echo "checking connection $curNMVPNConnectionName"
        #echo "$curNMVPNConnectionName: $(nmcli -g connection.type connection show $curNMVPNConnectionName)"
        if [[ ("$(nmcli -g connection.type connection show $curNMVPNConnectionName)" == "vpn") || ("$(nmcli -g connection.type connection show $curNMVPNConnectionName)" == "wireguard") ]] ; then

            for curLocation in ${location[@]} ; do #match location patterns

                #echo "curLocation $curLocation"

                if [[ $curNMVPNConnectionName =~ $curLocation ]] ; then

                    nmVPNConnectionNames[$i]=$curNMVPNConnectionName

                    i=$(( $i + 1 ))

                    #echo "$curNMVPNConnectionName -> OK"

                    break;

                fi #location pattern matching

            done # location pattern matchin

        fi; # it's a vpn connection

    done # connections

    echo "Suitable VPN connections:"
    for curNMVPNConnectionName in ${nmVPNConnectionNames[@]} ; do

        echo "${curNMVPNConnectionName}"

    done

}

nmVPNConnectionNamesCommand

# disconnect VPN connections that match with the specified locations
for tmpConnectionName in ${nmVPNConnectionNames[@]} ; do

    if [[ "$(nmcli -g GENERAL.STATE c s $tmpConnectionName)" == "activated" ]] ; then

        echo "Disconnecting VPN connection: $tmpConnectionName"

        timeout 60s nmcli connection down $tmpConnectionName;

    fi

done

sleep 1s;

curConnectionName="";

############################################################


################ VPN commands ##############################


#check whether VPN cliend it installed
function checkVPNPrerequisitesCommand {


    if ! [ -x "$(command -v $vpnEXE)" ]; then

        tput setaf 1;
        echo "Error: $vpnEXE is not available, therefore no VPN connection with the plugin $vpnPluginFileName is possible. Do you use NetworkManager for connection management in yor system?";
        exit 1

    fi

}

#connect to a certain location that will be selected from the list randomly. $1 is the location passed by the main script.
function connectVPNCommand {

    nmVPNConnectionNamesCommand

    local candidateConnectionNames;
    local idx=0;

    for tmpConnectionName in ${nmVPNConnectionNames[@]} ; do

        if [[ $tmpConnectionName =~ $1 ]] ; then

            idx=$(( $idx + 1 ));
            candidateConnectionNames[$idx]=$tmpConnectionName;

        fi

    done

    local connectionIdx=$(( RANDOM % ${idx} + 1 ))

    curConnectionName="${candidateConnectionNames[$connectionIdx]}"

    echo "Trying to connect to the picked NM connection: $curConnectionName";

    timeout 60s nmcli connection up $curConnectionName;

    sleep 2s;

}

#fallback command in case the primary one fails (happens sometimes with e.g. NordVPN)
function connectVPNFallbackCommand { timeout 60s nmcli connection up $curConnectionName; sleep 1s; }

#disconnect from VPN
function disconnectVPNCommand {

    if [[ "$(nmcli -g GENERAL.STATE c s $curConnectionName)" == "activated" ]] ; then

        timeout 60s nmcli connection down $curConnectionName;

    fi

    curConnectionName="";

    sleep 1s;

}

#check whether VPN is connected. It returns nothing if not matched.
function statusVPNConnectedCheckCommand { if [[ "$curConnectionName" != "" ]] ; then  nmcli -g GENERAL.STATE c s $curConnectionName | grep -q -w 'activated'; else echo 0; fi; echo $(($?==0)); }

#some statistics on the connection
function connectionVPNInfoCommand { echo "con: $curConnectionName | ip: $(connectionVPNInfoIPCommand) | geo: $(connectionVPNInfoCountryCommand), $(connectionVPNInfoCityCommand)  | type: $(expr "$(nmcli -g vpn.service-type connection show $curConnectionName)" : '.*\.\(.*\)')"; }

############################################################
