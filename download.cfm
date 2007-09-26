<cfset thisFile = application.file.get(url.p,url.f)>
<cfheader name="content-disposition" value="attachment; filename=#replace(thisFile.filename," ","_","ALL")#">
<cfcontent file="#expandpath('./')#userfiles\#url.p#\#thisFile.serverfilename#" deletefile="no" type="application/unknown">