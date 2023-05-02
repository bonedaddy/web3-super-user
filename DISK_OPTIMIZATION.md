# Disk Optimization

For the sake of convenience we are using the `ext4` filesystem for the OS disk, and all other data disks. This document covers ways to mount the disks to optimize performance.

# Fstab Configurations

Enable the `relatime`, and `lazytime` features

```conf
UUID=... /mnt/ssd_disk ext4 errors=remount-ro,relatime,lazytime 0 0
```

# Ext4 Tuning

Enable the `fast_commit` option, which reduces commit latency is ordered data mode:

```shell
$> sudo tune2fs -O fast_commit /dev/...
```