#!/bin/sh
# This script will create a .sh file an place it accordingly so that certbot runs it after a successful certifiate renewal, then will convert
# to a .pfx file and install in app base location.

echo "What is the Let's Encrypt domain for the cert?"
read KEY_DOMAIN

echo "What should be certificate password be? (press enter for none)"
read PFX_PASSWORD

# Write the .sh file
/bin/cat <<EOM >/etc/letsencrypt/renewal-hooks/deploy/convert_PKCS12.sh
#!/bin/sh
sudo openssl pkcs12 -export -out "/etc/dns/$KEY_DOMAIN.pfx" -inkey /etc/letsencrypt/live/$KEY_DOMAIN/privkey.pem -in /etc/letsencrypt/live/$KEY_DOMAIN/cert.pem -certfile /etc/letsencrypt/live/$KEY_DOMAIN/chain.pem -passout pass:$PFX_PASSWORD
echo "PKCS12 file written to /etc/dns/$KEY_DOMAIN.pfx"
EOM

# Make script executable.
sudo chmod +x /etc/letsencrypt/renewal-hooks/deploy/convert_PKCS12.sh

# Run the script manually for the first time to generate the initial .pfx file
sudo /etc/letsencrypt/renewal-hooks/deploy/convert_PKCS12.sh
