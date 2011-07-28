<cfcomponent displayName="category" hint="Methods dealing with categories.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="calendar" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="issueAdd" access="public" returntype="boolean" output="false"
				HINT="Inserts a pp_issues record.">
		<cfargument name="issueID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="issue" type="string" required="true">
		<cfargument name="detail" type="string" required="true">
		<cfargument name="dueDate" type="string" required="true">
		
		<cfset var gcDueDate = "">
		<cfset var calID = application.project.getCalID(arguments.projectID)>

		<cfset gcDueDate=createdatetime(DatePart('yyyy', arguments.dueDate),DatePart('m', arguments.dueDate),DatePart('d', arguments.dueDate),DatePart('h', now()),DatePart('n', now()),DatePart('s', 0))>
		<cfinvoke component="#application.gCal#" method="addEvent" returnVariable="result">
			<cfinvokeargument name="title" value="#arguments.issue# (issue)">
			<cfinvokeargument name="description" value="#arguments.detail#">
			<cfinvokeargument name="authorname" value="">
			<cfinvokeargument name="authormemail" value="">
			<cfinvokeargument name="where" value="">
			<cfinvokeargument name="start" value="#gcDueDate#">
			<cfinvokeargument name="end" value="#gcDueDate#">
			<cfinvokeargument name="allday" value="true">
			<cfinvokeargument name="resultType" value="fullResponse">
			<cfinvokeargument name="calendarid" value="#calID.googlecal#">
		</cfinvoke>
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#issues
			SET googlecalid = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#result.responseheader.location#">						
			WHERE issueid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#" maxlength="35">
		</cfquery>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="issueUpdate" access="public" returntype="boolean" output="false"
				HINT="Updates an issue.">
		<cfargument name="issueID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="issue" type="string" required="true">
		<cfargument name="detail" type="string" required="true">
		<cfargument name="dueDate" type="string" required="true">
		
		<cfset var go_to = createObject("java", "java.lang.Thread")>
		
		<cfset issueDelete(arguments.issueID)>
		<cfset go_to.sleep(1000)>
		<cfset issueAdd(arguments.issueID,arguments.projectID,arguments.issue,arguments.detail,arguments.dueDate)>
		
		<cfreturn true>
	</cffunction>

	<cffunction name="issueDelete" access="public" returntype="boolean" output="false"
				HINT="Marks an issue closed.">
		<cfargument name="issueID" type="string" required="true">
		
		<cfset var q = "">
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#" name="q">
			select googlecalid
			from #variables.tableprefix#issues
			where issueid=<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueid#" maxlength="35">	
		</cfquery>
		
		<cftry>
			<cfset application.gCal.deleteEvent(q.googlecalid)>
			<cfcatch></cfcatch>
		</cftry>
		<cfreturn true>
	</cffunction>

	<cffunction name="milestoneAdd" access="public" returnType="boolean" output="false"
				hint="Adds a milestone.">
		<cfargument name="milestoneID" type="uuid" required="true">		
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="dueDate" type="date" required="true">
		<cfargument name="userID" type="uuid" required="true">

		<cfset var gcDueDate = "">
		<cfset var calID = application.project.getCalID(arguments.projectid)>
		<cfset var qUser = application.user.get(arguments.userid)>
		
		<cfset gcDueDate=createdatetime(DatePart('yyyy', arguments.dueDate),DatePart('m', arguments.dueDate),DatePart('d', arguments.dueDate),DatePart('h', now()),DatePart('n', now()),DatePart('s', 0))>
		<cfinvoke component="#application.gcal#" method="addEvent" returnVariable="result">
			<cfinvokeargument name="title" value="#arguments.name# (milestone)">
			<cfinvokeargument name="description" value="#arguments.description#">
			<cfinvokeargument name="authorname" value="#qUser.firstname# #qUser.lastname#">
			<cfinvokeargument name="authormemail" value="#qUser.email#">
			<cfinvokeargument name="where" value="">
			<cfinvokeargument name="start" value="#gcDueDate#">
			<cfinvokeargument name="end" value="#gcDueDate#">
			<cfinvokeargument name="allday" value="true">
			<cfinvokeargument name="resultType" value="fullResponse">
			<cfinvokeargument name="calendarid" value="#calid.googlecal#">
		</cfinvoke>
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#milestones
				SET googlecalid = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#result.responseheader.location#">						
				WHERE milestoneID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneid#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="milestoneUpdate" access="public" returnType="boolean" output="false"
				hint="Updates a milestone.">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="dueDate" type="date" required="true">
		<cfargument name="userID" type="uuid" required="true">

		<cfset var gcDueDate = "">
		<cfset var go_to = createObject("java", "java.lang.Thread")>

		<cfset milestoneDelete(arguments.milestoneID)>
		<cfset go_to.sleep(1000)>
		<cfset milestoneAdd(arguments.milestoneID,arguments.projectID,arguments.name,arguments.description,arguments.dueDate,arguments.userID)>

		<cfreturn true>
	</cffunction>	
	
	<cffunction name="milestoneDelete" access="public" returnType="boolean" output="false"
				hint="Deletes a milestone.">
		<cfargument name="milestoneID" type="uuid" required="true">
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#" name="q">
			select googlecalid
			from #variables.tableprefix#milestones
			where milestoneid=<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.milestoneid#" maxlength="35">	
		</cfquery>
		<cftry>
			<cfset meh=application.gCal.deleteEvent(q.googlecalid)>
			<cfcatch></cfcatch>
		</cftry>
		<cfreturn true>
	</cffunction>		
	
	<cffunction name="todoAdd" access="public" returnType="boolean" output="false"
				hint="Adds a task.">
		<cfargument name="todoID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="task" type="string" required="true">
		<cfargument name="userID" type="uuid" required="true">
		<cfargument name="due" type="string" required="true">

		<cfset var gcDueDate = "">
		<cfset var calID = application.project.getCalID(arguments.projectid)>
		<cfset var qUser = application.user.get(arguments.userid)>
		
		<cfset gcDueDate=createdatetime(DatePart('yyyy', arguments.due),DatePart('m', arguments.due),DatePart('d', arguments.due),DatePart('h', now()),DatePart('n', now()),DatePart('s', 0))>
		<cfinvoke component="#application.gcal#" method="addEvent" returnVariable="result">
			<cfinvokeargument name="title" value="#arguments.task# (todo)">
			<cfinvokeargument name="description" value="">
			<cfinvokeargument name="authorname" value="#qUser.firstname# #qUser.lastname#">
			<cfinvokeargument name="authormemail" value="#qUser.email#">
			<cfinvokeargument name="where" value="">
			<cfinvokeargument name="start" value="#gcDueDate#">
			<cfinvokeargument name="end" value="#gcDueDate#">
			<cfinvokeargument name="allday" value="true">
			<cfinvokeargument name="resultType" value="fullResponse">
			<cfinvokeargument name="calendarid" value="#calid.googlecal#">
		</cfinvoke>
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#todos
				SET googlecalid = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#result.responseheader.location#">						
				WHERE todoID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todoID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="todoUpdate" access="public" returnType="boolean" output="false"
				hint="Updates a task.">
		<cfargument name="todoID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="task" type="string" required="true">
		<cfargument name="userID" type="uuid" required="true">
		<cfargument name="due" type="string" required="true">
		
		<cfset var dueDate = "">
		<cfset var go_to = createObject("java", "java.lang.Thread")>
		
		<cfset todoDelete(arguments.todoID)>
		<cfset go_to.sleep(1000)>
		<cfset todoAdd(arguments.todoID,arguments.projectID,arguments.task,arguments.userID,arguments.due)>
		
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="todoDelete" access="public" returnType="boolean" output="false"
				hint="Deletes a task.">
		<cfargument name="todoID" type="string" required="false" default="">
		<cfset var q = "">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#" name="q">
			select googlecalid
			from #variables.tableprefix#todos
			where todoid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.todoID#" maxlength="35">	
		</cfquery>
		<cftry>
			<cfset application.gCal.deleteEvent(q.googlecalid)>
			<cfcatch></cfcatch>
		</cftry>
		<cfreturn true>
	</cffunction>

</cfcomponent>
