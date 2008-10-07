<cfcomponent displayName="Messages" hint="Methods dealing with project messages.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="search" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="comments" access="public" returnType="query" output="false"
				hint="Returns message comments.">
		<cfargument name="searchText" type="string" required="true">
		<cfset var qComments = "">
		
		<cfquery name="qComments" datasource="#variables.dsn#">
			SELECT c.commentID,c.itemID,c.commentText,c.stamp,u.userID,u.firstName,u.lastName,u.avatar
				FROM #variables.tableprefix#comments c LEFT JOIN #variables.tableprefix#users u	ON c.userid = u.userid
			WHERE c.commentText like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
			ORDER BY c.stamp desc
		</cfquery>
		<cfreturn qComments>
	</cffunction>

	<cffunction name="files" access="public" returnType="query" output="false"
				hint="Returns projects.">
		<cfargument name="searchText" type="string" required="true">
		<cfset var qFiles = "">
		<cfset var datesOnly = arrayNew(1)>
	    <cfset var leftChar = arrayNew(1)>

		<cfquery name="qFiles" datasource="#variables.dsn#">
			SELECT f.fileID, f.title, f.categoryID, f.description, f.filename, f.serverfilename, f.filetype,
				f.filesize,f.uploaded,f.uploadedBy,u.firstName, u.lastName, fc.category
			FROM #variables.tableprefix#files f 
				LEFT JOIN #variables.tableprefix#users u ON f.uploadedBy = u.userID
				LEFT JOIN #variables.tableprefix#categories fc on f.categoryID = fc.categoryID
			WHERE fc.type = 'file' AND
				(f.title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR f.description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
			ORDER BY f.title asc
		  </cfquery>
		  
		  <cfloop query="qFiles">
			  <cfset datesOnly[currentRow] = DateFormat(uploaded)>
			  <cfset leftChar[currentRow] = left(title,1)>
		  </cfloop>
		  <cfset queryAddColumn(qFiles,"uploadDate",datesOnly)>
		  <cfset queryAddColumn(qFiles,"leftChar",leftChar)>
		  
		<cfreturn qFiles>
	</cffunction>

	<cffunction name="issues" access="public" returntype="query" output="false"
				HINT="Returns issues.">				
		<cfargument name="searchText" type="string" required="true">
		<cfset var qIssues = "">
		<cfquery name="qIssues" datasource="#variables.dsn#">
			SELECT issueID, i.projectID, i.shortID, i.issue, i.detail, i.type, i.severity, i.status, 
				i.created, i.createdBy,	i.assignedTo, i.milestoneID, i.relevantURL, i.updated, i.updatedBy, 
				i.resolution, i.resolutionDesc, p.name, c.firstName as createdFirstName, 
				c.lastName as createdLastName, u.firstName as updatedFirstName, 
				u.lastName as updatedLastName, a.firstName as assignedFirstName, 
				a.lastName as assignedLastName,	m.name as milestone
			FROM #variables.tableprefix#issues i 
				LEFT JOIN #variables.tableprefix#projects p ON i.projectID = p.projectID
				LEFT JOIN #variables.tableprefix#users c ON i.createdBy = c.userID
				LEFT JOIN #variables.tableprefix#users u ON i.updatedBy = u.userID
				LEFT JOIN #variables.tableprefix#users a ON i.assignedTo = a.userID
				LEFT JOIN #variables.tableprefix#milestones m ON i.milestoneID = m.milestoneID
			WHERE (i.issue like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR i.detail like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
		</cfquery>		
		<cfreturn qIssues>
	</cffunction>

	<cffunction name="messages" access="public" returnType="query" output="false"
				hint="Returns messages.">
		<cfargument name="searchText" type="string" required="true">
		<cfset var qMessages = "">
		<cfquery name="qMessages" datasource="#variables.dsn#">
			SELECT u.userID,u.firstName,u.lastName,u.avatar,m.messageID,m.categoryID,m.milestoneID,m.title,m.message,
					m.allowcomments,m.stamp,ms.name,mc.category,
					(SELECT count(commentID) FROM #variables.tableprefix#comments c where m.messageid = c.itemid and type = 'msg') as commentcount,
					(SELECT count(fileID) FROM #variables.tableprefix#file_attach fa where m.messageid = fa.itemid and fa.type = 'msg') as attachcount
			FROM #variables.tableprefix#messages m 
				LEFT JOIN #variables.tableprefix#categories mc ON m.categoryID = mc.categoryID
				LEFT JOIN #variables.tableprefix#users u ON u.userID = m.userID 
				LEFT JOIN #variables.tableprefix#milestones ms ON m.milestoneid = ms.milestoneid
			WHERE mc.type = 'msg' AND (m.title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR m.message like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
			ORDER BY m.stamp desc
		</cfquery>
		<cfreturn qMessages>
	</cffunction>

	<cffunction name="milestones" access="public" returnType="query" output="false"
				hint="Returns milestones.">
		<cfargument name="searchText" type="string" required="true">
		<cfset var qMilestones = "">
		<cfquery name="qMilestones" datasource="#variables.dsn#">
			SELECT milestoneid,m.projectID,m.name,m.description,dueDate,completed,
				m.forid,m.userid,u.firstName,u.lastName,p.name as projName
				FROM #variables.tableprefix#milestones m
				LEFT JOIN #variables.tableprefix#users u ON m.forid = u.userid
				LEFT JOIN #variables.tableprefix#projects p ON m.projectID = p.projectID
			WHERE (m.name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR m.description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
		</cfquery>
		<cfreturn qMilestones>
	</cffunction>

	<cffunction name="todos" access="public" returnType="query" output="false"
				hint="Returns task list.">
		<cfargument name="searchText" type="string" required="true">
		<cfset var qTodoLists = "">
		<cfquery name="qTodoLists" datasource="#variables.dsn#">
			SELECT t.todoID,t.todolistID,t.projectID,t.task,t.userID,t.rank,t.due,t.completed,t.svnrevision,
					tl.title, tl.description, u.firstName,u.lastName 
				FROM #variables.tableprefix#todos t 
					LEFT JOIN #variables.tableprefix#todolists tl ON t.todolistID = tl.todolistID
					LEFT JOIN #variables.tableprefix#users u ON t.userID = u.userID
			WHERE (t.task like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR tl.title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR tl.description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
			ORDER BY tl.rank,tl.added,t.added
		</cfquery>
		<cfreturn qTodoLists>
	</cffunction>
	
</CFCOMPONENT>
