# User Accounts

It's important that you secure your server by isolating user accounts as much as possible. For our purposes we recommend three main accounts:

* `docker-adm`
* `auth-adm`
* `maintenance-adm`

# Docker Admin

The `docker-adm` account is part of the `docker` group allowing for deployment, maintenance, and usage of the docker daemon.

The user account should have no special permissions, other than being part of the docker group.


# Auth Admin

The `auth-adm` account is used for accessing the server either locally or remotely. It should be secured with an ssh public key, as well as requiring both 2FA on SSH access.

## Enabling 2FA

To enable 2FA, you can run the following script:

```bash
#!/bin/bash

# references
# https://www.digitalocean.com/community/tutorials/how-to-configure-multi-factor-authentication-on-ubuntu-18-04
# https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-16-04

# we use nullok so that we dont brick ourselves if we havent configured 2fa before running this


sudo apt install libpam-google-authenticator

# enables 2fa for ssh
echo "auth required pam_google_authenticator.so nullok" | sudo tee --append /etc/pam.d/sshd
# enables 2fa for login and sudo requests
echo "auth required pam_google_authenticator.so nullok" | sudo tee --append /etc/pam.d/common-auth
echo "[WARN] if you want to enable 2fa for desktop environments make sure to edit '/etc/pam.d/gdm' or similar"
# this makes ssh aware of ssh
echo "AuthenticationMethods publickey,password publickey,keyboard-interactive" | sudo tee --append /etc/ssh/sshd_config
# enable challenge response
sudo sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/KbdInteractiveAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

echo "please comment out '@include common-auth' in /etc/pam.d/sshd to disable password prompts"
echo "[INFO] please run the google-authenticator command"
```

Afterwards running this script, execute `google-authenticator` and follow the prompts. Once this is done edit `/etc/pam.d/sshd` and comment out the line `@include common-auth`, which will disable password prompts for sshd, enabling only ssh-key  authentication, and OTP verification. The above configuration will require the first time sudo is invoked the user provides a 2FA code.

# Maintenance Admin

The `maintenance-adm` account is used for performing all systems administration tasks, and has `sudo` group membership. In addition to this access to the `sudo` command should be gated behind 2FA.

