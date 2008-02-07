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
			SELECT p.projectID, p.ownerID, p.clientID, p.name, p.description, p.display, p.added, 
				p.addedBy, p.status, p.ticketPrefix, p.svnurl, p.svnuser, p.svnpass, pu.admin, 
				pu.files, pu.issues, pu.msgs, pu.mstones, pu.todos, pu.svn, c.name as clientName,
				u.firstName as ownerFirstName, u.lastName as ownerLastName
			FROM #variables.tableprefix#projects p 
				INNER JOIN #variables.tableprefix#project_users pu ON p.projectID = pu.projectID
				INNER JOIN #variables.tableprefix#users u ON p.ownerID = u.userID
				LEFT JOIN #variables.tableprefix#clients c on p.clientID = c.clientID 
			WHERE 0=0
			  <cfif compare(ARGUMENTS.projectID,'')>
				  AND p.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			  </cfif>
			  <cfif compare(ARGUMENTS.userID,'')>
				  AND pu.userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
			  </cfif>
				ORDER BY p.name
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>
	
	<cffunction name="getDistinct" access="public" returntype="query" output="false"
				hint="Returns project records.">				
		<cfargument name="projectID" type="string" required="false" default="">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT p.projectID, p.ownerID, p.clientID, p.name, p.description, p.display, p.added, 
				p.addedBy, p.status, p.ticketPrefix, p.svnurl, p.svnuser, p.svnpass, c.name as clientName,
				u.firstName as ownerFirstName, u.lastName as ownerLastName
			FROM #variables.tableprefix#projects p
				INNER JOIN #variables.tableprefix#users u ON p.ownerID = u.userID
				LEFT JOIN #variables.tableprefix#clients c on p.clientID = c.clientID 
			WHERE 0=0
			  <cfif compare(ARGUMENTS.projectID,'')>
				  AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			  </cfif>
			ORDER BY p.name
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>	
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Adds a project.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="ownerID" type="uuid" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="display" type="numeric" required="true">
		<cfargument name="clientID" type="string" required="true">
		<cfargument name="status" type="string" required="true">
		<cfargument name="ticketPrefix" type="string" required="true">
		<cfargument name="svnurl" type="string" required="true">
		<cfargument name="svnuser" type="string" required="true">
		<cfargument name="svnpass" type="string" required="true">
		<cfargument name="addedBy" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#projects (projectID,ownerID,name,description,display,added,addedBy,clientID,status,ticketPrefix,svnurl,svnuser,svnpass)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.ownerID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.display#">,
					#Now()#, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addedBy#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clientID#" maxlength="35">,
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
		<cfargument name="ownerID" type="uuid" required="true">		
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="display" type="numeric" required="true">
		<cfargument name="clientID" type="string" required="true">
		<cfargument name="status" type="string" required="true">
		<cfargument name="ticketPrefix" type="string" required="true">
		<cfargument name="svnurl" type="string" required="true">
		<cfargument name="svnuser" type="string" required="true">
		<cfargument name="svnpass" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#projects 
				SET name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					ownerID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.ownerID#" maxlength="35">,
					description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
					display = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.display#">,
					clientID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clientID#" maxlength="35">,
					status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#" maxlength="8">,
					ticketPrefix = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticketPrefix#" maxlength="2">,
					svnurl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnurl#" maxlength="100">,
					svnuser = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnuser#" maxlength="20">,
					svnpass = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnpass#" maxlength="20">
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
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
			DELETE FROM #variables.tableprefix#activity WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#files WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#issues WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#messages WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#milestones WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#projects WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#project_users WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#todolists WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#todos WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
		</cfquery>
	</cffunction>
	
	
	<cffunction name="projectUsers" access="public" returntype="query" output="false"
				hint="Returns project users.">				
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="admin" type="numeric" required="false" default="0">
		<cfargument name="order_by" type="string" required="false" default="lastName, firstName">
		<cfargument name="projectIDlist" type="string" required="false" default="">
		
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT distinct u.userID, u.firstName, u.lastName, u.username, u.email, u.phone, u.mobile,
				u.lastLogin, u.email_files, u.mobile_files, u.email_issues,	u.mobile_issues, 
				u.email_msgs, u.mobile_msgs, u.email_mstones, u.mobile_mstones,	u.email_todos, 
				u.mobile_todos, u.avatar, c.prefix, c.suffix	
				<cfif not compare(arguments.projectIDlist,'')>
					, pu.admin,	pu.files, pu.issues, pu.msgs, pu.mstones, pu.todos, pu.svn
				</cfif>
			FROM #variables.tableprefix#users u 
				INNER JOIN #variables.tableprefix#project_users pu ON u.userID = pu.userID
				LEFT JOIN #variables.tableprefix#carriers c on u.carrierID = c.carrierID
			WHERE u.active = 1
			<cfif compare(arguments.projectID,'')>
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.projectIDlist,'')>
				AND projectID IN ('#replace(arguments.projectIDlist,",","','","ALL")#')
			</cfif>
			<cfif arguments.admin>AND pu.admin = 1</cfif>
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
					select userID from #variables.tableprefix#project_users where projectID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				)
			ORDER BY lastName, firstName
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>		
	
	<cffunction name="makeOwner" access="public" returntype="void" output="false"
				hint="Makes user the owner of a project.">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="userID" type="string" required="true">
		
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#projects
			SET ownerID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
			WHERE projectid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
	</cffunction>

	<cffunction name="setUserPermissions" access="public" returntype="void" output="false"
				hint="Sets permissions for a project user.">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="admin" type="string" required="true">
		<cfargument name="files" type="numeric" required="true">
		<cfargument name="issues" type="numeric" required="true">
		<cfargument name="msgs" type="numeric" required="true">
		<cfargument name="mstones" type="numeric" required="true">
		<cfargument name="todos" type="numeric" required="true">
		<cfargument name="svn" type="string" required="true">
		
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#project_users
			SET admin = <cfif isNumeric(arguments.admin)>1<cfelse>0</cfif>,
				files = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.files#" maxlength="1">,
				issues = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issues#" maxlength="1">,
				msgs = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.msgs#" maxlength="1">,
				mstones = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mstones#" maxlength="1">,
				todos = <cfif isNumeric(arguments.todos)>1<cfelse>0</cfif>
			WHERE projectid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35"> 
		</cfquery>
	</cffunction>
	
</CFCOMPONENT>
