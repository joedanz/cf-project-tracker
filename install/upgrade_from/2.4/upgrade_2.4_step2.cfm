<!---
	THIS SCRIPT SHOULD BE RUN AFTER THE OTHER UPGRADE SCRIPT FOR YOUR DATABASE PLATFORM.
	TAKES CARE OF CREATING USER NOTIFICATIONS PER PROJECT.
--->

<cfsetting showdebugoutput="true">

<!--- get all users --->
<cfquery name="getUsers" datasource="#application.settings.dsn#">
	select * from #application.settings.tableprefix#users
</cfquery>

<!--- insert per project notifications --->
<cfloop query="getUsers">
	<cfscript>
		this_email_files = email_files;
		this_mobile_files = mobile_files;
		this_email_issues = email_issues;
		this_mobile_issues = mobile_issues;
		this_email_msgs = email_msgs;
		this_mobile_msgs = mobile_msgs;
		this_email_mstones = email_mstones;
		this_mobile_mstones = mobile_mstones;
		this_email_todos = email_todos;
		this_mobile_todos = mobile_todos;
	</cfscript>
	<cfquery name="userProjects" datasource="#application.settings.dsn#">
		select * from #application.settings.tableprefix#project_users 
		where userid = <cfqueryparam cfsqltype="cf_sql_char" value="#userID#" maxlength="35"> 
	</cfquery>
	<cfloop query="userProjects">
		<cfquery datasource="#application.settings.dsn#">
			insert into #application.settings.tableprefix#user_notify (userID, projectID, email_files, 
				mobile_files, email_issues, mobile_issues, email_msgs, mobile_msgs, email_mstones, 
				mobile_mstones, email_todos, mobile_todos) 
			values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#userID#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#projectID#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this_email_files#">,
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this_mobile_files#">,						
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this_email_issues#">,
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this_mobile_issues#">,
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this_email_msgs#">,
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this_mobile_msgs#">,
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this_email_mstones#">,
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this_mobile_mstones#">,
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this_email_todos#">,
				<cfqueryparam cfsqltype="cf_sql_tinyint" value="#this_mobile_todos#">
				)
		</cfquery>
	</cfloop>
</cfloop>

<!--- REMOVE OLD COLUMNS FROM PROJECT_USERS TABLE --->
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#users DROP COLUMN email_files
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#users DROP COLUMN mobile_files
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#users DROP COLUMN email_issues
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#users DROP COLUMN mobile_issues
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#users DROP COLUMN email_msgs
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#users DROP COLUMN mobile_msgs
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#users DROP COLUMN email_mstones
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#users DROP COLUMN mobile_mstones
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#users DROP COLUMN email_todos
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#users DROP COLUMN mobile_todos
</cfquery>
