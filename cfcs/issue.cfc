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
		<cfargument name="milestoneID" type="string" required="false" default="">
		<cfargument name="componentID" type="string" required="false" default="">
		<cfargument name="versionID" type="string" required="false" default="">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT issueID, i.projectID, i.shortID, i.issue, i.detail, i.type, i.severity, i.status, 
				i.created, i.createdBy,	i.assignedTo, i.milestoneID, i.relevantURL, i.updated, i.updatedBy, 
				i.resolution, i.resolutionDesc, i.componentID, i.versionID, p.name, c.firstName as createdFirstName, 
				c.lastName as createdLastName, u.firstName as updatedFirstName, 
				u.lastName as updatedLastName, a.firstName as assignedFirstName, 
				a.lastName as assignedLastName,	m.name as milestone, pc.component, pv.version
			FROM #variables.tableprefix#issues i 
				LEFT JOIN #variables.tableprefix#projects p ON i.projectID = p.projectID
				LEFT JOIN #variables.tableprefix#users c ON i.createdBy = c.userID
				LEFT JOIN #variables.tableprefix#users u ON i.updatedBy = u.userID
				LEFT JOIN #variables.tableprefix#users a ON i.assignedTo = a.userID
				LEFT JOIN #variables.tableprefix#milestones m ON i.milestoneID = m.milestoneID
				LEFT JOIN #variables.tableprefix#project_components pc ON i.componentID = pc.componentID
				LEFT JOIN #variables.tableprefix#project_versions pv ON i.versionID = pv.versionID
			WHERE 0=0
			<cfif compare(arguments.projectID,'')>
				AND i.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.projectIDlist,'')>
				AND i.projectID IN ('#replace(arguments.projectIDlist,",","','","ALL")#')
			</cfif>			
			<cfif compare(arguments.issueID,'')>
				AND issueID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.status,'')>
				AND i.status IN (<cfif find('|',arguments.status)>'#replace(arguments.status,"|","','","ALL")#'<cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#"></cfif>)
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
			<cfif compare(arguments.milestoneID,'')>
				AND i.milestoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.componentID,'')>
				AND i.componentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.componentID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.versionID,'')>
				AND i.versionID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.versionID#" maxlength="35">
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
		<cfargument name="assignedTo" type="string" required="true">
		<cfargument name="milestoneID" type="string" required="true">
		<cfargument name="relevantURL" type="string" required="true">
		<cfargument name="createdBy" type="string" required="true">
		<cfargument name="filesList" type="string" required="true">
		<cfset var qCountTix = "">
		<CFTRANSACTION>
		<CFQUERY NAME="qCountTix" DATASOURCE="#variables.dsn#">
			SELECT 	count(*) as numTix FROM #variables.tableprefix#issues 
			WHERE 	projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
		</CFQUERY>
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#issues (issueID, projectID, shortID, issue, detail, type, severity, status, assignedTo, milestoneID, relevantURL, created, createdBy)
				VALUES(<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">, 
						'#arguments.ticketPrefix##qCountTix.numTix+1#',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issue#" maxlength="120">, 
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.detail#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" maxlength="11">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.severity#" maxlength="10">, 
						'<cfif not compare(arguments.assignedTo,'')>New<cfelse>Accepted</cfif>', 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assignedTo#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relevantURL#" maxlength="255">,
						#Now()#, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.createdBy#" maxlength="35">
						)
		</CFQUERY>
		<!--- add attached file --->
		<cfif listLen(arguments.filesList)>
			<cfloop list="#arguments.filesList#" index="i">
				<cfset application.file.attachFile(arguments.issueID,i,'issue')>
			</cfloop>
		</cfif>		
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
		<cfargument name="assignedTo" type="string" required="true">
		<cfargument name="milestoneID" type="string" required="true">
		<cfargument name="relevantURL" type="string" required="true">
		<cfargument name="updatedBy" type="string" required="true">
		<cfargument name="filesList" type="string" required="true">

		<cfset var previous = get(arguments.projectID,arguments.issueID)>

		<!--- clear and repopulate file attach list --->
		<cfset application.file.removeAttachments(arguments.issueID,'issue')>
		<cfif listLen(arguments.filesList)>
			<cfloop list="#arguments.filesList#" index="i">
				<cfset application.file.attachFile(arguments.issueID,i,'issue')>
			</cfloop>
		</cfif>
		
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#issues SET
				projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">, 
				issue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issue#" maxlength="120">, 
				detail = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.detail#">, 
				type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" maxlength="11">, 
				severity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.severity#" maxlength="10">, 
				assignedTo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.assignedTo#" maxlength="35">,
				<cfif not compare(previous.assignedTo,'') and compare(arguments.assignedTo,'')>
					status = 'Accepted',
				<cfelseif compare(previous.assignedTo,'') and not compare(arguments.assignedTo,'')>
					status = 'New',
				</cfif>
				milestoneID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">,
				relevantURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relevantURL#" maxlength="255">, 
				updated = #Now()#, 
				updatedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.updatedBy#" maxlength="35">
			WHERE 0=0
				AND issueID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#">			
		</cfquery>
		
	</cffunction>
	
	<cffunction name="accept" access="public" returntype="void" output="false"
				HINT="Accept a ticket.">
		<cfargument name="issueID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="userID" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#issues 
			SET status = 'Accepted',
				assignedTo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">,
				updated = #CreateODBCDateTime(Now())#, 
				updatedBy = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
				AND issueID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#">
		</cfquery>		
	</cffunction>

	<cffunction name="unaccept" access="public" returntype="void" output="false"
				HINT="Unaccept a ticket.">
		<cfargument name="issueID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="userID" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#issues 
			SET status = 'New', assignedTo = '', updated = #CreateODBCDateTime(Now())#, 
				updatedBy = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
				AND issueID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#">
		</cfquery>		
	</cffunction>

	<cffunction name="resolve" access="public" returntype="void" output="false"
				HINT="Resolve a ticket.">
		<cfargument name="issueID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="closealso" type="boolean" required="true">
		<cfargument name="resolution" type="string" required="true">
		<cfargument name="resolutionDesc" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#issues 
			SET status = 'Resolved',
				resolution = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.resolution#" maxlength="12">,
				resolutionDesc = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.resolutionDesc#">,
				updated = #CreateODBCDateTime(Now())#, 
				updatedBy = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
				AND issueID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#">
		</cfquery>		
	</cffunction>

	<cffunction name="close" access="public" returntype="void" output="false"
				HINT="Marks an issue closed.">
		<cfargument name="issueID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="userID" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#issues 
				SET	status = 'Closed', updated = #CreateODBCDateTime(Now())#, 
				updatedBy = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
				AND issueID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#">
		</cfquery>		
	</cffunction>
	
	<cffunction name="reopen" access="public" returntype="void" output="false"
				HINT="Re-opens an issue.">
		<cfargument name="issueID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="userID" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#issues 
				SET	status = 'Accepted', updated = #CreateODBCDateTime(Now())#, 
				updatedBy = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
				AND issueID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#">
		</cfquery>		
	</cffunction>

</CFCOMPONENT>