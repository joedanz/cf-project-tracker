<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

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

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left full">
		<div class="main">

			<div class="header">
				<span class="rightmenu"><a href="javascript:history.back();" class="back">Back to Repository Browsing</a></span>
				
				<h2 class="svn">Subversion source browsing</h2>
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
						<cffile action="write" file="#expandpath('./')##url.f#" output="#fileQ.content#">
						<cfheader name="content-disposition" value="attachment; filename=#url.f#">
						<cfcontent file="#expandpath('./')##url.f#" deletefile="yes" type="application/unknown">
						<cfabort>
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