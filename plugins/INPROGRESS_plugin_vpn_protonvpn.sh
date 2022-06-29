#!/bin/bash

#server locations for VPN
#сервери для VPN
location=( US JP NL )


################ VPN commands ##############################

#connect to a certain location that will be selected from the list randomly. $1 is the location passed by the main script.
function connectVPNCommand { timeout 60s protonvpn-cli connect --cc $1; sleep 15s; }

#fallback command in case the primary one fails (happens sometimes with e.g. NordVPN)
function connectVPNFallbackCommand { timeout 60s protonvpn-cli reconnect; sleep 10s; }

#disconnect from VPN
function disconnectVPNCommand { protonvpn-cli disconnect; sleep 5s; }

#check whether VPN is connected. It returns nothing if not matched.
function statusVPNConnectedCheckCommand { protonvpn-cli status | grep -q -w ''; echo $(($?==0)); }

############################################################
