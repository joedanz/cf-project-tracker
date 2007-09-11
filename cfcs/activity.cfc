<cfcomponent displayName="Activity" hint="Methods dealing with project tasks.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="activity" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns projects.">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="recentOnly" type="boolean" required="false" default="false">
		<cfset var qGetActivity = "">
		<cfquery name="qGetActivity" datasource="#variables.dsn#">
			SELECT a.activityID,a.projectID,a.type,a.id,a.name,a.activity,a.stamp,
				u.userid,u.firstName,u.lastName,p.name as projectName
			FROM #variables.tableprefix#activity a 
				LEFT JOIN #variables.tableprefix#projects p	ON a.projectID = p.projectID
			INNER JOIN #variables.tableprefix#users u ON a.userID = u.userID
			WHERE 0=0
			<cfif compare(arguments.projectID,'')>AND a.projectID = 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35"></cfif>
			<cfif arguments.recentOnly>
				AND a.stamp > #DateAdd("m",-1,Now())#
			</cfif>
			ORDER BY stamp desc
		</cfquery>
		<cfreturn qGetActivity>
	</cffunction>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Returns projects.">
		<cfargument name="activityID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="userID" type="uuid" required="true">
		<cfargument name="type" type="string" required="true">
		<cfargument name="id" type="string" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="activity" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#activity (activityID,projectID,userid,type,id,name,activity,stamp)
			VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activityID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activity#">,
					#Now()#)
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
</cfcomponent>