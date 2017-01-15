#!/bin/bash

INPUTFILE=$1
OUTFILE=$2

#Has an input filename been entered?
if [[ -z $INPUTFILE ]]
	# No it has no. Fail.
		then
			INPUTFILE=$(whiptail --inputbox "You have not entered an input filename. Please enter one now." 15 75 --title "Input Filename Required" 3>&1 1>&2 2>&3)
			# SET INPUTFILE VARIABLE AND MOVE ON
				if [[ $INPUTFILE = 0 ]]
					then
						echo "User Selected OK and entered $INPUTFILE"
					else
						# How about now? Is there now an input filename to use?
						if [[ -z $INPUTFILE ]]
							then
								echo "Operation1 failed due to missing input filename."
							else
								echo "Operation1 was successful. INPUTFILE was $INPUTFILE and OUTFILE was $OUTFILE."
						fi
				fi

			echo "You must enter an input filename for this script to do anything."
	# Yes it has. Continue.
		else
			echo "BREAK1: Operation 1 was successful. INPUTFILE was $INPUTFILE."
fi

# Has an output filename been entered?
if [[ -z $OUTFILE ]]
# No it has not, prompt the user to enter an output filename.
	then
		SUGGESTEDNAME=${INPUTFILE%.*}
		OUTFILE=$(whiptail --inputbox "You have not entered an output filename. Please enter one now." 15 75 $SUGGESTEDNAME.ovf --title "Output Filename Required"  3>&1 1>&2 2>&3)
		# SET OUTFILE VARIABLE AND MOVE ON
#		OUTFILE=$?
				if [[ $OUTFILE = 0 ]]
					then
						echo "User Selected OK and entered $OUTFILE"
					else

						# How about now? Is there now an output filename to use?
						if [[ -z $OUTFILE ]]
							then
								echo "Operation2 failed due to missing output filename."
								exit
							else
								echo ""
						fi

				fi
	# Yes, it has
	else
		#OUTFILE=$(whiptail --inputbox "Confirm input filename:" 15 75 --title "Confirmation" 3>&1 1>&2 2>&3)
		break
fi

# Prompt user for how much RAM should be used
RAMAMT=$(whiptail --inputbox "How much RAM in megabytes should be configured for this VM?" 15 75 4096 --title "Enter RAM Amount" 3>&1 1>&2 2>&3)
	if [[ $RAMAMT = 0 ]]
		then
			echo "User Selected OK and entered $RAMAMT"
		else

			# How about now? Is there now a RAM amount to use?
			if [[ -z $RAMAMT ]]
				then
					echo "Operation4 failed due to missing RAM amount."
					exit
				else
					echo ""
			fi

	fi

# Prompt user for how much VRAM should be used
VRAMAMT=$(whiptail --inputbox "How much VRAM in megabytes should be configured for this VM?" 15 75 16 --title "Enter RAM Amount" 3>&1 1>&2 2>&3)
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
					echo ""
			fi

	fi
SHRTOF=${OUTFILE%.*}

# Perform VMware -> VitrualBox conversion
# 1. Create the new output folder and cd into it
mkdir $INPUTFILE"-conversion" && cd $INPUTFILE"-conversion"
# 2. Convert VMX to OVF
ovftool ../$INPUTFILE $OUTFILE
# 3. Import OVF File with adjustments
# 4. Make a working directory for the converted VM
vboxmanage import $OUTFILE --vsys 0 --vmname $SHRTOF --ostype Windows2012_64 --memory $RAMAMT --unit 9 --disk $SHRTOF.vmdk
# 4. Modify the VRAM to 16MB
vboxmanage modifyvm $SHRTOF --vram $VRAMAMT
# 4. Start the VM in Vbox
vboxmanage startvm $SHRTOF
sleep 30s
vboxmanage controlvm $SHRTOF acpipowerbutton
sleep 20s
# 5. Convert to RAW
vboxmanage clonehd $SHRTOF.vmdk $SHRTOF.raw --format RAW