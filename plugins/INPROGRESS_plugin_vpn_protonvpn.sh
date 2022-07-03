#!/bin/bash

#server locations for VPN
#сервери для VPN
location=( US JP NL )


# VPN client
vpnEXE="protonvpn-cli"


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
function connectVPNCommand { timeout 60s protonvpn-cli connect --cc $1; sleep 15s; }

#fallback command in case the primary one fails (happens sometimes with e.g. NordVPN)
function connectVPNFallbackCommand { timeout 60s protonvpn-cli reconnect; sleep 10s; }

#disconnect from VPN
function disconnectVPNCommand { protonvpn-cli disconnect; sleep 5s; }

#check whether VPN is connected. It returns nothing if not matched.
function statusVPNConnectedCheckCommand { protonvpn-cli status | grep -q -w ''; echo $(($?==0)); }

############################################################
