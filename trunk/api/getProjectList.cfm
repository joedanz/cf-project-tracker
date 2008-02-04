<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset projects = application.project.getDistinct()>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<projects><cfloop query="projects">
	<project>
		<id>#projectid#</id>	
		<name>#name#</name>
		<status>#status#</status>
	</project></cfloop>
</projects>
</cfoutput>

<cfsetting enablecfoutputonly="false">