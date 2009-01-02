<cfcomponent displayName="Todos" hint="Methods dealing with project tasks.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="todo" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns projects.">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="todolistID" type="string" required="false" default="">
		<cfargument name="completed" type="string" required="false" default="">
		<cfargument name="order_by" type="string" required="false" default="t.rank,t.added">
		<cfargument name="assignedTo" type="string" required="false" default="">
		<cfargument name="projectIDlist" type="string" required="false" default="">
		<cfargument name="todoID" type="string" required="false" default="">
		<cfargument name="fullJoin" type="boolean" required="false" default="false">
		<cfset var qGetTodos = "">
		<cfquery name="qGetTodos" datasource="#variables.dsn#">
			SELECT t.todoID,t.todolistID,t.projectID,t.task,t.userID,t.rank,t.due,t.completed,
					<cfif arguments.fullJoin>
						tl.title, p.projectID, p.name,
					</cfif>
					u.firstName,u.lastName, count(tt.timetrackid) as numTimeTracks, sum(tt.hours) as numHours
				FROM #variables.tableprefix#todos t
					<cfif arguments.fullJoin> 
						LEFT JOIN #variables.tableprefix#todolists tl ON t.todolistID = tl.todolistID
						LEFT JOIN #variables.tableprefix#projects p ON tl.projectID = p.projectID
					</cfif>
					LEFT JOIN #variables.tableprefix#users u ON t.userID = u.userID
					LEFT JOIN #variables.tableprefix#timetrack tt ON t.todoID = tt.itemid
			WHERE 0=0
				<cfif compare(arguments.projectID,'')> AND t.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35"></cfif>
				<cfif compare(arguments.projectIDlist,'')>
					AND t.projectID IN ('#replace(arguments.projectIDlist,",","','","ALL")#')
				</cfif>	
				<cfif compare(arguments.todolistID,'')> AND todolistID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todolistID#" maxlength="35"></cfif>
				<cfif compare(arguments.todoID,'')> AND todoID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todoID#" maxlength="35"></cfif>
				<cfif compare(arguments.completed,'')>
					<cfif arguments.completed>
						AND t.completed IS NOT NULL
					<cfelse>
						AND t.completed IS NULL
					</cfif>
				</cfif>
				<cfif compare(arguments.assignedTo,'')>
					AND t.userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assignedTo#" maxlength="35">
				</cfif>
			GROUP BY
				<cfif arguments.fullJoin>
					p.name, p.projectID, tl.title, 
				</cfif> 
				t.todoID,t.todolistID,t.projectID,t.task,t.userID,t.rank,t.added,t.due,
				t.completed,u.firstName,u.lastName
				
			ORDER BY #arguments.order_by#
		</cfquery>
		<cfreturn qGetTodos>
	</cffunction>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Adds a task.">
		<cfargument name="todoID" type="uuid" required="true">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="task" type="string" required="true">
		<cfargument name="userID" type="uuid" required="true">
		<cfargument name="due" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#todos (todoID,todolistID,projectID,task,userid,rank,added,due)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todoID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todolistID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.task#" maxlength="300">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					999,#Now()#,
					<cfif isDate(arguments.due)>
						<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.due#">
					<cfelse>
						NULL
					</cfif>)
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a task.">
		<cfargument name="todoID" type="uuid" required="true">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="task" type="string" required="true">
		<cfargument name="userID" type="uuid" required="true">
		<cfargument name="due" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#todos
				SET task = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.task#" maxlength="300">,
					userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					due = 
						<cfif isDate(arguments.due)>
							<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.due#">
						<cfelse>
							NULL
						</cfif>
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
					AND todolistID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todolistID#" maxlength="35">
					AND todoID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todoID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="delete" access="public" returnType="boolean" output="false"
				hint="Deletes a task.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfargument name="todoID" type="string" required="false" default="">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#todos
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND todolistID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todolistID#" maxlength="35">
				<cfif compare(arguments.todoID,'')>AND todoID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todoID#" maxlength="35"></cfif>
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="updateRank" access="public" returnType="boolean" output="false"
				hint="Updates ordering of a task.">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfargument name="todoID" type="uuid" required="true">
		<cfargument name="rank" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#todos
			SET rank = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rank#">
			WHERE todoID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todoID#" maxlength="35">
				AND todolistID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todolistID#" maxlength="35">			
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="markCompleted" access="public" returnType="boolean" output="false"
				hint="Marks a task completed.">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfargument name="todoID" type="uuid" required="true">
		<cfargument name="isCompleted" type="boolean" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#todos
			SET completed = <cfif arguments.isCompleted>#Now()#<cfelse>NULL</cfif>
			WHERE todoID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todoID#" maxlength="35">
				AND todolistID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todolistID#" maxlength="35">			
		</cfquery>
		<cfreturn true>
	</cffunction>
		
</cfcomponent>