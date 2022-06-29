#!/bin/bash

#server locations for VPN
#сервери для VPN
location=( "Croatia" "Turkey" "Slovenia" "Hungary" "India" "Moldova" "Belgium" "United_Kingdom" "United_States" "Hong_Kong" "Israel" "Portugal" "Switzerland" )


################ VPN commands ##############################

#connect to a certain location that will be selected from the list randomly. $1 is the location passed by the main script.
function connectVPNCommand { nordvpn connect $1; sleep 10s; } 

#fallback command in case the primary one fails (happens sometimes with e.g. NordVPN)
function connectVPNFallbackCommand { nordvpn connect; sleep 10s; }

#disconnect from VPN
function disconnectVPNCommand { nordvpn disconnect; sleep 5s; } 

#check whether VPN is connected. It returns nothing if not matched.
function statusVPNConnectedCheckCommand { nordvpn status | grep -q -w 'Connected'; echo $(($?==0)); }

############################################################
