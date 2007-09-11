<cfcomponent displayName="Milestones" hint="Methods dealing with project milestones.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="milestone" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns projects.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="milestoneID" type="string" required="false" default="">
		<cfargument name="type" type="string" required="false" default="">
		<cfset var qGetMilestones = "">
		<cfquery name="qGetMilestones" datasource="#variables.dsn#">
			SELECT milestoneid,name,description,dueDate,completed,m.userid,firstName,lastName 
				FROM #variables.tableprefix#milestones m
				LEFT JOIN #variables.tableprefix#users u ON m.forid = u.userid
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
			<cfif compare(arguments.milestoneID,'')> AND milestoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35"></cfif>
			<cfswitch expression="#arguments.type#">
				<cfcase value="overdue">
					AND dueDate < #Now()# AND completed IS NULL
				</cfcase>
				<cfcase value="upcoming">
					AND dueDate > #Now()# AND completed IS NULL
				</cfcase>
				<cfcase value="completed">
					AND completed IS NOT NULL
				</cfcase>
			</cfswitch>
		</cfquery>
		<cfreturn qGetMilestones>
	</cffunction>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Adds a milestone.">
		<cfargument name="milestoneID" type="uuid" required="true">		
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="dueDate" type="date" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="forID" type="uuid" required="true">
		<cfargument name="completed" type="boolean" required="true">
		<cfargument name="userID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#milestones (milestoneID,projectID,userID,forID,name,description,dueDate,completed)
			VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#" maxlength="2000">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dueDate#">,
					<cfif arguments.completed>#CreateODBCDateTime(Now())#<cfelse>NULL</cfif>)
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a milestone.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="dueDate" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="forID" type="uuid" required="true">
		<cfargument name="completed" type="boolean" required="true">
		<cfset original = application.milestone.get(arguments.projectID,arguments.milestoneID)>		
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#milestones 
				SET name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#" maxlength="2000">,
					dueDate = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dueDate#">,
					forID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forID#" maxlength="35">,
					completed = <cfif arguments.completed and not isDate(original.completed)>#CreateODBCDateTime(Now())#<cfelse>NULL</cfif>
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
					AND milestoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="remove" access="public" returnType="boolean" output="false"
				hint="Deletes a milestone.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#milestones
			WHERE milestoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
	
	<cffunction name="markCompleted" access="public" returnType="boolean" output="false"
				hint="Marks a milestone as completed.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#milestones SET completed = #Now()#
			WHERE milestoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="markActive" access="public" returnType="boolean" output="false"
				hint="Marks a milestone as active again.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#milestones SET completed = NULL
			WHERE milestoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
		
</cfcomponent>