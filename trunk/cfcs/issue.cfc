<cfcomponent displayName="pp_issues" HINT="">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="issue" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>
	
	<CFFUNCTION NAME="get" ACCESS="public" RETURNTYPE="query" OUTPUT="false"
				HINT="Returns pp_issues records.">				
		<CFARGUMENT NAME="projectID" TYPE="string" REQUIRED="false" DEFAULT="">
		<CFARGUMENT NAME="issueID" TYPE="string" REQUIRED="false" DEFAULT="">
		<CFARGUMENT NAME="status" TYPE="string" REQUIRED="false" DEFAULT="">
		<cfargument name="projectIDlist" type="string" required="false" default="">
		<cfargument name="type" type="string" required="false" default="">
		<cfargument name="severity" type="string" required="false" default="">
		<cfargument name="assignedTo" type="string" required="false" default="">
		<CFSET var qRecords = "">
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
				AND i.projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#" MAXLENGTH="35">
			</cfif>
			<cfif compare(arguments.projectIDlist,'')>
				AND i.projectID IN ('#replace(arguments.projectIDlist,",","','","ALL")#')
			</cfif>			
			<cfif compare(arguments.issueID,'')>
				AND issueID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.issueID#" MAXLENGTH="35">
			</cfif>
			<cfif compare(arguments.status,'')>
				AND i.status = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.status#" MAXLENGTH="6">
			</cfif>
			<cfif compare(arguments.type,'')>
				AND i.type = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.type#" MAXLENGTH="11">
			</cfif>
			<cfif compare(arguments.severity,'')>
				AND i.severity = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.severity#" MAXLENGTH="10">
			</cfif>
			<cfif compare(arguments.assignedTo,'')>
				AND i.assignedTo = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.assignedTo#" MAXLENGTH="35">
			</cfif>						
		</cfquery>		
		<CFRETURN qRecords>
	</CFFUNCTION>
	
	<CFFUNCTION NAME="add" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Inserts a pp_issues record.">
		<CFARGUMENT NAME="issueID" TYPE="uuid" REQUIRED="true">
		<CFARGUMENT NAME="projectID" TYPE="uuid" REQUIRED="true">
		<CFARGUMENT NAME="ticketPrefix" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="issue" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="detail" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="type" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="severity" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="status" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="assignedTo" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="relevantURL" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="createdBy" TYPE="string" REQUIRED="true">
		<CFSET var qCountTix = "">
		<CFTRANSACTION>
		<CFQUERY NAME="qCountTix" DATASOURCE="#variables.dsn#">
			SELECT count(*) as numTix FROM #variables.tableprefix#issues 
				WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#" MAXLENGTH="35">
		</CFQUERY>
		<CFQUERY DATASOURCE="#variables.dsn#">
			INSERT INTO #variables.tableprefix#issues (issueID, projectID, shortID, issue, detail, type, severity, status, assignedTo, relevantURL, created, createdBy)
				VALUES(<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.issueID#" MAXLENGTH="35">,
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#" MAXLENGTH="35">, 
						'#ARGUMENTS.ticketPrefix##NumberFormat(qCountTix.numTix+001,"000")#',
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.issue#" MAXLENGTH="120">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.detail#" MAXLENGTH="2000">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.type#" MAXLENGTH="11">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.severity#" MAXLENGTH="10">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.status#" MAXLENGTH="6">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.assignedTo#" MAXLENGTH="35">,
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.relevantURL#" MAXLENGTH="255">,
						#Now()#, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.createdBy#" MAXLENGTH="35">
						)
		</CFQUERY>
		</CFTRANSACTION>
	</CFFUNCTION>
	
	<CFFUNCTION NAME="update" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Updates an issue.">
		<CFARGUMENT NAME="issueID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="projectID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="issue" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="detail" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="type" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="severity" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="status" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="assignedTo" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="relevantURL" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="updatedBy" TYPE="string" REQUIRED="true">
		<CFQUERY DATASOURCE="#variables.dsn#">
			UPDATE #variables.tableprefix#issues SET
				projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#" MAXLENGTH="35">, 
				issue = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.issue#" MAXLENGTH="120">, 
				detail = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.detail#" MAXLENGTH="2000">, 
				type = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.type#" MAXLENGTH="11">, 
				severity = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.severity#" MAXLENGTH="10">, 
				status = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.status#" MAXLENGTH="6">, 
				assignedTo = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.assignedTo#" MAXLENGTH="35">, 
				relevantURL = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.relevantURL#" MAXLENGTH="255">, 
				updated = #Now()#, 
				updatedBy = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.updatedBy#" MAXLENGTH="35">
			WHERE 0=0
				AND issueID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.issueID#">			
		</cfquery>		
	</CFFUNCTION>
	
	<CFFUNCTION NAME="markClosed" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Marks an issue closed.">
		<CFARGUMENT NAME="issueID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="projectID" TYPE="string" REQUIRED="true">
		<CFQUERY DATASOURCE="#variables.dsn#">
			UPDATE #variables.tableprefix#issues SET status = 'Closed'
				WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#">
					AND issueID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.issueID#">
		</cfquery>		
	</CFFUNCTION>	
	
</CFCOMPONENT>
