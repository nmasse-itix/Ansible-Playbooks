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

openssl req -new -newkey "rsa:$SERVER_KEYSIZE" -keyout "$OUTDIR/$BASENAME.key" -nodes -sha256 -out "$OUTDIR/$BASENAME.crt" -subj "/CN=$CERT_CN" -x509 -set_serial 1 -days 3650 -extensions v3_req -config <(cat <<EOF
req_extensions = v3_req # The extensions to add to a certificate request
distinguished_name = req_distinguished_name

[ v3_req ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always
basicConstraints = critical,CA:false
keyUsage = critical, digitalSignature, keyEncipherment

[ req_distinguished_name ]
CN = supplied

EOF) && openssl x509 -noout -text -in "$OUTDIR/$BASENAME.crt"


cat "$OUTDIR/$BASENAME.key" "$OUTDIR/$BASENAME.crt" | openssl pkcs12 -export -out "$OUTDIR/$BASENAME.p12" -passout "pass:$PASSWORD"

keytool -importcert -noprompt -trustcacerts -storepass "$PASSWORD" -storetype JKS -keystore "$OUTDIR/$BASENAME-trust.jks" -file "$OUTDIR/$BASENAME.crt" -alias "$BASENAME"
keytool -list -storetype JKS -storepass "$PASSWORD" -keystore "$OUTDIR/$BASENAME-trust.jks" -rfc
keytool -importkeystore -noprompt -srcalias 1 -srcstorepass "$PASSWORD" -srcstoretype PKCS12 -srckeystore "$OUTDIR/$BASENAME.p12" -destalias "$BASENAME" -deststoretype JKS -deststorepass "$PASSWORD" -destkeystore "$OUTDIR/$BASENAME.jks"
keytool -list -storetype JKS -storepass "$OUTDIR/$PASSWORD" -keystore "$OUTDIR/$BASENAME.jks" -rfc
