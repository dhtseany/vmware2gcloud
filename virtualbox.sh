#!/bin/bash

function VirtualBoxReceivePrep() {
#		echo "OUTFILE is set to $OUTFILE"
		RAMAmountCheck
		VRAMAmountCheck
		SHRTOF=${OUTFILE%.*}
		# /home/snellsg/vmware/winservtest1
		IN_PATH=$(pwd)
		echo $IN_PATH
		# /home/snellsg/vmware/winservtest1/winservtest1-{random}
		OUT_PATH=$IN_PATH/$SHRTOF
		# Perform VMware -> VitrualBox conversion
		# Create the new output folder and cd into it
		echo "OUT_PATH is set to $OUT_PATH"
		mkdir $OUT_PATH
		convertVMWaretoVBox $1
}

function convertVMWaretoVBox() {
		OUTTYPE=$1
		# Convert VMX to OVF
		dialog --backtitle "vmware2gcloud" --infobox "Converting from VMware format to VMware Open Virtualization Format..." 15 75
		# ovftool $IN_PATH/$INPUTFILE $OUT_PATH/$OUTFILE
		ovftool $INPUTFILE $OUTFILE
		# Import OVF File with adjustments
		for OUTTYPE in $OUTTYPE
			do
				case "$OUTTYPE" in
					VBoxInstall) importIntoVBox
					;;
					*) exit
			esac
		done
}

function importIntoVBox() {
		dialog --backtitle "vmware2gcloud" --infobox "Importing converted VM into VirtualBox" 15 75
		vboxmanage import $OUT_PATH/$OUTFILE --vsys 0 --vmname $SHRTOF --ostype Windows2012_64 --memory $RAMAMT --unit 9 --disk $OUT_PATH/$SHRTOF-imported.vmdk

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
		if [[ $OUTTYPE = "VBoxInstall" ]] 
			then
				exit
			else
				echo &>/dev/null
		fi
}