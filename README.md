# This is worst thing i made, but it works 😒
Okay so, to check curret limit use this, it will be 8 if you not used my `.bat` "programm"
```PowerShell
reg query "HKLM\SYSTEM\CurrentControlSet\Services\icssvc\Settings" /v WifiMaxPeers
```

1) Next step is setting limits, in my `.bat` i used 99, in this example too
```PowerShell
reg add "HKLM\SYSTEM\CurrentControlSet\Services\icssvc\Settings" /v WifiMaxPeers /t REG_DWORD /d 99 /f
```

2) We need restart `Internet Connection Sharing` thing... this is actual name
```PowerShell
Restart-Service icssvc
```
Or you can use cmd intead
```Cmd
net stop icssvc
net start icssvc
```
