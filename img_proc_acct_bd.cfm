	<cffile action="upload" accept="image/gif,image/jpg,image/jpeg" filefield="imagefile"
			destination = "#ExpandPath('./images/avatars')#" nameConflict = "MakeUnique">
	<cfimage height="72" width="72" nameconflict="overwrite"
		srcfile="#ExpandPath('./images/avatars')#/#serverFile#"
		destfile="#ExpandPath('./images/avatars')#/#session.user.userid#_72.jpg">
	<cfimage height="48" width="48" nameconflict="overwrite"
		srcfile="#ExpandPath('./images/avatars')#/#serverFile#"
		destfile="#ExpandPath('./images/avatars')#/#session.user.userid#_48.jpg">
	<cfimage height="24" width="24" nameconflict="overwrite"
		srcfile="#ExpandPath('./images/avatars')#/#serverFile#"
		destfile="#ExpandPath('./images/avatars')#/#session.user.userid#_24.jpg">
	<cfimage height="16" width="16" nameconflict="overwrite"
		srcfile="#ExpandPath('./images/avatars')#/#serverFile#"
		destfile="#ExpandPath('./images/avatars')#/#session.user.userid#_16.jpg">
	<cffile action="delete" file="#ExpandPath('./images/avatars')#/#serverFile#">
	<cfset application.user.setImage(session.user.userID,1)>
