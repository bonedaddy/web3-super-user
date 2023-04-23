# Systemd

# Analying Service Configurations

We can conduct a security analysis of a systemd service using the following command

```shell
$> systemd-analyze security systemd-resolved.service
```

# Services

Unit configuration files ended in `.service` encode information about a process supervised by systemd.

## Startup Orders

## `WantedBy`, `RequiredBy`

See the `Wants` and `Requires` documentation

## `Wants`

Configures "weak" required dependencies of other units, and ensures that the service will not be started until all services specified in `Wants` have started. 

This service will start even if any of the wanted services fail to start.

## `Requires`

Similar to `Wants`, but requires that the services start successfully before the main service is started.

## `After`

When `After` is used, the main service start will be delayed until all services in `After` have started. `Before` ensures that the main service is started before all other services listed in `Before`.

## Dependencies

The following dependencies are implicitly added

* Services with `Type=dbus` acquire dependencies of type `Requires=` and `After=` on `dbus.socket`
* Socket activated services are ordered after the activating `.socket` units via an `After=` dependency.
* note that services pull in all `.socket` units listed in `Sockets=` via automatic `Wants=` and `After=` dependencies

## `Type`

Used to configure the startup type of this service, can be one of `simple`, `exec`, `forking`, `oneshot`, `dbus`, `notify`, `notify-reload`, `idle`.

For long running services it is recommended to use the `simple` type as its 

### `simple`

The unit is started immediately after the main service process has been forked off. It is expected that the process started by `ExecStart` is the main process of this service. Followup services will be enabled immediately, before the service startup completes.

With `simple`, running `systemctl start` will report success even if the binarys service fails to execute successfully.

### `exec`

Like `simple`, but delays starting up followup units until the main service has been executed.

With `exec`,running `systemctl start` will report failre if the binary fails to exedcute.

### `forking`

It is expected that the process started by `ExecStart` will call `fork()` as part of its startup, and the parent process is expected to exit when startup is complete. Recommended that `PIDFile=` option is also set

### `dbus`

Similar to `simple`, except it is expected that the services acquires a name of the D-Bus bus, as configured by `BusName=`. Follow up units will be started after the bus name has been acquired.

### `notify`

