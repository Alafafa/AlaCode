#!/bin/sh

########################################
#
# Tommy DnsPod DDNS Client v0.2.0
#
# Author: Tommy Lau <tommy@gen-new.com>
#
# Created: 2015-02-23 08:52:00 UTC
# Updated: 2016-07-15 15:48:00 UTC
#
########################################

# Use 'json', other option is 'xml'
format='json'

# Use English for default, 'cn' for Chinese
language='en'

# API URL
api_url='https://dnsapi.cn/'

#Get os type function
get_osType() {
    local os_type=`cat /etc/os-release|grep -e "^ID\="|awk '{split($0,a,"=");print a[2]}'`
    if [ "$os_type" = "\"centos\""]; then
        os_type=centos
    fi
    echo $os_type
}

# Get public internet IP
get_pubIp() {
    local inter="http://members.3322.org/dyndns/getip"
    wget --quiet --no-check-certificate --output-document=- $inter
    #curl --silent $inter
}

#Get pppoe-wan ip
get_wanIp() {
    ifconfig pppoe-wan|head -n 2|tail -n 1| awk '{ print $2 }'|awk -F ':' '{ print $2 }'
}

# Send the API request to DnsPod API
# @param1: The command to execute, for example, Info.Version and etc.
# @param2: The parameters to send to the API, for example, domain='domain.tld'
api_post_curl() {
    # Client agent
    local agent="Tommy DnsPod Client/0.2.0 (tommy@gen-new.com)"

    # Stop if no API command is given
    local inter="$api_url${1:?'Info.Version'}"

    # Default post content for every request
    local param="login_token=$token&format=$format&lang=$language&${2}"

	#echo "api_post_addr:$inter; param:$param"
    #wget --quiet --no-check-certificate --output-document=- --post-data "$param" --user-agent="$agent" $inter
	curl -k -X POST $inter  -d "$param"
}

# Lookup current ip
# @param1: The domain to nslookup
dns_lookup() {
    local server="114.114.114.114"
    
    if [ "$os_type" = "ubuntu" || "$os_type" = "centos"]; then
        nslookup ${1} $server | awk '/^Address: / { print $2 }'
    elif [ "$os" = "openwrt" ]; then
        nslookup ${1} $server | tr -d '\n[:blank:]' | sed 's/.\+1 \([0-9\.]\+\).*/\1/'
    else 
        nslookup ${1} $server | tr -d '\n[:blank:]' | sed 's/.\+1 \([0-9\.]\+\).*/\1/'
    fi
}

# Update the DNS record
# @param1: The domain name to update, for example, 'domain.tld'
# @param2: The subdomain, for example, 'www'
dns_update() {
	local loop_var="true"
	
	while [[ "$loop_var" = "true" ]]
	do
		local wan_ip=$(get_wanIp)
		echo "inr wan ip: '$wan_ip'"
		
		if [ "$wan_ip" = "" ]; then
			echo "inr wan ip is not valid, waiting ...... "
			sleep 6
		else
			local pub_ip=$(get_pubIp)
			echo "out wan ip: '$pub_ip'"
			if [ "$pub_ip" = "" ]; then
				echo "public ip is not valid"
				sleep 15
			elif [ "$wan_ip" = "$pub_ip" ]; then
				loop_var="false"
			else
				echo "pppoe dial again ......"
				/sbin/ifup wan
				sleep 15
			fi
		fi
	done
	
    local dns_ip=$(dns_lookup "${2}.${1}")
    echo "dns lookup ip: '$dns_ip'"

    if [ "$pub_ip" = "$dns_ip" ]; then
		echo "No need to update DDNS."
        return 0
    fi

    # Get domain id
    local domain_id=$(api_post_curl "Domain.Info" "domain=${1}")
    domain_id=$(echo $domain_id | sed 's/.\+{"id":"\([0-9]\+\)".\+/\1/')
	
    echo "domain_id: $domain_id"

    # Get record id of the sub domain
    local record_id=$(api_post_curl "Record.List" "domain_id=${domain_id}&sub_domain=${2}")
    record_id=$(echo $record_id | sed 's/.\+\[{"id":"\([0-9]\+\)".\+/\1/')
    echo "record_id: $record_id"

    # Update the record
    local result=$(api_post_curl "Record.Ddns" "domain_id=${domain_id}&record_id=${record_id}&record_line_id=0&sub_domain=${2}")
    echo "result: $result"
	
    result_code=$(echo $result | sed 's/.\+{"code":"\([0-9]\+\)".\+/\1/')
    result_message=$(echo $result | sed 's/.\+,"message":"\([^"]\+\)".\+/\1/')

    # Output
    echo "Code: $result_code, Message: $result_message"
}

#Linux Os Type
os_type=$(get_osType)

# User token
token="${1:?'Please input your token'}"

# Domain
domain=${2:?'Please input domain'}

# Sub domain
sub_domain=${3:?'Please input sub domain'}

# Update the DDNS
dns_update "$domain" "$sub_domain"