#!/bin/bash
source ./dump.sh

function VBoxOSTypeSelect() {
	VBoxOSList=$(vboxmanage list ostypes | grep ^ID | sed -e 's/^ID:          //')
	VBoxOSArray=($VBoxOSList)
	VBoxOSTypeChoice=$(dialog --backtitle "vmware2gcloud" \
	--ok-label "Next" --cancel-label "Exit" --radiolist \
	"What OS Type should be used by VirtualBox?" 20 75 5 \
	for option in $VBoxOSArray
		do echo ${option[@]}
	done
	)
	# 1 "VMWare ESXi" on \
	# 2 "Google Computxe Image" off \
	# 3 "Local VMWare Files on hard disk" off \
	# 4 "Local OVF or OVA Files" off 
	# 5 "Local RAW File" 3>&1 1>&2 2>&3
	exit
}

function VirtualBoxReceivePrep() {
	# INTYPE=$1
	# OUTTYPE=$2
#	echo "OUTFILE is set to $OUTFILE"
	RAMAmountCheck
	VRAMAmountCheck
	chooseVBoxOSType
	# echo "SHRTOF is set to $SHRTOF"
	# exit
	# /home/snellsg/vmware/winservtest1
	# echo $IN_PATH
	# exit
	# /home/snellsg/vmware/winservtest1/winservtest1-{random}
	# You moved the next line to the OutputFilenameCheck function
	# STRPOPATH=${OUTFILE##*/}
	# SHRTOF=${STRPOPATH%.*}
	# OUT_PATH=$IN_PATH/$SHRTOF-$OUTTYPE-converted
	# Perform VMware -> VitrualBox conversion
	# Create the new output folder and cd into it
	# echo "OUT_PATH is set to $OUT_PATH"
	mkdir $OUT_PATH
	# convertVMWaretoVBox $1
	# echo "INTYPE is set to $INTYPE"
	
	#chooseVBoxOSType $INTYPE $OUTTYPE
}

function chooseVBoxOSType() {
	# INTYPE=$1
	# OUTTYPE=$2
	VBoxOSTypeChoice=$(dialog --backtitle "vmware2gcloud" --title "Choose OS Type" --inputbox "Which OSType should be used for this converted VM?" 15 75 "ArchLinux_64" 3>&1 1>&2 2>&3)
	### I think i want this chunk for the next function, not here
	# if [[ $ INTYPE = "LocalRaw" ]]
	# 	then
	# 		something
	# 	else
	###
	# for INTYPE in $INTYPE
	# 	do
	# 		case "$INTYPE" in
	# 			localRaw) RAWtoVBoxConversion $INTYPE $OUTTYPE
	# 			;;
	# 			localVMWare) convertVMWaretoVBox $INTYPE $OUTTYPE
	# 			;;
	# 			*) exit
	# 		esac
	# done
}

function createVBoxOSTypes() {
	vboxmanage list ostypes | grep ^ID | sed -e 's/^ID:          //' > ~/.config/vmware2gcloud/vboxtypes.lst
}

function convertVMWaretoVBox() {
	# INTYPE=$1
	# OUTTYPE=$2
	# # Convert VMX to OVF
	dialog --backtitle "vmware2gcloud" --infobox "Converting from VMware format to VMware Open Virtualization Format..." 15 75
	# ovftool $IN_PATH/$INPUTFILE $OUT_PATH/$OUTFILE
	ovftool $INPUTFILE $OUT_PATH/$OUTFILE
		ovftoolCheck=$?
		dump
	# Import OVF File with adjustments	
}

function RAWtoVBoxConversion() {
	# INTYPE=$1
	# OUTTYPE=$2
	# dialog --backtitle "vmware2gcloud" --infobox "Converting from RAW to VMDK..." 15 75
    # echo "INPUTFILE is $INPUTFILE"
	# echo "OUT_PATH is $OUT_PATH"
	# echo "OUTFILE is $OUTFILE"
	# exit
	vboxmanage convertfromraw $INPUTFILE $OUT_PATH/$OUTPUTFILE --format VMDK
	# echo "Command that was about to be run was:"
	# echo "vboxmanage convertfromraw $INPUTFILE $OUT_PATH/$OUTFILE --format VMDK"
}

function importIntoVBox() {
		dialog --backtitle "vmware2gcloud" --infobox "Importing converted VM into VirtualBox" 15 75
		vboxmanage import $OUT_PATH/$OUTFILE --vsys 0 --vmname $SHRTOF --ostype $VBoxOSTypeChoice --memory $RAMAMT --unit 9 --disk $OUT_PATH/$SHRTOF-imported.vmdk

		# Modify the VRAM to 16MB
		dialog --backtitle "vmware2gcloud" --infobox "Modifying installed video RAM amount." 15 75
		vboxmanage modifyvm $SHRTOF --vram $VRAMAMT

		# Start the VM in Vbox
		dialog --backtitle "vmware2gcloud" --infobox "Starting VM for hardware updates (required to be prevent crashing)"
		vboxmanage startvm $SHRTOF --type headless
		# Pause while VM initializes its new hardware environment
		# A better way is still needed for this step.
		sleep 30s
		# After the first sleep is done, shut down the VM
		# Check to see how clean this is
		vboxmanage controlvm $SHRTOF acpipowerbutton
		dialog --backtitle "vmware2gcloud" --infobox "Shutdown command has been sent."
		# Sleep again in case the VM needs a moment to finish shutting self down
		sleep 20s
}