<cfcomponent displayName="Project Users" hint="Methods dealing with project users.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">
	
	<cffunction name="init" access="public" returntype="role" output="false"
				HINT="Returns an instance of the CFC initialized with the correct DSN & table prefix.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" returntype="query" output="false"
				HINT="Returns user role.">				
		<cfargument name="userID" type="string" required="false" default="">	
		<cfargument name="projectID" type="string" required="false" default="">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT admin,files,issues,msgs,mstones,todos,timetrack,billing,svn
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
		<cfargument name="admin" type="string" required="true">
		<cfargument name="files" type="numeric" required="true">
		<cfargument name="issues" type="numeric" required="true">
		<cfargument name="msgs" type="numeric" required="true">
		<cfargument name="mstones" type="numeric" required="true">
		<cfargument name="todos" type="numeric" required="true">
		<cfargument name="timetrack" type="numeric" required="true">
		<cfargument name="billing" type="string" required="true">
		<cfargument name="svn" type="string" required="true">
		<cfif isNumeric(arguments.admin) and arguments.admin>
			<cfset arguments.files = 2>
			<cfset arguments.issues = 2>
			<cfset arguments.msgs = 2>
			<cfset arguments.mstones = 2>
			<cfset arguments.todos = 2>
			<cfset arguments.timetrack = 2>
			<cfset arguments.billing = 2>
			<cfset arguments.svn = 1>
		</cfif>
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#project_users (projectID,userID,admin,files,issues,msgs,mstones,todos,timetrack,billing,svn)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#IIF(isNumeric(arguments.admin),arguments.admin,'0')#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.files#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issues#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.msgs#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mstones#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.todos#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.timetrack#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.billing#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#IIF(isNumeric(arguments.svn),arguments.svn,'0')#">)
		</cfquery>
		<cfreturn true>
	</cffunction>
		
	<cffunction name="remove" access="public" returnType="boolean" output="false"
				hint="Removes user role.">
		<cfargument name="projectID" type="string" required="false" default="">		
		<cfargument name="userID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
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
