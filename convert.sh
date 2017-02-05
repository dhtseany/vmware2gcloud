#!/bin/bash

#source ./genericFunctions.sh
source ./fileCheckFunctions.sh
source ./virtualbox.sh
source ./vmware.sh
source ./dump.sh
configFolderCheck
# INPUTFILE=$1
# OUTFILE=$2
INSTANCE_ID=${RANDOM}

sourceInputTypeAsk
for INTYPE in $INTYPE
do
    case "$INTYPE" in
    1) VMWareSetupCheck
        ;;
    2) echo "Selection was Google Compute"
        ;;
    3) InputFilenameCheck localVMWare
        ;;
    4) echo "Selection was OVFFileInput"
        ;;
    5) InputFilenameCheck localRaw
        ;;
    *) dump_message="MissingInputFilename" && dump_function="sourceInputTypeAsk" && dump $dump_function $dump_message
        ;;
    esac
done

for INTYPE in $INTYPE
		do
			case $INTYPE in
				localVMWare) ext="ovf"
				;;
				localRaw) ext="vmdk"
				;;
				VBoxInstall) ext="ovf"
				;;
				*) dump_message="WeirdInputTypeReceivedForFileExtension" && dump_function="OutputFilenameCheck" && dump $dump_function $dump_message
		esac
	done


for INTYPE in $INTYPE
do
    case "$INTYPE" in
        localVMWare) OutputFilenameCheck localVMWare
        ;;
        localRaw ) OutputFilenameCheck localRaw 
        ;;
        *) dump_message="WeirdInputTypeReceived" && dump_function="InputFilenameCheck" && dump $dump_function $dump_message
    esac
done

sourceOutputTypeAsk

for OUTTYPE in $OUTTYPE
do
    case "$OUTTYPE" in
    1) echo "Selection was VMWareSetup"
        ;;
    2) OutputFilenameCheck saveToFileSystem
        ;;
    VBoxInstall) OutputFilenameCheck VBoxInstall
        ;;
    4) echo "Selection was Google Compute"
            ;;
    *) dump_message="MissingOutputFIlename" && dump_function="sourceOutputTypeAsk" && dump $dump_function $dump_message
        ;;
    esac
done

for OUTTYPE in $OUTTYPE 
    do
        case $OUTTYPE in
            localVMWare) echo "Sorry Hot Rod, but this isn't a working feature yet.'"
            ;;
            localRaw) VirtualBoxReceivePrep #$INTYPE $OUTTYPE
            ;;
            #VBoxInstall) VirtualBoxReceivePrep $INTYPE $OUTTYPE
            VBoxInstall) VirtualBoxReceivePrep
            ;;
            *) dump_message="WeirdOutputTypeReceivedDuringFinalOutputCheck" && dump_function="OutputFilenameCheck" && dump $dump_function $dump_message
        esac
done

for INTYPE in $INTYPE
    do
        case "$INTYPE" in
            localRaw) RAWtoVBoxConversion
            ;;
            localVMWare) convertVMWaretoVBox
            ;;
            *) dump_message="InvalidInputTypeDetected" && dump_function="VirtualBoxReceivePrep" && dump $dump_function $dump_message
        esac
done

for OUTTYPE in $OUTTYPE
		do
			case "$OUTTYPE" in
				VBoxInstall) importIntoVBox
				;;
				saveToFileSystem) exit
				;;
            *) dump_message="InvalidOutputTypeDetected" && dump_function="FinalCheckforVboxInstall" && dump $dump_function $dump_message
			esac
	done

dump_message="CleanExit" && dump_function="Intentional" && dump $dump_function $dump_message




# echo $sourceInputType
# InputFilenameCheck $sourceInputType
# #sourceOutputAsk