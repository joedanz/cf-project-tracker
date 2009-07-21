<cfsetting enablecfoutputonly="true">

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfif not session.user.admin and not project.svn eq 1>
	<cfoutput><h2>You do not have permission to access the repository!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfparam name="url.act" default="browse">
<cfparam name="numRevisions" default="20">
<cfparam name="url.p" default="">
<cfparam name="url.wd" default="">
<cfset numDirs = 0>
<cfset numFiles = 0>
<cfset totalFileSize = 0>
<cfset project = application.project.get(session.user.userid,url.p)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; #project.name#" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left full">
		<div class="main">

			<div class="header">
				
				<span class="rightmenu">
					<span class="b g">Browse Repository</span> | 
					<a href="svnLog.cfm?p=#url.p#">Last #numrevisions# Revisions</a>
				</span>
				
				<h2 class="svn">Subversion source browsing</h2>
			</div>
			<div class="content">
			 	<div class="wrapper">

					<!--- browse repository --->
					<cftry>
						<cfset svn = createObject("component", "cfcs.SVNBrowser").init(project.svnurl,project.svnuser,project.svnpass)>
						<cfset list = svn.list('/' & url.wd)>
						<cfset buildPath = "/">
						<cfset listCount = listLen(url.wd, "/")>
						<cfset loopCount = 0>
						
						<table class="svn full">
						<caption>#project.name#: <a href="#cgi.script_name#?p=#url.p#" class="nounder">root</a>
						<cfloop list="#url.wd#" delimiters="/" index="i">
							<cfset loopCount = loopCount + 1>
							<cfset prevBuildPath = buildPath>
							<cfif listCount NEQ loopCount>
								<cfset buildPath = buildPath & i & "/">
							<cfelse>
								<cfset buildPath = buildPath & i>
							</cfif>
							/ <a href="#cgi.script_name#?p=#url.p#&wd=#buildPath#" class="nounder">#replace(replace(buildPath,prevBuildPath,''),'/','','all')#</a>
						</cfloop>
						
						</caption>
						<thead>
							<tr>
								<th>Name</th>
								<th>Size</th>
								<th>Date Modified</th>
								<th class="tac">Revision</th>
								<th>Author</th>
							</tr>
						</thead>
						<tbody>
						<cfset thisrow = 0>
						<cfif compare(url.wd,'')>
							<cfset lastdirmarker = request.udf.RFind('/',url.wd)>
							<cfif lastdirmarker lte 1><cfset pd = ""><cfelse><cfset pd = left(url.wd,lastdirmarker-1)></cfif>
							<tr class="odd">
								<td>
								<img src="images/folder.gif" height="16" width="16" border="0" alt="Directory" />
								<a href="#cgi.script_name#?p=#url.p#&act=browse&wd=#URLEncodedFormat(pd)#" class="nounder">..</a></td>
								<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
							</tr>
						<cfset thisrow = thisrow + 1>			
						</cfif>
						<cfloop query="list">
					
							<cfif not compareNoCase(kind,'Dir')>
							<tr class="<cfif thisRow mod 2 eq 0>odd<cfelse>even</cfif>">
								<td>
								<a href="#cgi.script_name#?p=#url.p#&act=browse&wd=#URLEncodedFormat(url.wd & '/' & name)#" class="nounder">
								<img src="images/folder.gif" height="16" width="16" border="0" alt="Directory" />
								#name#</a></td>
								<td>-----</td>
								<!---<cfset dt = request.udf.DateConvertISO8601(list.date,-getTimeZoneInfo().utcHourOffset)>--->
								<td>#DateFormat(date,"mm-dd-yyyy")# @ <cfif application.settings.clockHours eq 12>#TimeFormat(date,"hh:mm:ss tt")#<cfelse>#TimeFormat(date,"HH:mm:ss")#</cfif></td>
								<td class="tac">#NumberFormat(revision)#</td>
								<td>#author#</td>
							</tr>
							<cfset thisrow = thisrow + 1>
							<cfset numDirs = numDirs + 1>
							</cfif>
						</cfloop>
						<cfloop query="list">
							<cfif not compareNoCase(kind,'File')>
							
							<tr class="<cfif thisRow mod 2 eq 0>odd<cfelse>even</cfif>">
								<td>
									<a href="svnResource.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#" class="nounder">
								<cfif listFindNoCase('.cfm,.cfc',right(name,4))>
									<img src="images/file_cf.gif" height="16" width="16" border="0" alt="ColdFusion File" />
								<cfelseif listFindNoCase('.htm,html',right(name,4))>
									<img src="images/file_htm.gif" height="16" width="16" border="0" alt="HTML File" />
								<cfelseif not compareNoCase(right(name,3),'.js')>
									<img src="images/file.gif" height="16" width="16" border="0" alt="Javascript File" />
								<cfelseif not compareNoCase(right(name,4),'.css')>
									<img src="images/file.gif" height="16" width="16" border="0" alt="CSS File" />
								<cfelseif listFindNoCase('png,jpg,gif,exe,pdf,doc,rtf,xls,ppt',right(name,3))>
									<img src="images/file.gif" height="16" width="16" border="0" alt="File" />
								<cfelse>
									<img src="images/file.gif" height="16" width="16" border="0" alt="File" />
								</cfif>
								#name#</a></td>
								<td>#NumberFormat(size)# bytes</td>
								<!---<cfset dt = request.udf.DateConvertISO8601(date,-getTimeZoneInfo().utcHourOffset)>--->
								<td>#DateFormat(date,"mm-dd-yyyy")# @ <cfif application.settings.clockHours eq 12>#TimeFormat(date,"hh:mm:ss tt")#<cfelse>#TimeFormat(date,"HH:mm:ss")#</cfif></td>
								<td class="tac">#NumberFormat(revision)#</td>
								<td>#author#</td>
							</tr>
							<cfset thisrow = thisrow + 1>
							<cfset numFiles = numFiles + 1>
							<cfset totalFileSize = totalFileSize + size>
							</cfif>
						
						</cfloop>	
						</tbody>
						<tfoot><tr><td colspan="5">#NumberFormat(totalFileSize)# bytes in <cfif numFiles gt 0>#numFiles# files</cfif><cfif numFiles gt 0 and numDirs gt 0> and </cfif><cfif numDirs gt 0> #numDirs# directories</cfif>.</tr></tfoot>
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