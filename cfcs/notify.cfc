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
		<cfargument name="type" type="string" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="string" required="true">
		

		<cfmail from="#session.user.email#" to="#email#" subject="New #qProject.name# Comment on #qMessage.title#">A new #qProject.name# message has been posted on the message in #qMessage.category# entitled:
#qMessage.title#

#arguments.comment#

To view the full message and leave comments, visit this link:
#application.settings.rootURL##application.settings.mapping#/message.cfm?p=#arguments.projectID#&m=#arguments.messageID#
			</cfmail>
						
	</cffunction>	
	
</cfcomponent>