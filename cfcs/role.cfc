<cfcomponent displayName="pp_project_users" HINT="">

	<CFSET variables.dsn = "">
	<CFSET variables.tableprefix = "">
	
	<CFFUNCTION NAME="init" ACCESS="public" RETURNTYPE="role" OUTPUT="false"
				HINT="Returns an instance of the CFC initialized with the correct DSN & table prefix.">
		<CFARGUMENT NAME="settings" TYPE="struct" REQUIRED="true" HINT="Settings">

		<CFSET variables.dsn = arguments.settings.dsn>
		<CFSET variables.tableprefix = arguments.settings.tableprefix>

		<CFRETURN this>
	</CFFUNCTION>
	
	<CFFUNCTION NAME="get" ACCESS="public" RETURNTYPE="query" OUTPUT="false"
				HINT="Returns user role.">				
		<CFARGUMENT NAME="userID" TYPE="string" REQUIRED="false" DEFAULT="">	
		<CFARGUMENT NAME="projectID" TYPE="string" REQUIRED="false" DEFAULT="">
		<CFSET var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT role
			FROM #variables.tableprefix#project_users
			WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#" MAXLENGTH="35">
				AND userID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.userID#" MAXLENGTH="35">
		</cfquery>		
		<CFRETURN qRecords>
	</CFFUNCTION>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Sets user role.">
		<cfargument name="projectID" type="uuid" required="true">		
		<cfargument name="userID" type="uuid" required="true">
		<cfargument name="roles" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#project_users (projectID,userID,role)
			VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.roles#">)
		</cfquery>
		<cfreturn true>
	</cffunction>
		
	<cffunction name="remove" access="public" returnType="boolean" output="false"
				hint="Removes user role.">
		<cfargument name="projectID" type="uuid" required="true">		
		<cfargument name="userID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#project_users
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
				AND userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
</CFCOMPONENT>
