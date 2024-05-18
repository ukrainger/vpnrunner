#!/bin/bash


#checking for installation
#виконавча програма
EXEDir=void
EXE=void

voidRunning=0;

############### functions ##################################

function statusAttackCommand {

    #echo $((1==1));
    echo $(($voidRunning==1));

}

function startAttackProxyCommand {

    voidRunning=1;

}
 
function startAttackCommand {

    voidRunning=1;

}

function stopAttackCommand {

    voidRunning=0;

}


#some statistics
function exeInfoCommand {

    :;

}


############################################################


############### init #######################################

function initEXECommand {

    initEXECommandSucceeded=true;

}

############################################################

