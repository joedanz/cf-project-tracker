<cfcomponent displayName="Todo Lists" hint="Methods dealing with project task lists.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="todolist" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns task list.">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="todolistID" type="string" required="false" default="">
		<cfargument name="projectIDlist" type="string" required="false" default="">
		<cfargument name="milestoneID" type="string" required="false" default="">
		<cfset var qGetTodoLists = "">
		<cfquery name="qGetTodoLists" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT u.firstName, u.lastName, tl.todolistID, tl.projectID, tl.title, tl.description, tl.added, tl.timetrack,
				(select count(*) from #variables.tableprefix#todos t where tl.todolistID = t.todolistID and completed is not NULL) as completed_count, 
				(select count(*) from #variables.tableprefix#todos t where tl.todolistID = t.todolistID and completed is NULL) as uncompleted_count,
				ms.milestoneid, ms.name, p.projectID, p.name as projName 
			FROM #variables.tableprefix#todolists tl
				LEFT JOIN #variables.tableprefix#users u ON u.userID = tl.userID 
				LEFT JOIN #variables.tableprefix#milestones ms ON tl.milestoneid = ms.milestoneid
				LEFT JOIN #variables.tableprefix#projects p ON tl.projectID = p.projectID
			WHERE 0=0
				<cfif compare(arguments.projectID,'')> AND tl.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35"></cfif>
				<cfif compare(arguments.projectIDlist,'')>
					AND tl.projectID IN (<cfqueryparam value="#arguments.projectIDlist#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
				</cfif>				
				<cfif compare(arguments.todolistID,'')> AND tl.todolistID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todolistID#" maxlength="35"></cfif>
				<cfif compare(arguments.milestoneID,'')> AND ms.milestoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35"></cfif>
			ORDER BY p.name, tl.projectID, tl.title, tl.rank, tl.added 
		</cfquery>
		<cfreturn qGetTodoLists>
	</cffunction>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Adds a task list.">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="milestoneID" type="string" required="true">
		<cfargument name="timetrack" type="numeric" required="true">
		<cfargument name="userID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#todolists (todolistID,projectID,title,description,milestoneid,timetrack,userid,added,rank)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todolistID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="100">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.timetrack#" maxlength="1">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					#Now()#,1)
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a task list.">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="milestoneID" type="string" required="true">
		<cfargument name="timetrack" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#todolists 
				SET title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="100">,
					description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
					milestoneid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">,
					timetrack = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.timetrack#" maxlength="1">
				WHERE projectid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
					AND todolistid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todolistID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="updateRank" access="public" returnType="boolean" output="false"
				hint="Updates a task list.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfargument name="rank" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#todolists 
				SET rank = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rank#">
				WHERE projectid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
					AND todolistid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todolistID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="delete" access="public" returnType="boolean" output="false"
				hint="Deletes a task list.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#todolists
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND todolistID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todolistID#" maxlength="35">
		</cfquery>
		<cfset application.activity.delete(arguments.projectID,'To-Do List',arguments.todolistID)>
		<cfreturn true>
	</cffunction>	
	
</cfcomponent>