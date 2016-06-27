#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

MYDIR="$(dirname $0)"
cd "$MYDIR"

rm -rf ca/newcerts/*
echo "01" > ca/serial
echo "01" > ca/crlnumber
echo -n > ca/index.txt
rm -f ca/root_ca.crt ca/root_ca.crl ca/root_ca.key truststore.jks
