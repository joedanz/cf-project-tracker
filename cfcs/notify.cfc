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
		<cfset var theMessage = "">
		
		<cfloop query="qProjectUsers">		
			<cfif email_files and request.udf.isEmail(email)>
				
				<cfsavecontent variable="theMessage">
				<cfoutput>A new #qProject.name# file has been added:
#qFile.title#

Category: #qFile.category#

#request.udf.CleanText(qFile.description)#

To view file details or to download, visit this link:
#application.settings.rootURL##application.settings.mapping#/files.cfm?p=#arguments.projectID#&f=#arguments.fileID#
				</cfoutput>
				</cfsavecontent>
				
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] File in '#qFile.category#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] File in '#qFile.category#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_files and isNumeric(mobile)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>New #qProject.name# file:
#qFile.title#

#Left(request.udf.CleanText(qFile.description),100)#<cfif len(request.udf.CleanText(qFile.description)) gt 100>...</cfif>				
				</cfoutput>
				</cfsavecontent>
				
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] File#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] File#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="fileUpdate" access="public" returnType="void" output="false"
				hint="Notification of updated file.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="fileID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qProjectUsers = application.project.projectUsers(arguments.projectID)>
		<cfset var qFile = application.file.get(arguments.projectID,arguments.fileID)>
		<cfset var theMessage = "">
		<cfloop query="qProjectUsers">		
			<cfif email_files and request.udf.isEmail(email)>
				
				<cfsavecontent variable="theMessage">
				<cfoutput>The following #qProject.name# issue has been updated:
#qFile.title#

Category: #qFile.category#

#request.udf.CleanText(qFile.description)#

To view file details or to download, visit this link:
#application.settings.rootURL##application.settings.mapping#/files.cfm?p=#arguments.projectID#&f=#arguments.fileID#				
				</cfoutput>
				</cfsavecontent>				
				
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] File in '#qFile.category#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] File in '#qFile.category#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_files and isNumeric(mobile)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>Updated #qProject.name# file:
#qFile.title#

#Left(request.udf.CleanText(qFile.description),100)#<cfif len(request.udf.CleanText(qFile.description)) gt 100>...</cfif>
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[Updated] File#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[Updated] File#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
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
		<cfset var theMessage = "">
		<cfloop query="qProjectUsers">		
			<cfif email_issues and request.udf.isEmail(email)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>A new #qProject.name# issue has been added:
#qIssue.issue#

#request.udf.CleanText(qIssue.detail)#

<cfif compare(qIssue.milestone,'')>Milestone: #qIssue.milestone#

</cfif><cfif compare(qIssue.assignedLastName,'')>Assigned To: #qIssue.assignedFirstName# #qIssue.assignedLastName#

</cfif>To view the full issue, visit this link:
#application.settings.rootURL##application.settings.mapping#/issue.cfm?p=#arguments.projectID#&i=#arguments.issueID#
				</cfoutput>
				</cfsavecontent>

				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] Issue - #qIssue.type##IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] Issue - #qIssue.type##IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_issues and isNumeric(mobile)>

				<cfsavecontent variable="theMessage">
				<cfoutput>New #qProject.name# issue:

#Left(request.udf.CleanText(qIssue.issue),100)#<cfif len(request.udf.CleanText(qIssue.issue)) gt 100>...</cfif>				
				</cfoutput>
				</cfsavecontent>
				
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] Issue#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] Issue#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>			
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
		<cfset var theMessage = "">
		<cfloop query="qProjectUsers">		
			<cfif email_issues and request.udf.isEmail(email)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>The following #qProject.name# issue has been updated:
#qIssue.issue#

Status: #qIssue.status#

#request.udf.CleanText(qIssue.detail)#

<cfif compare(qIssue.milestone,'')>Milestone: #qIssue.milestone#

</cfif><cfif compare(qIssue.assignedLastName,'')>Assigned To: #qIssue.assignedFirstName# #qIssue.assignedLastName#

