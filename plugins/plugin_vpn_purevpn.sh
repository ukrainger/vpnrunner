#!/bin/bash

#server locations for VPN
#сервери для VPN
#location=( RU IN HU AF EG GE RS TR AE BG CN MC VN )
location=( RU IN HU TR CN )


# VPN client
vpnEXE="purevpn"


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
function connectVPNCommand { timeout 60s purevpn --connect $1; sleep 10s; }

#fallback command in case the primary one fails (happens sometimes with e.g. NordVPN)
function connectVPNFallbackCommand { timeout 60s purevpn --connect; sleep 10s; }

#disconnect from VPN
function disconnectVPNCommand { purevpn --disconnect; sleep 5s; }

#check whether VPN is connected. It returns nothing if not matched.
function statusVPNConnectedCheckCommand { purevpn --status | grep -q -w 'Connected'; echo $(($?==0)); }

#some statistics on the connection
function connectionVPNInfoCommand { echo "$(purevpn --info|tr -d '=-'|tr '\n\t' ' ')"; }

############################################################
