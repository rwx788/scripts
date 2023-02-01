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
