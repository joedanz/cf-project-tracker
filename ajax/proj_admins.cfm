<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset proj_admins = application.project.projectUsers(url.p,'1')>

<cfoutput>
<cfif proj_admins.recordCount>
<div class="header"><h3>Project Admin<cfif proj_admins.recordCount gt 1>s</cfif></h3></div>
<div class="content">
	<ul>
		<cfloop query="proj_admins">
			<li>#firstName# #lastName#<cfif (project.admin or session.user.admin) and userid neq project.ownerid> <span style="font-size:.8em;">(<a href="#cgi.script_name#?p=#url.p#&mo=#userID#">make owner</a>)</span></cfif></li>
		</cfloop>
	</ul>
</div>
</cfif>
</cfoutput>

<cfsetting enablecfoutputonly="false">