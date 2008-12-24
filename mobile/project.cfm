<cfsetting enablecfoutputonly="true">

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>

<cfmodule template="../tags/layout.cfm" templatename="../mobile/mobile" title="#project.name# &raquo; Overview" project="#project.name#" projectid="#url.p#">

<cfoutput>

</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">