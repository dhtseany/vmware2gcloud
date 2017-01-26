#!/bin/bash
vboxmanage unregistervm winservtest1 --delete
#rm -rf winservtest1/
rm winservtest1.tar.gz
cp ~/dev/vmware2gcloud/convert.sh convert.sh
cp ~/dev/vmware2gcloud/reset.sh reset.sh
clear
# &>/dev/null