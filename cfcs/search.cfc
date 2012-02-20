<cfcomponent displayName="Messages" hint="Methods dealing with project messages.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="search" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="comments" access="public" returnType="query" output="false"
				hint="Returns message comments.">
		<cfargument name="searchText" type="string" required="true">
		<cfargument name="projectid" type="string" required="true">
		<cfargument name="admin" type="boolean" required="true">
		<cfset var qComments = "">
		
		<cfquery name="qComments" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT c.commentID, c.itemID, c.type, c.commentText, c.stamp, m.messageID, m.title, i.issueID, i.issue,
				u.userID, u.firstName, u.lastName, u.avatar, p.projectID, p.name as projName
				FROM #variables.tableprefix#comments c 
					INNER JOIN #variables.tableprefix#projects p ON c.projectID = p.projectID
					LEFT JOIN #variables.tableprefix#messages m	ON c.itemID = m.messageID AND c.type = 'msg'  
					LEFT JOIN #variables.tableprefix#issues i ON c.itemID = i.issueID AND c.type = 'issue'
					LEFT JOIN #variables.tableprefix#users u ON c.userid = u.userid
			WHERE c.commentText like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				<cfif compare(arguments.projectid,'')>
					AND p.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				<cfelseif not arguments.admin>
					AND p.projectID IN (<cfqueryparam value="#ValueList(session.user.projects.projectID)#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
				</cfif>
			ORDER BY c.stamp desc
		</cfquery>
		<cfreturn qComments>
	</cffunction>

	<cffunction name="files" access="public" returnType="query" output="false"
				hint="Returns projects.">
		<cfargument name="searchText" type="string" required="true">
		<cfargument name="projectid" type="string" required="true">
		<cfargument name="admin" type="boolean" required="true">
		<cfset var qFiles = "">
		<cfset var datesOnly = arrayNew(1)>
	    <cfset var leftChar = arrayNew(1)>

		<cfquery name="qFiles" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT f.fileID, f.title, f.categoryID, f.description, f.filename, f.serverfilename, f.filetype,
				f.filesize,f.uploaded,f.uploadedBy,u.firstName, u.lastName, fc.category, p.projectID, 
				p.name as projName
			FROM #variables.tableprefix#files f 
				INNER JOIN #variables.tableprefix#projects p ON f.projectID = p.projectID
				LEFT JOIN #variables.tableprefix#users u ON f.uploadedBy = u.userID
				LEFT JOIN #variables.tableprefix#categories fc on f.categoryID = fc.categoryID
			WHERE fc.type = 'file' AND
				(f.title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR f.description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
				<cfif compare(arguments.projectid,'')>
					AND p.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				<cfelseif not arguments.admin>
					AND p.projectID IN (<cfqueryparam value="#ValueList(session.user.projects.projectID)#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
				</cfif>
			ORDER BY f.title asc
		  </cfquery>
		  
		  <cfloop query="qFiles">
			  <cfset datesOnly[currentRow] = LSDateFormat(uploaded)>
			  <cfset leftChar[currentRow] = left(title,1)>
		  </cfloop>
		  <cfset queryAddColumn(qFiles,"uploadDate",datesOnly)>
		  <cfset queryAddColumn(qFiles,"leftChar",leftChar)>
		  
		<cfreturn qFiles>
	</cffunction>

	<cffunction name="issues" access="public" returntype="query" output="false"
				HINT="Returns issues.">				
		<cfargument name="searchText" type="string" required="true">
		<cfargument name="projectid" type="string" required="true">
		<cfargument name="admin" type="boolean" required="true">
		<cfset var qIssues = "">
		<cfquery name="qIssues" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT issueID, i.shortID, i.issue, i.detail, i.type, i.severity, i.status, i.created, i.createdBy,	
				i.assignedTo, i.updated, i.updatedBy, p.projectID, p.name as projName
			FROM #variables.tableprefix#issues i 
				INNER JOIN #variables.tableprefix#projects p ON i.projectID = p.projectID
				LEFT JOIN #variables.tableprefix#users c ON i.createdBy = c.userID
				LEFT JOIN #variables.tableprefix#users u ON i.updatedBy = u.userID
				LEFT JOIN #variables.tableprefix#users a ON i.assignedTo = a.userID
				LEFT JOIN #variables.tableprefix#milestones m ON i.milestoneID = m.milestoneID
			WHERE (i.issue like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR i.detail like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
				<cfif compare(arguments.projectid,'')>
					AND p.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				<cfelseif not arguments.admin>
					AND p.projectID IN (<cfqueryparam value="#ValueList(session.user.projects.projectID)#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
				</cfif>
		</cfquery>		
		<cfreturn qIssues>
	</cffunction>

	<cffunction name="messages" access="public" returnType="query" output="false"
				hint="Returns messages.">
		<cfargument name="searchText" type="string" required="true">
		<cfargument name="projectid" type="string" required="true">
		<cfargument name="admin" type="boolean" required="true">
		<cfset var qMessages = "">
		<cfquery name="qMessages" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT m.messageID, m.categoryID, m.milestoneID, m.title, m.message, m.stamp, ms.name, mc.category, 
					p.projectID, p.name as projName
			FROM #variables.tableprefix#messages m 
				INNER JOIN #variables.tableprefix#projects p ON m.projectID = p.projectID
				LEFT JOIN #variables.tableprefix#categories mc ON m.categoryID = mc.categoryID
				LEFT JOIN #variables.tableprefix#milestones ms ON m.milestoneid = ms.milestoneid
			WHERE mc.type = 'msg' AND (m.title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR m.message like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
				<cfif compare(arguments.projectid,'')>
					AND p.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				<cfelseif not arguments.admin>
					AND p.projectID IN (<cfqueryparam value="#ValueList(session.user.projects.projectID)#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
				</cfif>
			ORDER BY m.stamp desc
		</cfquery>
		<cfreturn qMessages>
	</cffunction>

	<cffunction name="milestones" access="public" returnType="query" output="false"
				hint="Returns milestones.">
		<cfargument name="searchText" type="string" required="true">
		<cfargument name="projectid" type="string" required="true">
		<cfargument name="admin" type="boolean" required="true">
		<cfset var qMilestones = "">
		<cfquery name="qMilestones" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT milestoneid, m.name, m.description, dueDate, completed,
				m.forid, m.userid, u.firstName, u.lastName, p.projectID, p.name as projName
			FROM #variables.tableprefix#milestones m
				INNER JOIN #variables.tableprefix#projects p ON m.projectID = p.projectID
				LEFT JOIN #variables.tableprefix#users u ON m.forid = u.userid
			WHERE (m.name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR m.description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
				<cfif compare(arguments.projectid,'')>
					AND p.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				<cfelseif not arguments.admin>
					AND p.projectID IN (<cfqueryparam value="#ValueList(session.user.projects.projectID)#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
				</cfif>
		</cfquery>
		<cfreturn qMilestones>
	</cffunction>

	<cffunction name="projects" access="public" returntype="query" output="false"
				hint="Returns project records.">				
		<cfargument name="searchText" type="string" required="true">
		<cfargument name="admin" type="boolean" required="true">
		<cfset var qProjects = "">
		<cfquery name="qProjects" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT p.projectID, p.name, p.description
			FROM #variables.tableprefix#projects p 
				INNER JOIN #variables.tableprefix#project_users pu ON p.projectID = pu.projectID
				LEFT JOIN #variables.tableprefix#users u ON pu.userid = u.userid
				LEFT JOIN #variables.tableprefix#clients c on p.clientID = c.clientID 
			WHERE (p.name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR p.description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
				<cfif not arguments.admin>
					AND p.projectID IN (<cfqueryparam value="#ValueList(session.user.projects.projectID)#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
				</cfif>
				ORDER BY p.name
		</cfquery>		
		<cfreturn qProjects>
	</cffunction>

	<cffunction name="screenshots" access="public" returnType="query" output="false"
				hint="Returns projects.">
		<cfargument name="searchText" type="string" required="true">
		<cfargument name="projectid" type="string" required="true">
		<cfargument name="admin" type="boolean" required="true">
		<cfset var qScreenshots = "">
		<cfquery name="qScreenshots" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT s.fileID, s.issueID, s.title, s.description, s.filename, s.serverfilename, s.filetype,
				p.projectID, p.name as projName
			FROM #variables.tableprefix#screenshots s
				INNER JOIN #variables.tableprefix#issues i ON s.issueID = i.issueID
				INNER JOIN #variables.tableprefix#projects p ON i.projectID = p.projectID 
				LEFT JOIN #variables.tableprefix#users u ON s.uploadedBy = u.userID
			WHERE (s.title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR s.filename like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR s.description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
				<cfif compare(arguments.projectid,'')>
					AND p.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				<cfelseif not arguments.admin>
					AND p.projectID IN (<cfqueryparam value="#ValueList(session.user.projects.projectID)#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
				</cfif>
		</cfquery>
		<cfreturn qScreenshots>
	</cffunction>

	<cffunction name="todos" access="public" returnType="query" output="false"
				hint="Returns task list.">
		<cfargument name="searchText" type="string" required="true">
		<cfargument name="projectid" type="string" required="true">
		<cfargument name="admin" type="boolean" required="true">
		<cfset var qTodoLists = "">
		<cfquery name="qTodoLists" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT t.todoID, t.todolistID, t.task, t.userID, t.rank, t.due, t.completed, 
					tl.title, tl.description, u.firstName, u.lastName, p.projectID, p.name as projName
				FROM #variables.tableprefix#todos t 
					INNER JOIN #variables.tableprefix#projects p ON t.projectID = p.projectID
					LEFT JOIN #variables.tableprefix#todolists tl ON t.todolistID = tl.todolistID
					LEFT JOIN #variables.tableprefix#users u ON t.userID = u.userID
			WHERE (t.task like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR tl.title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR tl.description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
				<cfif compare(arguments.projectid,'')>
					AND p.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				<cfelseif not arguments.admin>
					AND p.projectID IN (<cfqueryparam value="#ValueList(session.user.projects.projectID)#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
				</cfif>
			ORDER BY tl.rank,tl.added,t.added
		</cfquery>
		<cfreturn qTodoLists>
	</cffunction>
	
</CFCOMPONENT>
