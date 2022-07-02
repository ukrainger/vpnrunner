#!/bin/bash

#source "${pluginDir}/plugin_networking_nm.sh"

echo "#################################################################################################"
echo "Note, there is no active network management plugin selected -> network state will not be impacted";
echo "#################################################################################################"
sleep 5s

############### networking commands ########################

#check whether networking is enabled at all. It returns nothing if not matched.
function statusNetworkingEnabledCheckCommand { echo 1; }

#check whether networking connectivity is available
function statusConnectivityEnabledCheckCommand { echo 1; }

#check whether network connection is established (not the same as networking check)
function statusNetworkConnectedCheckCommand { echo 1; }

#turn on network
function connectNetworkCommand { sleep 1s; }

#turn off network
function disconnectNetworkCommand { sleep 1s; }

############################################################
