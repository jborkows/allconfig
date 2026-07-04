```bash
> ping "EPSON%20XP-5150%20Series._ipps._tcp.local"
ping: EPSON%20XP-5150%20Series._ipps._tcp.local: Name or service not known
```

I don't know why the name of was like this:
```bash
> avahi-resolve -n "EPSON967430.local"
EPSON967430.local       10.72.7.169
```
Add as default
```bash 
> sudo lpadmin -p EpsonXP5150 -E -v "ipp://10.72.7.169:631/ipp/print" -m everywhere
> lpstat -d
no system default destination
> sudo lpadmin -d EpsonXP5150
> lpstat -d
system default destination: EpsonXP5150
> lpoptions
some text
> lpr raw-hollow-sigmod.pdf # printing...
```
