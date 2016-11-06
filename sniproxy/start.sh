docker rm -f sniproxy

docker run -d --restart=unless-stopped -p 443:443 --name sniproxy sniproxy
