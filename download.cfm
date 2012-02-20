<cfif StructKeyExists(url,"i")>
	<cfset thisFile = application.screenshot.get(url.i,url.f)>
<cfelse>
	<cfset thisFile = application.file.get(url.p,url.f)>
</cfif>	

<cfheader name="content-disposition" value="attachment; filename=#replace(thisFile.filename," ","_","ALL")#">
<cfcontent file="#application.userFilesPath##url.p#/#thisFile.serverfilename#" deletefile="no" type="application/unknown">