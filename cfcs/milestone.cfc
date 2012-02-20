<cfcomponent displayName="Milestones" hint="Methods dealing with project milestones.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="milestone" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
		
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
		<cfargument name="withRate" type="boolean" required="false" default="false">
		<cfset var qGetMilestones = "">
		<cfquery name="qGetMilestones" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT milestoneid, m.projectID, m.name, m.description, m.dueDate, m.completed,
				m.forid, m.userid, m.rate, m.billed, m.paid, u.firstName, u.lastName, p.name as projName,
				(SELECT count(commentID) FROM #variables.tableprefix#comments c where m.milestoneid = c.itemid and type = 'mstone') as commentcount
				FROM #variables.tableprefix#milestones m
				LEFT JOIN #variables.tableprefix#users u ON m.forid = u.userid
				LEFT JOIN #variables.tableprefix#projects p ON m.projectID = p.projectID
			WHERE 0=0
			<cfif compare(arguments.projectID,'')>
				AND m.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.projectIDlist,'')>
				AND m.projectID IN (<cfqueryparam value="#arguments.projectIDlist#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
			</cfif>
			<cfif compare(arguments.milestoneID,'')>
				AND m.milestoneID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.forID,'')>
				AND m.forID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forID#" maxlength="35">
			</cfif>
			<cfif arguments.withRate>
				AND m.rate > 0
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
		<cfargument name="rate" type="string" required="true">
		<cfargument name="completed" type="boolean" required="true">
		<cfargument name="userID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#milestones (milestoneID,projectID,userID,forID,name,description,dueDate,rate,completed)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dueDate#">,
					<cfif isNumeric(arguments.rate)><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.rate#"><cfelse>NULL</cfif>,
					<cfif arguments.completed>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateConvert("local2Utc",Now())#">
					<cfelse>NULL</cfif>)
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a milestone.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="dueDate" type="date" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="forID" type="uuid" required="true">
		<cfargument name="rate" type="string" required="true">
		<cfargument name="completed" type="boolean" required="true">
		<cfset var original = application.milestone.get(arguments.projectID,arguments.milestoneID)>		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#milestones 
				SET name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
					dueDate = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.dueDate#">,
					forID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forID#" maxlength="35">,
					rate = <cfif isNumeric(arguments.rate)><cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.rate#"><cfelse>NULL</cfif>,
					completed = <cfif arguments.completed>
							<cfif isDate(original.completed)>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(original.completed)#">
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateConvert("local2Utc",Now())#">
							</cfif>
						<cfelse>NULL</cfif>
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
					AND milestoneID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="delete" access="public" returnType="boolean" output="false"
				hint="Deletes a milestone.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#milestones
			WHERE milestoneID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfset application.comment.delete(itemID=arguments.milestoneID,type='mstone')>
		<cfset application.activity.delete(arguments.projectID,'Milestone',arguments.milestoneID)>
		<cfreturn true>
	</cffunction>		
	
	<cffunction name="markCompleted" access="public" returnType="boolean" output="false"
				hint="Marks a milestone as completed.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#milestones 
			SET completed = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateConvert("local2Utc",Now())#">
			WHERE milestoneID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="markActive" access="public" returnType="boolean" output="false"
				hint="Marks a milestone as active again.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#milestones 
			SET completed = NULL
			WHERE milestoneID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
		
</cfcomponent>