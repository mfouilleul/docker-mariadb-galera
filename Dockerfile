FROM mariadb:10.1

ADD https://github.com/mfouilleul/seeds/releases/download/0.1.5/seeds-v0.1.5-beta-linux-amd64.tar.gz /tmp/
RUN cd /tmp \
    && tar -xzf seeds-v0.1.5-beta-linux-amd64.tar.gz -C /usr/local/bin \
    && rm seeds-v0.1.5-beta-linux-amd64.tar.gz \
    && chmod +x /usr/local/bin/seeds

ADD ["galera/", "/opt/galera/"]

RUN cd /opt/galera \
    && mkdir /etc/mysql/galera.conf.d \
    && mv /opt/galera/galera.cnf /etc/mysql/galera.conf.d/galera.cnf \
    && chmod +x *.sh

ADD ["docker-entrypoint.sh", "/usr/local/bin/"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mysqld"]
