#!/bin/bash

INPUTFILE=$1
OUTFILE=$2
INSTANCE_ID=${RANDOM}
FILECHECK="${INPUTFILE#*.}"
# Does $INPUTFILE end with a tar.gz?
if [[ $FILECHECK != "tar.gz" ]]
	then
		#Has an input filename been entered?
		if [[ -z $INPUTFILE ]]
			# No it has no. Fail.
				then
					INPUTFILE=$(whiptail --inputbox "You have not entered an input filename. Please enter one now." 15 75 --title "Input Filename Required" 3>&1 1>&2 2>&3)
					# SET INPUTFILE VARIABLE AND MOVE ON
						if [[ $INPUTFILE = 0 ]]
							then
								echo ""
							else
								# How about now? Is there now an input filename to use?
								if [[ -z $INPUTFILE ]]
									then
										echo "Operation1 failed due to missing input filename."
										exit
									else
										echo ""
								fi
						fi

					echo "You must enter an input filename for this script to do anything."
			# Yes it has. Continue.
				else
					echo ""
		fi

		# Has an output filename been entered?
		if [[ -z $OUTFILE ]]
		# No it has not, prompt the user to enter an output filename.
			then
				SUGGESTEDNAME=${INPUTFILE%.*}
				OUTFILE=$(whiptail --inputbox "You have not entered an output filename. Please enter one now." 15 75 $SUGGESTEDNAME-$INSTANCE_ID.ovf --title "Output Filename Required"  3>&1 1>&2 2>&3)
				# SET OUTFILE VARIABLE AND MOVE ON
		#		OUTFILE=$?
						if [[ $OUTFILE = 0 ]]
							then
								echo ""
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
					echo ""
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
		# winservtest1
		SHRTOF=${OUTFILE%.*}
		# /home/snellsg/vmware/winservtest1
		IN_PATH=$(pwd)
		echo $IN_PATH
		# /home/snellsg/vmware/winservtest1/winservtest1-{random}
		OUT_PATH=$IN_PATH/$SHRTOF
		# Perform VMware -> VitrualBox conversion

		# 1. Create the new output folder and cd into it
		echo "OUT_PATH is set to $OUT_PATH"
		mkdir $OUT_PATH

		# 2. Convert VMX to OVF
		echo "Converting from VMware format to VMware Open Virtualization Format"
		ovftool $IN_PATH/$INPUTFILE $OUT_PATH/$OUTFILE

		# 3. Import OVF File with adjustments
		echo "Importing converted VM into VirtualBox"
		vboxmanage import $OUT_PATH/$OUTFILE --vsys 0 --vmname $SHRTOF --ostype Windows2012_64 --memory $RAMAMT --unit 9 --disk $OUT_PATH/$SHRTOF-imported.vmdk

		# 4. Modify the VRAM to 16MB
		echo "Modifying installed video RAM amount."
		vboxmanage modifyvm $SHRTOF --vram $VRAMAMT

		# 5. Start the VM in Vbox
		echo "Starting VM for hardware updates (required to be prevent crashing)"
		vboxmanage startvm $SHRTOF --type headless
		# 6. Pause while VM initializes its new hardware environment
		# A better way is needed for this step.
		sleep 30s
		# 7. After the first sleep is done, shut down the VM
		# Check to see how clean this is
		vboxmanage controlvm $SHRTOF acpipowerbutton
		echo "Shutdown command has been sent."
		# 8. Sleep again in case the VM needs a moment to finish shutting self down
		sleep 20s


		# 9. Convert to RAW
		echo "Cloning converted VM to gCloud standard RAW format"
		echo "Inputfile: $OUT_PATH/$SHRTOF-imported.vmdk"
		echo "Outfile: $OUT_PATH/$SHRTOF.raw"
		vboxmanage clonehd $OUT_PATH/$SHRTOF-imported.vmdk $OUT_PATH/disk.raw --format RAW

		# 10. Remove the VBox VM
		echo "Removing temporary VBox VM from local config"
		vboxmanage unregistervm $SHRTOF --delete

		# 10. Tar it for upload to Google
		echo "Begin TAR/GZ compression of RAW file."
		TARNAME=$SHRTOF.tar.GZ
		tar -Sczf $OUT_PATH/$TARNAME $OUT_PATH/disk.raw &>/dev/null
		echo "TAR/GZ Compression complete."
		# Conversion from VBox to RAW Complete. 
		# Proceed to gCloud upload if desired

	else
	TARNAME=$INPUTFILE
	whiptail --title "Previous Conversion Detected." --msgbox "$TARNAME was detected. Proceeding directly to Google Upload scripts." 8 78
fi
echo "TARNAME is $TARNAME"
TRSRT=${TARNAME%.*.*}
echo "TRSRT is set to $TRSRT"
if (whiptail --title "Upload to Google?" --yesno "All conversions have completed successfuly. We are now ready to push this RAW VM up to Google Compute. Shall we continue?" 8 78)
	then
		BUCKET_CHOICE=$(whiptail --title "Verify Bucket Choice" --inputbox "Verify bucket to upload to:" 15 75 cmh-custom-utilities.appspot.com 3>&1 1>&2 2>&3)
		echo "BUCKET_CHOICE was set to gs://$BUCKET_CHOICE"
		echo "Uploading [$TARNAME] to gs://$BUCKET_CHOICE"
		gsutil cp $TARNAME gs://$BUCKET_CHOICE
		echo "Creating new Compute Instance from gs://$BUCKET_CHOICE/$SHRTOF.tar.gz"
		gcloud compute images create $SHRTOF --source-uri gs://$BUCKET_CHOICE/$TARNAME
	else

		# How about now? Is there now a VRAM amount to use?
		echo "Yay, the first part made it!"
fi