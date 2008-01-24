<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset proj_admins = application.project.projectUsers(url.p,'1')>

<cfoutput>
<cfif proj_admins.recordCount>
<div class="header"><h3>Project Admin<cfif proj_admins.recordCount gt 1>s</cfif></h3></div>
<div class="content">
	<ul>
		<cfloop query="proj_admins">
			<li>#lastName#, #firstName#</li>
		</cfloop>
	</ul>
</div>
</cfif>
</cfoutput>

<cfsetting enablecfoutputonly="false">