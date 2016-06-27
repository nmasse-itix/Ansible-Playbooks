#!/bin/bash

# Very insecure, but anyway it's a demo !
NEWPASS={{ mysql_root_password }}

test -f /root/.mysql_secret || exit 0
sed -r 's/^#.*: (.*)$/[client]\npassword=\1/' /root/.mysql_secret > /root/.my.cnf
chmod 600 /root/.my.cnf
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$NEWPASS'); SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('$NEWPASS'); FLUSH PRIVILEGES;" |mysql --connect-expired-password && rm -f /root/.mysql_secret
echo -e "[client]\npassword=$NEWPASS\n" > /root/.my.cnf
echo "UPDATE mysql.user SET Password = PASSWORD('$NEWPASS') WHERE User = 'root'; FLUSH PRIVILEGES;" |mysql
