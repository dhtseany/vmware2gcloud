#!/bin/bash
source ./dump.sh

function sourceInputTypeAsk() {
	INTYPE=$(
		dialog --backtitle "vmware2gcloud" \
		--ok-label "Next" --cancel-label "Exit" --radiolist \
		"What is the input source for this job?" 20 75 5 \
		1 "VMWare ESXi" on \
		2 "Google Compute Image" off \
		3 "Local VMWare Files on hard disk" off \
		4 "Local OVF or OVA Files" off \
		5 "Local RAW File" off 3>&1 1>&2 2>&3
		)
}

function sourceOutputTypeAsk() {
	OUTTYPE=$(
		dialog --backtitle "vmware2gcloud" --extra-button --extra-label "Previous" \
		--ok-label "Next" --cancel-label "Exit" --radiolist \
		"What is the output source for this job?" 20 75 4 \
		1 "VMWare ESXi" on \
		2 "Save to local filesystem" off \
		VBoxInstall "Local VirtualBox Installation" off \
		4 "Upload to Google Compute" off 3>&1 1>&2 2>&3
		)
}

#//////////////////////////////////// START OF CHECK FUNCTIONS //////////////////////////////////// 
function InputFilenameCheck() {
	INTYPE=$1
	# echo "$INTYPE via InputFilenameCheck"
	# exit
	#OLDER: INPUTFILE=$(dialog --title "You have not entered an input filename. Please enter one now." 15 75 --title "Input Filename Required" 3>&1 1>&2 2>&3)
	INPUTFILE=$(dialog --backtitle "vmware2gcloud" --title "Select input file." --fselect / 25 75 3>&1 1>&2 2>&3)
	# # SET INPUTFILE VARIABLE AND MOVE ON
	# echo "INPUT file is set to $INPUTFILE"
	#IN_PATH=${INPUTFILE##*.}
	IN_PATH=$(dirname ${INPUTFILE})
	# echo "IN_PATH is set to $IN_PATH"
	# sourceOutputTypeAsk
	# for INTYPE in $INTYPE
	# do
	# 	case "$INTYPE" in
	# 		localVMWare) OutputFilenameCheck localVMWare
	# 		;;
	# 		localRaw ) OutputFilenameCheck localRaw 
	# 		;;
	# 		*) dump_message="WeirdInputTypeReceived" && dump_function="InputFilenameCheck" && dump $dump_function $dump_message
	# 	esac
	# done
}

function OutputFilenameCheck() {
	# INTYPE=$1
	# OUTTYPE=$1
	# echo "INTYPE is set to $INTYPE"
	# echo "OUTTYPE is set to $OUTTYPE"
	# echo "INPUTFILE is set to $INPUTFILE"
	#No it has not, prompt the user to enter an output filename.
	# echo "INPUTFILE is set to $INPUTFILE"
	STRPPATH=${INPUTFILE##*/}
	SUGGESTEDNAME=${STRPPATH%.*}
	# echo "SUGGESTEDNAME is set to $SUGGESTEDNAME"
	# exit
	# #OUTFILE=$(dialog --backtitle "vmware2gcloud" --title "Select Output Directory" --fselect $SUGGESTEDNAME-$INSTANCE_ID 25 75 3>&1 1>&2 2>&3)
	
	
	#echo "ext is set to $ext"
	OUTFILE=$SUGGESTEDNAME-$INSTANCE_ID.$ext
	STRPOPATH=${OUTFILE##*/}
	SHRTOF=${STRPOPATH%.*}
	OUT_PATH=$IN_PATH/$SHRTOF-$OUTTYPE-converted

	# echo "OUTFILE is set to $OUTFILE"
	# for OUTTYPE in $OUTTYPE 
	# 		do
	# 			case $OUTTYPE in
	# 				localVMWare) echo "Sorry Hot Rod, but this isn't a working feature yet.'"
	# 				;;
	# 				localRaw) VirtualBoxReceivePrep $INTYPE $OUTTYPE
	# 				;;
	# 				#VBoxInstall) VirtualBoxReceivePrep $INTYPE $OUTTYPE
	# 				VBoxInstall) VirtualBoxReceivePrep --localRaw --VBoxInstall
	# 				;;
	# 				*) dump_message="WeirdOutputTypeReceivedDuringFinalOutputCheck" && dump_function="OutputFilenameCheck" && dump $dump_function $dump_message
	# 			esac
	# done
}

function RAMAmountCheck() {
	RAMAMT=$(dialog --backtitle "vmware2gcloud" --title "Enter RAM Amount" --inputbox "How much RAM in megabytes should be configured for this VM?" 15 75 "4096" 3>&1 1>&2 2>&3)
	if [[ $RAMAMT = 0 ]]
		then
			echo &>/dev/null
		else

			# How about now? Is there now a RAM amount to use?
			if [[ -z $RAMAMT ]]
				then
					dump_message="MissingRAMAmount" && dump_function="RAMAmountCheck" && dump $dump_function $dump_message
				else
					echo &>/dev/null
			fi
	fi
}

function VRAMAmountCheck() {
	# Prompt user for how much VRAM should be used
	VRAMAMT=$(dialog --backtitle "vmware2gcloud" --title "Enter VRAM Amount" --inputbox "How much VRAM in megabytes should be configured for this VM?" 15 75 "16" 3>&1 1>&2 2>&3)
	if [[ $VRAMAMT = 0 ]]
		then
			echo "User Selected OK and entered $VRAMAMT"
		else

			# How about now? Is there now a VRAM amount to use?
			if [[ -z $VRAMAMT ]]
				then
					dump_message="MissingVRAMAmount" && dump_function="VRAMAmountCheck" && dump $dump_function $dump_message
				else
					echo &>/dev/null
			fi
	fi
}
#//////////////////////////////////// END OF CHECK FUNCTIONS //////////////////////////////////// 

function configFolderCheck() {
	if [[ -d ~/.config/vmware2gcloud ]]
		then
			echo &>/dev/null
		else    
			mkdir -p ~/.config/vmware2gcloud
	fi
}