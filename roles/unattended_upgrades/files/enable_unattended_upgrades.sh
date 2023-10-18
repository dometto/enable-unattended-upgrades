#!/bin/bash
LOG=/var/log/post-cloud-init.log

echo "Running cloud-init status --wait..." >> $LOG
# Block until cloud-init completes
cloud-init status --wait > /dev/null 2>&1
[ $? -ne 0 ] && echo 'Cloud-init failed' >> $LOG && exit 1
echo 'Cloud-init succeeded at ' $(date -R) >> $LOG

systemctl enable apt-daily.timer || echo "Could not enable apt-daily.timer" >> $LOG
systemctl enable apt-daily-upgrade.timer || echo  "Could not enable apt-daily-upgrade.timer" >> $LOG
systemctl start apt-daily.timer || echo  "Could not start apt-daily.timer" >> $LOG
systemctl start apt-daily-upgrade.timer || echo  "Could not start apt-daily-upgrade.timer" >> $LOG