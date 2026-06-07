# Easy path
```bash
bluetoothctl devices
bluetoothctl connect [MAC]
```
# Pain mode
Check if bluetooth is not disabled:
```bash
rfkill
rfkill unblock bluetooth #to make sure bluetoothctl is enabled
```

Execute
```bash 
bluetoothctl
```
within
```bash
power on 
scan.clear
scan on #start scanning
devices
scan off #stop scanning

```
Then check easy path

