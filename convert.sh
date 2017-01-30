#!/bin/bash

source ./fileCheckFunctions.sh
source ./virtualbox.sh
source ./vmware.sh

INPUTFILE=$1
OUTFILE=$2
INSTANCE_ID=${RANDOM}

sourceInputTypeAsk

# FILECHECK="${INPUTFILE#*.}"
# Does $INPUTFILE end with a tar.gz?
# if [[ $FILECHECK != "tar.gz" ]]
# 	then
# 		InputFilenameCheck
# 		VirtualBoxReceivePrep
# 		convertVMWaretoVBox
# 		processRAWConversion
# 	else
# 		TARNAME=$INPUTFILE
# 		whiptail --title "Previous Conversion Detected." --msgbox "$TARNAME was detected. Proceeding directly to Google Upload scripts." 8 78
# fi
# uploadToGoogle