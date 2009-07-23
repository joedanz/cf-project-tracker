<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfset todos = application.todo.get(attributes.project,attributes.todolist)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<todos><cfloop query="todos">
	<todo>
		<id>#todoid#</id>
		<task>#xmlFormat(task)#</task>
		<position>#rank#</position>
		<completed><cfif isDate(completed)>#LSDateFormat(DateAdd("h",application.settings.default_offset,completed),"yyyy-mm-dd")#T#LSTimeFormat(DateAdd("h",application.settings.default_offset,completed),"HH:mm:ss")#Z</cfif></completed>
		<due><cfif isDate(due)>#LSDateFormat(due,"yyyy-mm-dd")#T#LSTimeFormat(due,"HH:mm:ss")#Z</cfif></due>
	</todo></cfloop>
</todos>
</cfoutput>

<cfsetting enablecfoutputonly="false">