Similar to `exec` except it is expected that the service sends a `READY=1` notification via [sd_notify](https://www.freedesktop.org/software/systemd/man/sd_notify.html#) or an equivalent call when it has finished starting up. Systemd will start followup units after this notification is received

### `notify-reload`

Identical to `notify` but when the `SIGHUP` signal is sent to the service main process, the service is reloaded. After the service is finished reloading, the service is expected to send a message via `sd_notify` with `RELOADING=1`, with `MONOTONIC_USEC` set to the current monotonic time, as obtained via [clock_gettime](https://man7.org/linux/man-pages/man2/clock_gettime.2.html)

## `ExecStart`

Commands with their arguments are executed when the service starts. You may provide multiple commandlines in the same directive, or specify multiple `ExecStart` directives. The first argument must be an absolute path to an executable, or a simple filename without any slashes.

Unless `Type=forking` is set, the process started via the command line will be considered the main process of the daemon.

## `ExecStartPre` and `ExecStartPost`

Commands that are executed before or after the command in `ExecStart`. If multiple statements are specified, they are executed sequentially.

With this, `ExecStart` commands are only run after all `ExecStartPre` commands succesfully complete. 

`ExecStartPost` runs after the process started via `ExecStart` invokes succesfully.

## `ExecReload`

Commands used to trigger a configuration reload of the service, with an environment variable set `$MAINPID` which is the process id of the daemon. This is an asynchronous operation and not suitable when ordering reloads of multiple services against each other.

## `Restart`

Configures whether the service will be restarted when the process exits, is killed or a timeout is reached, with the process being the one started by any of `ExecStartPre`, `ExecStartPost`, `ExecStop`, `ExecStopPost` or `ExecReload` unless the death of the process is as a result of `systemctl stop` or `systemctl restart`.

Takes a value of `no`, `on-success`, `on-failure`, `on-abnormal`, `on-watchdog`, `on-abort`, `always`, with a default of `no`.


```service
ExecReload=kill -HUP $MAINPID
```

# Configurations

## PrivateT(e)mp Directories

This creates a file system name space under `/tmp` mitigating a number of security vulnerabilities

```service
PrivateTmp=yes
```

## ProtectSystem

Can be used to sandbox which directories a process has access to, using `strict` means the entire filesystem hierarchy is mounted as read-only, and `ReadWritePaths` can be used to grant read/write access as needed

```service
ProtectSystem=strict
```

## ProtectHome

This makes `/home`, and `/root` appear empty

```service
ProtectHome=yes
```

## ProtectDevices

Creates a private `/dev` namespace using pseudo devices that do not give access to hardware. Disables `CAP_MKNOD`

```service
ProtectDevices=yes
```

## Read/Write/Inaccessible Directories

Using the following we can enable read-write, read-only, and inaccessible options ofr filesystem access.


```service
ReadWriteDirectories=
ReadOnlyDirectories=
InaccessibleDirectories=
```

## RemoveIPC

All SystemV and POSIX IPC objects owned by the user and group of the running process when the unit is stopped.

```service
RemoveIPC=yes
```

## DynamicUser

Creates an ephemeral UNIX user that exists only for the duration of the process

```service
DynamicUser=yes
```

When using this, all data stored is temporary. If you need persistent storage you can use the following configurations, which store data under `/var/log`, `/var/lib` and /

```service
# stores data under `/var/lib`
StateDirectory=
# stores data under `/var/log`
LogsDirectory=
# stores data under `/var/cache`
CacheDirectory
```

## WorkingDirectory

Sets the current directory of the running process

```service
WorkingDirectory=/etc/nebula
```

## NoNewPrivileges

Ensures that the service process and its children never gain new privileges through `execve()` (e.g. via setuid or setgid bits, or filesystem capabilitie

```service
NoNewPrivileges=true
```

## Resource Restriction

The following parameters can be used to enforce resource limitations

```service
# limit the number of open files
LimitNOFILE=
# specify the maximum amount of memory usage
MemoryMax=16G # 16GB for example
```

## KeyringMode

Used to restrict access to the session keyring. The following ensures the process uses a completely isolated keyring. See https://man7.org/linux/man-pages/man7/session-keyring.7.html for more information

```service
KeyringMode=private
```

## PrivateNetwork

When true, the service exists in its own isolated network namespace without external network access using only the `loopback` device. Can be combined with `JoinsNamespaceOf=` to interconnect multiple services running in private network mode.

```service
PrivateNetwork=true
JoinsNamespaceOf=nebula.service
```

## PrivateUsers

When this is set, creates a new user namespace for the processes, configuring minimal user and group mappings, with the "root" user and group as well as the unit's own user and group to themselves and everything else to the "nobody" user and group. The process will have zero process capabilities on the host's user namespace, but full capabilities within the service's user namespace. 

```service
PrivateUsers=true
```

## ProtectHostname

When this is used, a new UTS namespace is created for the process.

```service
ProtectHostname=true
```

## ProtectClock

Disables writes to the hardware or system clock.

```service
ProtectClock=true
```

## ProtectKernelTunables

Ensures that the kernel variables access through `/proc/sys/, /sys/, /proc/sysrq-trigger, /proc/latency_stats, /proc/acpi, /proc/timer_stats, /proc/fs and /proc/irq` are read-only.

```service
ProtectKernelTunables=true
```

## MemoryDenyWriteExecute

Any attempts to create memory mappings that are writable and executable are denied.

```service
MemoryDenyWriteExecute=true
```

## PrivateMounts

Takes a boolean parameter. If set, the processes of this unit will be run in their own private file system (mount) namespace with all mount propagation from the processes towards the host's main file system namespace turned off. This means any file system mount points established or removed by the unit's processes will be private to them and not be visible to the host. 

```service
PrivateMounts=true
```

## Environment

Used to set environment variables. Variable expansion is not performed inside the strings and the "$" character has no special meaning

```service
Environment="VAR1=word1 word2" VAR2=word3 "VAR3=$word 5 6"
```
The above creates three env variables `VAR1` `VAR2` `VAR3`, with the values `word1 word2`, `word3`, `$word 5 6`.

## EnvironmentFile

Like `Environment` but reads env variables from a tex

## LoadCredential / LoadCredentialEncrypted

Format of `ID[:PATH]`

Can be used to pass credentials to the unit which are small sized binary or textual objects primarily used. The data is accessible from the unit's processes via the file system, at a read-only location that (if possible and permitted) is backed by non-swappable memory. The data is only accessible to the user associated with the unit.

The `ID` is used as a name for the credential, with the path to the credential on the filesystem  specified after a colon. If no matching system credential is found, the directories /etc/credstore/, /run/credstore/ and /usr/lib/credstore/ are searched for files under the credential's name — which hence are recommended locations for credential data on disk. If LoadCredentialEncrypted= is used /run/credstore.encrypted/, /etc/credstore.encrypted/, and /usr/lib/credstore.encrypted/ are searched as well.

The location of the credential is exported to the env variable `$CREDENTIALS_DIRECTORY`.


When `LoadCredentialEncrypted` is used, the credential must be encrypted leveraing [systemd-creds](https://www.freedesktop.org/software/systemd/man/systemd-creds.html#). A credential configured this way may be symmetrically encrypted/authenticated with a secret key derived from the system's TPM2 security chip, or with a secret key stored in `/var/lib/systemd/credentials.secret`, or with both.

Alternatively, if the `-p` switch is used with `systemd-creds`, the encrypted credential can be embedded directly within the unit file using `SetCredentialEncrypted`


```service
LoadCredential=foo:/etc/credstore
LoadCredentialEncrypted=bar:/etc/credstore.encrypted
SetCredentialEncrypted=baz:wowmuchencryption
```

# Examples

```systemd
[Unit]
Description=Some HTTP Server
After=remote-fs.target sqldb.service
Requires=sqldb.service
AssertPathExists=/srv/webserver

[Service]
Type=notify
ExecStart=/usr/sbin/some-fancy-httpd-server

[Install]
WantedBy=multi-user.target
```

# Service Hardening

[Take from here](https://ruderich.org/simon/notes/systemd-service-hardening), and contains a variety of options that can be used to harden a systemd service.

```service
CapabilityBoundingSet=
LockPersonality=yes
MemoryDenyWriteExecute=yes
NoNewPrivileges=yes
PrivateDevices=yes
PrivateMounts=yes
PrivateNetwork=yes
PrivateTmp=yes
PrivateUsers=yes
ProtectControlGroups=yes
ProtectHome=yes
ProtectKernelModules=yes
ProtectKernelTunables=yes
ProtectSystem=strict
# Permit AF_UNIX for syslog(3) to help debugging. (Empty setting permits all
# families! A possible workaround would be to blacklist AF_UNIX afterwards.)
RestrictAddressFamilies=
RestrictAddressFamilies=AF_UNIX
RestrictNamespaces=yes
RestrictRealtime=yes
SystemCallArchitectures=native
SystemCallFilter=
SystemCallFilter=@system-service
SystemCallFilter=~@aio @chown @clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @privileged @raw-io @reboot @resources @setuid @swap userfaultfd mincore

# Only available in Debian bullseye or later
ProtectHostname=yes
RestrictSUIDSGID=yes

# Restrict access to potential sensitive data (kernels, config, mount points,
# private keys). The paths will be created if they don't exist and they must
# not be files.
TemporaryFileSystem=/boot:ro /etc/luks:ro /etc/ssh:ro /etc/ssl/private:ro /media:ro /mnt:ro /run:ro /srv:ro /var:ro
# Permit syslog(3) messages to journald
BindReadOnlyPaths=/run/systemd/journal/dev-log
```

# Resources

* https://www.redhat.com/sysadmin/mastering-systemd
* https://www.redhat.com/sysadmin/systemd-secure-services
* https://unix.stackexchange.com/questions/635027/systemd-dynamicuser-vs-user
* https://0pointer.net/blog/dynamic-users-with-systemd.html
* https://www.freedesktop.org/software/systemd/man/systemd.exec.html
* https://www.freedesktop.org/software/systemd/man/systemd-creds.html#
* https://www.freedesktop.org/software/systemd/man/systemd.service.html#
* https://www.freedesktop.org/software/systemd/man/systemd.unit.html
* https://ruderich.org/simon/notes/systemd-service-hardening