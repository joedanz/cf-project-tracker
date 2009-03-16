<cfsetting enablecfoutputonly="true">

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfif not session.user.admin and project.svn eq 0>
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
					<a href="svnBrowse.cfm?p=#url.p#">Browse Repository</a> | 
					<span class="b g">Last #numrevisions# Revisions</span>
				</span>
				
				<h2 class="svn">Subversion source browsing</h2>
			</div>
			<div class="content">
			 	<div class="wrapper">
	
					<!--- show last N revisions --->
					<cftry>
						<cfset svn = createObject("component", "cfcs.SVNBrowser").init(project.svnurl,project.svnuser,project.svnpass)>
						<cfset log = svn.getLog(numEntries=numRevisions)>
						
						<table class="svn full">
						<caption>#project.name# - Last 20 Revisions</caption>
						<thead>
							<tr>
								<th>Rev</th>
								<th>Message</th>
								<th>Timestamp</th>
								<th>Author</th>
								<th class="tac">Changed</th>
							</tr>
						</thead>
						<tbody>
						<cfloop query="log">
							<tr class="<cfif currentRow mod 2 eq 1>odd<cfelse>even</cfif>"<!---<cfif StructKeyExists(url,"r") and url.r is revision> style="background-color:##ffc;"</cfif>--->>
								
								<td>#revision#</td>
								<td><div id="r#revision#view">&nbsp;#message#</div></td>
								<!---<cfset dt = request.udf.DateConvertISO8601(logEntries[i].date,-getTimeZoneInfo().utcHourOffset)>--->
								<td>#DateFormat(date,"ddd mmm d 'yy")# @ <cfif application.settings.clockHours eq 12>#TimeFormat(date,"h:mmtt")#<cfelse>#TimeFormat(date,"HH:mm")#</cfif></td>
								<td>#author#</td>
								
								<td class="tac"><a href="##" onclick="$('##files#currentRow#').toggle();return false;" class="nounder">#StructCount(path)# files</a></td>
							</tr>
							
							<tr class="files" style="display:none;" id="files#currentRow#"><td colspan="5" style="padding-left:50px;background-color:##ffc;">
							<cfset thisRow = 1>
							<cfloop collection="#path#" item="resource">
							<cfset filebreaker = request.udf.RFind('/',resource)>
								#thisRow#: <cfif filebreaker gt 1 and find('.',resource)><a href="svnResource.cfm?p=#url.p#&wd=#URLEncodedFormat(left(resource,filebreaker-1))#&f=#right(resource,len(resource)-filebreaker)#" class="nounder">#resource#</a><cfelse>#resource#</cfif><br />
								<cfset thisRow = thisRow + 1>
							</cfloop>
							</td></tr>
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