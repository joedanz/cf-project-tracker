<!---
	THIS SCRIPT SHOULD BE RUN AFTER THE OTHER UPGRADE SCRIPT FOR YOUR DATABASE PLATFORM.
	TAKES CARE OF CREATING USER NOTIFICATIONS PER PROJECT.
--->

<cfsetting showdebugoutput="true">

<!--- GET ALL USERS --->
<cfquery name="getUsers" datasource="#application.settings.dsn#">
	select * from #application.settings.tableprefix#users
</cfquery>

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
	<!--- INSERT PER PROJECT PERMISSIONS --->
	<cfloop query="userProjects">
		<cfif files gt 0>
			<cfquery datasource="#application.settings.dsn#">
				UPDATE #application.settings.tableprefix#project_users
					SET file_view = 1
				<cfif files gt 1>
					, file_edit = 1
				</cfif>
				where userid = <cfqueryparam cfsqltype="cf_sql_char" value="#userID#" maxlength="35">
			</cfquery>
		</cfif>
		<cfif issues gt 0>
			<cfquery datasource="#application.settings.dsn#">
				UPDATE #application.settings.tableprefix#project_users
					SET issue_view = 1
				<cfif issues gt 1>
					, issue_edit = 1
					, issue_accept = 1
					, issue_comment = 1
				</cfif>
				where userid = <cfqueryparam cfsqltype="cf_sql_char" value="#userID#" maxlength="35">
			</cfquery>	
		</cfif>
		<cfif msgs gt 0>
			<cfquery datasource="#application.settings.dsn#">
				UPDATE #application.settings.tableprefix#project_users
					SET msg_view = 1
				<cfif msgs gt 1>
					, msg_edit = 1
					, msg_comment = 1
				</cfif>
				where userid = <cfqueryparam cfsqltype="cf_sql_char" value="#userID#" maxlength="35">
			</cfquery>	
		</cfif>
		<cfif mstones gt 0>
			<cfquery datasource="#application.settings.dsn#">
				UPDATE #application.settings.tableprefix#project_users
					SET mstone_view = 1
				<cfif mstones gt 1>
					, mstone_edit = 1
					, mstone_comment = 1
				</cfif>
				where userid = <cfqueryparam cfsqltype="cf_sql_char" value="#userID#" maxlength="35">
			</cfquery>	
		</cfif>
		<cfif todos gt 0>
			<cfquery datasource="#application.settings.dsn#">
				UPDATE #application.settings.tableprefix#project_users
					SET todolist_view = 1
				<cfif todos gt 1>
					, todolist_edit = 1
					, todo_edit = 1
					, todo_comment = 1
				</cfif>
				where userid = <cfqueryparam cfsqltype="cf_sql_char" value="#userID#" maxlength="35">
			</cfquery>	
		</cfif>
		<cfif timetrack gt 0>
			<cfquery datasource="#application.settings.dsn#">
				UPDATE #application.settings.tableprefix#project_users
					SET time_view = 1
				<cfif timetrack gt 1>
					, time_edit = 1
				</cfif>
				where userid = <cfqueryparam cfsqltype="cf_sql_char" value="#userID#" maxlength="35">
			</cfquery>	
		</cfif>
		<cfif billing gt 0>
			<cfquery datasource="#application.settings.dsn#">
				UPDATE #application.settings.tableprefix#project_users
					SET bill_view = 1
				<cfif billing gt 1>
					, bill_edit = 1
					, bill_rates = 1
					, bill_invoices = 1
					, bill_markpaid = 1
				</cfif>
				where userid = <cfqueryparam cfsqltype="cf_sql_char" value="#userID#" maxlength="35">
			</cfquery>	
		</cfif>

		<!--- INSERT PER PROJECT NOTIFICATIONS --->
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
	ALTER TABLE #application.settings.tableprefix#project_users DROP COLUMN files
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#project_users DROP COLUMN issues
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#project_users DROP COLUMN msgs
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#project_users DROP COLUMN mstones
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#project_users DROP COLUMN todos
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#project_users DROP COLUMN timetrack
</cfquery>

