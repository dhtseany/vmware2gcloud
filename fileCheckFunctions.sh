#!/bin/bash

function sourceInputTypeAsk() {
	for sourceInputTypeSelection in $(
		dialog --backtitle "vmware2gcloud" \
		--ok-label "Next" --cancel-label "Exit" --radiolist \
		"What is the input source for this job?" 20 75 5 \
		1 "VMWare ESXi" on \
		2 "Google Compute Image" off \
		3 "Local VMWare Files on hard disk" off \
		4 "Local OVF or OVA Files" off 3>&1 1>&2 2>&3
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
			2) echo "Selection was InputFilenameCheck"
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
	# INPUTFILE=$(dialog --title "You have not entered an input filename. Please enter one now." 15 75 --title "Input Filename Required" 3>&1 1>&2 2>&3)
	INPUTFILE=$(dialog --backtitle "vmware2gcloud" --title "Select input file." --fselect / 25 75 3>&1 1>&2 2>&3)
	# SET INPUTFILE VARIABLE AND MOVE ON
	echo "INPUT file is set to $INPUTFILE"
	sourceOutputAsk
	for INTYPE in $INTYPE
	do
		case "$INTYPE" in
			localVMWare) OutputFilenameCheck
			;;
		esac
	done
}

function OutputFilenameCheck() {
	OUTTYPE=$1
	#echo "INPUTFILE is set to $INPUTFILE"
	#No it has not, prompt the user to enter an output filename.
	SUGGESTEDNAME=${INPUTFILE%.*}
	# #OUTFILE=$(dialog --backtitle "vmware2gcloud" --title "Select Output Directory" --fselect $SUGGESTEDNAME-$INSTANCE_ID 25 75 3>&1 1>&2 2>&3)
	OUTFILE=$SUGGESTEDNAME-$INSTANCE_ID.ovf
	#echo "OUTFILE is set to $OUTFILE"
	for OUTTYPE in $OUTTYPE
		do
			case "$OUTTYPE" in
				VBoxInstall) VirtualBoxReceivePrep
				;;
				*) exit
		esac
	done

}

function RAMAmountCheck() {
	RAMAMT=$(dialog --backtitle "vmware2gcloud" --inputbox "How much RAM in megabytes should be configured for this VM?" 15 75 4096 --title "Enter RAM Amount" 3>&1 1>&2 2>&3)
	if [[ $RAMAMT = 0 ]]
		then
			echo ""
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