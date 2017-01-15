# vmware2gcloud
A Linux Utility for automatically converting a virtual machine from VMWare format to VirtualBox format, then automatically upload the converted VM to Google's Cloud Compute Engine

# Dependencies
The following package dependencies are required for this package to do it's job:

google-cloud-sdk

vmware-player  (To gain access to ovftool; I might split that off later to minimize the installation requirements)

virtualbox     (To gain access to vboxmanage; likely requires a fully configured installation)
   
