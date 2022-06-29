#!/bin/bash

#server locations for VPN
#сервери для VPN
#location=(RU BY AZ GE MD AM BG HR FR IL IN IT KG KZ RO ES SE SK CH TR)
location=(RU BY KZ AZ AM KG TR)


################ VPN commands ##############################


#connect to a certain location that will be selected from the list randomly. $1 is the location passed by the main script.
function connectVPNCommand { hotspotshield connect $1; sleep 10s; } 

#fallback command in case the primary one fails (happens sometimes with e.g. NordVPN)
function connectVPNFallbackCommand { hotspotshield connect; sleep 10s; }

#disconnect from VPN
function disconnectVPNCommand { hotspotshield disconnect; sleep 5s; } 

#check whether VPN is connected. It returns nothing if not matched.
function statusVPNConnectedCheckCommand { hotspotshield status | grep -w -q 'connected'; echo $(($?==0)); }

############################################################
