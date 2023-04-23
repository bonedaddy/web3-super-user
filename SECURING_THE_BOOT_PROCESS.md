# Securing The Boot Process

It is very important that the boot process of your server be secured, as this can provide a fallback defense if your server is ever physically compromised.


# GRUB Security

A good first step to securign the boot process is to add a password to grub. This prevents nayone from changing configurations temporarily unless they enter a password.

To do so run the following command:

```shell
$> sudo grub-mkpasswd-pbkdf2
$> sudo vim /etc/grub.d/40_custom
```

Then append to the end of the editor the following:

```
set superusers="YOURUSER"
password_pbkdf2 YOURUSER PASSWORD
```

Now we will skip the grub menu entirely. To do so run `sudo vim /etc/default/grub` and set `GRUB_TIMEOUT` to `1`

# Resources

* https://ruderich.org/simon/notes/secure-boot-with-grub-and-signed-linux-and-initrd
* https://www.gnu.org/software/grub/manual/grub/html_node/Security.html
* https://wiki.debian.org/SecureBoot
* https://forums.debian.net/viewtopic.php?t=110580