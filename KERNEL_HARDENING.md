# Kernel Hardening And Optimization

There are a few options for hardening your kernel, the most effective of which are using kernel modules like grsecurity. However the setup can be complex, limit system performance, etc.. As such we will focus on using kernel tunables to perform system hardening.

All configurations referenced in this documentation can be stored in `/etc/sysctl.conf` and then applied without a reboot using `sudo sysctl -p`.

# Kernel Tunables

Kernel tunables allow you to control the behaviour of the linux kernel, and can be used to enable a number of tweaks, allowing for enhanced system performance, security, etc..

## Kernel Configurations

These are configuration which directly influence kernel behavior

```conf
# mitigate kernel pointer leaks
kernel.kptr_restrict=2
# prevent dmesg from leaking sensitive information
kernel.printk=3 3 3 3
# restrict ebpf access to the `CAP_EBF` or `CAP_SYS_ADMIN` capabilities
kernel.unprivileged_bpf_disabled=1
# disallow loading another kernel during runtime
kernel.kexec_load_disabled=1
# disable sysrq except for secure-attention-key
kernel.sysrq=4
# restrict usage of performance events
kernel.perf_event_paranoid=3
# restrict ptrace access to CAP_SYS_PTRACE
kernel.yama.ptrace_scope=2
```

## VM Configuration

```conf
# allows mitigating against some userfaultfd() use-after-free bugs
vm.unprivileged_userfaultfd=0
# only under extreme scenarios use swap
vm.swappiness=1
```

## Filesystem Configuration

```conf
# mitigate a number of TOCTOU races, etc..
fs.protected_symlinks=1
fs.protected_hardlinks=1
```

## Network Configuration

### misc

```conf
# enable JIT hardening (oe https://github.com/torvalds/linux/blob/9e4b0d55d84a66dbfede56890501dc96e696059c/include/linux/filter.h#L1039-L1070)
net.core.bpf_jit_harden=2
# make all attempts to lower network latency
net.ipv4.tcp_low_latency=1
# increase the max number of sockets allowed to exist in the "time wait" state
net.ipv4.tcp_max_tw_buckets = 450000
# allows for sockets that are about to be destroyed to be reused
net.ipv4.tcp_tw_reuse=1
# network buffer tuning
net.core.rmem_max=26214400
net.core.rmem_default=26214400
net.core.wmem_max=26214400
net.core.wmem_default=26214400
net.core.optmem_max=26214400
```

### ipv4

```conf
# enable time-wait assination mitigation
net.ipv4.tcp_rfc1337=1
# enable source validation of packets received
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
# avoid smurf attacks, prevent clock fingerprinting
# TODO: makes it hard to debug network connectivity issues
# net.ipv4.icmp_echo_ignore_all=1
# disable icmp redirect, and minimize information disclosure
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.all.secure_redirects=0
net.ipv4.conf.default.secure_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.send_redirects=0
# disable source routing
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.default.accept_source_route=0
# disable sack
net.ipv4.tcp_sack=0
net.ipv4.tcp_dsack=0
net.ipv4.tcp_fack=0
net.ipv4.tcp_fastopen=3
net.ipv4.udp_mem = 2527891 3037191 4055782
net.ipv4.udp_wmem_min = 16384
net.ipv4.udp_rmem_min = 16384

```

### ipv6

```conf
net.ipv6.conf.all.accept_redirects=0
net.ipv6.conf.default.accept_redirects=0
net.ipv6.conf.all.accept_source_route=0
net.ipv6.conf.default.accept_source_route=0
# prevent malicious ipv6 router advertisements
net.ipv6.conf.all.accept_ra=0
net.ipv6.conf.default.accept_ra=0
# enable ipv6 privacy extensions
net.ipv6.conf.all.use_tempaddr=2
net.ipv6.conf.default.use_tempaddr=2
```

## Misc

```conf
# restrict tty line discilpines
dev.tty.ldisc_autoload=0
```

# Resources

* https://madaidans-insecurities.github.io/guides/linux-hardening.html#kernel