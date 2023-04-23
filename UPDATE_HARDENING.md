# System Updates

Often times updates are retrieved over `http`. While package managers contain tooling to verify the authenticity of updates, nevertheless its important to maximize security where possible. Additionally package managers like `apt` offer additional configurations that can be used to restrict syscalls that are performed.




# APT seccomp-bpf

This allows limiting which syscalls apt can perform during updates. To do so create a file located at `/etc/apt/apt.conf.d/40sandbox` and add the following:

```
APT::Sandbox::Seccomp "true";
```

# Use HTTPS For APT

To do this edit `/etc/apt/sources.list` and change `http` -> `https`. For example a fresh bullseye deployment will look like this after applying the configs:

```conf
deb https://deb.debian.org/debian/ bullseye main
deb-src https://deb.debian.org/debian/ bullseye main

deb https://security.debian.org/debian-security bullseye-security main
deb-src https://security.debian.org/debian-security bullseye-security main

# bullseye-updates, to get updates before a point release is made;
# see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
deb https://deb.debian.org/debian/ bullseye-updates main
deb-src https://deb.debian.org/debian/ bullseye-updates main
```

# Resources

* https://madaidans-insecurities.github.io/guides/linux-hardening.html#kernel
