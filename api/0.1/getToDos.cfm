<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset todos = application.todo.get(attributes.project,attributes.todolist)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<todos><cfloop query="todos">
	<todo>
		<id>#todoid#</id>
		<task>#xmlFormat(task)#</task>
		<position>#rank#</position>
		<completed><cfif isDate(completed)>#DateFormat(DateAdd("h",application.settings.default_offset,completed),"yyyy-mm-dd")#T#TimeFormat(DateAdd("h",application.settings.default_offset,completed),"HH:mm:ss")#Z</cfif></completed>
		<due><cfif isDate(due)>#DateFormat(due,"yyyy-mm-dd")#T#TimeFormat(due,"HH:mm:ss")#Z</cfif></due>
	</todo></cfloop>
</todos>
</cfoutput>

<cfsetting enablecfoutputonly="false">