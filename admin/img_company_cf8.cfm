	<cfif compare(application.settings.company_logo,'')>
		<cftry>
			<cffile action="delete" file="#ExpandPath('.' & application.settings.userFilesPath)#/#application.settings.company_logo#">
			<cfcatch></cfcatch>
		</cftry>
	</cfif>
	<cffile action="upload" accept="image/gif,image/jpg,image/jpeg,image/png" filefield="imagefile"
			destination = "#ExpandPath('.' & application.settings.userFilesPath)#" nameConflict = "MakeUnique">
	<cffile action="read" file="#ExpandPath('.' & application.settings.userFilesPath)#/#cffile.serverFile#" variable="imgfile">
	<cfset application.config.saveCompanyLogo(cffile.serverFile)>
	<cfset application.settings.company_logo = cffile.serverFile>