#!/bin/bash

option=${1:-"--help"}

if [ "${option}" = "--help" ]
then
    echo ""
	echo "The Script will perform initial setup of host machine (requires root privileges)."
    echo ""
	echo "usage: ${0} [[--help] [--setup]]"
    echo ""
	echo "optional arguments:"
	echo "  --help          show this help message and exit"
	echo "  --setup         check that host has all necessary dependencies installed for building"
    echo ""
	exit
fi

# Create and clear the log file
echo "" > host_env_setup.log

echo "Installing apt packages:"

while read line
do
    # Remove extra whitespace from an ASCII line
    line=`echo "${line}" | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g'`

    # Ignore comments and blank line
    m=`echo "${line}" | grep -v ^#`
    if [ ! "${m}" ]
    then
        continue
    fi

    # Ignore the already installed software
    dpkg -s "${line}" >>host_env_setup.log 2>&1
    if [ "$?" = "0" ]
    then
        echo -e "${line} [\033[32mDone\033[0m]" | awk '{printf "%-50s%-10s\n", $1, $2}'
        continue
    fi

    apt-get --yes install "${line}" >>host_env_setup.log 2>&1
    if [ "$?" = "0" ]
    then
        echo -e "${line} [\033[32mPass\033[0m]" | awk '{printf "%-50s%-10s\n", $1, $2}'
    else
        echo -e "${line} [\033[31mFailed\033[0m]" | awk '{printf "%-50s%-10s\n", $1, $2}'
        exit 1
    fi
done < apt_setup.lst

echo "Use update-alternatives create symbolic links determining default commands:"

while read line
do
    # Remove extra whitespace from an ASCII line
    line=`echo "${line}" | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*$//g'`

    # Ignore comments and blank line
    m=`echo "${line}" | grep -v ^#`
    if [ ! "${m}" ]
    then
        continue
    fi

    if [ "${line:0:1}" = "[" -a "${line: -1}" = "]" ]
    then
        line=`echo ${line%]*}`
        line=`echo ${line##*[}`
        link="${line}"
        continue
    fi

    if [ -z "${link}" ]
    then
        continue
    fi

    name=`echo $line | awk '{print $1}'`
    path=`echo $line | awk '{print $2}'`
    priority=`echo $line | awk '{print $3}'`

    update-alternatives --install ${link} ${name} ${path} ${priority}

done < update-alternatives.conf
