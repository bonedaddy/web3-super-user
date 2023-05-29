# Warning

> **tl;dr - use dont use `sysctl.conf.old`**

While using `sysctl.conf.old` I experienced frequent database corruption issues running redundant beacon chain and consensus layer nodes that happened across Nethermind, Geth, Nimbus, and Lighthouse. I was testing out some unpublished kernel tweaks, that I believed caused the issues.

It was having time wait reuse, and recycle enabled, while disabling tcp timestamps. There are some warnings about enabling these kernel tweaks on the internet, and they were right... :facepalm:

Currently re-enabling my tweaks more slowly this time with the results tracked in `sysctl.conf` just to make sure there are no other peculiarities.