</cfif>To view the full issue, visit this link:
#application.settings.rootURL##application.settings.mapping#/issue.cfm?p=#arguments.projectID#&i=#arguments.issueID#
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] Issue - #qIssue.type##IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] Issue - #qIssue.type##IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_issues and isNumeric(mobile)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>Updated #qProject.name# issue:

#Left(qIssue.issue,100)#<cfif len(qIssue.issue) gt 100>...</cfif>
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[Updated] Issue#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[Updated] Issue#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>			
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
		<cfset var qMailNotifyUsers = application.project.userNotify('',arguments.notifyList,arguments.projectID)>
		<cfset var theMessage = "">
		<cfloop query="qMailNotifyUsers">
			<cfif email_msgs and request.udf.isEmail(email)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput><cfif compare(userID,arguments.addedBy)>A new #qProject.name# message has been posted<cfelse>You have posted a new #qProject.name# message</cfif>:
#qMessage.title#
	
#request.udf.CleanText(qMessage.message)#
	
<cfif compare(qMessage.name,'')>Milestone: #qMessage.name#

</cfif><cfif compare(userID,arguments.addedBy)>To view the full message and leave comments, visit this link:<cfelse>You have 15 minutes from the time of posting to edit the message.
Use the following link to view or edit the message and to make comments:</cfif>
#application.settings.rootURL##application.settings.mapping#/message.cfm?p=#arguments.projectID#&m=#arguments.messageID#
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] Message in '#qMessage.category#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] Message in '#qMessage.category#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_msgs and isNumeric(mobile)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>New #qProject.name# message:
#qMessage.title#
	
#Left(request.udf.CleanText(qMessage.message),100)#<cfif len(request.udf.CleanText(qMessage.message)) gt 100>...</cfif>
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] Message#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] Message#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>			
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="messageUpdate" access="public" returnType="void" output="false"
				hint="Notification of updated message.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="messageID" type="uuid" required="true">
		<cfargument name="notifyList" type="string" required="true">
		<cfargument name="updatedBy" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qMessage = application.message.get(arguments.projectID,arguments.messageID)>
		<cfset var qMailNotifyUsers = application.project.userNotify('',arguments.notifyList,arguments.projectID)>
		<cfset var theMessage = "">
		<cfloop query="qMailNotifyUsers">		
			<cfif email_msgs and request.udf.isEmail(email)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput><cfif compare(userID,arguments.updatedBy)>The following #qProject.name# message has been updated<cfelse>You have updated a #qProject.name# message</cfif>:
#qMessage.title#

#request.udf.CleanText(qMessage.message)#

<cfif compare(qMessage.name,'')>Milestone: #qMessage.name#

</cfif>To view the full issue, visit this link:
#application.settings.rootURL##application.settings.mapping#/message.cfm?p=#arguments.projectID#&m=#arguments.messageID#
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] Message in '#qMessage.category#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] Message in '#qMessage.category#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_msgs and isNumeric(mobile)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>Updated #qProject.name# message:

#Left(request.udf.CleanText(qMessage.message),100)#<cfif len(request.udf.CleanText(qMessage.message)) gt 100>...</cfif>
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[Updated] Message#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[Updated] Message#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>			
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
		<cfset var theMessage = "">
		<cfloop query="qNotifyList">		
			<cfif email_msgs and request.udf.isEmail(email)>
				
				<cfsavecontent variable="theMessage">
				<cfoutput>A new #qProject.name# comment has been posted on the message in #qMessage.category# entitled:
#qMessage.title#

#request.udf.CleanText(arguments.comment)#

To view the full message and leave comments, visit this link:
#application.settings.rootURL##application.settings.mapping#/message.cfm?p=#arguments.projectID#&m=#arguments.messageID#
				</cfoutput>
				</cfsavecontent>
				
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] Comment on '#qMessage.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] Comment on '#qMessage.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_msgs and isNumeric(mobile)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>New comment on: #qMessage.title#

