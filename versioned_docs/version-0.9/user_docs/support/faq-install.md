---
sidebar_position: 5
---

# Installation Troubleshooting

## MacOS prompts that 'kcl' cannot be opened because Apple cannot check if it contains malicious software

MacOS prompts that 'kcl' cannot be opened because Apple cannot check if it contains malicious software. This issue is due to the Gatekeeper security feature in the macOS system preventing the application from running. To solve this issue, follow these steps:

Open 'System Preferences' and click 'Security and Privacy'. In the "General" tab, you will see a message: '"kcl" cannot be opened'. Click 'Open still'. Alternatively, you can click 'Open any method' to open your application. (You may need to use administrator privileges to open the application.)

If you don't want to perform these steps every time you open an application, you can add the application to the whitelist to run without being blocked. To add your application to the whitelist:

Open the terminal and run the following command:

```shell
xattr -d com.apple.quarantine /path/to/kcl
```

Where `/path/to/kcl` is the complete path of the kcl application. After running the command, the application will be added to the whitelist and Gatekeeper will no longer prevent it from running.

## Program not found or run linker failed error on Windows/Linux/MacOS

Please ensure that the following dependencies are in your PATH:

- `clang` for MacOS
- `gcc` for Linux
- `cl.exe` for Windows, which can be obtained by installing `MSVC` including `MSVCP140.dll` and `VCRUNTIME140.dll`.

## Encountering exit status 0xc0000135 error on Windows platform

Please ensure that `.NET Framework` and `MSVC` are installed on your Windows. If not installed, you can install them and try again.

## Errors on Starting/Running KCL inside a Container for "Permission Denied" or "File Not Found"

The issue is due to KCL requiring write permissions for its default global configuration and global package cache at compile time. One solution is to set the global configuration and package directory to the `/tmp` folder. For detailed Dockerfile configuration, please see [here](https://github.com/kcl-lang/cli/blob/main/Dockerfile).

```dockerfile
ENV KCL_PKG_PATH=/tmp
ENV KCL_CACHE_PATH=/tmp
```
