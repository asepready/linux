Initial Settings : Add User Accounts
 	
If you'd like to add new user accounts, configure like follows.
[1]	For example, Add a [sysadmin] user.
```sh
root:~# adduser sysadmin
New password:            # set user password
Retype new password:     # confirm
```
root:~#
[2]	If you'd like to limit users to switch to root user account, configure like follows.
For example, Configure that only [sysadmin] user can switch to root account with [su] command.
```sh
root:~# usermod -aG adm sysadmin
root:~# vi /etc/pam.d/su
# line 15 : uncomment and add the group
auth       required   pam_wheel.so group=adm
```
[3]	If you'd like to remove user accounts, configure like follows.
```sh
# remove a user [sysadmin] (only removed user account)
ubuntu:~$ deluser sysadmin
# remove a user [sysadmin] (removed user account and his home directory)
ubuntu:~$ deluser sysadmin --remove-home
```