# Docker

It is often useful to have docker running alongside your staking nodes, making it easy to deploy monitoring tools locally. However one needs to be careful as to secure the docker host properly.

# Docker Specific User

To manage containers and the docker daemon itself, create a dedicated user account whose sole privilege is being part of the `docker` group. This allows mitigating some threats that are present when compromised docker containers are spawned by a privileged user.

# Userns Remap

`userns-remap` is a feature that allows for linux namespace isolation mapping docker users to a less-privileged user on the docker host. For our purposes we will be enabling this globally for the docker engine itself, allowing `dockremap` to handle creation of the user.

To do this, edit the daemon configuration `/etc/docker/daemon.json` with the following

```json
{
    "userns-remap": "default"
}
```

# Capabilities Dropping

Unless your docker containers need specific capabilities, it is a good idea to drop all capabilities, manually adding the ones which are neded. This can be done with the following flags:

```yaml
cap-drop: ALL
cap-add: ...
```

# Enabling No New Privileges

To prevent escalation using `setuid` or `setgid` binaries, add the following to the docker daemon and restart

```json
{
    "no-new-privileges": true
}
```

# Disabling ICC (Inter Container Communication)

This restricts traffic between docker containers on the default bridge. Note that to enable docker containers to talk to each other, you will need to user the `--link` parameter.

```json
{
    "icc": false
}
```

# Resources

* https://docs.docker.com/engine/security/userns-remap/
* https://github.com/docker/docs/tree/main/engine/security
* https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html#rule-2-set-a-user
* https://www.digitalocean.com/community/tutorials/how-to-audit-docker-host-security-with-docker-bench-for-security-on-ubuntu-16-04