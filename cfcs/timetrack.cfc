<cfcomponent displayName="Carriers" hint="Methods dealing with mobile carriers.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="timetrack" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
		
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
		<cfargument name="clientID" type="string" required="false" default="">
		<cfargument name="projectIDlist" type="string" required="false" default="">
		<cfset var qGet = "">

		<cfquery name="qGet" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT tt.timetrackID, tt.projectID, tt.userID, tt.dateStamp, tt.hours, tt.description,
					tt.itemID, tt.itemType,	tt.billed, tt.paid, u.firstName, u.lastName, 
					t.todolistID, t.task, i.shortID, i.issue, p.clientID as projClientID, p.name, 
					cl.name as client, cr.clientID, cr.rateID, cr.category, cr.rate
				FROM #variables.tableprefix#timetrack tt 
					LEFT JOIN #variables.tableprefix#users u on tt.userid = u.userid
					LEFT JOIN #variables.tableprefix#todos t ON tt.itemID = t.todoID
					LEFT JOIN #variables.tableprefix#issues i ON tt.itemID = i.issueID
					LEFT JOIN #variables.tableprefix#projects p ON tt.projectID = p.projectID
					LEFT JOIN #variables.tableprefix#clients cl ON p.clientID = cl.clientID
					LEFT JOIN #variables.tableprefix#client_rates cr ON tt.rateID = cr.rateID
				WHERE 0 = 0
				<cfif compare(arguments.timetrackID,'')>
					AND tt.timetrackID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.timetrackID#" maxlength="35">
				</cfif>
				<cfif compare(arguments.projectID,'')>
					AND tt.projectID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				</cfif>
				<cfif compare(arguments.projectIDlist,'')>
					AND tt.projectID IN (<cfqueryparam value="#arguments.projectIDlist#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
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
				<cfif compare(arguments.clientID,'')>
					AND p.clientID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.clientID#" maxlength="35">
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
		<cfargument name="rateID" type="string" required="false" default="">
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
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#timetrack (timetrackID,projectID,userID,dateStamp,hours,description,itemid,itemtype,rateID)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.timetrackID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDate(arguments.dateStamp)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#hoursConverted#" maxlength="7" scale="2">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#" maxlength="255">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemid#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemtype#" maxlength="10">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rateID#" maxlength="35">)
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
		<cfargument name="rateID" type="string" required="false" default="">
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
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#timetrack 
				SET projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
					dateStamp = <cfqueryparam cfsqltype="cf_sql_date" value="#createODBCDate(arguments.dateStamp)#">,
					hours = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hoursConverted#" maxlength="7" scale="2">,
					description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#" maxlength="255">,
					rateID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rateID#" maxlength="35">
				WHERE timetrackID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.timetrackID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="delete" access="public" returnType="boolean" output="false"
				hint="Deletes a time tracking value.">
		<cfargument name="timetrackID" type="uuid" required="true">		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#timetrack 
				WHERE timetrackID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.timetrackID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		

	<cffunction name="countTime" access="public" returnType="query" output="false"
				hint="Returns total hours for item.">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="itemID" type="string" required="false" default="">
		<cfset var qCountTime = "">		
		<cfquery name="qCountTime" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT count(hours) as numLines, sum(hours) as numHours FROM #variables.tableprefix#timetrack 
				WHERE 0=0
				<cfif compare(arguments.projectID,'')>
					AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				</cfif>
				<cfif compare(arguments.itemID,'')>
					AND itemID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemID#" maxlength="35">
				</cfif>
		</cfquery>
		<cfreturn qCountTime>
	</cffunction>

	<cffunction name="sumRate" access="public" returnType="query" output="false"
				hint="Returns total rate for item.">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfset var qSumRate = "">		
		<cfquery name="qSumRate" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT sum(t.hours*cr.rate) as sumRate 
			FROM #variables.tableprefix#timetrack t 
				LEFT JOIN #variables.tableprefix#client_rates cr ON t.rateID = cr.rateID
				LEFT JOIN #variables.tableprefix#projects p on t.projectID = p.projectID
			WHERE t.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND t.rateID != ''
		</cfquery>
		<cfreturn qSumRate>
	</cffunction>

</cfcomponent>