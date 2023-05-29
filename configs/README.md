# Warning

While using `sysctl.conf.old` I experienced frequent database corruption issues running redundant beacon chain and consensus layer nodes that happened across Nethermind, Geth, Nimbus, and Lighthouse. I was testing out some unpublished kernel tweaks, that I believed caused the issues.

It was having time wait reuse, and recycle enabled, while disabling tcp timestamps. There are some edge cases with these features, however I've used them on other servers without issue. The difference (i think) is that I 