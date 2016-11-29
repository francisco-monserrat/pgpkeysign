#!/bin/bash
# 
# Sign a Keyring file , receive two arguments
#
# 1 == keyring file to sign
# 2 == file with PGP keyids (to to sign the keys))
#
# Options / comment / uncommendt
# Generate a keyring with all the signed keys
# Generate a file with each of the keyids 
# send keys to PGP keyservers
# Todo: 
# Integrate with mail.scpt to send and emaiul

FILE=$1
SIGNERFILE=$2

tmpfile=keys.txt


# Get the list of Keyids to sign

gpg < $FILE | grep ^pub |  cut -d "/" -f 2 | cut -d " " -f 1 | grep "0x" >  $tmpfile

# import the keys in our keyring 

gpg $GPGOPTIONS --import < $FILE 

# Now sign the keys in two loops (lets check that gpg-agent don't ask to much for Keys 

for signer in `cat $SIGNERFILE`; do 
	echo "Signing keys with keyid $signer" 
	gpg $GPGOPTIONS -kv $signer 
		for key in `cat $tmpfile`; do gpg $GPGOPTIONS  --yes --no-auto-check-trustdb -u $signer --sign-key $key  
         done 
done

# Now update the keys 
#for i in `cat $tmpfile`; do gpg --recv-keys $i ; done 
# and now send the keys to keyservers
#for i in `cat $tmpfile`; do gpg --send-keys $i ; done 


# Now create keyring file  
for i in `cat $tmpfile`; do gpg -a --export $i >> $i.asc   ; done

# Now create a new keyring with all the files
for i in `cat $tmpfile`; do  (cat $i.asc |  gpg --homedir .  --no-default-keyring --keyring $FILE.NEW.pgp --import ) ; done 
 
