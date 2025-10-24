# PAM-Konami

Inspired by the implementation from [wumb0](https://github.com/wumb0/pam_konami)

## Build `libpam_konami.so`

Buid the shared library [pam module](https://tldp.org/HOWTO/User-Authentication-HOWTO/x115.html):

```bash
docker build --output=. .
sudo mv libpam_konami.so  /usr/local/lib/libpam_konami.so
```

## Update /etc/pam.d/common-auth

Add the following line to the start of `/etc/pam.d/common-auth`:

```vim
auth  sufficient  /usr/local/lib/libpam_konami.so
```

## Try it out!

Run the following commands:

```bash
sudo -k
sudo su -
```
