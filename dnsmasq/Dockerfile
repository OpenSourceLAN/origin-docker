FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl && (for i in epic-games steam blizzard riot origin wargaming.net sony xboxlive ; do echo "#"; echo "# " $i;  curl -s https://raw.githubusercontent.com/uklans/cache-domains/master/$i.txt | sed 's/*//'; done ) | awk '{if ($1 == "#") print $0; else print "address=/" $1 "/IP_HERE"}' > /dnsmasq-template.conf

FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y dnsmasq

COPY --from=0 /dnsmasq-template.conf /dnsmasq-template.conf

ADD start-dnsmasq.sh /usr/bin/
RUN echo "conf-dir=/etc/dnsmasq.d/,*.conf" >> /etc/dnsmasq.conf
CMD ["start-dnsmasq.sh"]

