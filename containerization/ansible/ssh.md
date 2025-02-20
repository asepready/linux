```sh
# Create a ssh-keygen so you can ssh without a password
sysadmin@master:~$ ssh-keygen
sysadmin@worker1:~$ ssh-keygen
sysadmin@worker2:~$ ssh-keygen

# Copy all public key from regular user to all nodes
sysadmin@master:~$ ssh-copy-id sysadmin@master
sysadmin@master:~$ ssh-copy-id sysadmin@worker1
sysadmin@master:~$ ssh-copy-id sysadmin@worker2

sysadmin@worker1:~$ ssh-copy-id sysadmin@master
sysadmin@worker1:~$ ssh-copy-id sysadmin@worker1
sysadmin@worker1:~$ ssh-copy-id sysadmin@worker2

sysadmin@worker2:~$ ssh-copy-id sysadmin@master
sysadmin@worker2:~$ ssh-copy-id sysadmin@worker1
sysadmin@worker2:~$ ssh-copy-id sysadmin@worker2

# Check if the host can access without using a password (passwordless).
sysadmin@master:~$ ssh sysadmin@master "whoami; hostname"
sysadmin@master:~$ ssh sysadmin@worker1 "whoami; hostname"
sysadmin@master:~$ ssh sysadmin@worker2 "whoami; hostname"

sysadmin@worker1:~$ ssh sysadmin@master "whoami; hostname"
sysadmin@worker1:~$ ssh sysadmin@worker1 "whoami; hostname"
sysadmin@worker1:~$ ssh sysadmin@worker2 "whoami; hostname"

sysadmin@worker2:~$ ssh sysadmin@master "whoami; hostname"
sysadmin@worker2:~$ ssh sysadmin@worker1 "whoami; hostname"
sysadmin@worker2:~$ ssh sysadmin@worker2 "whoami; hostname"
