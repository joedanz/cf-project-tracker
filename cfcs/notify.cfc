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

	<cffunction name="fileNew" access="public" returnType="void" output="false"
				hint="Notification of new file.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="fileID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qProjectUsers = application.project.projectUsers(arguments.projectID)>
		<cfset var qFile = application.file.get(arguments.projectID,arguments.fileID)>
		<cfloop query="qProjectUsers">		
			<cfif email_msgs and request.udf.isEmail(email)>
				<cfmail from="#application.settings.adminEmail#" to="#email#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Issue">A new #qProject.name# file has been added:
#qFile.title#

Category: #qFile.category#

#request.udf.CleanText(qFile.description)#

To view file details or to download, visit this link:
#application.settings.rootURL##application.settings.mapping#/issue.cfm?p=#arguments.projectID#&i=#arguments.issueID#
				</cfmail>
			</cfif>
			<cfif mobile_msgs and isNumeric(mobile)>
				<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Issue">New #qProject.name# file:
#qFile.title#

#Left(request.udf.CleanText(qFile.description),100)#<cfif len(request.udf.CleanText(qFile.description)) gt 100>...</cfif>
				</cfmail>			
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="fileUpdate" access="public" returnType="void" output="false"
				hint="Notification of updated file.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="issueID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qProjectUsers = application.project.projectUsers(arguments.projectID)>
		<cfset var qFile = application.file.get(arguments.projectID,arguments.fileID)>
		<cfloop query="qProjectUsers">		
			<cfif email_msgs and request.udf.isEmail(email)>
				<cfmail from="#application.settings.adminEmail#" to="#email#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Issue">The following #qProject.name# issue has been updated:
#qFile.title#

Category: #qFile.category#

#request.udf.CleanText(qFile.description)#

To view file details or to download, visit this link:
#application.settings.rootURL##application.settings.mapping#/issue.cfm?p=#arguments.projectID#&i=#arguments.issueID#
				</cfmail>
			</cfif>
			<cfif mobile_msgs and isNumeric(mobile)>
				<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Issue">Updated #qProject.name# file:
#qFile.title#

#Left(request.udf.CleanText(qFile.description),100)#<cfif len(request.udf.CleanText(qFile.description)) gt 100>...</cfif>
				</cfmail>			
			</cfif>
		</cfloop>
	</cffunction>	

	<cffunction name="issueNew" access="public" returnType="void" output="false"
				hint="Notification of new issue.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="issueID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qProjectUsers = application.project.projectUsers(arguments.projectID)>
		<cfset var qIssue = application.issue.get(arguments.projectID,arguments.issueID)>
		<cfloop query="qProjectUsers">		
			<cfif email_msgs and request.udf.isEmail(email)>
				<cfmail from="#application.settings.adminEmail#" to="#email#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Issue">A new #qProject.name# issue has been added:
#qIssue.issue#

#request.udf.CleanText(qIssue.detail)#

<cfif compare(qIssue.milestone,'')>Milestone: #qIssue.milestone#

</cfif><cfif compare(qIssue.assignedLastName,'')>Assigned To: #qIssue.assignedFirstName# #qIssue.assignedLastName#

</cfif>To view the full issue, visit this link:
#application.settings.rootURL##application.settings.mapping#/issue.cfm?p=#arguments.projectID#&i=#arguments.issueID#
				</cfmail>
			</cfif>
			<cfif mobile_msgs and isNumeric(mobile)>
				<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Issue">New #qProject.name# issue:

#Left(request.udf.CleanText(qIssue.issue),100)#<cfif len(request.udf.CleanText(qIssue.issue)) gt 100>...</cfif>
				</cfmail>			
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="issueUpdate" access="public" returnType="void" output="false"
				hint="Notification of updated issue.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="issueID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qProjectUsers = application.project.projectUsers(arguments.projectID)>
		<cfset var qIssue = application.issue.get(arguments.projectID,arguments.issueID)>
		<cfloop query="qProjectUsers">		
			<cfif email_msgs and request.udf.isEmail(email)>
				<cfmail from="#application.settings.adminEmail#" to="#email#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Issue">The following #qProject.name# issue has been updated:
#qIssue.issue#

#request.udf.CleanText(qIssue.detail)#

<cfif compare(qIssue.milestone,'')>Milestone: #qIssue.milestone#

</cfif><cfif compare(qIssue.assignedLastName,'')>Assigned To: #qIssue.assignedFirstName# #qIssue.assignedLastName#

