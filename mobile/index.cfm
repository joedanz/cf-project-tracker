<cfsetting enablecfoutputonly="true">

<cfmodule template="../tags/layout.cfm" templatename="../mobile/mobile" title="#application.settings.app_title# &raquo; Home">

<cfoutput>
 	<label for="projects">Your Projects:</label>
	<ul id="projects">
		<cfloop query="session.user.projects">
			<li><a href="project.cfm?p=#projectID#">#name#</a></li>
		</cfloop>
	</ul>   
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">