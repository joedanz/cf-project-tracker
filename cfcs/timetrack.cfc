<cfcomponent displayName="Carriers" hint="Methods dealing with mobile carriers.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="timetrack" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns time tracking info.">
		<cfargument name="timetrackID" type="string" required="false" default="">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="userID" type="string" required="false" default="">
		<cfargument name="startDate" type="string" required="false" default="">
		<cfargument name="endDate" type="string" required="false" default="">
		<cfargument name="itemID" type="string" required="false" default="">
		<cfset var qGet = "">

		<cfquery name="qGet" datasource="#variables.dsn#">
			SELECT tt.timetrackID, tt.projectID, tt.userID, tt.dateStamp, tt.hours, tt.description,
					tt.itemID, tt.itemType,	u.firstName, u.lastName, t.todolistID, t.task
				FROM #variables.tableprefix#timetrack tt 
					LEFT JOIN #variables.tableprefix#users u on tt.userid = u.userid
					LEFT JOIN #variables.tableprefix#todos t ON tt.itemID = t.todoID
				WHERE 0 = 0
				<cfif compare(arguments.timetrackID,'')>
					AND tt.timetrackID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.timetrackID#" maxlength="35">
				</cfif>
				<cfif compare(arguments.projectID,'')>
					AND tt.projectID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				</cfif>
				<cfif compare(arguments.userID,'')>
					AND tt.userID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
				</cfif>
				<cfif compare(arguments.startDate,'')>
					AND tt.dateStamp >= #CreateODBCDate(arguments.startDate)#
				</cfif>
				<cfif compare(arguments.endDate,'')>
					AND tt.dateStamp <= #CreateODBCDate(arguments.endDate)#
				</cfif>
				<cfif compare(arguments.itemID,'')>
					AND tt.itemID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.itemID#" maxlength="35">
				</cfif>
			ORDER BY dateStamp desc
		</cfquery>
		<cfreturn qGet>
	</cffunction>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Adds a time tracking value.">	
		<cfargument name="timetrackID" type="uuid" required="true">	
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="dateStamp" type="string" required="true">
		<cfargument name="hours" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="itemID" type="string" required="false" default="">
		<cfargument name="itemType" type="string" required="false" default="">
		<cfset var hoursConverted = "">
		<cfset var hrs = "">
		<cfset var min = "">
		<cfif find(':',arguments.hours)>
			<cfset hrs = left(arguments.hours,find(':',arguments.hours)-1)>
			<cfset min = right(arguments.hours,len(arguments.hours)-find(':',arguments.hours)) / 60>
			<cfset hoursConverted = left(hrs+min,6)>
		<cfelse>
			<cfset hoursConverted = arguments.hours>
		</cfif>
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#timetrack (timetrackID,projectID,userID,dateStamp,hours,description,itemid,itemtype)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.timetrackID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDate(arguments.dateStamp)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#hoursConverted#" maxlength="6">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#" maxlength="255">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemid#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemtype#" maxlength="10">)
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a time tracking value.">
		<cfargument name="timetrackID" type="uuid" required="true">		
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="dateStamp" type="string" required="true">
		<cfargument name="hours" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#timetrack 
				SET projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					dateStamp = <cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDate(arguments.dateStamp)#">,
					hours = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hours#" maxlength="6">,
					description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#" maxlength="255">
				WHERE timetrackID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.timetrackID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="delete" access="public" returnType="boolean" output="false"
				hint="Deletes a time tracking value.">
		<cfargument name="timetrackID" type="uuid" required="true">		
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#timetrack 
				WHERE timetrackID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.timetrackID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		

	<cffunction name="countHours" access="public" returnType="numeric" output="false"
				hint="Returns total hours for item.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfset var qCountHours = "">		
		<cfquery name="qCountHours" datasource="#variables.dsn#">
			SELECT sum(hours) as numHours FROM #variables.tableprefix#timetrack 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn qCountHours.numHours>
	</cffunction>

</cfcomponent>