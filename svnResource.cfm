<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif not StructKeyExists(url,'p')>
	<cfoutput><h2>No Project Selected!</h2></cfoutput><cfabort>
</cfif>

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfif not session.user.admin and not project.svn eq 1>
	<cfoutput><h2>You do not have permission to access the repository!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfset project = application.project.get(session.user.userid,url.p)>
<cfset numFiles = 0>
<cfset totalFileSize = 0>
<cfset Diffable="cfc,cfm,cfml,txt,plx,php,php4,php5,asp,aspx,xml,html,htm,sql,css,js">

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; #project.name#" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text='<link rel="stylesheet" href="./css/svn.css" media="screen,projection" type="text/css" />'>

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left full">
		<div class="main">

			<div class="header">
				<span class="rightmenu"><a href="svnBrowse.cfm?p=#url.p#&wd=#url.wd#" class="back">Back to Repository Browsing</a></span>
				
				<h2 class="svn">Subversion source browsing</h2>
			</div>
			<div class="content">
			 	<div class="wrapper">

				<cftry>
					<cfset svn = createObject("component", "cfcs.SVNBrowser").init(project.svnurl,project.svnuser,project.svnpass)>
					<cfset fileList = svn.History('#url.wd#/#url.f#')>
					<cfset buildPath = "/">
					<cfset listCount = listLen(url.wd, "/")>
					<cfset loopCount = 0>
					
					<table class="svn full">
					<caption>#project.name#: <a href="svnBrowse.cfm?p=#url.p#" class="nounder">root</a>
					<cfloop list="#url.wd#" delimiters="/" index="i">
						<cfset loopCount = loopCount + 1>
						<cfset prevBuildPath = buildPath>
						<cfif listCount NEQ loopCount>
							<cfset buildPath = buildPath & i & "/">
						<cfelse>
							<cfset buildPath = buildPath & i>
						</cfif>
						/ <a href="svnBrowse.cfm?p=#url.p#&wd=#buildPath#" class="nounder">#replace(replace(buildPath,prevBuildPath,''),'/','','all')#</a>
					</cfloop>
					
					</caption>
					<thead>
						<tr>
							<th>Name</th>
							<th>Date Modified</th>
							<th class="tac">Revision</th>
							<th class="tac">View</th>
							<th class="tac">D/L</th>
							<th class="tac">Diff With Last</th>
							<th>Author</th>
							<th>Message</th>
						</tr>
					</thead>					
					<tbody>
					
					<cfloop query="fileList">
						<cfset fileExt = right(name,len(name)-find('.',name))>
						<tr class="<cfif numFiles mod 2 eq 0>odd<cfelse>even</cfif>">
							<td>
							<cfif listFindNoCase('cfm,cfc',fileExt)>
								<a href="svnViewCode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#" class="nounder"><img src="images/file_cf.gif" height="16" width="16" border="0" alt="ColdFusion File" />
							<cfelseif listFindNoCase('.htm,html',fileExt)>
								<a href="svnViewCode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#" class="nounder"><img src="images/file_htm.gif" height="16" width="16" border="0" alt="HTML File" />
							<cfelseif not compareNoCase(fileExt,'js')>
								<a href="svnViewCode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#" class="nounder"><img src="images/file.gif" height="16" width="16" border="0" alt="Javascript File" />
							<cfelseif not compareNoCase(fileExt,'css')>
								<a href="svnViewCode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#" class="nounder"><img src="images/file.gif" height="16" width="16" border="0" alt="CSS File" />
							<cfelseif listFindNoCase('png,jpg,gif,exe,pdf,doc,rtf,xls,ppt',fileExt)>
								<a href="svnGetFile.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#" class="nounder"><img src="images/file.gif" height="16" width="16" border="0" alt="File" />
							<cfelse>
								<a href="svnViewCode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#" class="nounder"><img src="images/file.gif" height="16" width="16" border="0" alt="File" />
							</cfif>
							#name#</a></td>
							<!---<cfset dt = request.udf.DateConvertISO8601(date,-getTimeZoneInfo().utcHourOffset)>--->
							<td>#LSDateFormat(date,"mm-dd-yyyy")# @ <cfif application.settings.clockHours eq 12>#LSTimeFormat(date,"hh:mm:ss tt")#<cfelse>#LSTimeFormat(date,"HH:mm:ss")#</cfif></td>
							<td class="tac">#NumberFormat(revision)#</td>
							
							
							
							<td class="tac"><a href="svnViewCode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#"><img src="./images/zoom.gif" height="16" width="16" border="0" alt="View" /></a></td>
							<td class="tac"><a href="svnGetFile.cfm?p=#url.p#&wd=#url.wd#&f=#name#&r=#revision#"><img src="./images/files_sm.gif" height="16" width="16" border="0" alt="Download" /></td>
							<td class="tac"><cfif currentRow neq recordCount><a href="svnDiff.cfm?p=#url.p#&wd=#url.wd#&f=#URLEncodedFormat(name)#&r1=#revision[currentRow+1]#&r2=#revision#">Perform Diff</a><cfelse>&nbsp;</cfif></td>
							<td>#author#</td>
							<td>#message#</td>
						</tr>						
						<cfset numFiles = numFiles + 1>		
					</cfloop>
					
					</tbody>
					</table>


					<cfcatch>
						<div class="alert">There was a problem accessing the Subversion repository at #project.svnurl#</div>
						<div class="fs80 g" style="margin-left:20px;">If your repository requires authentication, please ensure that your username and password are correct.</div>
					</cfcatch>
				</cftry>			

			 	</div>
			</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">

	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">