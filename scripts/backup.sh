# back up
#
# create backup
#
# sudo su
# cd /
# tar cvpzf backup.tgz --exclude=/proc --exclude=/lost+found --exclude=/backup.tgz --exclude=/mnt --exclude=/sys /
# 
# restore backup
#
# sudo su
# cd /
# // backup file needs to be in /
# tar xvpfz backup.tgz -C /
# recreate dirs excluded above
# reboot
