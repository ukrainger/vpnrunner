#!/bin/bash

#source "${pluginDir}/plugin_networking_nm.sh"

echo "#####################################################################################################################"
echo "Note, there is no network management plugin selected -> no need to worry, vpnrunner will not change the network state"
echo "#####################################################################################################################"
#sleep 5s

networkingEnabled=1;
networkConnected=1;

############### networking commands ########################

#check whether networking is enabled at all.
function statusNetworkingEnabledCheckCommand { echo $(($networkingEnabled==1)); }

#check whether networking connectivity is available
function statusConnectivityEnabledCheckCommand { echo 1; }

#check whether network connection is established (not the same as networking check)
function statusNetworkConnectedCheckCommand { echo $(($networkConnected==1)); }

#turn on network
function connectNetworkCommand { networkingEnabled=1; networkConnected=1; }

#turn off network
function disconnectNetworkCommand { networkConnected=0; networkingEnabled=0; }

############################################################
