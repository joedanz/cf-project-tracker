<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfset issues = application.issue.get(attributes.project)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<issues><cfloop query="issues">
	<issue>
		<id>#issueid#</id>	
		<created>#LSDateFormat(DateAdd("h",application.settings.default_offset,created),"yyyy-mm-dd")#T#LSTimeFormat(DateAdd("h",application.settings.default_offset,created),"HH:mm:ss")#Z</created>
		<severity>#xmlFormat(severity)#</severity>
		<status>#xmlFormat(status)#</status>
		<type>#xmlFormat(type)#</type>
		<issue>#xmlFormat(issue)#</issue>
		<detail>#xmlFormat(detail)#</detail>
	</issue></cfloop>
</issues>
</cfoutput>

<cfsetting enablecfoutputonly="false">