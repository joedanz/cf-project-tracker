<cfcomponent displayName="pp_projects" HINT="">

	<CFSET variables.dsn = "">
	<CFSET variables.tableprefix = "">
	
	<CFFUNCTION NAME="init" ACCESS="public" RETURNTYPE="project" OUTPUT="false"
				HINT="Returns an instance of the CFC initialized with the correct DSN & table prefix.">
		<CFARGUMENT NAME="settings" TYPE="struct" REQUIRED="true" HINT="Settings">

		<CFSET variables.dsn = arguments.settings.dsn>
		<CFSET variables.tableprefix = arguments.settings.tableprefix>
		
		<CFRETURN this>
	</CFFUNCTION>
	
	<CFFUNCTION NAME="get" ACCESS="public" RETURNTYPE="query" OUTPUT="false"
				HINT="Returns project records.">				
		<CFARGUMENT NAME="userID" TYPE="string" REQUIRED="false" DEFAULT="">
		<CFARGUMENT NAME="projectID" TYPE="string" REQUIRED="false" DEFAULT="">
		<CFSET var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT p.projectID, p.name, p.description, p.display, p.added, p.addedBy, p.status, 
				p.ticketPrefix, p.svnurl, p.svnuser, p.svnpass
			FROM #variables.tableprefix#projects p INNER JOIN #variables.tableprefix#project_users pu
			 ON p.projectID = pu.projectID
			WHERE 0=0
			  <cfif compare(ARGUMENTS.projectID,'')>
				  AND p.projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
			  </cfif>
			  <cfif compare(ARGUMENTS.userID,'')>
				  AND pu.userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">
			  </cfif>
				ORDER BY name
		</cfquery>		
		<CFRETURN qRecords>
	</CFFUNCTION>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Adds a project.">
		<cfargument name="projectID" type="uuid" required="true">		
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="display" type="numeric" required="true">
		<cfargument name="status" type="string" required="true">
		<cfargument name="ticketPrefix" type="string" required="true">
		<cfargument name="svnurl" type="string" required="true">
		<cfargument name="svnuser" type="string" required="true">
		<cfargument name="svnpass" type="string" required="true">
		<cfargument name="addedBy" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#projects (projectID,name,description,display,added,addedBy,status,ticketPrefix,svnurl,svnuser,svnpass)
			VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#" maxlength="1000">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.display#">,
					#Now()#, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addedBy#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#" maxlength="8">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticketPrefix#" maxlength="2">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnurl#" maxlength="100">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnuser#" maxlength="20">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnpass#" maxlength="20">)
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a project.">
		<cfargument name="projectID" type="uuid" required="true">		
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="display" type="numeric" required="true">
		<cfargument name="status" type="string" required="true">
		<cfargument name="ticketPrefix" type="string" required="true">
		<cfargument name="svnurl" type="string" required="true">
		<cfargument name="svnuser" type="string" required="true">
		<cfargument name="svnpass" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#projects 
				SET name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#" maxlength="1000">,
					display = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.display#">,
					status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#" maxlength="8">,
					ticketPrefix = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticketPrefix#" maxlength="2">,
					svnurl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnurl#" maxlength="100">,
					svnuser = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnuser#" maxlength="20">,
					svnpass = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnpass#" maxlength="20">
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
	
	<CFFUNCTION NAME="delete" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Deletes a project record.">
		<CFARGUMENT NAME="projectID" TYPE="string" REQUIRED="true">
		
		<!--- delete physical files --->
		<cfset var qFiles = application.file.get(arguments.projectid)>
		<cfloop query="qFiles">
		
		</cfloop>
		
		<!--- delete database records --->
		<CFQUERY DATASOURCE="#variables.dsn#">
			DELETE FROM #variables.tableprefix#files WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#">;
			DELETE FROM #variables.tableprefix#issues WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#">;
			DELETE FROM #variables.tableprefix#messages WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#">;
			DELETE FROM #variables.tableprefix#milestones WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#">;
			DELETE FROM #variables.tableprefix#projects WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#">;
			DELETE FROM #variables.tableprefix#project_users WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#">;
			DELETE FROM #variables.tableprefix#tags WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#">;
			DELETE FROM #variables.tableprefix#todolists WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#">;
			DELETE FROM #variables.tableprefix#todos WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#">;
		</cfquery>
	</CFFUNCTION>
	
	
	<CFFUNCTION NAME="projectUsers" ACCESS="public" RETURNTYPE="query" OUTPUT="false"
				HINT="Returns project users.">				
		<CFARGUMENT NAME="projectID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="role" TYPE="string" REQUIRED="false" default="">
		<CFARGUMENT NAME="order_by" TYPE="string" REQUIRED="false" default="lastName, firstName">
		<CFSET var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT u.userID, u.firstName, u.lastName, u.akoID, u.email, u.phone, u.lastLogin, u.avatar, u.admin, pu.role
			FROM #variables.tableprefix#users u 
				INNER JOIN #variables.tableprefix#project_users pu ON u.userID = pu.userID
			WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#" MAXLENGTH="35">
			<cfif compare(arguments.role,'')>AND pu.role = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.role#" MAXLENGTH="5"></cfif>
			ORDER BY #arguments.order_by#
		</cfquery>		
		<CFRETURN qRecords>
	</CFFUNCTION>	
	
	<CFFUNCTION NAME="nonProjectUsers" ACCESS="public" RETURNTYPE="query" OUTPUT="false"
				HINT="Returns project users.">				
		<CFARGUMENT NAME="projectID" TYPE="string" REQUIRED="true">
		<CFSET var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT userID, firstName, lastName
			FROM #variables.tableprefix#users 
				WHERE userID NOT IN (
					select userID from #variables.tableprefix#project_users where projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#" MAXLENGTH="35">
				)
			ORDER BY lastName, firstName
		</cfquery>		
		<CFRETURN qRecords>
	</CFFUNCTION>		
	
</CFCOMPONENT>
