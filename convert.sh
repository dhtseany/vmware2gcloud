#!/bin/bash

# source ./genericFunctions.sh
source ./fileCheckFunctions.sh
source ./virtualbox.sh
source ./vmware.sh
configFolderCheck
INPUTFILE=$1
OUTFILE=$2
INSTANCE_ID=${RANDOM}

sourceInputTypeAsk
# echo $sourceInputType
# InputFilenameCheck $sourceInputType
# #sourceOutputAsk