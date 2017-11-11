#!/bin/bash
# **************************************************************************************
# Ricoh SP200s, Epson V39 and Fujitsu SP1130 driver installation script
# Created by Akshai M, ICFOSS Kerala
# Date : 11 Nov 2017
# Ricoh SP200 use code from https://github.com/madlynx/ricoh-sp100 
# SP1130 and V39 use drivers provided by their vendors
# Vendor drivers contain Non-free components as well.
# Usage of script implicitly agrees to the T&C made by the respective vendors
# For support create an issue here https://github.com/akshaim/Drivers_V39-SP200S-SP1130
# **************************************************************************************


nc -z 8.8.8.8 53  >/dev/null 2>&1
if [ $? != 0 ]; then
    echo -e "\e[31mInternet Connectivity Error. Working Internet connection required to continue\e[0m"
    exit
fi

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? != 0 ]; then
    echo -e "\e[31mDNS Error. Set as provided by ISP\e[0m" 
    exit
fi

if [ "`lsb_release -is`" == "Ubuntu" ]
then
    sudo apt-get update;
    if [ $? != 0 ]; then
        echo -e "\e[31mUpdate Unsuccessful.Fix sources.list to continue.\e[0m" 
        exit
    else
        echo -e "\e[32m Update successful. Installing jbigkit-bin.\e[0m" 
    fi
    sudo apt-get -y install jbigkit-bin
    if [ $? != 0 ]; then
        echo "jbigkit-bin installation unsuccessful."
        exit
    else
        echo -e "\e[32m jbigkit-bin installation successful.\e[0m" 
    fi
    if [ -x /usr/lib/cups ]; then
        echo "Cups directory exists. Copying filter"
        sudo cp Filters/pstoricohddst-gdi /usr/lib/cups/filter
	if [ $? != 0 ]; then
            echo -e "\e[31mFilter installation failed. \e[0m"
            exit
        else
            echo -e "\e[32mFilter installation successful \e[0m"
        fi
    else
        echo "Cups dir not found. Installing cups"
        sudo apt-get install cups
	sudo cp Filters/pstoricohddst-gdi /usr/lib/cups/filter      
	exit
    fi
    if which gdebi >/dev/null; then
        echo "Installing Drivers for Fujitsu SP-1130"
    else
        echo "Installing Gdebi"
	sudo apt-get -y install gdebi
	echo "Installing Drivers for Fujitsu SP-1130"
        
    fi   
    MACHINE_Arch=`uname -m`
    if [ ${MACHINE_Arch} == 'x86_64' ]; then
        sudo gdebi deb/pfusp-ubuntu14.04_2.1.0_amd64.deb
    else
        sudo gdebi deb/pfusp-ubuntu14.04_2.1.0_i386.deb
    fi
    if [ $? != 0 ]; then
        echo -e "\e[31mDriver installation failed. \e[0m"
        exit
    else
        echo -e "\e[32mFujitsu SP-1130 installtion successful.Use Simple Scan for basic features  \e[0m" 
    fi
    echo "Installing Xsane for additional scanning features"
    sudo apt-get -y install xsane
    
    echo "Installing Drivers for Epson Perfection V39"
    MACHINE_Arch=`uname -m`
    if [ ${MACHINE_Arch} == 'x86_64' ]; then
        EPSON_Perfection_V39/EP_V39_driver_x64/./install.sh
    else
        EPSON_Perfection_V39/EP_V39_driver_x86/./install.sh
    fi
    if [ $? != 0 ]; then
        echo -e "\e[31mDriver installation failed. \e[0m"
        exit
    else
        echo -e "\e[32mEpson V39 Driver Installation Successful\nUse Image Scan application to use the scanner \e[0m"
    fi
    
else
    echo "Unsupported Operating system"
fi
