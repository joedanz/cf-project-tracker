<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset issues = application.issue.get(attributes.project)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<issues><cfloop query="issues">
	<issue>
		<id>#issueid#</id>	
		<created>#DateFormat(created,"yyyy-mm-dd")#T#TimeFormat(created,"HH:mm:ss")#Z</created>
		<severity>#severity#</severity>
		<status>#status#</status>
		<type>#type#</type>
		<issue>#issue#</issue>
		<detail>#detail#</detail>
	</issue></cfloop>
</issues>
</cfoutput>

<cfsetting enablecfoutputonly="false">