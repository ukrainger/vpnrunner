#!/bin/bash

##server locations for VPN
#сервери для VPN
#location=( "Belarus" "Uzbekistan" "Kyrgyzstan" "Kazakhstan" "Croatia" "Turkey" "Slovenia" "Hungary" "India" "Moldova" "Belgium" "United Kingdom" "United States" "Hong Kong" "Israel" "Portugal" "Switzerland" )
location=( "Belarus" "Uzbekistan" "Kyrgyzstan" "Kazakhstan" "Armenia" "Mongolia" "Turkey" "Slovenia" "Hungary" "India" "Moldova" "Israel" )


# VPN client
vpnEXE="expressvpn"


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
function connectVPNCommand { timeout 60s expressvpn connect $1; sleep 10s; }

#fallback command in case the primary one fails (happens sometimes with e.g. NordVPN)
function connectVPNFallbackCommand { timeout 60s expressvpn connect; sleep 10s; }

#disconnect from VPN
function disconnectVPNCommand { expressvpn disconnect; sleep 5s; } 

#check whether VPN is connected. It returns nothing if not matched.
function statusVPNConnectedCheckCommand { expressvpn status | grep -q 'Connected to'; echo $(($?==0)); }

############################################################
