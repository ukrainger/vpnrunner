#!/bin/bash

############### networking commands ########################

#check whether networking is enabled at all. It returns nothing if not matched.
function statusNetworkingEnabledCheckCommand { nmcli networking | grep -w -q 'enabled'; echo $(($?==0)); } 

#check whether networking connectivity is available
function statusConnectivityEnabledCheckCommand { nmcli networking connectivity | grep -w -q 'full' || nmcli networking connectivity | grep -w -q 'limited'; echo $(($?==0)); } 

#check whether network connection is established (not the same as networking check)
function statusNetworkConnectedCheckCommand { nmcli -g STATE general | grep -w -q 'connected'; echo $(($?==0)); } 

#turn on network
function connectNetworkCommand { nmcli networking on; sleep 5s; }

#turn off network
function disconnectNetworkCommand { nmcli networking off; sleep 5s; } 

############################################################
