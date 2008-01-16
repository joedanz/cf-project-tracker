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
			SELECT role
			FROM #variables.tableprefix#project_users
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
				AND userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Sets user role.">
		<cfargument name="projectID" type="uuid" required="true">		
		<cfargument name="userID" type="uuid" required="true">
		<cfargument name="roles" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#project_users (projectID,userID,role)
			VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.roles#" maxlength="9">)
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
					AND projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
				</cfif>
				AND userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
</cfcomponent>
