#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

ROOTCA_KEYSIZE="2048"
ROOTCA_VALIDITY="7400"
ROOTCA_CRLVALIDITY="740"

MYDIR="$(dirname $0)"
cd "$MYDIR"

rm -rf ca/newcerts/*
echo "01" > ca/serial
echo "01" > ca/crlnumber
echo -n > ca/index.txt
openssl req -new -sha256 -newkey "rsa:$ROOTCA_KEYSIZE" -keyout "ca/root_ca.key" -nodes -out "ca/root_ca.crt" -x509 -days "$ROOTCA_VALIDITY" -set_serial 0 -config ca/openssl.cnf
openssl ca -batch -md sha256 -gencrl -crldays "$ROOTCA_CRLVALIDITY" -out "ca/root_ca.crl" -config ca/openssl.cnf
