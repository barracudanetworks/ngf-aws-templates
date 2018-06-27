if [[ $(head -1 /opt/phion/run/server.ctrl | cut -d " " -f 3) =~ ^(primary|secondary)$ ]]; then
  MY_ID=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id`
  MY_IP=`/opt/aws/bin/aws ec2 describe-instances --instance-id $MY_ID --output text | grep ASSOC | head -1 | cut -d $'    ' -f 4`
  CLUSTER_CNT=`phionctrl server show | grep Boxes | xargs | tr " " "\n" | grep -v Boxes | wc -l`
  if [ "_$1" != "_$MY_IP" ] && [ $CLUSTER_CNT == "2" ]; then
    /opt/phion/hooks/ha/aws-shift-eip.sh HA-START
  fi
fi
