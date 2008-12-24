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
				hint="Returns milestones.">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="milestoneID" type="string" required="false" default="">
		<cfargument name="type" type="string" required="false" default="">
		<cfargument name="limit" type="string" required="false" default="">
		<cfargument name="projectIDlist" type="string" required="false" default="">
		<cfargument name="forID" type="string" required="false" default="">
		<cfset var qGetMilestones = "">
		<cfquery name="qGetMilestones" datasource="#variables.dsn#">
			SELECT milestoneid,m.projectID,m.name,m.description,dueDate,completed,
				m.forid,m.userid,u.firstName,u.lastName,p.name as projName
				FROM #variables.tableprefix#milestones m
				LEFT JOIN #variables.tableprefix#users u ON m.forid = u.userid
				LEFT JOIN #variables.tableprefix#projects p ON m.projectID = p.projectID
			WHERE 0=0
			<cfif compare(arguments.projectID,'')>
				AND m.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.projectIDlist,'')>
				AND m.projectID IN ('#replace(arguments.projectIDlist,",","','","ALL")#')
			</cfif>
			<cfif compare(arguments.milestoneID,'')>
				AND m.milestoneID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.forID,'')>
				AND m.forID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forID#" maxlength="35">
			</cfif>
			<cfswitch expression="#arguments.type#">
				<cfcase value="overdue">
					AND dueDate < #CreateODBCDate(Now())# AND completed IS NULL
					ORDER BY dueDate
				</cfcase>
				<cfcase value="upcoming">
					AND dueDate >= #CreateODBCDate(Now())# AND completed IS NULL
					<cfif compare(arguments.limit,'')>
						AND dueDate <= #DateAdd("m",arguments.limit,CreateODBCDate(Now()))#
					</cfif>
					ORDER BY dueDate
				</cfcase>
				<cfcase value="completed">
					AND completed IS NOT NULL
					ORDER BY dueDate
				</cfcase>
				<cfcase value="incomplete">
					AND completed IS NULL
					ORDER BY dueDate
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
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
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
		<cfset var original = application.milestone.get(arguments.projectID,arguments.milestoneID)>		
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#milestones 
				SET name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
					dueDate = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dueDate#">,
					forID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forID#" maxlength="35">,
					completed = <cfif arguments.completed><cfif isDate(original.completed)>#CreateODBCDateTime(original.completed)#<cfelse>#CreateODBCDateTime(Now())#</cfif><cfelse>NULL</cfif>
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
					AND milestoneID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="remove" access="public" returnType="boolean" output="false"
				hint="Deletes a milestone.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#milestones
			WHERE milestoneID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfset application.activity.delete(arguments.projectID,'Milestone',arguments.milestoneID)>
		<cfreturn true>
	</cffunction>		
	
	<cffunction name="markCompleted" access="public" returnType="boolean" output="false"
				hint="Marks a milestone as completed.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#milestones SET completed = #Now()#
			WHERE milestoneID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="markActive" access="public" returnType="boolean" output="false"
				hint="Marks a milestone as active again.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#milestones SET completed = NULL
			WHERE milestoneID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
		
</cfcomponent>