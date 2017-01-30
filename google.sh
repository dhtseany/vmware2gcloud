#!/bin/bash

function processRAWConversion() {
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
    TARNAME=$SHRTOF.tar.gz
    tar -I pigz -cf $OUT_PATH/$TARNAME $OUT_PATH/disk.raw &>/dev/null
    echo "TAR/GZ Compression complete."
    # Conversion from VBox to RAW Complete. 
    # Proceed to gCloud upload if desired
}

function uploadToGoogle() {
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
            echo "Yay, the first part made it!"
    fi
}