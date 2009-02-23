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
		<cfargument name="categoryID" type="string" required="false" default="">
		<cfargument name="milestoneID" type="string" required="false" default="">
		<cfargument name="m" type="numeric" required="false" default="0">
		<cfargument name="y" type="numeric" required="false" default="0">
		<cfset var qGetMessages = "">
		<cfquery name="qGetMessages" datasource="#variables.dsn#">
			SELECT u.userID,u.firstName,u.lastName,u.avatar,m.messageID,m.categoryID,m.milestoneID,m.title,m.message,
					m.allowcomments,m.stamp,ms.name,mc.category,
					(SELECT count(commentID) FROM #variables.tableprefix#comments c where m.messageid = c.itemid and type = 'msg') as commentcount,
					(SELECT count(fileID) FROM #variables.tableprefix#file_attach fa where m.messageid = fa.itemid and fa.type = 'msg') as attachcount
			FROM #variables.tableprefix#messages m 
				LEFT JOIN #variables.tableprefix#categories mc ON m.categoryID = mc.categoryID
				LEFT JOIN #variables.tableprefix#users u ON u.userID = m.userID 
				LEFT JOIN #variables.tableprefix#milestones ms ON m.milestoneid = ms.milestoneid
			WHERE m.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				<cfif compare(arguments.messageid,'')> AND m.messageID = 
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35"></cfif>
				<cfif compare(arguments.categoryID,'')> AND m.categoryID = 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" maxlength="35"></cfif>
				<cfif compare(arguments.milestoneID,'')> AND m.milestoneID = 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35"></cfif>
				<cfif arguments.m> AND m.stamp between #createdate(arguments.y,arguments.m,'1')# AND #createDateTime(arguments.y,arguments.m,daysInMonth(createdate(arguments.y,arguments.m,'1')),'23','59','59')#</cfif>
				AND mc.type = 'msg'
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
			SELECT u.userID, u.firstName, u.lastName, u.email, u.mobile,
				un.email_files, un.mobile_files, un.email_issues, un.mobile_issues, un.email_msgs,
				un.mobile_msgs, un.email_mstones, un.mobile_mstones, un.email_todos, un.mobile_todos,
				c.carrier, c.prefix, c.suffix
			FROM #variables.tableprefix#message_notify m
				LEFT JOIN #variables.tableprefix#users u ON m.userID = u.userID
				LEFT JOIN #variables.tableprefix#user_notify un ON u.userID = un.userID
				LEFT JOIN #variables.tableprefix#carriers c ON u.carrierID = c.carrierID
			WHERE m.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND m.messageID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
		</cfquery>
		<cfreturn qGetNotifyList>
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
		<cfset var catID = "">
		<cfset var i = "">
		
		<!--- determine if new category --->
		<cfif request.udf.IsCFUUID(arguments.category)>
			<cfset catID = arguments.category>
		<cfelse>
			<cfset catID = application.category.add(arguments.projectID,arguments.category,'msg')>
		</cfif>
		
		<!--- insert record --->
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#messages (messageID,projectID,title,message,categoryID,milestoneID,allowcomments,userID,stamp)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="120">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.message#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#catID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.allowcomments#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.addedBy#" maxlength="35">,
					#Now()#)
		</cfquery>
		
		<!--- add attached file --->
		<cfif listLen(arguments.filesList)>
			<cfloop list="#arguments.filesList#" index="i">
				<cfset application.file.attachFile(arguments.messageID,i,'msg')>
			</cfloop>
		</cfif>
		
		<!--- set notification list --->
		<cfif not listFind(arguments.notifyList,session.user.userID)>
			<cfset arguments.notifyList = ListAppend(arguments.notifyList,session.user.userID)>
		</cfif>
		<cfloop list="#arguments.notifyList#" index="i">
			<cfset application.message.addNotify(arguments.projectID,arguments.messageID,i)>
		</cfloop>
		
		<!--- send notifications --->
		<cfset application.notify.messageNew(arguments.projectID,arguments.messageID,arguments.notifyList,arguments.addedBy)>
		<cfreturn true>
	</cffunction>	

	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a message.">
		<cfargument name="messageID" type="uuid" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="categoryID" type="string" required="true">
		<cfargument name="message" type="string" required="true">
		<cfargument name="milestoneID" type="string" required="true">
		<cfargument name="allowcomments" type="numeric" required="true">
		<cfargument name="updatedBy" type="uuid" required="true">
		<cfargument name="notifyList" type="string" required="true">
		<cfargument name="filesList" type="string" required="true">
		<cfset var qProject = application.project.get(arguments.projectID)>
		<cfset var qMailUsers = "">
		<cfset var i = "">
		<cfset var mailMessage = "">
		
		<!--- update record --->
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#messages 
				SET title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="120">,
					message = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.message#">,
					categoryid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.categoryID#" maxlength="35">,
					milestoneid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneID#" maxlength="35">,
					allowcomments = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.allowcomments#" maxlength="1">
				WHERE projectid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
					AND messageid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
		</cfquery>
		
		<!--- clear and repopulate message notify list --->
		<cfset application.message.removeNotify(arguments.projectID,arguments.messageID)>
		<cfif listLen(arguments.notifyList)>
			<cfloop list="#arguments.notifyList#" index="i">
				<cfset application.message.addNotify(arguments.projectID,arguments.messageID,i)>
			</cfloop>
		</cfif>

		<!--- clear and repopulate file attach list --->
		<cfset application.file.removeAttachments(arguments.messageID,'msg')>
		<cfif listLen(arguments.filesList)>
			<cfloop list="#arguments.filesList#" index="i">
				<cfset application.file.attachFile(arguments.messageID,i,'msg')>
			</cfloop>
		</cfif>
		
		<!--- send notifications --->
		<cfset application.notify.messageUpdate(arguments.projectID,arguments.messageID,arguments.notifyList,arguments.updatedBy)>
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
			WHERE itemID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#message_notify
			WHERE messageID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#file_attach
			WHERE itemID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.messageID#" maxlength="35">
				AND type = 'msg'
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

	<cffunction name="getCatMsgs" access="public" returnType="query" output="false"
				hint="Returns message categories with msg count.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfset var qGetCategories = "">
		<cfquery name="qGetCategories" datasource="#variables.dsn#">
			SELECT c.categoryID, c.category, count(m.messageID) as numMsgs
			FROM #variables.tableprefix#categories c LEFT JOIN #variables.tableprefix#messages m
				ON c.categoryID = m.categoryID
			WHERE c.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND c.type = 'msg'
			GROUP BY c.categoryID, c.category
			ORDER BY c.category
		</cfquery>
		<cfreturn qGetCategories>
	</cffunction>	

</CFCOMPONENT>
