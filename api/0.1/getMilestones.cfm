<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset mstones = application.milestone.get(attributes.project)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<milestones><cfloop query="mstones">
	<milestone>
		<id>#milestoneid#</id>	
		<name>#xmlFormat(name)#</name>
		<description>#xmlFormat(description)#</description>
		<dueDate>#DateFormat(dueDate,"yyyy-mm-dd")#T#TimeFormat(dueDate,"HH:mm:ss")#Z</dueDate>
	</milestone></cfloop>
</milestones>
</cfoutput>

<cfsetting enablecfoutputonly="false">