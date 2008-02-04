<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<!--- API Version 0.1 --->

<!--- Ensure that API is enabled --->
<cfif not application.settings.enable_api>
<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<projecttracker>
	<error>
		<type>API</type>
		<message>API Not Enabled.</message>
	</error>
</projecttracker>
</cfoutput>
<cfabort>
</cfif>

<!--- Verify API Key --->
<cfif compareNoCase(url.key,application.settings.api_key)>
<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<projecttracker>
	<error>
		<type>API</type>
		<message>Invalid API Key.</message>
	</error>
</projecttracker>
</cfoutput>
<cfabort>
</cfif>

<cfif StructKeyExists(url,'comments')>
	<cf_getComments project="#url.p#" message="#url.m#">
<cfelseif StructKeyExists(url,'files')>
	<cf_getFiles project="#url.p#">
<cfelseif StructKeyExists(url,'issues')>
	<cf_getIssues project="#url.p#">
<cfelseif StructKeyExists(url,'messageArchive')>
	<cf_getMessages project="#url.p#">
<cfelseif StructKeyExists(url,'mstones')>
	<cf_getMilestones project="#url.p#">
<cfelseif StructKeyExists(url,'projects')>
	<cf_getProjectList>
<cfelseif StructKeyExists(url,'todolists')>
	<cf_getToDoLists project="#url.p#">
<cfelseif StructKeyExists(url,'todos')>
	<cf_getToDos project="#url.p#" todolist="#url.t#">	
</cfif>

<cfsetting enablecfoutputonly="false">