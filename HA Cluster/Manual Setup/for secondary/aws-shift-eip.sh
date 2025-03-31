#!/bin/bash

. /etc/phion/bin/cloud-logapi.sh
init_log box_Cloud_control aws-eip-shift
ilog "hook script called with $1"
[[ "_$1" == "_HA-START" ]] && {
/opt/aws/bin/aws ec2 associate-address --instance-id $IID --allocation-id $EID --allow-reassociation
ilog "EIP shifting to secondary initiated: ${aws_handle}"
}