#Left(request.udf.CleanText(arguments.comment),100)#<cfif len(request.udf.CleanText(arguments.comment)) gt 100>...</cfif>
				</cfoutput>
				</cfsavecontent>
				
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] Msg Comment#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] Msg Comment#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>			
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="milestoneNew" access="public" returnType="void" output="false"
				hint="Notification of new milestone.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qProjectUsers = application.project.projectUsers(arguments.projectID)>
		<cfset var qMilestone = application.milestone.get(arguments.projectID,arguments.milestoneID)>
		<cfset var theMessage = "">
		<cfloop query="qProjectUsers">
			<cfif email_mstones and request.udf.isEmail(email)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>A new #qProject.name# milestone has been added:
#qMilestone.name#

#request.udf.CleanText(qMilestone.description)#

<cfif compare(qMilestone.lastName,'')>Assigned To: #qMilestone.firstName# #qMilestone.lastName#

</cfif>To view file details or to download, visit this link:
#application.settings.rootURL##application.settings.mapping#/milestones.cfm?p=#arguments.projectID#&m=#arguments.milestoneID#
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] Milestone#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] Milestone#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_mstones and isNumeric(mobile)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>New #qProject.name# file:
#qMilestone.name#

Due Date: #DateFormat(qMilestone.dueDate,"ddd, mmmm d, yyyy")#

#Left(request.udf.CleanText(qMilestone.description),100)#<cfif len(request.udf.CleanText(qMilestone.description)) gt 100>...</cfif>
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] Milestone#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] Milestone#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>		
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="milestoneUpdate" access="public" returnType="void" output="false"
				hint="Notification of updated milestone.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qProjectUsers = application.project.projectUsers(arguments.projectID)>
		<cfset var qMilestone = application.milestone.get(arguments.projectID,arguments.milestoneID)>
		<cfset var theMessage = "">
		<cfloop query="qProjectUsers">		
			<cfif email_mstones and request.udf.isEmail(email)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>The following #qProject.name# milestone has been updated:
#qMilestone.name#

Due Date: #DateFormat(qMilestone.dueDate,"ddd, mmmm d, yyyy")#

#request.udf.CleanText(qMilestone.description)#

<cfif compare(qMilestone.lastName,'')>Assigned To: #qMilestone.firstName# #qMilestone.lastName#

</cfif>To view file details or to download, visit this link:
#application.settings.rootURL##application.settings.mapping#/milestones.cfm?p=#arguments.projectID#&m=#arguments.milestoneID#
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] Milestone#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] Milestone#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_mstones and isNumeric(mobile)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>Updated #qProject.name# milestone:
#qMilestone.name#

#Left(request.udf.CleanText(qMilestone.description),100)#<cfif len(request.udf.CleanText(qMilestone.description)) gt 100>...</cfif>
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[Updated] Milestone#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[Updated] Milestone#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>			
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="todoNew" access="public" returnType="void" output="false"
				hint="Notification of new todo.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfargument name="todoID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qProjectUsers = application.project.projectUsers(arguments.projectID)>
		<cfset var qTodolist = application.todolist.get(arguments.projectID,arguments.todolistID)>
		<cfset var qTodo = application.todo.get(projectID=arguments.projectID,todolistID=arguments.todolistID,todoID=arguments.todoID)>
		<cfset var theMessage = "">
		<cfloop query="qProjectUsers">		
			<cfif email_todos and request.udf.isEmail(email)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>A new #qProject.name# to-do has been added to list #qTodolist.title#:
#qTodo.task#

<cfif isDate(qTodo.due)>Due Date: #DateFormat(qTodo.due,"ddd, mmmm d, yyyy")#

</cfif>To view file details or to download, visit this link:
#application.settings.rootURL##application.settings.mapping#/todos.cfm?p=#arguments.projectID#&t=#arguments.todolistID#
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] To-Do in '#qTodolist.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] To-Do in '#qTodolist.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_todos and isNumeric(mobile)>
				
				<cfsavecontent variable="theMessage">
				<cfoutput>New #qProject.name# to-do:
#qTodo.task#

