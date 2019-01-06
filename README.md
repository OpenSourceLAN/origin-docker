# LAN Cache in a docker container

Simply expose this container on port 80, and point a bunch of domains to this server's IP address, 
and you get a fully operational LAN cache. Hooray!

## Game Download Service URL Reference List

For a list of DNS addresses to override on your DNS server, refer to [uklans/cache-domains](https://github.com/uklans/cache-domains/),
or the individual nginx configuration files in this repo.

## Quickstart

To build and run, do:
```
./buildcontainer.sh
./start.sh
```

`start.sh` will make a /data/ directory to store logs and cache data in. 

## SSL HTTPS Dependency

*Warning*: some services (eg, when downloading the Origin client) require HTTPS access to the 
hosts that we are hijacking. To avoid connectivity issues, you will need to run an 
[SNI proxy](https://github.com/dlundquist/sniproxy) to enable pass through of HTTPS traffic. 

You can build and run the sniproxy container in the `sniproxy` directory to achieve this. 

```
cd sniproxy
docker build -t sniproxy .
docker run --name sniproxy -p 443:443 sniproxy
```

## Installation Walkthrough

### Start with a clean install of Linux

### Ensure `/data` is on a volume (or symlink) with plenty of disk space.

Example:
 - consider you have a mega-partition mounted to /mnt/storage
 - create a symlink for /data
```
$ sudo ln -s /mnt/storage/lancache/ /data

$ df -h /data
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       1.7T   69M  1.6T   1% /mnt/storage
```

### Install Docker if not already installed
 - curl sudo bash is terrible, but you're trusting my code anyway :)
```
$ curl -sSL https://get.docker.com | sudo bash
```

### Get this repository
```
$ git clone https://github.com/OpenSourceLAN/origin-docker.git
$ cd origin-docker
```

### Set your max cache size
`$ vi nginx.conf`
Edit nginx.conf:
- Find the proxy_cache_path line and udpate the max_size parameter to the maximum
  amount of disk space you would like your cache to use

### Build the containers
`# ./buildcontainer.sh`

### Start the cache container

Notes:
 - using `--restart=always`, will auto-start after reboot
 - security, running your Docker services as root or non root
   see https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface
`# ./start.sh`

### Start the SNI proxy container (optional, but recommended)
`# docker run --name sniproxy -p 443:443 sniproxy`

### Start the DNS server if you need it
`# cd dnsmasq && ./start.sh`


## Credits
In addition to OpenSourceLAN members, this project contains [contributions](https://github.com/OpenSourceLAN/origin-docker/pull/1) from @ChainedHope

