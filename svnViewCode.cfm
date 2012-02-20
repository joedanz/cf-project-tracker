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
				<span class="rightmenu"><a href="javascript:history.back();" class="back">View All Revisions</a></span>
				
				<h2 class="svn">Subversion Source Browsing</h2>
			</div>
			<div class="content">
			 	<div class="wrapper">

				<cftry>
					<cfparam name="filetype" type="string" default="string">
					<cfif listFindNoCase('png,gif,jpg,doc,rtf,xls,ppt,mdb,pdf,exe',right(url.f,3))>
						<cfset filetype = 'binary'>
					</cfif>
					<cfset svn = createObject("component", "cfcs.SVNBrowser").init(project.svnurl,project.svnuser,project.svnpass)>
					<cfset fileQ = svn.FileVersion('#url.wd#/#url.f#',url.r,filetype)>
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
							/ <a href="#cgi.script_name#?p=#url.p#&amp;wd=#buildPath#" class="nounder">#replace(replace(buildPath,prevBuildPath,''),'/','','all')#</a>
						</cfloop>
						
						</caption>
					<thead>
						<tr>
							<th>Name</th>
							<th>Size</th>
							<th>Timestamp</th>
							<th>Revision</th>
							<th>Author</th>
							<th>Download</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>#fileQ.name#</td>
							<td>#NumberFormat(fileQ.size)#</td>
							<!---<cfset dt = DateConvertISO8601(logEntries[i].date,-getTimeZoneInfo().utcHourOffset)>--->
							<td>#LSDateFormat(fileQ.date,"ddd mmm d 'yy")# @ <cfif application.settings.clockHours eq 12>#LSTimeFormat(fileQ.date,"h:mmtt")#<cfelse>#LSTimeFormat(fileQ.date,"HH:mm")#</cfif></td>
							<td>#fileQ.revision#</td>
							<td>#fileQ.author#</td>
							<td><a href="svnGetFile.cfm?p=#url.p#&amp;wd=#url.wd#&amp;f=#url.f#&amp;r=#url.r#" class="nounder"><img src="./images/files_sm.gif" height="16" width="16" border="0" alt="Download" /> Download</a></td>
						</tr>
					</table>

					<pre name="code" class="html">
						#replace(toString(fileQ.content),'<','&lt;','all')#
					</pre>
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

<link type="text/css" rel="stylesheet" href="#application.settings.mapping#/includes/dp.SyntaxHighlighter/Styles/SyntaxHighlighter.css"></link>
<script language="javascript" src="#application.settings.mapping#/includes/dp.SyntaxHighlighter/Scripts/shCore.js"></script>
<script language="javascript" src="#application.settings.mapping#/includes/dp.SyntaxHighlighter/Scripts/shBrushCSharp.js"></script>
<script language="javascript" src="#application.settings.mapping#/includes/dp.SyntaxHighlighter/Scripts/shBrushXml.js"></script>
<script language="javascript">
dp.SyntaxHighlighter.ClipboardSwf = '#application.settings.mapping#/includes/dp.SyntaxHighlighter/Scripts/clipboard.swf';
dp.SyntaxHighlighter.HighlightAll('code');
</script>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">