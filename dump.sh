#!/bin/bash

function dump() {
	ERROR_FUNCTION=$1
	ERROR_CODE=$2
	dumpfile=./dump.txt
	datetime=$(date)
	echo "######################START#DUMP######################################################" >> $dumpfile
	echo "Data dump @ $datetime" >> $dumpfile
	echo "" >> $dumpfile
    echo "Job Type: $INTYPE to $OUTTYPE"
	echo "File Selections:" >> $dumpfile
	echo "INPUTFILE was set to $INPUTFILE" >> $dumpfile
	echo "INTYPE was set to $INTYPE" >> $dumpfile
	echo "OUT_PATH was set to $OUT_PATH" >> $dumpfile
	echo "OUTFILE was set to $OUTFILE" >> $dumpfile
	echo "OUTTYPE was set to $OUTTYPE" >> $dumpfile
	echo "" >> $dumpfile
	echo "More misc data:" >> $dumpfile
	echo "STRPPATH was set to $STRPPATH (input)" >> $dumpfile
	echo "SUGGESTEDNAME was set to $SUGGESTEDNAME (input)" >> $dumpfile
	echo "STRPOPATH was set to $STRPOPATH (output)" >> $dumpfile
	echo "SHRTOF was set to $SHRTOF (output)" >> $dumpfile
	echo "ext was set to $ext (output)" >> $dumpfile
    echo "######################################################################################" >> $dumpfile
	echo "" >> $dumpfile
	echo "VirtualBox Related:" >> $dumpfile
	echo "RAM amount was set to $RAMAMT MB" >> $dumpfile
	echo "Video RAM amount was set to $VRAMAMT MB" >> $dumpfile
	echo "VirtualBox OS type was set to $VBoxOSTypeChoice" >> $dumpfile
	echo "convertVMWaretoVBoxGo is set to $convertVMWaretoVBoxGo" >> $dumpfile
    echo "" >> $dumpfile
    echo "Final OVFTool exit status was:" >> $dumpfile
    echo $ovftoolCheck >> $dumpfile
	echo "######################################################################################" >> $dumpfile
	echo "Final Error Result: (if present)" >> $dumpfile
	echo "Faulting Function: $ERROR_FUNCTION" >> $dumpfile
	echo "Error Code: $ERROR_CODE" >> $dumpfile
	echo "######################END#DUMP########################################################" >> $dumpfile
	echo "" >> $dumpfile	

}
