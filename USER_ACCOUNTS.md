# User Accounts


Each service ran is done so under a privilege minimzed user account to help isolate processes from each otehr as much as possible. At a minimum there are two users, a docker administrator user, and your actual admin user account. The admin user is the only user which is permitted to be used over ssh, and is secured with public key authentication, as well as 2FA support.

# Docker Admin

A user account name `docker-admin` is created, whose sole purpose is to administer docker containers. Therefore it is the only user account that is a member of the `docker` group. This user will need shell access in order to be usable.

```shell
$> sudo useradd -m docker-admin --shell /bin/bash
$> sudo usermod -aG docker docker-admin
```

# Administrator 

The administrator account is a general purpose account that is used as an entrypoint into the server, while having access to the `sudo` command. Additionally 2FA is configured so that not only must a 2FA code be presented during SSH, attempting to invoke the `sudo` command also requires a 2FA code. This account is not a member of any other group, and is strictly used for pivoting to the appropriate user account.

Once you have created this user, make sure to enable public key ssh authentication, and copy over your ssh key before enabling 2FA authenticaiton.

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
