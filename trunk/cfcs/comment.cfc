<cfcomponent displayName="Comments" hint="Methods dealing with message comments.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="comment" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns message comments.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="type" type="string" required="false" default="">
		<cfargument name="itemID" type="string" required="false" default="">	
		<cfargument name="lastOnly" type="boolean" required="false" default="false">
		<cfset var qGetComments = "">
		<cfset var maxRows = -1>
		
		<cfif arguments.lastOnly>
			<cfset maxRows = 1>
		</cfif>
		
		<cfquery name="qGetComments" datasource="#variables.dsn#" maxrows="#maxRows#">
			SELECT c.commentID,c.itemID,c.commentText,c.stamp,u.userID,u.firstName,u.lastName,u.avatar
				FROM #variables.tableprefix#comments c LEFT JOIN #variables.tableprefix#users u	ON c.userid = u.userid
			WHERE c.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			<cfif not compare(arguments.type,'msg')> 
				AND c.itemID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemID#" maxlength="35">
				AND c.type = 'msg'
			<cfelseif not compare(arguments.type,'issue')> 
				AND c.itemID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemID#" maxlength="35">
				AND c.type = 'issue'
			</cfif>
			ORDER BY c.stamp <cfif arguments.lastOnly>desc</cfif>
		</cfquery>
		<cfreturn qGetComments>
	</cffunction>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Add a message comment.">
		<cfargument name="commentID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="type" type="string" required="true">
		<cfargument name="itemID" type="string" required="true">
		<cfargument name="userID" type="uuid" required="true">
		<cfargument name="comment" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#comments (commentID,projectID,type,itemID,userID,commentText,stamp)
				VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.commentID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" maxlength="6">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.itemID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.comment#">,
						#Now()#)
		</cfquery>
		<cfset application.notify.messageComment(arguments.projectID,arguments.itemID,arguments.comment)>		
		<cfreturn true>
	</cffunction>		
	
	<cffunction name="delete" access="public" returnType="boolean" output="false"
				hint="Add a message comment.">
		<cfargument name="userID" type="uuid" required="true">
		<cfargument name="commentID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#comments
				WHERE userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
					AND commentID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.commentID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>			
	
</cfcomponent>