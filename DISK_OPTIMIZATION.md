# Disk Optimization

For the sake of convenience we are using the `ext4` filesystem for the OS disk, and all other data disks. This document covers ways to mount the disks to optimize performance.

# Fstab Configurations

Enable the `relatime`, and `lazytime` features

```conf
UUID=... /mnt/ssd_disk ext4 errors=remount-ro,relatime,lazytime 0 0
```

## Changing Commit Frequency

Every 5 seconds ext4 will commit data to disk, which under heavy write scenarios can lead to a noticeable amount of increased disk IO. If using a UPS you can increase the commit interval to minimize the impact that the commit process has for data ingestion. This must be enabled without care, as if you do not have battery backed systems, you can lose up to commit interval seconds of data.

To enable this we can change the previous fstab config to:
```conf
UUID=... /mnt/ssd_disk ext4 errors=remounte-ro,relatime,lazytime,commit=60 0 0
```

# Ext4 Tuning

Enable the `fast_commit` option, which reduces commit latency is ordered data mode:

```shell
$> sudo tune2fs -O fast_commit /dev/...
```


# Changing The Scheduler