<cfcomponent displayName="pp_issues" hint="">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="issue" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" returntype="query" output="false"
				HINT="Returns pp_issues records.">				
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="issueID" type="string" required="false" default="">
		<cfargument name="status" type="string" required="false" default="">
		<cfargument name="projectIDlist" type="string" required="false" default="">
		<cfargument name="type" type="string" required="false" default="">
		<cfargument name="severity" type="string" required="false" default="">
		<cfargument name="assignedTo" type="string" required="false" default="">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT issueID, i.projectID, shortID, issue, detail, type, severity, i.status, created, createdBy, 
				assignedTo, relevantURL, updated, updatedBy, p.name,
				c.firstName as createdFirstName, c.lastName as createdLastName, 
				u.firstName as updatedFirstName, u.lastName as updatedLastName, 
				a.firstName as assignedFirstName, a.lastName as assignedLastName
			FROM #variables.tableprefix#issues i 
				LEFT JOIN #variables.tableprefix#projects p ON i.projectID = p.projectID
				LEFT JOIN #variables.tableprefix#users c ON i.createdBy = c.userID
				LEFT JOIN #variables.tableprefix#users u ON i.updatedBy = u.userID
				LEFT JOIN #variables.tableprefix#users a ON i.assignedTo = a.userID
			WHERE 0=0
			<cfif compare(arguments.projectID,'')>
				AND i.projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.projectIDlist,'')>
				AND i.projectID IN ('#replace(arguments.projectIDlist,",","','","ALL")#')
			</cfif>			
			<cfif compare(arguments.issueID,'')>
				AND issueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issueID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.status,'')>
				AND i.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#" maxlength="6">
			</cfif>
			<cfif compare(arguments.type,'')>
				AND i.type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" maxlength="11">
			</cfif>
			<cfif compare(arguments.severity,'')>
				AND i.severity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.severity#" maxlength="10">
			</cfif>
			<cfif compare(arguments.assignedTo,'')>
				AND i.assignedTo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assignedTo#" maxlength="35">
			</cfif>						
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>
	
	<cffunction name="add" access="public" returntype="void" output="false"
				HINT="Inserts a pp_issues record.">
		<cfargument name="issueID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="ticketPrefix" type="string" required="true">
		<cfargument name="issue" type="string" required="true">
		<cfargument name="detail" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfargument name="severity" type="string" required="true">
		<cfargument name="status" type="string" required="true">
		<cfargument name="assignedTo" type="string" required="true">
		<cfargument name="relevantURL" type="string" required="true">
		<cfargument name="createdBy" type="string" required="true">
		<cfset var qCountTix = "">
		<CFTRANSACTION>
		<CFQUERY NAME="qCountTix" DATASOURCE="#variables.dsn#">
			SELECT count(*) as numTix FROM #variables.tableprefix#issues 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
		</CFQUERY>
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#issues (issueID, projectID, shortID, issue, detail, type, severity, status, assignedTo, relevantURL, created, createdBy)
				VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issueID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">, 
						'#arguments.ticketPrefix##NumberFormat(qCountTix.numTix+001,"000")#',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issue#" maxlength="120">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#" maxlength="2000">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" maxlength="11">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.severity#" maxlength="10">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#" maxlength="6">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assignedTo#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relevantURL#" maxlength="255">,
						#Now()#, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdBy#" maxlength="35">
						)
		</CFQUERY>
		</CFTRANSACTION>
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false"
				HINT="Updates an issue.">
		<cfargument name="issueID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="issue" type="string" required="true">
		<cfargument name="detail" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfargument name="severity" type="string" required="true">
		<cfargument name="status" type="string" required="true">
		<cfargument name="assignedTo" type="string" required="true">
		<cfargument name="relevantURL" type="string" required="true">
		<cfargument name="updatedBy" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#issues SET
				projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">, 
				issue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issue#" maxlength="120">, 
				detail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#" maxlength="2000">, 
				type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" maxlength="11">, 
				severity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.severity#" maxlength="10">, 
				status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#" maxlength="6">, 
				assignedTo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assignedTo#" maxlength="35">, 
				relevantURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relevantURL#" maxlength="255">, 
				updated = #Now()#, 
				updatedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.updatedBy#" maxlength="35">
			WHERE 0=0
				AND issueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issueID#">			
		</cfquery>		
	</cffunction>
	
	<cffunction name="markClosed" access="public" returntype="void" output="false"
				HINT="Marks an issue closed.">
		<cfargument name="issueID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#issues SET status = 'Closed'
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#">
					AND issueID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issueID#">
		</cfquery>		
	</cffunction>	
	
</CFCOMPONENT>
