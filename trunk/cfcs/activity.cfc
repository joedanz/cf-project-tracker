<cfcomponent displayName="Activity" hint="Methods dealing with project activity.">

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
		<cfargument name="projectIDlist" type="string" required="false" default="">
		<cfargument name="recentOnly" type="boolean" required="false" default="false">
		<cfset var qGetActivity = "">
		<cfquery name="qGetActivity" datasource="#variables.dsn#">
			SELECT a.activityID,a.projectID,a.type,a.id,a.name,a.activity,a.stamp,
				u.userid,u.firstName,u.lastName,p.projectID,p.name as projectName, 'red' as thiscolor
			FROM #variables.tableprefix#activity a 
				LEFT JOIN #variables.tableprefix#projects p	ON a.projectID = p.projectID
			INNER JOIN #variables.tableprefix#users u ON a.userID = u.userID
			WHERE 0=0
			<cfif compare(arguments.projectID,'')>AND a.projectID = 
				<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.projectIDlist,'')>
				AND a.projectID IN ('#replace(arguments.projectIDlist,",","','","ALL")#')
			</cfif>			
			<cfif arguments.recentOnly>
				AND a.stamp > #DateAdd("m",-1,Now())#
			</cfif>
			ORDER BY stamp desc
		</cfquery>
		<cfreturn qGetActivity>
	</cffunction>
	
	<cffunction name="getForGrid" access="remote" returnType="struct" output="false">
		<cfargument name="page" type="numeric" required="true">
		<cfargument name="pagesize" type="numeric" required="true">
		<cfargument name="sortcol" type="string" required="true">
		<cfargument name="sortdir" type="string" required="true">
		<cfargument name="dsn" type="string" required="true">
		<cfargument name="tableprefix" type="string" required="true">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="recentOnly" type="boolean" required="false" default="false">
		
		<cfset var result = structNew()>
		<cfset var qGetActivity = "">
		<cfquery name="qGetActivity" datasource="#arguments.dsn#">
			SELECT a.activityID,a.projectID,a.type,a.id,a.name,a.activity,a.activity + ' by' as activityText,a.stamp,
				u.userid,u.firstName + ' ' + u.lastName as fullname,p.projectID,p.name as projectName
			FROM #arguments.tableprefix#activity a 
				LEFT JOIN #arguments.tableprefix#projects p	ON a.projectID = p.projectID
			INNER JOIN #arguments.tableprefix#users u ON a.userID = u.userID
			WHERE 0=0
			<cfif compare(arguments.projectID,'')>AND a.projectID = 
				<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35"></cfif>
			<cfif arguments.recentOnly>
				AND a.stamp > #DateAdd("m",-1,Now())#
			</cfif>
			ORDER BY 
					<cfif len(arguments.sortcol)><cfif not compareNoCase(arguments.sortcol,'NAME')>a.</cfif>[#arguments.sortcol#]<cfelse>stamp</cfif>
					<cfif len(arguments.sortdir)>#arguments.sortdir#<cfelse>desc</cfif>
		</cfquery>

		<cfset result = queryConvertForGrid(qGetActivity, arguments.page, arguments.pagesize)>

		<cfreturn result>
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
			VALUES(<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.activityID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.id#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activity#">,
					#Now()#)
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="delete" access="public" returnType="boolean" output="false"
				hint="Delete activity record.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="type" type="string" required="true">
		<cfargument name="id" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#activity 
				WHERE 0=0
					AND projectID = 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
					AND type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">
					AND id = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.id#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
</cfcomponent>