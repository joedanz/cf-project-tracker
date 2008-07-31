<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset todolists = application.todolist.get(attributes.project)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<todo-lists><cfloop query="todolists">
	<todo-list>
		<id>#todolistid#</id>
		<title>#xmlFormat(title)#</title>
		<description>#xmlFormat(description)#</description>
		<completed_count>#NumberFormat(completed_count)#</completed_count>
		<uncompleted_count>#NumberFormat(uncompleted_count)#</uncompleted_count>
	</todo-list></cfloop>
</todo-lists>
</cfoutput>

<cfsetting enablecfoutputonly="false">