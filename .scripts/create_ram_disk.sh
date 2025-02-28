mounting_point="/mnt/ramdisk"
sudo mkdir -p $mounting_point
sudo mount -t tmpfs -o size=4G tmpfs $mounting_point
sudo chmod 700 $mounting_point
sudo chown $USER:$USER $mounting_point
echo "Ram disk created at $mounting_point"

# or add in /etc/fstab
# tmpfs /mnt/ramdisk tmpfs rw,size=4G 0 0

