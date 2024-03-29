#!/bin/bash

#server locations for VPN
#сервери для VPN
#location=( "slovenia" "armenia" "turkey" "moldova" "egypt" "serbia" "czech-republic" "croatia" "albania" "israel" "kazakhstan" "venezuela" "united-arab-emirates" "hungary" "qatar" "slovakia" "mongolia" "china" "saudi-arabia" "brazil" "india" )
location=( "armenia" "turkey" "moldova" "egypt" "serbia" "czech-republic" "croatia" "israel" "kazakhstan" "united-arab-emirates" "hungary" "mongolia" "china" "saudi-arabia" "india" )


# VPN client
vpnEXE="piactl"


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
function connectVPNCommand { piactl set protocol wireguard; piactl set region $1; sleep 5s; timeout 60s piactl connect; }

#fallback command in case the primary one fails (happens sometimes with e.g. NordVPN)
function connectVPNFallbackCommand { piactl set region $1; sleep 2s; timeout 60s piactl connect; }

#disconnect from VPN
function disconnectVPNCommand { piactl disconnect; }

#check whether VPN is connected. It returns nothing if not matched.
function statusVPNConnectedCheckCommand { piactl get connectionstate | grep -q -w 'Connected'; echo $(($?==0)); }

#some statistics on the connection
function connectionVPNInfoCommand { echo "rgn: $( piactl get region ) | ip: $(connectionVPNInfoIPCommand) | geo: $(connectionVPNInfoCountryCommand), $(connectionVPNInfoCityCommand) | prtcl: $( piactl get protocol )"; }

#restart VPN service. Note, the user must be allowed restarting.
function restartVPNServiceCommand {

    # non-interactive sudo. Will only work if the user is allowed to restart the service
    sudo -n systemctl restart piavpn.service; echo $(($?==0))

}

############################################################
