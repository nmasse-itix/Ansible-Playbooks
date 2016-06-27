#!/bin/bash

SERVER_KEYSIZE="2048"
SERVER_VALIDITY="740"

set -e # Exit immediately if a command exits with a non-zero status.

MYDIR="$(dirname $0)"
cd "$MYDIR"

# Parameter validation
test -n "$BASENAME"
test -n "$CERT_CN"
test -n "$OUTDIR"
test -n "$PASSWORD"

openssl req -new -newkey "rsa:$SERVER_KEYSIZE" -keyout "$OUTDIR/$BASENAME.key" -nodes -out "$OUTDIR/$BASENAME.csr" -subj "/CN=$CERT_CN"
openssl ca -batch -in "$OUTDIR/$BASENAME.csr" -out "$OUTDIR/$BASENAME.crt" -notext -days "$SERVER_VALIDITY" -config ca/openssl.cnf -name "RootCA" -extensions server_ext
cat "$OUTDIR/$BASENAME.key" "$OUTDIR/$BASENAME.crt" | openssl pkcs12 -export -out "$OUTDIR/$BASENAME.p12" -passout "pass:$PASSWORD"
keytool -importkeystore -noprompt -srcalias 1 -srcstorepass "$PASSWORD" -srcstoretype PKCS12 -srckeystore "$OUTDIR/$BASENAME.p12" -destalias "$BASENAME" -deststoretype JKS -deststorepass "$PASSWORD" -destkeystore "$OUTDIR/$BASENAME.jks"
cp truststore.jks "$OUTDIR/$BASENAME-trust.jks"
cp ca/root_ca.crt "$OUTDIR/$BASENAME-ca.crt"
