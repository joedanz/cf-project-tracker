<cfcomponent displayName="Notify" hint="Methods dealing with notifications.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="notify" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>

	
	<cffunction name="messageComment" access="public" returnType="void" output="false"
				hint="Notification of new comment.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="string" required="true">
		<cfargument name="comment" type="string" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qMessage = application.message.get(arguments.projectID,arguments.messageID)>
		<cfset var qNotifyList = application.message.getNotifyList(arguments.projectID,arguments.messageID)>
		<cfset var email_subject = "">
		<cfset var mobile_subject = "">
		<cfloop query="qNotifyList">		
			<cfif email_msgs and request.udf.isEmail(email)>
				<cfmail from="#application.settings.adminEmail#" to="#email#" subject="New #IIF(compare(qProject.name,''),'#qProject.name# ','')#Comment on #qMessage.title#">A new #qProject.name# message has been posted on the message in #qMessage.category# entitled:
#qMessage.title#

#arguments.comment#

To view the full message and leave comments, visit this link:
#application.settings.rootURL##application.settings.mapping#/message.cfm?p=#arguments.projectID#&m=#arguments.messageID#
				</cfmail>
			</cfif>
			<cfif mobile_msgs and isNumeric(mobile)>
				<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="New #IIF(compare(qProject.name,''),'#qProject.name# ','')#Msg Comment">New comment on: #qMessage.title#

#Left(request.udf.CleanText(arguments.comment),100)#<cfif len(request.udf.CleanText(arguments.comment)) gt 100>...</cfif>
				</cfmail>			
			</cfif>
		</cfloop>
	</cffunction>	
	
</cfcomponent>