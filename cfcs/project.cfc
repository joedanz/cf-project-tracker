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
				p.addedBy, p.status, p.ticketPrefix, p.svnurl, p.svnuser, p.svnpass,
				p.tab_files, p.tab_issues, p.tab_msgs, p.tab_mstones,p.tab_todos, p.tab_time, p.tab_svn,
				<cfif compare(arguments.userID,'')> 
					pu.admin, pu.files, pu.issues, pu.msgs, pu.mstones, pu.todos, pu.timetrack, pu.svn,
				<cfelse>
					1 as admin, 2 as files, 2 as issues, 2 as msgs, 2 as mstones, 2 as todos, 
					2 as timetrack, 1 as svn,
				</cfif> 
				c.name as clientName, u.firstName as ownerFirstName, u.lastName as ownerLastName
			FROM #variables.tableprefix#projects p 
				<cfif compare(arguments.userID,'')>
					INNER JOIN #variables.tableprefix#project_users pu ON p.projectID = pu.projectID
				</cfif>
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
		<cfargument name="allowReg" type="boolean" required="false" default="false">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT p.projectID, p.ownerID, p.clientID, p.name, p.description, p.display, p.added, 
				p.addedBy, p.status, p.ticketPrefix, p.svnurl, p.svnuser, p.svnpass, p.allow_reg, 
				p.reg_active, p.reg_files, p.reg_issues, p.reg_msgs, p.reg_mstones, p.reg_todos, 
				p.reg_time, p.reg_svn, p.tab_files, p.tab_issues, p.tab_msgs, p.tab_mstones, 
				p.tab_todos, p.tab_time, p.tab_svn, c.name as clientName, 
				u.firstName as ownerFirstName, u.lastName as ownerLastName
			FROM #variables.tableprefix#projects p
				INNER JOIN #variables.tableprefix#users u ON p.ownerID = u.userID
				LEFT JOIN #variables.tableprefix#clients c on p.clientID = c.clientID 
			WHERE 0=0
			  <cfif compare(ARGUMENTS.projectID,'')>
				  AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			  </cfif>
			  <cfif ARGUMENTS.allowReg>
				  AND allow_reg = 1
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
		<cfargument name="allow_reg" type="numeric" required="true">
		<cfargument name="reg_active" type="numeric" required="true">
		<cfargument name="reg_files" type="numeric" required="true">
		<cfargument name="reg_issues" type="numeric" required="true">
		<cfargument name="reg_msgs" type="numeric" required="true">
		<cfargument name="reg_mstones" type="numeric" required="true">
		<cfargument name="reg_todos" type="numeric" required="true">
		<cfargument name="reg_time" type="numeric" required="true">
		<cfargument name="reg_svn" type="numeric" required="true">
		<cfargument name="tab_files" type="numeric" required="true">
		<cfargument name="tab_issues" type="numeric" required="true">
		<cfargument name="tab_msgs" type="numeric" required="true">
		<cfargument name="tab_mstones" type="numeric" required="true">
		<cfargument name="tab_todos" type="numeric" required="true">
		<cfargument name="tab_time" type="numeric" required="true">
		<cfargument name="tab_svn" type="numeric" required="true">
		<cfargument name="addedBy" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#projects (projectID,ownerID,name,description,display,added,addedBy,clientID,status,ticketPrefix,svnurl,svnuser,svnpass,allow_reg,reg_active,reg_files,reg_issues,reg_msgs,reg_mstones,reg_todos,reg_time,reg_svn,tab_files,tab_issues,tab_msgs,tab_mstones,tab_todos,tab_time,tab_svn)
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
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnpass#" maxlength="20">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.allow_reg#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_active#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_files#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issues#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_msgs#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_mstones#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_todos#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_time#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_svn#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_files#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_issues#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_msgs#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_mstones#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_todos#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_time#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_svn#" maxlength="1">)
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
		<cfargument name="allow_reg" type="numeric" required="true">
		<cfargument name="reg_active" type="numeric" required="true">
		<cfargument name="reg_files" type="numeric" required="true">
		<cfargument name="reg_issues" type="numeric" required="true">
		<cfargument name="reg_msgs" type="numeric" required="true">
		<cfargument name="reg_mstones" type="numeric" required="true">
		<cfargument name="reg_todos" type="numeric" required="true">
		<cfargument name="reg_time" type="numeric" required="true">
		<cfargument name="reg_svn" type="numeric" required="true">
		<cfargument name="tab_files" type="numeric" required="true">
		<cfargument name="tab_issues" type="numeric" required="true">
		<cfargument name="tab_msgs" type="numeric" required="true">
		<cfargument name="tab_mstones" type="numeric" required="true">
		<cfargument name="tab_todos" type="numeric" required="true">
		<cfargument name="tab_time" type="numeric" required="true">
		<cfargument name="tab_svn" type="numeric" required="true">
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
					svnpass = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnpass#" maxlength="20">,
					allow_reg = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.allow_reg#" maxlength="1">,
					reg_active = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_active#" maxlength="1">,
					reg_files = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_files#" maxlength="1">,
					reg_issues = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issues#" maxlength="1">,
					reg_msgs = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_msgs#" maxlength="1">,
					reg_mstones = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_mstones#" maxlength="1">,
					reg_todos = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_todos#" maxlength="1">,
					reg_time = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_time#" maxlength="1">,
					reg_svn = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_svn#" maxlength="1">,
					tab_files = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_files#" maxlength="1">,
					tab_issues = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_issues#" maxlength="1">,
					tab_msgs = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_msgs#" maxlength="1">,
					tab_mstones = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_mstones#" maxlength="1">,
					tab_todos = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_todos#" maxlength="1">,
					tab_time = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_time#" maxlength="1">,
					tab_svn = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_svn#" maxlength="1">
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
		<cftransaction>
			<cfquery datasource="#variables.dsn#">
				DELETE FROM #variables.tableprefix#activity 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#">
				DELETE FROM #variables.tableprefix#files 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#">
				DELETE FROM #variables.tableprefix#issues 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#">
				DELETE FROM #variables.tableprefix#messages 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#">
				DELETE FROM #variables.tableprefix#milestones 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#">
				DELETE FROM #variables.tableprefix#projects 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#">
				DELETE FROM #variables.tableprefix#project_components 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#">
				DELETE FROM #variables.tableprefix#project_users 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#">
				DELETE FROM #variables.tableprefix#project_versions 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#">
				DELETE FROM #variables.tableprefix#todolists 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#">
				DELETE FROM #variables.tableprefix#todos 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
		</cftransaction>
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
					, pu.admin,	pu.files, pu.issues, pu.msgs, pu.mstones, pu.todos, pu.timetrack, pu.svn
				</cfif>
			FROM #variables.tableprefix#users u 
				INNER JOIN #variables.tableprefix#project_users pu ON u.userID = pu.userID
				LEFT JOIN #variables.tableprefix#carriers c on u.carrierID = c.carrierID
			WHERE u.active = 1
			<cfif compare(arguments.projectID,'')>
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.projectIDlist,'')>
				AND projectID IN (<cfqueryparam value="#arguments.projectIDlist#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
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
		<cfargument name="timetrack" type="numeric" required="true">
		<cfargument name="svn" type="string" required="true">
		
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#project_users
			SET admin = <cfif isNumeric(arguments.admin)>1<cfelse>0</cfif>,
				files = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.files#" maxlength="1">,
				issues = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issues#" maxlength="1">,
				msgs = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.msgs#" maxlength="1">,
				mstones = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mstones#" maxlength="1">,
				todos = <cfif isNumeric(arguments.todos)><cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.todos#" maxlength="1"><cfelse>0</cfif>,
				timetrack = <cfif isNumeric(arguments.timetrack)><cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.timetrack#" maxlength="1"><cfelse>0</cfif>,
				svn = <cfif isNumeric(arguments.svn) and arguments.svn eq 1>1<cfelse>0</cfif>
			WHERE projectid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35"> 
		</cfquery>
	</cffunction>

	<cffunction name="component" access="public" returntype="query" output="false"
				HINT="Returns project component records.">
		<cfargument name="projectID" type="string" required="true">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT c.componentID, c.component, count(i.issueID) as numIssues
			FROM #variables.tableprefix#project_components c LEFT JOIN #variables.tableprefix#issues i
				ON c.componentID = i.componentID
			WHERE c.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			GROUP BY c.componentID, c.component
			ORDER BY component
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>

	<cffunction name="addProjectItem" access="public" returnType="string" output="false"
				hint="Adds a project item.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="item" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfset var newID = createUUID()>
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#project_#arguments.type#s (projectID,#arguments.type#ID,#arguments.type#)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					'#newID#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.item#" maxlength="50">)
		</cfquery>
		<cfreturn newID>
	</cffunction>

	<cffunction name="updateProjectItem" access="public" returnType="boolean" output="false"
				hint="Updates a project item.">
		<cfargument name="itemID" type="string" required="true">
		<cfargument name="item" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#project_#arguments.type#s
			SET	#arguments.type# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.item#" maxlength="50">
			WHERE #arguments.type#ID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.itemID#" maxlength="35">  
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="deleteProjectItem" access="public" returnType="boolean" output="false"
				hint="Deletes a project item.">
		<cfargument name="itemID" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#project_#arguments.type#s
			WHERE #arguments.type#ID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.itemID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="version" access="public" returntype="query" output="false"
				HINT="Returns project version records.">
		<cfargument name="projectID" type="string" required="true">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT v.versionID, v.version, count(i.issueID) as numIssues
			FROM #variables.tableprefix#project_versions v LEFT JOIN #variables.tableprefix#issues i
				ON v.versionID = i.versionID
			WHERE v.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			GROUP BY v.versionID, v.version
			ORDER BY version
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>

</CFCOMPONENT>
