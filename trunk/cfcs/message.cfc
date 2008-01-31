<cfcomponent displayName="Messages" hint="Methods dealing with project messages.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="message" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns messages.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="string" required="false" default="">
		<cfargument name="category" type="string" required="false" default="">
		<cfargument name="milestoneID" type="string" required="false" default="">
		<cfargument name="m" type="numeric" required="false" default="0">
		<cfargument name="y" type="numeric" required="false" default="0">
		<cfset var qGetMessages = "">
		<cfquery name="qGetMessages" datasource="#variables.dsn#">
			SELECT u.userID,u.firstName,u.lastName,u.avatar,m.messageID,m.milestoneid,m.title,m.message,m.category,
					m.allowcomments,m.stamp,ms.name,
					(SELECT count(commentID) FROM #variables.tableprefix#comments c where m.messageid = c.messageid) as commentcount,
					(SELECT count(fileID) FROM #variables.tableprefix#message_files mf where m.messageid = mf.messageid) as attachcount
			FROM #variables.tableprefix#messages m LEFT JOIN #variables.tableprefix#users u
				ON u.userID = m.userID LEFT JOIN #variables.tableprefix#milestones ms
				ON m.milestoneid = ms.milestoneid
			WHERE m.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				<cfif compare(arguments.messageid,'')> AND m.messageID = 
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35"></cfif>
				<cfif compare(arguments.category,'')> AND m.category = 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#"></cfif>
				<cfif compare(arguments.milestoneID,'')> AND m.milestoneID = 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35"></cfif>
				<cfif arguments.m> AND m.stamp between #createdate(arguments.y,arguments.m,'1')# AND #createDateTime(arguments.y,arguments.m,daysInMonth(createdate(arguments.y,arguments.m,'1')),'23','59','59')#</cfif>
			ORDER BY m.stamp desc
		</cfquery>
		<cfreturn qGetMessages>
	</cffunction>
	
	<cffunction name="getNotifyList" access="public" returnType="query" output="false"
				hint="Returns notify list for a message.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="string" required="false" default="">
		<cfset var qGetNotifyList = "">
		<cfquery name="qGetNotifyList" datasource="#variables.dsn#">
			SELECT u.userID,u.firstName,u.lastName,u.email,u.mobile,
				u.email_files, u.mobile_files, u.email_issues, u.mobile_issues, u.email_msgs,
				u.mobile_msgs, u.email_mstones, u.mobile_mstones, u.email_todos, u.mobile_todos,
				c.carrier,c.prefix,c.suffix
			FROM #variables.tableprefix#message_notify m
				LEFT JOIN #variables.tableprefix#users u ON m.userID = u.userID
				LEFT JOIN #variables.tableprefix#carriers c ON u.carrierID = c.carrierID
			WHERE m.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND m.messageID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
		</cfquery>
		<cfreturn qGetNotifyList>
	</cffunction>
	
	<cffunction name="getFileList" access="public" returnType="query" output="false"
				hint="Returns files associated with a message.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="uuid" required="true">
		<cfset var qGetFileList = "">
		<cfquery name="qGetFileList" datasource="#variables.dsn#">
			SELECT f.fileID,f.title,f.filetype,f.filename,f.serverfilename,f.filesize,f.category,f.uploaded
			FROM #variables.tableprefix#message_files mf
				LEFT JOIN #variables.tableprefix#files f ON mf.fileID = f.fileID
			WHERE f.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND mf.messageID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
		</cfquery>
		<cfreturn qGetFileList>
	</cffunction>	
	
	<cffunction name="categories" access="public" returnType="query" output="false"
				hint="Returns message categories.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfset var qGetCategories = "">
		<cfquery name="qGetCategories" datasource="#variables.dsn#">
			SELECT distinct category FROM #variables.tableprefix#messages
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			ORDER BY category
		</cfquery>
		<cfreturn qGetCategories>
	</cffunction>	
	
	<cffunction name="milestones" access="public" returnType="query" output="false"
				hint="Returns message milestones.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfset var qGetMilestones = "">
		<cfquery name="qGetMilestones" datasource="#variables.dsn#">
			SELECT distinct ms.milestoneid, ms.name 
			FROM #variables.tableprefix#messages m LEFT JOIN #variables.tableprefix#milestones ms
					ON m.milestoneid = ms.milestoneid
			WHERE m.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND ms.name != ''
		</cfquery>
		<cfreturn qGetMilestones>
	</cffunction>	
	
	<cffunction name="dates" access="public" returnType="query" output="false"
				hint="Returns message dates.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfset var qGetDates = "">
		<cfquery name="qGetDates" datasource="#variables.dsn#">
			SELECT distinct month(stamp) as m, year(stamp) as y
			FROM #variables.tableprefix#messages
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn qGetDates>
	</cffunction>		

	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Adds a message.">
		<cfargument name="messageID" type="uuid" required="true">					
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="category" type="string" required="true">
		<cfargument name="message" type="string" required="true">
		<cfargument name="milestoneID" type="string" required="true">
		<cfargument name="allowcomments" type="numeric" required="true">
		<cfargument name="addedBy" type="uuid" required="true">
		<cfargument name="notifyList" type="string" required="true">
		<cfargument name="filesList" type="string" required="true">
		<cfset var qMailUsers = "">
		<cfset var qProject = "">
		<cfset var sText = "">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#messages (messageID,projectID,title,message,category,milestoneid,allowcomments,userid,stamp)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="120">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.message#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.allowcomments#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.addedBy#" maxlength="35">,
					#Now()#)
		</cfquery>
		<cfif listLen(arguments.filesList)>
			<cfloop list="#arguments.filesList#" index="i">
				<cfset application.message.addFile(arguments.messageID,i)>
			</cfloop>
		</cfif>
		<cfif listLen(arguments.notifyList)>
			<cfset qMailUsers = application.user.get('',ListAppend(arguments.notifyList,arguments.addedBy))>
			<cfset qProject = application.project.get(arguments.projectID)>
			<cfset sText = htmlCodeFormat(arguments.message)>
			<cfset sText = reReplace(sText, "<[^>]*>", "", "all")>
			<cfset sText = replaceNoCase(sText,"&nbsp;","","ALL")>
			<cfloop query="qMailUsers">
				<cfset application.message.addNotify(arguments.messageID,arguments.projectID,userID)>
				<cfif compare(userID,session.user.userID)> <!--- don't send to message creator --->
					<cfmail from="#session.user.email#" to="#email#" subject="New #qProject.name# Message: #arguments.title#">A new #qProject.name# message has been posted in category #arguments.category# entitled:
#arguments.title#
	
#sText#
	
To view the full message and leave comments, visit this link:
#application.settings.rootURL##application.settings.mapping#/message.cfm?p=#arguments.projectID#&m=#arguments.messageID#
					</cfmail>
				</cfif>
			</cfloop>
		</cfif>
		<cfif not listFind(arguments.notifyList,session.user.userID)>
			<cfset application.message.addNotify(arguments.projectID,arguments.messageID,session.user.userID)>
		</cfif>
		<cfreturn true>
	</cffunction>	

	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a message.">
		<cfargument name="messageID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="category" type="string" required="true">
		<cfargument name="message" type="string" required="true">
		<cfargument name="milestoneID" type="string" required="true">
		<cfargument name="allowcomments" type="numeric" required="true">
		<cfargument name="notifyList" type="string" required="true">
		<cfargument name="filesList" type="string" required="true">
		<cfset var qProject = application.project.get(arguments.projectID)>
		<cfset var qMailUsers = "">
		
		<!--- clear and repopulate message notify list --->
		<cfset application.message.removeNotify(arguments.projectID,arguments.messageID)>
		<cfif listLen(arguments.notifyList)>
			<cfloop list="#arguments.notifyList#" index="i">
				<cfset application.message.addNotify(arguments.projectID,arguments.messageID,i)>
			</cfloop>
		</cfif>
		
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#messages 
				SET title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="120">,
					message = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.message#">,
					category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#" maxlength="50">,
					milestoneid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">,
					allowcomments = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.allowcomments#" maxlength="1">
				WHERE projectid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
					AND messageid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
		</cfquery>

		<cfset qMailUsers = application.message.getNotify(arguments.projectID,arguments.messageID)>
		<cfloop query="qMailUsers">
			<cfif compare(userID,session.user.userID)> <!--- don't notify message updater --->
				<cfmail from="#session.user.email#" to="#email#" subject="#qProject.name# Message Updated">The message entitled #arguments.title# has been updated:

To view the full message and leave comments, visit this link:
#application.settings.rootURL##application.settings.mapping#/message.cfm?p=#arguments.projectID#&m=#arguments.messageID#
				</cfmail>
			</cfif>
		</cfloop>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="delete" access="public" returnType="boolean" output="false"
				hint="Deletes a message.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#messages
			WHERE messageID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#comments
			WHERE messageID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#message_notify
			WHERE messageID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#message_files
			WHERE messageID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
		</cfquery>
		<cfset application.activity.delete(arguments.projectID,'Message',arguments.messageID)>		
		<cfreturn true>
	</cffunction>		

	<cffunction name="addNotify" access="public" returnType="boolean" output="false"
				hint="Adds message notification for a user.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="uuid" required="true">
		<cfargument name="userID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#message_notify (messageID,projectID,userID)
				VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#userID#" maxlength="35">)
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="addFile" access="public" returnType="boolean" output="false"
				hint="Adds message notification for a user.">
		<cfargument name="messageID" type="uuid" required="true">
		<cfargument name="fileID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#message_files (messageID,fileID)
				VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">)
		</cfquery>
		<cfreturn true>
	</cffunction>	

	<cffunction name="getNotify" access="public" returnType="query" output="false"
				hint="Gets users for message notification.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="uuid" required="true">
		<cfset var qGetNotify = "">
		<cfquery name="qGetNotify" datasource="#variables.dsn#">
			SELECT u.userID,u.email FROM #variables.tableprefix#message_notify mn
				LEFT JOIN #variables.tableprefix#users u ON mn.userID = u.userID
			WHERE messageID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn qGetNotify>
	</cffunction>		

	<cffunction name="removeNotify" access="public" returnType="boolean" output="false"
				hint="Deletes a message notification.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="uuid" required="true">
		<cfargument name="userID" type="string" required="false" default="">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#message_notify
			WHERE messageID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				<cfif compare(arguments.userID,'')>
					AND userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
				</cfif>
		</cfquery>
		<cfreturn true>
	</cffunction>		

</CFCOMPONENT>
