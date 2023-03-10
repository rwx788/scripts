# Guides

## Recover from messing up sudoers file over ssh
Based on [this amazing answer](https://unix.stackexchange.com/questions/677591/how-to-restore-a-broken-sudoers-file-without-being-able-to-use-sudo)
Saved me multiple times when I forgot to use visudo!

* Open two SSH sessions to the target server.

* In the first session, get the PID of bash by running:
```bash
$ echo $$
```
* In the second session, start the authentication agent with:
```bash
$ pkttyagent --process $YOUR_PID_HERE
```
* Use the pid obtained from step 1.
* Back in the first session, run:
```bash
$ pkexec chown root:root /etc/sudoers /etc/sudoers.d -R
```
* Enter the password in the second session password promt

# scripts

## dotnet

To install dotnet sdks on arm64 macOS:
```bash
# dotnet-install.sh --install-dir /usr/local/share/dotnet -arch arm64 --channel 6.0
# dotnet-install.sh --install-dir /usr/local/share/dotnet/x64 -arch x64 --channel 6.0
# dotnet-install.sh --install-dir /usr/local/share/dotnet/x64 -arch x64 --channel 3.1
```
In case `dotnet` command cannot be found in the PATH, create a symlink to the /usr/local/bin:
```bash
$ ln -s /usr/local/share/dotnet/dotnet /usr/local/bin/
```
