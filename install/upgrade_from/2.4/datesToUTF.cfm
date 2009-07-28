<cfsetting requesttimeout="300">

<cfquery name="getActivity" datasource="#application.settings.dsn#">
	SELECT activityID, stamp FROM #application.settings.tableprefix#activity
	ORDER BY stamp DESC
</cfquery>
<cfloop query="getActivity">
	<cfquery datasource="#application.settings.dsn#">
		UPDATE #application.settings.tableprefix#activity
		SET stamp = #DateConvert("local2utc",stamp)#
		WHERE activityID = '#activityID#'
	</cfquery>
</cfloop>
ACTIVITY RECORDS CONVERTED...<br />

<cfquery name="getComments" datasource="#application.settings.dsn#">
	SELECT commentID, stamp FROM #application.settings.tableprefix#comments
	ORDER BY stamp DESC
</cfquery>
<cfloop query="getComments">
	<cfquery datasource="#application.settings.dsn#">
		UPDATE #application.settings.tableprefix#comments
		SET stamp = #DateConvert("local2utc",stamp)#
		WHERE commentID = '#commentID#'
	</cfquery>
</cfloop>
COMMENT RECORDS CONVERTED...<br />

<cfquery name="getFiles" datasource="#application.settings.dsn#">
	SELECT fileID, uploaded FROM #application.settings.tableprefix#files
	ORDER BY uploaded DESC
</cfquery>
<cfloop query="getFiles">
	<cfquery datasource="#application.settings.dsn#">
		UPDATE #application.settings.tableprefix#files
		SET uploaded = #DateConvert("local2utc",uploaded)#
		WHERE fileID = '#fileID#'
	</cfquery>
</cfloop>
FILE RECORDS CONVERTED...<br />

<cfquery name="getIssues" datasource="#application.settings.dsn#">
	SELECT issueID, created FROM #application.settings.tableprefix#issues
	ORDER BY created DESC
</cfquery>
<cfloop query="getIssues">
	<cfquery datasource="#application.settings.dsn#">
		UPDATE #application.settings.tableprefix#issues
		SET created = #DateConvert("local2utc",created)#
		WHERE issueID = '#issueID#'
	</cfquery>
</cfloop>
ISSUE RECORDS CONVERTED...<br />

<cfquery name="getMessages" datasource="#application.settings.dsn#">
	SELECT messageID, stamp FROM #application.settings.tableprefix#messages
	ORDER BY stamp DESC
</cfquery>
<cfloop query="getMessages">
	<cfquery datasource="#application.settings.dsn#">
		UPDATE #application.settings.tableprefix#messages
		SET stamp = #DateConvert("local2utc",stamp)#
		WHERE messageID = '#messageID#'
	</cfquery>
</cfloop>
MESSAGE RECORDS CONVERTED...<br />

<cfquery name="getMilestones" datasource="#application.settings.dsn#">
	SELECT milestoneID, completed FROM #application.settings.tableprefix#milestones
	ORDER BY completed DESC
</cfquery>
<cfloop query="getMilestones">
	<cfif isDate(completed)>
		<cfquery datasource="#application.settings.dsn#">
			UPDATE #application.settings.tableprefix#milestones
			SET completed = #DateConvert("local2utc",completed)#
			WHERE milestoneID = '#milestoneID#'
		</cfquery>
	</cfif>
</cfloop>
MILESTONE RECORDS CONVERTED...<br />

<cfquery name="getProjects" datasource="#application.settings.dsn#">
	SELECT projectID, added FROM #application.settings.tableprefix#projects
	ORDER BY added DESC
</cfquery>
<cfloop query="getProjects">
	<cfquery datasource="#application.settings.dsn#">
		UPDATE #application.settings.tableprefix#projects
		SET added = #DateConvert("local2utc",added)#
		WHERE projectID = '#projectID#'
	</cfquery>
</cfloop>
PROJECT RECORDS CONVERTED...<br />

<cfquery name="getScreenshots" datasource="#application.settings.dsn#">
	SELECT fileID, uploaded FROM #application.settings.tableprefix#screenshots
	ORDER BY uploaded DESC
</cfquery>
<cfloop query="getScreenshots">
	<cfquery datasource="#application.settings.dsn#">
		UPDATE #application.settings.tableprefix#screenshots
		SET uploaded = #DateConvert("local2utc",uploaded)#
		WHERE fileID = '#fileID#'
	</cfquery>
</cfloop>
SCREENSHOT RECORDS CONVERTED...<br />

<cfquery name="getTodos" datasource="#application.settings.dsn#">
	SELECT todoID, added, completed FROM #application.settings.tableprefix#todos
	ORDER BY added DESC
</cfquery>
<cfloop query="getTodos">
	<cfquery datasource="#application.settings.dsn#">
		UPDATE #application.settings.tableprefix#todos
		SET added = #DateConvert("local2utc",added)#
		WHERE todoID = '#todoID#'
	</cfquery>
	<cfif isDate(completed)>
		<cfquery datasource="#application.settings.dsn#">
			UPDATE #application.settings.tableprefix#todos
			SET completed = #DateConvert("local2utc",completed)#
			WHERE todoID = '#todoID#'
		</cfquery>	
	</cfif>
</cfloop>
TODO RECORDS CONVERTED...<br />

<cfquery name="getTodolists" datasource="#application.settings.dsn#">
	SELECT todolistID, added FROM #application.settings.tableprefix#todolists
	ORDER BY added DESC
</cfquery>
<cfloop query="getTodolists">
	<cfquery datasource="#application.settings.dsn#">
		UPDATE #application.settings.tableprefix#todolists
		SET added = #DateConvert("local2utc",added)#
		WHERE todolistID = '#todolistID#'
	</cfquery>
</cfloop>
TODOLIST RECORDS CONVERTED...<br />

<cfquery name="getUsers" datasource="#application.settings.dsn#">
	SELECT userID, lastLogin FROM #application.settings.tableprefix#users
	ORDER BY lastLogin DESC
</cfquery>
<cfloop query="getUsers">
	<cfif isDate(lastLogin)>
		<cfquery datasource="#application.settings.dsn#">
			UPDATE #application.settings.tableprefix#users
			SET lastLogin = #DateConvert("local2utc",lastLogin)#
			WHERE userID = '#userID#'
		</cfquery>
	</cfif>
</cfloop>
USER RECORDS CONVERTED...<br />