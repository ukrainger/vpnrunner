#!/bin/bash

############### networking commands ########################

#check whether networking is enabled at all. It returns nothing if not matched.
function statusNetworkingEnabledCheckCommand { nmcli networking | grep -w -q 'enabled'; echo $(($?==0)); } 

#check whether networking connectivity is available
function statusConnectivityEnabledCheckCommand { nmcli networking connectivity | grep -w -q 'full' || nmcli networking connectivity | grep -w -q 'limited'; echo $(($?==0)); } 

#check whether network connection is established (not the same as networking check)
function statusNetworkConnectedCheckCommand { nmcli -g STATE general | grep -w -q 'connected'; echo $(($?==0)); } 

#turn on network
function connectNetworkCommand {

    local timeout=1;
    local connectTriggered=0;

    # ensure networking toggles on
    if [[ "$(statusNetworkingEnabledCheckCommand)" != "1" ]] ; then
        nmcli networking on &
    fi;

    for (( i=1; i<=60; i++ )) ; do

        #echo -n ".";

        if [[ "$(statusNetworkingEnabledCheckCommand)" == "1" ]] ; then

            # activate connection if specified
            if [[ $# -eq 1 && "$connectTriggered" == "0" ]] ; then
                connectTriggered=1;
                nmcli connection up "$1" &
            fi;

            if [[ "$(statusNetworkConnectedCheckCommand)" == "1" ]] ; then

                timeout=0;
                break;

            else

                echo -n ".";
                sleep 1s;

            fi;

        else

            #nmcli networking on;
            echo -n ".";
            sleep 1s;

        fi

    done

    if [[ $timeout == 1 ]] ; then
        echo "TIMEOUT";
    fi;

}

#turn off network
function disconnectNetworkCommand {

    local timeout=1;
    local connectionSpecified=0;

    if [[ $# -eq 1 ]] ; then
        connectionSpecified=1;
        nmcli connection down "$1" &
    else
        nmcli networking off &
    fi;

    for (( i=1; i<=60; i++ )) ; do

        if [[ "$(statusNetworkingEnabledCheckCommand)" != "1" || ($connectionSpecified && "$(statusNetworkConnectedCheckCommand)" != "1") ]] ; then

            timeout=0;
            break;

        else

            echo -n ".";
            sleep 1s;

        fi

    done

    if [[ $timeout == 1 ]] ; then
        echo "TIMEOUT";
    fi;

}

############################################################
