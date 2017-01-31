#!/bin/bash

function VMWareSetupCheck() {
if [[ -d ~/.config/vmware2gcloud ]]
    then
        if [[ -s ~/.config/vmware2gcloud/VMWareSetup.cache ]]
            then
                VMWareReuseSetupFile=$(dialog --backtitle "vmware2gcloud -> VMWare ESXi Setup" \
                --yesno "Previously created setup file was detected. \
                Continue with detected setup file?" 20 75 3>&1 1>&2 2>&3
                )
                if [[ $VMWareReuseSetupFile = yes ]]
                    then
                        source ~/.config/vmware2gcloud/VMWareSetup.cache
                        VMWareChooseRemoteServer
                    else
                        dialog --title "Setup File Not Found" 20 10
                        VMWareSetupMenu
                fi
            else
                dialog --backtitle "vmware2gcloud -> VMWare ESXi Setup" \
                "No setup file found. Proceeding to Setup Menu." 20 75
                touch ~/.config/vmware2gcloud/VMWareSetup.cache
                VMWareSetup
        fi
    else    
        mkdir -p ~/.config/vmware2gcloud
        VMWareSetupCheck
fi
}

function VMWareSetup() {
	for VMWareSetupMenu in $(    
        dialog --backtitle "vmware2gcloud -> VMWare ESXi Setup" \
        --ok-label "Next" --cancel-label "Exit" \
        --extra-button --extra-label "Previous" --radiolist \
        "What would you like to change?" 20 75 5 \
        1 "Manage Stored ESXi Hosts Credentials" on \
        2 "Choose Local Working Directory" off \
        3 "<- Go Back" off 3>&1 1>&2 2>&3
        )
        do
            case "$VMWareSetupMenu" in
            1) sourceInputTypeAsk
                ;;
            2) echo "Selection was Choose Local Working Directory"
                ;;
            3) sourceInputTypeAsk
                ;;
            *) echo " $sourceInputTypeSelection was Not processed"
                ;;
            esac
	done
}

# function VMWareChooseRemoteServer() {
# }

# function VMWareFileInput() {

# }

# function VMWareExtraction() {


# }