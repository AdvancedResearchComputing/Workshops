# Secure Remote Development

## SSH key management and usage

If you're making frequent SSH connections to ARC systems or transferring data, SSH-keys can make the authentication steps more seamless.

[SSH Keys overview](https://docs.arc.vt.edu/usage/sshkeys.html)


## File system awareness and login node limitations

>[!NOTE]
> Long running or intensive workloads are not appropriate for login nodes. Please run these in a job where you have access to dedicated hardware resources. You may get "locked out" of login node if you launch an intensive task there.

`loginusage`

```
[brownm12@tinkercliffs2 ~]$ loginusage
Control Group                                                                                                      Tasks   %CPU   Memory  Input/s Output/s
user.slice/user-1709627.slice                                                                                          7    3.4    30.4M        -        -
user.slice/user-1709627.slice/user@1709627.service                                                                     2    3.3     8.2M        -        -
user.slice/user-1709627.slice/user@1709627.service/init.scope                                                          2    3.3   660.0K        -        -
user.slice/user-1709627.slice/session-1129008.scope                                                                    5    0.1    14.9M        -        -
user.slice/user-1709627.slice/user@1709627.service/app.slice                                                           -      -   872.0K        -        -
user.slice/user-1709627.slice/user@1709627.service/app.slice/dbus.socket                                               -      -     4.0K        -        -

USER         PID %CPU S THCNT STIME     ELAPSED     TIME COMMAND
brownm12  179947  1.5 S     1 09:50    01:25:22 00:01:19 /usr/lib/systemd/systemd --user
brownm12  179949  0.0 S     1 09:50    01:25:22 00:00:00 (sd-pam)
brownm12  179958  0.0 R     1 09:50    01:25:22 00:00:00 sshd: brownm12@pts/110
brownm12  179959  0.0 S     1 09:50    01:25:22 00:00:00 -bash
brownm12  553507  0.0 S     1 11:15       00:05 00:00:00 -bash
brownm12  553925  0.0 R     1 11:15       00:00 00:00:00 ps -U 1709627 -o user,pid,pcpu,state,thcount,stime,etime,cputime,command
```

Next > [Efficient Job Submission with Slurm](3-job_submission)