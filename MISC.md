# Miscellaneous Information And Resources

Contains links, configs, etc.. that aren't necessarily restricted to the categories included in this document.

# Suggested Packages

## `irqbalance`

Used to distribute interrupts across multiple CPU cores. Can be installed with

```shell
$> sudo apt install irqbalance
```


# JWT Secret Generation

We need to generate a jwt secret used for rpc authentication. To do so we can run the following command

```shell
$> openssl rand -hex 32 | tr -d "\n"
```

# Resources

* https://www.debian.org/doc/manuals/securing-debian-manual/
* https://madaidans-insecurities.github.io/guides/linux-hardening.html
* https://www.thomas-krenn.com/en/wiki/Linux_Performance_Measurements_using_vmstat
* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/performance_tuning_guide/index
* https://www.ibm.com/docs/en/linux-on-systems?topic=performance-tuning-hints-tips
* https://easyengine.io/tutorials/linux/sysctl-conf/
* https://levelup.gitconnected.com/linux-kernel-tuning-for-high-performance-networking-high-volume-incoming-connections-196e863d458a
* https://www.frozentux.net/ipsysctl-tutorial/chunkyhtml/tcpvariables.html
* https://www.mo4tech.com/linux-tcp-kernel-parameter-settings-and-tuning-details.html