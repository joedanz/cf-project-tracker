<cfcomponent displayName="Task Lists" hint="Methods dealing with project task lists.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="todolist" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns projects.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="todolistID" type="string" required="false" default="">
		<cfset var qGetTodoLists = "">
		<cfquery name="qGetTodoLists" datasource="#variables.dsn#">
			SELECT u.firstName,u.lastName,tl.todolistID,tl.title,tl.description,tl.added,ms.milestoneid,ms.name 
			FROM #variables.tableprefix#todolists tl
				LEFT JOIN #variables.tableprefix#users u ON u.userID = tl.userID 
				LEFT JOIN #variables.tableprefix#milestones ms ON tl.milestoneid = ms.milestoneid
			WHERE tl.projectID = '#arguments.projectID#'
				<cfif compare(arguments.todolistID,'')> AND tl.todolistID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.todolistID#" maxlength="35"></cfif>
			ORDER BY rank, added, title
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
		<cfargument name="userID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#todolists (todolistID,projectID,title,description,milestoneid,userid,added,rank)
			VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.todolistID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">,
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
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#todolists 
				SET title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">,
					description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
					milestoneid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">
				WHERE projectid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
					AND todolistid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.todolistID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="updateRank" access="public" returnType="boolean" output="false"
				hint="Updates a task list.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfargument name="rank" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#todolists 
				SET rank = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rank#">
				WHERE projectid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
					AND todolistid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.todolistID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="delete" access="public" returnType="boolean" output="false"
				hint="Deletes a task list.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="tasklistID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#todolists
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
				AND todolistID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tasklistID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
</cfcomponent>