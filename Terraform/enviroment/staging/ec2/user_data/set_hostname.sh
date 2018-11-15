#!/usr/bin/env bash
# used for the amazon instance name setup by FC
set -e -x
# enabled debug
HOSTNAME_PREFIX=${hostname}
INSTANCE_ID=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id`
echo $HOSTNAME_PREFIX'-'$INSTANCE_ID > /etc/hostname
hostname -F /etc/hostname
sed -i -e '/^127.0.1.1/d' /etc/hosts
echo '127.0.1.1 '$HOSTNAME_PREFIX'-'$INSTANCE_ID'.terraform.aws.fmts.int '$HOSTNAME_PREFIX'-'$INSTANCE_ID >> /etc/hosts
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y