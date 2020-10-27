# Linux

## NFS 
sudo apt install nfs-common
mkdir /mnt/kenobiNFS
mount 10.10.179.78:/var /mnt/kenobiNFS

## SSH
sudo chmod 600 id_rsa
ssh -i id_rsa user@ipaddress

## SUID
find / -perm -u=s -type f 2>/dev/null

# Privesc
https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Linux%20-%20Privilege%20Escalation.md

# Scenarios

## Using systemctl
https://medium.com/@klockw3rk/privilege-escalation-leveraging-misconfigured-systemctl-permissions-bc62b0b28d49