</cfif>To view the full issue, visit this link:
#application.settings.rootURL##application.settings.mapping#/issue.cfm?p=#arguments.projectID#&i=#arguments.issueID#
				</cfmail>
			</cfif>
			<cfif mobile_msgs and isNumeric(mobile)>
				<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Issue">Updated #qProject.name# issue:

#Left(qIssue.issue,100)#<cfif len(qIssue.issue) gt 100>...</cfif>
				</cfmail>			
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="messageNew" access="public" returnType="void" output="false"
				hint="Notification of new message.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="uuid" required="true">
		<cfargument name="notifyList" type="string" required="true">
		<cfargument name="addedBy" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qMessage = application.message.get(arguments.projectID,arguments.messageID)>
		<cfset var qMailNotifyUsers = application.user.get('',arguments.notifyList)>
		<cfloop query="qMailNotifyUsers">
			<cfif email_msgs and request.udf.isEmail(email)>
				<cfmail from="#application.settings.adminEmail#" to="#email#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Message"><cfif compare(userID,arguments.addedBy)>A new #qProject.name# message has been posted<cfelse>You have posted a new #qProject.name# message</cfif>:
#qMessage.title#
	
#request.udf.CleanText(qMessage.message)#
	
<cfif compare(qMessage.name,'')>Milestone: #qMessage.name#

</cfif><cfif compare(userID,arguments.addedBy)>To view the full message and leave comments, visit this link:<cfelse>You have 15 minutes from the time of posting to edit the message.
Use the following link to view or edit the message and to make comments:</cfif>
#application.settings.rootURL##application.settings.mapping#/issue.cfm?p=#arguments.projectID#&m=#arguments.messageID#
					</cfmail>
			</cfif>
			<cfif mobile_msgs and isNumeric(mobile)>
				<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Message">New #qProject.name# message:
#qMessage.title#
	
#Left(request.udf.CleanText(qMessage.message),100)#<cfif len(request.udf.CleanText(qMessage.message)) gt 100>...</cfif>
				</cfmail>			
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="messageUpdate" access="public" returnType="void" output="false"
				hint="Notification of updated message.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qProjectUsers = application.project.projectUsers(arguments.projectID)>
		<cfset var qMessage = application.message.get(arguments.projectID,arguments.messageID)>
		<cfloop query="qProjectUsers">		
			<cfif email_msgs and request.udf.isEmail(email)>
				<cfmail from="#application.settings.adminEmail#" to="#email#" subject="Updated #IIF(compare(qProject.name,''),'##qProject.name## ','')#Message">The following #qProject.name# message has been updated:
#qMessage.title#

#request.udf.CleanText(qMessage.message)#

<cfif compare(qMessage.name,'')>Milestone: #qMessage.name#

</cfif>To view the full issue, visit this link:
#application.settings.rootURL##application.settings.mapping#/issue.cfm?p=#arguments.projectID#&m=#arguments.messageID#
				</cfmail>
			</cfif>
			<cfif mobile_msgs and isNumeric(mobile)>
				<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="Updated #IIF(compare(qProject.name,''),'##qProject.name## ','')#Message">Updated #qProject.name# message:

#Left(request.udf.CleanText(qMessage.message),100)#<cfif len(request.udf.CleanText(qMessage.message)) gt 100>...</cfif>
				</cfmail>			
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="messageComment" access="public" returnType="void" output="false"
				hint="Notification of new comment.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="string" required="true">
		<cfargument name="comment" type="string" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qMessage = application.message.get(arguments.projectID,arguments.messageID)>
		<cfset var qNotifyList = application.message.getNotifyList(arguments.projectID,arguments.messageID)>
		<cfloop query="qNotifyList">		
			<cfif email_msgs and request.udf.isEmail(email)>
				<cfmail from="#application.settings.adminEmail#" to="#email#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Comment on #qMessage.title#">A new #qProject.name# message has been posted on the message in #qMessage.category# entitled:
#qMessage.title#

#request.udf.CleanText(arguments.comment)#

To view the full message and leave comments, visit this link:
#application.settings.rootURL##application.settings.mapping#/message.cfm?p=#arguments.projectID#&m=#arguments.messageID#
				</cfmail>
			</cfif>
			<cfif mobile_msgs and isNumeric(mobile)>
				<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="New #IIF(compare(qProject.name,''),'##qProject.name## ','')#Msg Comment">New comment on: #qMessage.title#

#Left(request.udf.CleanText(arguments.comment),100)#<cfif len(request.udf.CleanText(arguments.comment)) gt 100>...</cfif>
				</cfmail>			
			</cfif>
		</cfloop>
	</cffunction>
	
</cfcomponent>