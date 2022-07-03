#!/bin/bash

#server locations for VPN
#сервери для VPN
location=( "Croatia" "Turkey" "Slovenia" "Hungary" "India" "Moldova" "Belgium" "United_Kingdom" "United_States" "Hong_Kong" "Israel" "Portugal" "Switzerland" )


# VPN client
vpnEXE="nordvpn"


################ VPN commands ##############################

#chech whether VPN cliend it installed
function checkVPNPrerequisitesCommand {


    if ! [ -x "$(command -v $vpnEXE)" ]; then

        tput setaf 1;
        echo "Error: $vpnEXE is not available, therefore no VPN connection with the plugin $vpnPluginFileName is possible. Have you installed the VPN client/application from your provider?";
        exit 1

    fi

}

#connect to a certain location that will be selected from the list randomly. $1 is the location passed by the main script.
function connectVPNCommand { nordvpn connect $1; sleep 10s; } 

#fallback command in case the primary one fails (happens sometimes with e.g. NordVPN)
function connectVPNFallbackCommand { nordvpn connect; sleep 10s; }

#disconnect from VPN
function disconnectVPNCommand { nordvpn disconnect; sleep 5s; } 

#check whether VPN is connected. It returns nothing if not matched.
function statusVPNConnectedCheckCommand { nordvpn status | grep -q -w 'Connected'; echo $(($?==0)); }

############################################################
