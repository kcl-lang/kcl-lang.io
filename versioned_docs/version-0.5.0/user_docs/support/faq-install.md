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
xattr -rd com.apple.quarantine /path/to/kcl
```

Where `/path/to/kcl` is the complete path of the kcl application. After running the command, the application will be added to the whitelist and Gatekeeper will no longer prevent it from running.

## program not found or run linker failed error on Windows/Linux/MacOS

Please ensure that the following dependencies are in your PATH:

+ `clang` for MacOS
+ `gcc` for Linux
+ `cl.exe` for Windows, which can be obtained by installing MSVC
