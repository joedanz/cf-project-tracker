<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfset mstones = application.milestone.get(attributes.project)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<milestones><cfloop query="mstones">
	<milestone>
		<id>#milestoneid#</id>	
		<name>#xmlFormat(name)#</name>
		<description>#xmlFormat(description)#</description>
		<dueDate>#LSDateFormat(dueDate,"yyyy-mm-dd")#T#LSTimeFormat(dueDate,"HH:mm:ss")#Z</dueDate>
	</milestone></cfloop>
</milestones>
</cfoutput>

<cfsetting enablecfoutputonly="false">