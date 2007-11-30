<cfcomponent displayName="Projects" hint="Methods dealing with projects.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">
	
	<cffunction name="init" access="public" returntype="project" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN & table prefix.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" returntype="query" output="false"
				hint="Returns project records.">				
		<cfargument name="userID" type="string" required="false" default="">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT p.projectID, p.name, p.description, p.display, p.added, p.addedBy, p.status, 
				p.ticketPrefix, p.svnurl, p.svnuser, p.svnpass, pu.role
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
		<cfreturn qRecords>
	</cffunction>
	
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
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
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
					description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
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
	
	<cffunction name="delete" access="public" returntype="void" output="false"
				hint="Deletes a project record.">
		<cfargument name="projectID" type="string" required="true">
		
		<!--- delete physical files --->
		<cfset var qFiles = application.file.get(arguments.projectid)>
		<cfloop query="qFiles">
			<cfset application.file.delete(arguments.projectid,fileID,uploadedBy)>
		</cfloop>
		
		<!--- delete database records --->
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#activity WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#">;
			DELETE FROM #variables.tableprefix#files WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#">;
			DELETE FROM #variables.tableprefix#issues WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#">;
			DELETE FROM #variables.tableprefix#messages WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#">;
			DELETE FROM #variables.tableprefix#milestones WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#">;
			DELETE FROM #variables.tableprefix#projects WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#">;
			DELETE FROM #variables.tableprefix#project_users WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#">;
			DELETE FROM #variables.tableprefix#todolists WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#">;
			DELETE FROM #variables.tableprefix#todos WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#">;
		</cfquery>
	</cffunction>
	
	
	<cffunction name="projectUsers" access="public" returntype="query" output="false"
				hint="Returns project users.">				
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="role" type="string" required="false" default="">
		<cfargument name="order_by" type="string" required="false" default="lastName, firstName">
		<cfargument name="projectIDlist" type="string" required="false" default="">
		
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT distinct u.userID, u.firstName, u.lastName, u.username, u.email, u.phone, u.lastLogin, u.avatar, u.admin, pu.role
			FROM #variables.tableprefix#users u 
				INNER JOIN #variables.tableprefix#project_users pu ON u.userID = pu.userID
			WHERE active = 1
			<cfif compare(arguments.projectID,'')>
				AND projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.projectIDlist,'')>
				AND projectID IN ('#replace(arguments.projectIDlist,",","','","ALL")#')
			</cfif>
			<cfif compare(arguments.role,'')>AND pu.role = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role#" maxlength="5"></cfif>
			ORDER BY #arguments.order_by#
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>	
	
	<cffunction name="nonProjectUsers" access="public" returntype="query" output="false"
				hint="Returns project users.">				
		<cfargument name="projectID" type="string" required="true">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT userID, firstName, lastName
			FROM #variables.tableprefix#users 
			WHERE active = 1
				AND userID NOT IN (
					select userID from #variables.tableprefix#project_users where projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
				)
			ORDER BY lastName, firstName
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>		
	
</CFCOMPONENT>
