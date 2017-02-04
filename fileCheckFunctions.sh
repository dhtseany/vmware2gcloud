#!/bin/bash

function sourceInputTypeAsk() {
	for sourceInputTypeSelection in $(
		dialog --backtitle "vmware2gcloud" \
		--ok-label "Next" --cancel-label "Exit" --radiolist \
		"What is the input source for this job?" 20 75 5 \
		1 "VMWare ESXi" on \
		2 "Google Compute Image" off \
		3 "Local VMWare Files on hard disk" off \
		4 "Local OVF or OVA Files" off \
		5 "Local RAW File" off 3>&1 1>&2 2>&3
		)
		do
			case "$sourceInputTypeSelection" in
			1) VMWareSetupCheck
				;;
			2) echo "Selection was Google Compute"
				;;
			3) InputFilenameCheck localVMWare
				;;
			4) echo "Selection was OVFFileInput"
				;;
			5) InputFilenameCheck localRaw #GoTo InputFilenameCheck carrying localRaw in $1
				;;
			*) echo " $sourceInputTypeSelection was Not processed"
				;;
			esac
	done
}

function sourceOutputAsk() {
	for sourceOutputTypeSelection in $(
		dialog --backtitle "vmware2gcloud" --extra-button --extra-label "Previous" \
		--ok-label "Next" --cancel-label "Exit" --radiolist \
		"What is the output source for this job?" 20 75 4 \
		1 "VMWare ESXi" on \
		2 "Save to local filesystem" off \
		3 "Local VirtualBox Installation" off \
		4 "Upload to Google Compute" off 3>&1 1>&2 2>&3
		)
		do
			case "$sourceOutputTypeSelection" in
			1) echo "Selection was VMWareSetup"
				;;
			2) OutputFilenameCheck saveToFileSystem
				;;
			3) OutputFilenameCheck VBoxInstall
				;;
			4) echo "Selection was Google Compute"
					;;
			*) echo " $sourceOutputTypeSelection was Not processed"
				;;
			esac
		done

}

#//////////////////////////////////// START OF CHECK FUNCTIONS //////////////////////////////////// 
function InputFilenameCheck() {
	INTYPE=$1
	# echo "$INTYPE via InputFilenameCheck"
	#OLDER: INPUTFILE=$(dialog --title "You have not entered an input filename. Please enter one now." 15 75 --title "Input Filename Required" 3>&1 1>&2 2>&3)
	INPUTFILE=$(dialog --backtitle "vmware2gcloud" --title "Select input file." --fselect / 25 75 3>&1 1>&2 2>&3)
	# # SET INPUTFILE VARIABLE AND MOVE ON
	# echo "INPUT file is set to $INPUTFILE"
	#IN_PATH=${INPUTFILE##*.}
	IN_PATH=$(dirname ${INPUTFILE})
	# echo "IN_PATH is set to $IN_PATH"
	sourceOutputAsk
	for INTYPE in $INTYPE
	do
		case "$INTYPE" in
			localVMWare) OutputFilenameCheck $INTYPE localVMWare
			;;
			localRaw ) OutputFilenameCheck $INTYPE localRaw
			;;
		esac
	done
}

function OutputFilenameCheck() {
	INTYPE=$1
	OUTTYPE=$2
	# echo "OUTTYPE is set to $OUTTYPE"
	#echo "INPUTFILE is set to $INPUTFILE"
	#No it has not, prompt the user to enter an output filename.
	# echo "INPUTFILE is set to $INPUTFILE"
	STRPPATH=${INPUTFILE##*/}
	SUGGESTEDNAME=${STRPPATH%.*}
	# echo "SUGGESTEDNAME is set to $SUGGESTEDNAME"
	# exit
	# #OUTFILE=$(dialog --backtitle "vmware2gcloud" --title "Select Output Directory" --fselect $SUGGESTEDNAME-$INSTANCE_ID 25 75 3>&1 1>&2 2>&3)
	
	for OUTTYPE in $OUTTYPE
		do
			case $OUTTYPE in
				localVMWare) ext="ovf"
				;;
				localRaw) ext="vmdk"
				;;
				VBoxInstall) ext="ovf"
				;;
			*)
		esac
	done
	OUTFILE=$SUGGESTEDNAME-$INSTANCE_ID.$ext
	echo "OUTFILE is set to $OUTFILE"
	for OUTTYPE in $OUTTYPE
			do
				case $OUTTYPE in
					localVMWare) echo "Sorry Hot Rod, but this isn't a working feature yet.'"
					;;
					localRaw) VirtualBoxReceivePrep $INTYPE localRaw
					;;
					VBoxInstall) VirtualBoxReceivePrep $INTYPE VBoxInstall
					;;
				*)
			esac
		done
}

function RAMAmountCheck() {
	RAMAMT=$(dialog --backtitle "vmware2gcloud" --inputbox "How much RAM in megabytes should be configured for this VM?" 15 75 4096 --title "Enter RAM Amount" 3>&1 1>&2 2>&3)
	if [[ $RAMAMT = 0 ]]
		then
			echo &>/dev/null
		else

			# How about now? Is there now a RAM amount to use?
			if [[ -z $RAMAMT ]]
				then
					echo "Operation4 failed due to missing RAM amount."
					exit
				else
					echo &>/dev/null
			fi
	fi
}

function VRAMAmountCheck() {
	# Prompt user for how much VRAM should be used
	VRAMAMT=$(dialog --backtitle "vmware2gcloud" --inputbox "How much VRAM in megabytes should be configured for this VM?" 15 75 16 --title "Enter RAM Amount" 3>&1 1>&2 2>&3)
	if [[ $VRAMAMT = 0 ]]
		then
			echo "User Selected OK and entered $VRAMAMT"
		else

			# How about now? Is there now a VRAM amount to use?
			if [[ -z $VRAMAMT ]]
				then
					echo "Operation4 failed due to missing VRAM amount."
					exit
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


