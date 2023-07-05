# Building A Redundant Ethereum Staking Node

This guide will cover how to build a redundant Ethereum staking node, leveraging two different CL and EL clients. The hardware may be a bit expensive depending on your exact requirements, so feel free to scale down the specs as needed.

This particular build was designed to be able to avoid a hardware upgrade for approximately 2 years, being able to run redundant staking configurations, supporting multiple validators, while also running supplementary monitoring services.

Multiple disks are used to isolate disk IO as much as possible, however you could store everything on one disk, but you will likely experience significant disk IO bottlenecks.

For the primary node we are running:

* Lighthouse (CL)
* Nethermind (EL)

For the fallback node we are running:

* Nimbus (CL)
* Geth (EL)

# Requirements

* 1x NUC12WSHi7
* 1x Samsung 870 EVO
* 2x GSkill DDR4 SO-DIMM DDR4 3200 32GB 
* 1x Corsair MP600 PRO 4TB
* 1x Apacer 3D NAND 1TB Internal SSD

# Configuration

## OS Disk

Install the OS to the apacer disk, using the entire 1TB disk for the OS. It's up to you if you want to store various directory (/var, /home, etc..) in different partitions, but for simplicity sakes we use a single partition.

## Additional Disks

Once the OS is installed format the Corsair and Samsung drives with Ext4, followed by creating two directories using the name of the disk type for the mount location:

* `/mnt/ssd_disk`
* `/mnt/nvme_disk`

Update `/etc/fstab` with the following configuration. You will want to remove `commit=60` if you are not running on battery backup / ups devices as it can result in data loss.

```conf
UUID=... /mnt/ssd_disk ext4 errors=remount-ro,relatime,lazytime,commit=60 0 0
UUID=... /mnt/nvme_disk ext4 errors=remount-ro,relatime,lazytime,commit=60 0 0
```

Enable `fast_commit` by running the following command against the actual disk devices:

```shell
$> sudo tune2fs -O fast_commit /dev/...
```

## Primary Node 

Prepare the lighthouse user:

```shell
$> sudo useradd -m lighthouse /usr/bin/nologin
```

Prepare the nethermind user

```shell
$> sudo useradd -m nethermind /usr/bin/nologin
```

Deploy the systemd services

* Copy `configs/systemd/lighthouse/beacon_chain.service` to `/etc/systemd/system/lighthouse_bn.service`
* Copy `configs/systemd/lighthouse/validator.service` to `/etc/systemd/system/lighthouse_vc.service`
* Copy `configs/systemd/nethermind/node.service` to `/etc/systemd/system/nethermind.service`

## Fallback Node

Prepare the nimbus user:

```shell
$> sudo useradd -m nimbus /usr/bin/nologin
```

Prepare the geth user:

```shell
$> sudo useradd -m geth /usr/bin/nologin
```

Deploy the systemd services

* Copy `configs/systemd/nimbus/beacon_chain.service` to `/etc/systemd/service/nimbus_bn.service`
* Copy `configs/systemd/geth/node.service` to `/etc/systemd/system/service/geth.service`