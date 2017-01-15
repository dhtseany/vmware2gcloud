# vmware2gcloud
A Linux Utility for automatically converting a virtual machine from VMWare format to VirtualBox format, then automatically upload the converted VM to Google's Cloud Compute Engine

# About
This script was developed using Arch Linux (4.8.13-1-ARCH x86_64 GNU/Linux). I am also the AUR package maintainer. While my intentions are to make this as agnostic as possible, syntaxes may vary across distributions. If you find bugs or want to suggest better ways of doing things please file an issue on the main Github repo.

# Dependencies
The following package dependencies are required for this package to do it's job:

google-cloud-sdk

vmware-player  (To gain access to ovftool; I might split that off later to minimize the installation requirements)

virtualbox     (To gain access to vboxmanage; likely requires a fully configured installation)
