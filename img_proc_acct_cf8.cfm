	<cffile action="upload" accept="image/gif,image/jpg,image/jpeg,image/png" filefield="imagefile"
			destination = "#ExpandPath(application.settings.userFilesPath & 'avatars')#" nameConflict = "MakeUnique">
	<cfimage action="resize" height="72" width="72" overwrite="yes"
		source="#ExpandPath(application.settings.userFilesPath & 'avatars')#/#serverFile#"
		destination="#ExpandPath(application.settings.userFilesPath & 'avatars')#/#session.user.userid#_72.jpg">
	<cfimage action="resize" height="48" width="48" overwrite="yes"
		source="#ExpandPath(application.settings.userFilesPath & 'avatars')#/#serverFile#"
		destination="#ExpandPath(application.settings.userFilesPath & 'avatars')#/#session.user.userid#_48.jpg">
	<cfimage action="resize" height="24" width="24" overwrite="yes"
		source="#ExpandPath(application.settings.userFilesPath & 'avatars')#/#serverFile#"
		destination="#ExpandPath(application.settings.userFilesPath & 'avatars')#/#session.user.userid#_24.jpg">
	<cfimage action="resize" height="16" width="16" overwrite="yes"
		source="#ExpandPath(application.settings.userFilesPath & 'avatars')#/#serverFile#"
		destination="#ExpandPath(application.settings.userFilesPath & 'avatars')#/#session.user.userid#_16.jpg">
	<cffile action="delete" file="#ExpandPath(application.settings.userFilesPath & 'avatars')#/#cffile.serverFile#">
	<cfset application.user.setImage(session.user.userID,1)>
	<cfset session.user.avatar = 1>