List: #qTodolist.title#
				</cfoutput>
				</cfsavecontent>
				
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] To-Do#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[New] To-Do#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>			
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="todoUpdate" access="public" returnType="void" output="false"
				hint="Notification of updated todo.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="todolistID" type="uuid" required="true">
		<cfargument name="todoID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qProjectUsers = application.project.projectUsers(arguments.projectID)>
		<cfset var qTodolist = application.todolist.get(arguments.projectID,arguments.todolistID)>
		<cfset var qTodo = application.todo.get(projectID=arguments.projectID,todolistID=arguments.todolistID,todoID=arguments.todoID)>
		<cfset var theMessage = "">
		<cfloop query="qProjectUsers">		
			<cfif email_todos and request.udf.isEmail(email)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>The following #qProject.name# to-do has been updated in list #qTodolist.title#:
#qTodo.task#

<cfif isDate(qTodo.due)>Due Date: #DateFormat(qTodo.due,"ddd, mmmm d, yyyy")#

</cfif>To view file details or to download, visit this link:
#application.settings.rootURL##application.settings.mapping#/todos.cfm?p=#arguments.projectID#&t=#arguments.todolistID#
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] To-Do in '#qTodolist.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] To-Do in '#qTodolist.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_todos and isNumeric(mobile)>
				
				<cfsavecontent variable="theMessage">
				<cfoutput>Updated #qProject.name# to-do:
#qTodo.task#

List: #qTodolist.title#
				</cfoutput>
				</cfsavecontent>
				
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[Updated] To-Do#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#application.settings.sms_subject_prefix#[Updated] To-Do#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>			
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="add" access="public" returntype="void" output="false"
				hint="Updates a user's notification settings.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="email_files" type="numeric" required="true">
		<cfargument name="mobile_files" type="numeric" required="true">
		<cfargument name="email_issues" type="numeric" required="true">
		<cfargument name="mobile_issues" type="numeric" required="true">
		<cfargument name="email_msgs" type="numeric" required="true">
		<cfargument name="mobile_msgs" type="numeric" required="true">
		<cfargument name="email_mstones" type="numeric" required="true">
		<cfargument name="mobile_mstones" type="numeric" required="true">
		<cfargument name="email_todos" type="numeric" required="true">
		<cfargument name="mobile_todos" type="numeric" required="true">
		
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#user_notify (userID, projectID, email_files, mobile_files,
				email_issues, mobile_issues, email_msgs, mobile_msgs, email_mstones, mobile_mstones, 
				email_todos, mobile_todos)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_files#">, 
					 <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_files#">,
					 <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_issues#">, 
					 <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_issues#">,
					 <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_msgs#">, 
					 <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_msgs#">,
					 <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_mstones#">, 
					 <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_mstones#">,
					 <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_todos#">, 
					 <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_todos#">
					)
		</cfquery>		
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false"
				hint="Updates a user's notification settings.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="email_files" type="numeric" required="true">
		<cfargument name="mobile_files" type="numeric" required="true">
		<cfargument name="email_issues" type="numeric" required="true">
		<cfargument name="mobile_issues" type="numeric" required="true">
		<cfargument name="email_msgs" type="numeric" required="true">
		<cfargument name="mobile_msgs" type="numeric" required="true">
		<cfargument name="email_mstones" type="numeric" required="true">
		<cfargument name="mobile_mstones" type="numeric" required="true">
		<cfargument name="email_todos" type="numeric" required="true">
		<cfargument name="mobile_todos" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#user_notify SET
				email_files = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_files#">, 
				mobile_files = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_files#">,
				email_issues = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_issues#">, 
				mobile_issues = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_issues#">,
				email_msgs = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_msgs#">, 
				mobile_msgs = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_msgs#">,
				email_mstones = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_mstones#">, 
				mobile_mstones = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_mstones#">,
				email_todos = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_todos#">, 
				mobile_todos = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_todos#"> 
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">
				AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">			
		</cfquery>		
	</cffunction>
		
	<cffunction name="remove" access="public" returnType="boolean" output="false"
				hint="Removes user role.">
		<cfargument name="projectID" type="string" required="false" default="">		
		<cfargument name="userID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#user_notify
			WHERE 0=0
				<cfif compare(arguments.projectID,'')>
					AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				</cfif>
				AND userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	

</cfcomponent>