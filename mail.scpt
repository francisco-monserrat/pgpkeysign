#!/usr/bin/osascript
--
-- AppleScript Automation to send an email with text and attachment
--
-- Args:
-- to : Email address to send the mail
-- subject: Subject of the email
-- text : file with text to add as body
-- attachment : Attachment file 
-- 
--  text & attachment should be complete unix paths
-- ./mail.applescript francisco.monserrat@rediris.es 'prueba de correo' ./texto.txt ./0x09E2CD4944E6CBCD.asc
-- 2016-11-29 16:43:17.137 osascript[47348:1397243] CFURLGetFSRef was passed an URL which has no scheme (the URL will not work with other CFURL routines)
-- 2016-11-29 16:43:17.141 osascript[47348:1397243] CFURLGetFSRef was passed an URL which has no scheme (the URL will not work with other CFURL routines)
-- ./mail.applescript francisco.monserrat@rediris.es 'prueba de correo' `pwd`/texto.txt `pwd`/0x09E2CD4944E6CBCD.asc
-- Preparing to send mail
--Recipient address francisco.monserrat@rediris.es
-- Subject: prueba de correo
-- Text message :/Users/paco/programas/firma-keyring/texto.txt
-- Attachment: /Users/paco/programas/firma-keyring/0x09E2CD4944E6CBCD.as

-- Read a file 
on readFile(unixPath)
	set foo to (open for access (POSIX file unixPath))
	set txt to (read foo for (get eof foo))
	close access foo
	return txt
end readFile


on run arguments 

  set theAddress   to first item of arguments
  set theSubject  to second item of arguments
  set filename  to item 3 of arguments 
  set attach to item 4 of arguments
  set autosend to item 5 of arguments

  log "Preparing to send mail "
  log "Recipient address " & theAddress 
  log "Subject: "& theSubject
  log "Text message :" & filename
  log "Attachment: " & attach
  log "autosend is :" & autosend

  set theContent to readFile(filename)

tell application "Mail"

  

 set theSignatureName to "blank"-- the signature name , blank is my default

     set theAttachmentFile to  (POSIX file attach) as string 
#    set theAttachmentFile to "Macintosh HD:Users:paco:programas:firma-keyring:0x5A68A1E251DCBDAE.asc" 
 
    set msg to make new outgoing message with properties {subject: theSubject, content: theContent, visible:true}

	tell msg to make new to recipient at end of every to recipient with properties {address:theAddress}
	tell msg to make new attachment with properties {file name:theAttachmentFile as alias}

	set message signature of msg to signature theSignatureName

   if (autosend = "yes") then 
        delay 2
	log "Sending the message"
	send msg
   end if  

end tell

end run
