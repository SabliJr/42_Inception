FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt install -y mariadb-server

RUN mkdir -p /run/mysqld /var/lib/mysql /var/log/mariadb && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql /var/log/mariadb

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

COPY ./conf/db.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./conf/db_setup.sh /db_setup.sh

RUN chmod +x ./db_setup.sh

ENTRYPOINT ["sh", "./db_setup.sh"]