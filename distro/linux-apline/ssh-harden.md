https://www.tecmint.com/secure-openssh-server/
```sh
#/etc/ssh/sshd_config
1. Setup SSH Passwordless Authentication
PasswordAuthentication no

2. Disable User SSH Passwordless Connection Requests
PermitEmptyPasswords no

3. Disable SSH Root Logins
PermitRootLogin no

4. Limit SSH Access to Certain Users
AllowUsers tecmint james

5. Use SSH Protocol 2
Protocol 2

ssh -1 user@remote-IP
You will get an error that reads “SSH protocol v.1 is no longer supported”.

ssh -2 user@remote-IP

6. Set SSH Connection Timeout Idle Value
ClientAliveInterval 180

7. Configure a Limit for Password Attempts
MaxAuthTries 3