<!--- REMOVE OLD COLUMNS FROM USERS TABLE --->
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


<!--- GET ALL PROJECTS --->
<cfquery name="getProjects" datasource="#application.settings.dsn#">
	select * from #application.settings.tableprefix#projects
</cfquery>

<!--- MODIFY PROJECT PERMISSION DEFAULTS --->
<cfloop query="getProjects">
	<cfquery datasource="#application.settings.dsn#">
		UPDATE #application.settings.tableprefix#projects
			SET reg_bill_view = 0, reg_bill_edit = 0, reg_bill_rates = 0, 
			reg_bill_invoices = 0, reg_bill_markpaid = 0,
			reg_file_view = <cfif reg_files gte 1>1<cfelse>0</cfif>,
			reg_file_edit = <cfif reg_files eq 2>1<cfelse>0</cfif>,
			reg_issue_view = <cfif reg_issues gte 1>1<cfelse>0</cfif>,
			<cfif reg_issues eq 2>
				reg_issue_edit = 1, reg_issue_accept = 1, reg_issue_comment = 1,
			<cfelse>
				reg_issue_edit = 0, reg_issue_accept = 0, reg_issue_comment = 0,
			</cfif>
			reg_msg_view = <cfif reg_msgs gte 1>1<cfelse>0</cfif>,
			<cfif reg_msgs eq 2>
				reg_msg_edit = 1, reg_msg_comment = 1,
			<cfelse>
				reg_msg_edit = 0, reg_msg_comment = 0,
			</cfif>
			reg_mstone_view = <cfif reg_mstones gte 1>1<cfelse>0</cfif>,
			<cfif reg_mstones eq 2>
				reg_mstone_edit = 1, reg_mstone_comment = 1,
			<cfelse>
				reg_mstone_edit = 0, reg_mstone_comment = 0,
			</cfif>
			reg_todolist_view = <cfif reg_todos gte 1>1<cfelse>0</cfif>,
			<cfif reg_todos eq 2>
				reg_todolist_edit = 1, reg_todo_edit = 1, reg_todo_comment = 1,
			<cfelse>
				reg_todolist_edit = 0, reg_todo_edit = 0, reg_todo_comment = 0,
			</cfif>
			reg_time_view = <cfif reg_time gte 1>1<cfelse>0</cfif>,
			reg_time_edit = <cfif reg_time eq 2>1<cfelse>0</cfif>
		WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#projectID#" maxlength="35">
	</cfquery>
</cfloop>

<!--- REMOVE OLD COLUMNS FROM PROJECTS TABLE --->
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#projects DROP COLUMN reg_files
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#projects DROP COLUMN reg_issues
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#projects DROP COLUMN reg_msgs
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#projects DROP COLUMN reg_mstones
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#projects DROP COLUMN reg_todos
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#projects DROP COLUMN reg_time
</cfquery>


<!--- MOVE AVATARS DIRECTORY TO USERFILES --->
<cftry>
	<cfdirectory action="create" directory="#ExpandPath('../../../userfiles/')#avatars">
	<cfcatch></cfcatch>
</cftry>

<!--- GET CURRENT AVATAR FILES --->
<cfdirectory action="list" directory="#ExpandPath('../../../images/')#avatars" name="avatars">

<!--- MOVE CURRENT AVATAR FILES --->
<cfloop query="avatars">
	<cfif compareNoCase(name,'.svn')>
		<cffile action="move" source="#ExpandPath('../../../images/')#avatars/#name#" destination="#ExpandPath('../../../userfiles/')#avatars">
	</cfif>
</cfloop>

<!--- DELETE OLD AVATAR DIRECTORY --->
<cftry>
	<cfdirectory action="delete" directory="#ExpandPath('../../../images/')#avatars">
	<cfcatch></cfcatch>
</cftry>