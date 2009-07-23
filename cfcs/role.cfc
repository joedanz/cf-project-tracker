<cfcomponent displayName="Project Users" hint="Methods dealing with project users.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">
	
	<cffunction name="init" access="public" returntype="role" output="false"
				HINT="Returns an instance of the CFC initialized with the correct DSN & table prefix.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" returntype="query" output="false"
				HINT="Returns user role.">				
		<cfargument name="userID" type="string" required="false" default="">	
		<cfargument name="projectID" type="string" required="false" default="">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT admin, file_view, file_edit, file_comment, issue_view, issue_edit, issue_assign, issue_resolve, 
					issue_close, issue_comment, msg_view, msg_edit, msg_comment, mstone_view, mstone_edit, 
					mstone_comment, todolist_view, todolist_edit, todo_edit, todo_comment, time_view, 
					time_edit, bill_view, bill_edit, bill_rates, bill_invoices, bill_markpaid, report, svn
			FROM #variables.tableprefix#project_users
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Sets user role.">
		<cfargument name="projectID" type="uuid" required="true">		
		<cfargument name="userID" type="uuid" required="true">
		<cfargument name="admin" type="string" required="false" default="0">
		<cfargument name="file_view" type="numeric" required="false" default="0">
		<cfargument name="file_edit" type="numeric" required="false" default="0">
		<cfargument name="file_comment" type="numeric" required="false" default="0">
		<cfargument name="issue_view" type="numeric" required="false" default="0">
		<cfargument name="issue_edit" type="numeric" required="false" default="0">
		<cfargument name="issue_assign" type="numeric" required="false" default="0">
		<cfargument name="issue_resolve" type="numeric" required="false" default="0">
		<cfargument name="issue_close" type="numeric" required="false" default="0">
		<cfargument name="issue_comment" type="numeric" required="false" default="0">
		<cfargument name="msg_view" type="numeric" required="false" default="0">
		<cfargument name="msg_edit" type="numeric" required="false" default="0">
		<cfargument name="msg_comment" type="numeric" required="false" default="0">
		<cfargument name="mstone_view" type="numeric" required="false" default="0">
		<cfargument name="mstone_edit" type="numeric" required="false" default="0">
		<cfargument name="mstone_comment" type="numeric" required="false" default="0">
		<cfargument name="todolist_view" type="numeric" required="false" default="0">
		<cfargument name="todolist_edit" type="numeric" required="false" default="0">
		<cfargument name="todo_edit" type="numeric" required="false" default="0">
		<cfargument name="todo_comment" type="numeric" required="false" default="0">
		<cfargument name="time_view" type="numeric" required="false" default="0">
		<cfargument name="time_edit" type="numeric" required="false" default="0">
		<cfargument name="bill_view" type="string" required="false" default="0">
		<cfargument name="bill_edit" type="string" required="false" default="0">
		<cfargument name="bill_rates" type="string" required="false" default="0">
		<cfargument name="bill_invoices" type="string" required="false" default="0">
		<cfargument name="bill_markpaid" type="string" required="false" default="0">
		<cfargument name="report" type="string" required="false" default="0">
		<cfargument name="svn" type="string" required="false" default="0">
		<cfif isNumeric(arguments.admin) and arguments.admin>
			<cfset arguments.file_view = 1>
			<cfset arguments.file_edit = 1>
			<cfset arguments.file_comment = 1>
			<cfset arguments.issue_view = 1>
			<cfset arguments.issue_edit = 1>
			<cfset arguments.issue_assign = 1>
			<cfset arguments.issue_resolve = 1>
			<cfset arguments.issue_close = 1>
			<cfset arguments.issue_comment = 1>
			<cfset arguments.msg_view = 1>
			<cfset arguments.msg_edit = 1>
			<cfset arguments.msg_comment = 1>
			<cfset arguments.mstone_view = 1>
			<cfset arguments.mstone_edit = 1>
			<cfset arguments.mstone_comment = 1>
			<cfset arguments.todolist_view = 1>
			<cfset arguments.todolist_edit = 1>
			<cfset arguments.todo_edit = 1>
			<cfset arguments.todo_comment = 1>
			<cfset arguments.time_view = 1>
			<cfset arguments.time_edit = 1>
			<cfset arguments.bill_view = 1>
			<cfset arguments.bill_edit = 1>
			<cfset arguments.bill_rates = 1>
			<cfset arguments.bill_invoices = 1>
			<cfset arguments.bill_markpaid = 1>
			<cfset arguments.report = 1>
			<cfset arguments.svn = 1>
		</cfif>
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#project_users (projectID, userID, admin, file_view, file_edit, 
				file_comment, issue_view, issue_edit, issue_assign, issue_resolve, issue_close, issue_comment, 
				msg_view, msg_edit, msg_comment, mstone_view, mstone_edit, mstone_comment, todolist_view, 
				todolist_edit, todo_edit, todo_comment, time_view, time_edit, bill_view, bill_edit, 
				bill_rates, bill_invoices, bill_markpaid, report, svn)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#IIF(isNumeric(arguments.admin),arguments.admin,'0')#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.file_view#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.file_edit#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.file_comment#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issue_view#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issue_edit#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issue_assign#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issue_resolve#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issue_close#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issue_comment#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.msg_view#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.msg_edit#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.msg_comment#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mstone_view#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mstone_edit#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mstone_comment#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.todolist_view#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.todolist_edit#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.todo_edit#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.todo_comment#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.time_view#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.time_edit#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.bill_view#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.bill_edit#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.bill_rates#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.bill_invoices#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.bill_markpaid#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.report#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#IIF(isNumeric(arguments.svn),arguments.svn,'0')#">)
		</cfquery>
		<cfreturn true>
	</cffunction>
		
	<cffunction name="remove" access="public" returnType="boolean" output="false"
				hint="Removes user role.">
		<cfargument name="projectID" type="string" required="false" default="">		
		<cfargument name="userID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#project_users
			WHERE 0=0
				<cfif compare(arguments.projectID,'')>
					AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				</cfif>
				AND userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
</cfcomponent>
