<cfcomponent displayName="Notify" hint="Methods dealing with notifications.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="notify" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
				
		<cfreturn this>
	</cffunction>

	<cffunction name="comment" access="public" returnType="void" output="false"
				hint="Notification of new comment.">
		<cfargument name="type" type="string" required="true">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="itemID" type="uuid" required="true">
		<cfargument name="commentID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qComment = application.comment.get(projectID=arguments.projectID,itemID=arguments.commentID)>
		<cfset var qItem = "">
		<cfset var qNotifyList = "">
		<cfset var theMessage = "">
		<cfset var emailSubject = "">
		<cfset var mobileSubject = "">
		
		<cfif not compare(arguments.type,'msg')>	
			<cfset qItem = application.message.get(arguments.projectID,arguments.itemID)>
			<cfset qNotifyList = application.message.getNotifyList(arguments.projectID,arguments.itemID)>
		<cfelse>
			<cfswitch expression="#arguments.type#">
				<cfcase value="issue">
					<cfset qItem = application.issue.get(arguments.projectID,arguments.itemID)>
				</cfcase>
				<cfcase value="file">
					<cfset qItem = application.file.get(arguments.projectID,arguments.itemID)>
				</cfcase>
				<cfcase value="mstone">
					<cfset qItem = application.milestone.get(arguments.projectID,arguments.itemID)>
				</cfcase>
				<cfcase value="todo">
					<cfset qItem = application.todo.get(projectID=arguments.projectID,todoID=arguments.itemID,fullJoin='true')>
				</cfcase>				
			</cfswitch>
			<cfset qNotifyList = application.project.projectUsers(arguments.projectID)>
		</cfif>
		<cfloop query="qNotifyList">		
			<cfif ((not compare(arguments.type,'msg') and email_msg_com) or (not compare(arguments.type,'issue') and email_issue_com) or (not compare(arguments.type,'file') and email_file_com) or (not compare(arguments.type,'mstone') and email_mstone_com) or (not compare(arguments.type,'todo') and email_todo_com)) and request.udf.isEmail(email)>
				
				<cfsavecontent variable="theMessage">
				<cfoutput>A new comment has been posted on the #qProject.name# <cfswitch expression="#arguments.type#">
					<cfcase value="msg">message in #qItem.category# entitled:
#qItem.title#</cfcase>
					<cfcase value="issue">issue entitled:
#qItem.issue#</cfcase>
					<cfcase value="file">file in #qItem.category# entitled:
#qItem.title#</cfcase>
					<cfcase value="mstone">milestone entitled:
#qItem.name#</cfcase>
					<cfcase value="todo">to-do on list #qItem.title# entitled:
#qItem.task#</cfcase>
				</cfswitch>

#request.udf.CleanText(qComment.commentText)#
<cfswitch expression="#arguments.type#">
	<cfcase value="msg">
To view the message and leave comments, visit this link:
#application.settings.rootURL##application.settings.mapping#/message.cfm?p=#arguments.projectID#&m=#arguments.itemID#
	</cfcase>
	<cfcase value="issue">
To view the issue and leave comments, visit this link:
#application.settings.rootURL##application.settings.mapping#/issue.cfm?p=#arguments.projectID#&i=#arguments.itemID#
	</cfcase>
	<cfcase value="file">
To view the file and leave comments, visit this link:
#application.settings.rootURL##application.settings.mapping#/files.cfm?p=#arguments.projectID#&f=#arguments.itemID#
	</cfcase>
	<cfcase value="mstone">
To view the milestone and leave comments, visit this link:
#application.settings.rootURL##application.settings.mapping#/milestones.cfm?p=#arguments.projectID#&m=#arguments.itemID#
	</cfcase>
	<cfcase value="todo">
To view the to-do and leave comments, visit this link:
#application.settings.rootURL##application.settings.mapping#/todo.cfm?p=#arguments.projectID#&t=#arguments.itemID#
	</cfcase>
</cfswitch>
				</cfoutput>
				</cfsavecontent>
				
				<cfswitch expression="#arguments.type#">
					<cfcase value="msg">
						<cfset emailSubject = "#application.settings.email_subject_prefix#[Comment] on Message '#qItem.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">
					</cfcase>
					<cfcase value="issue">
						<cfset emailSubject = "#application.settings.email_subject_prefix#[Comment] on Issue '#qItem.issue#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">
					</cfcase>
					<cfcase value="file">
						<cfset emailSubject = "#application.settings.email_subject_prefix#[Comment] on File '#qItem.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">
					</cfcase>
					<cfcase value="mstone">
						<cfset emailSubject = "#application.settings.email_subject_prefix#[Comment] on Milestone '#qItem.name#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">
					</cfcase>
					<cfcase value="todo">
						<cfset emailSubject = "#application.settings.email_subject_prefix#[Comment] on To-Do '#qItem.task#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">
					</cfcase>
				</cfswitch>
				
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#emailSubject#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#emailSubject#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif ((not compare(arguments.type,'msg') and mobile_msg_com) or (not compare(arguments.type,'issue') and mobile_issue_com) or (not compare(arguments.type,'file') and mobile_file_com) or (not compare(arguments.type,'mstone') and mobile_mstone_com) or (not compare(arguments.type,'todo') and mobile_todo_com)) and isNumeric(mobile)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>New comment on <cfswitch expression="#arguments.type#">
					<cfcase value="msg">message: #qItem.title#</cfcase>
					<cfcase value="issue">issue: #qItem.issue#</cfcase>
					<cfcase value="file">file: #qItem.title#</cfcase>
					<cfcase value="mstone">milestone: #qItem.name#</cfcase>
					<cfcase value="todo">to-do: #qItem.task#</cfcase>
				</cfswitch>

#Left(request.udf.CleanText(arguments.comment),100)#<cfif len(request.udf.CleanText(arguments.comment)) gt 100>...</cfif>
				</cfoutput>
				</cfsavecontent>
				
				<cfswitch expression="#arguments.type#">
					<cfcase value="msg">
						<cfset mobileSubject = "#application.settings.sms_subject_prefix#[Comment] on Message#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">
					</cfcase>
					<cfcase value="issue">
						<cfset mobileSubject = "#application.settings.sms_subject_prefix#[Comment] on Issue#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">
					</cfcase>
					<cfcase value="file">
						<cfset mobileSubject = "#application.settings.sms_subject_prefix#[Comment] on File#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">
					</cfcase>
					<cfcase value="mstone">
						<cfset mobileSubject = "#application.settings.sms_subject_prefix#[Comment] on Milestone#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">
					</cfcase>
					<cfcase value="todo">
						<cfset mobileSubject = "#application.settings.sms_subject_prefix#[Comment] on To-Do#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">
					</cfcase>
				</cfswitch>
				
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" 
							to="#prefix##mobile##suffix#" subject="#mobileSubject#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#prefix##mobile##suffix#" subject="#mobileSubject#" server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>			
			</cfif>
		</cfloop>
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
			<cfif email_file_new and request.udf.isEmail(email)>
				
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
			<cfif mobile_file_new and isNumeric(mobile)>
			
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
			<cfif email_file_upd and request.udf.isEmail(email)>
				
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
			<cfif mobile_file_upd and isNumeric(mobile)>
			
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
			<cfif email_issue_new and request.udf.isEmail(email)>
			
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
			<cfif mobile_issue_new and isNumeric(mobile)>

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
			<cfif email_issue_upd and request.udf.isEmail(email)>
			
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
			<cfif mobile_issue_new and isNumeric(mobile)>
			
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
			<cfif email_msg_new and request.udf.isEmail(email)>
			
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
			<cfif mobile_msg_new and isNumeric(mobile)>
			
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
			<cfif email_msg_upd and request.udf.isEmail(email)>
			
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
			<cfif mobile_msg_upd and isNumeric(mobile)>
			
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

	<cffunction name="milestoneNew" access="public" returnType="void" output="false"
				hint="Notification of new milestone.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="milestoneID" type="uuid" required="true">
		<cfset var qProject = application.project.get('',arguments.projectID)>
		<cfset var qProjectUsers = application.project.projectUsers(arguments.projectID)>
		<cfset var qMilestone = application.milestone.get(arguments.projectID,arguments.milestoneID)>
		<cfset var theMessage = "">
		<cfloop query="qProjectUsers">
			<cfif email_mstone_new and request.udf.isEmail(email)>
			
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
			<cfif mobile_mstone_new and isNumeric(mobile)>
			
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
			<cfif email_mstone_upd and request.udf.isEmail(email)>
			
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
			<cfif mobile_mstone_upd and isNumeric(mobile)>
			
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
			<cfif email_todo_new and request.udf.isEmail(email)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>A new #qProject.name# to-do has been added to list #qTodolist.title#:
#qTodo.task#

<cfif isDate(qTodo.due)>Due Date: #DateFormat(qTodo.due,"ddd, mmmm d, yyyy")#

</cfif>To view file details or to download, visit this link:
#application.settings.rootURL##application.settings.mapping#/todo.cfm?p=#arguments.projectID#&t=#arguments.todoID#
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] To-Do in '#qTodolist.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[New] To-Do in '#qTodolist.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_todo_new and isNumeric(mobile)>
				
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
			<cfif email_todo_upd and request.udf.isEmail(email)>
			
				<cfsavecontent variable="theMessage">
				<cfoutput>The following #qProject.name# to-do has been updated in list #qTodolist.title#:
#qTodo.task#

<cfif isDate(qTodo.due)>Due Date: #DateFormat(qTodo.due,"ddd, mmmm d, yyyy")#

</cfif>To view file details or to download, visit this link:
#application.settings.rootURL##application.settings.mapping#/todos.cfm?p=#arguments.projectID#&t=#arguments.todoID#
				</cfoutput>
				</cfsavecontent>
			
				<cfif not compare(application.settings.mailServer,'')>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] To-Do in '#qTodolist.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#">#theMessage#</cfmail>
				<cfelse>
					<cfmail from="#application.settings.adminEmail#" to="#email#" subject="#application.settings.email_subject_prefix#[Updated] To-Do in '#qTodolist.title#'#IIF(compare(qProject.name,''),DE(' (##qProject.name##)'),'')#"
						server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
				</cfif>
			</cfif>
			<cfif mobile_todo_upd and isNumeric(mobile)>
				
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
		<cfargument name="email_file_new" type="numeric" required="false" default="0">
		<cfargument name="mobile_file_new" type="numeric" required="false" default="0">
		<cfargument name="email_file_upd" type="numeric" required="false" default="0">
		<cfargument name="mobile_file_upd" type="numeric" required="false" default="0">
		<cfargument name="email_file_com" type="numeric" required="false" default="0">
		<cfargument name="mobile_file_com" type="numeric" required="false" default="0">
		<cfargument name="email_issue_new" type="numeric" required="false" default="0">
		<cfargument name="mobile_issue_new" type="numeric" required="false" default="0">
		<cfargument name="email_issue_upd" type="numeric" required="false" default="0">
		<cfargument name="mobile_issue_upd" type="numeric" required="false" default="0">
		<cfargument name="email_issue_com" type="numeric" required="false" default="0">
		<cfargument name="mobile_issue_com" type="numeric" required="false" default="0">		
		<cfargument name="email_msg_new" type="numeric" required="false" default="0">
		<cfargument name="mobile_msg_new" type="numeric" required="false" default="0">
		<cfargument name="email_msg_upd" type="numeric" required="false" default="0">
		<cfargument name="mobile_msg_upd" type="numeric" required="false" default="0">
		<cfargument name="email_msg_com" type="numeric" required="false" default="0">
		<cfargument name="mobile_msg_com" type="numeric" required="false" default="0">
		<cfargument name="email_mstone_new" type="numeric" required="false" default="0">
		<cfargument name="mobile_mstone_new" type="numeric" required="false" default="0">
		<cfargument name="email_mstone_upd" type="numeric" required="false" default="0">
		<cfargument name="mobile_mstone_upd" type="numeric" required="false" default="0">
		<cfargument name="email_mstone_com" type="numeric" required="false" default="0">
		<cfargument name="mobile_mstone_com" type="numeric" required="false" default="0">
		<cfargument name="email_todo_new" type="numeric" required="false" default="0">
		<cfargument name="mobile_todo_new" type="numeric" required="false" default="0">
		<cfargument name="email_todo_upd" type="numeric" required="false" default="0">
		<cfargument name="mobile_todo_upd" type="numeric" required="false" default="0">
		<cfargument name="email_todo_com" type="numeric" required="false" default="0">
		<cfargument name="mobile_todo_com" type="numeric" required="false" default="0">
		<cfargument name="email_time_new" type="numeric" required="false" default="0">
		<cfargument name="mobile_time_new" type="numeric" required="false" default="0">
		<cfargument name="email_time_upd" type="numeric" required="false" default="0">
		<cfargument name="mobile_time_upd" type="numeric" required="false" default="0">
		<cfargument name="email_bill_new" type="numeric" required="false" default="0">
		<cfargument name="mobile_bill_new" type="numeric" required="false" default="0">
		<cfargument name="email_bill_upd" type="numeric" required="false" default="0">
		<cfargument name="mobile_bill_upd" type="numeric" required="false" default="0">
		<cfargument name="email_bill_paid" type="numeric" required="false" default="0">
		<cfargument name="mobile_bill_paid" type="numeric" required="false" default="0">
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#user_notify (userID, projectID, email_file_new, mobile_file_new,
				email_file_upd, mobile_file_upd, email_file_com, mobile_file_com, email_issue_new, mobile_issue_new,
				email_issue_upd, mobile_issue_upd, email_issue_com, mobile_issue_com, email_msg_new, mobile_msg_new,
				email_msg_upd, mobile_msg_upd, email_msg_com, mobile_msg_com, email_mstone_new, mobile_mstone_new,
				email_mstone_upd, mobile_mstone_upd, email_mstone_com, mobile_mstone_com, email_todo_new, 
				mobile_todo_new, email_todo_upd, mobile_todo_upd, email_todo_com, mobile_todo_com,
				email_time_new, mobile_time_new, email_time_upd, mobile_time_upd, email_bill_new, 
				mobile_bill_new, email_bill_upd, mobile_bill_upd, email_bill_paid, mobile_bill_paid)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_file_new#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_file_new#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_file_upd#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_file_upd#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_file_com#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_file_com#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_issue_new#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_issue_new#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_issue_upd#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_issue_upd#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_issue_com#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_issue_com#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_msg_new#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_msg_new#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_msg_upd#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_msg_upd#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_msg_com#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_msg_com#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_mstone_new#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_mstone_new#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_mstone_upd#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_mstone_upd#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_mstone_com#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_mstone_com#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_todo_new#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_todo_new#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_todo_upd#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_todo_upd#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_todo_com#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_todo_com#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_time_new#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_time_new#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_time_upd#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_time_upd#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_bill_new#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_bill_new#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_bill_upd#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_bill_upd#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_bill_paid#">, 
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_bill_paid#">
					)
		</cfquery>		
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false"
				hint="Sets notifications for a project user.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="email_file_new" type="numeric" required="true">
		<cfargument name="mobile_file_new" type="numeric" required="true">
		<cfargument name="email_file_upd" type="numeric" required="true">
		<cfargument name="mobile_file_upd" type="numeric" required="true">
		<cfargument name="email_file_com" type="numeric" required="true">
		<cfargument name="mobile_file_com" type="numeric" required="true">
		<cfargument name="email_issue_new" type="numeric" required="true">
		<cfargument name="mobile_issue_new" type="numeric" required="true">
		<cfargument name="email_issue_upd" type="numeric" required="true">
		<cfargument name="mobile_issue_upd" type="numeric" required="true">
		<cfargument name="email_issue_com" type="numeric" required="true">
		<cfargument name="mobile_issue_com" type="numeric" required="true">		
		<cfargument name="email_msg_new" type="numeric" required="true">
		<cfargument name="mobile_msg_new" type="numeric" required="true">
		<cfargument name="email_msg_upd" type="numeric" required="true">
		<cfargument name="mobile_msg_upd" type="numeric" required="true">
		<cfargument name="email_msg_com" type="numeric" required="true">
		<cfargument name="mobile_msg_com" type="numeric" required="true">
		<cfargument name="email_mstone_new" type="numeric" required="true">
		<cfargument name="mobile_mstone_new" type="numeric" required="true">
		<cfargument name="email_mstone_upd" type="numeric" required="true">
		<cfargument name="mobile_mstone_upd" type="numeric" required="true">
		<cfargument name="email_mstone_com" type="numeric" required="true">
		<cfargument name="mobile_mstone_com" type="numeric" required="true">
		<cfargument name="email_todo_new" type="numeric" required="true">
		<cfargument name="mobile_todo_new" type="numeric" required="true">
		<cfargument name="email_todo_upd" type="numeric" required="true">
		<cfargument name="mobile_todo_upd" type="numeric" required="true">
		<cfargument name="email_todo_com" type="numeric" required="true">
		<cfargument name="mobile_todo_com" type="numeric" required="true">
		<cfargument name="email_time_new" type="numeric" required="true">
		<cfargument name="mobile_time_new" type="numeric" required="true">
		<cfargument name="email_time_upd" type="numeric" required="true">
		<cfargument name="mobile_time_upd" type="numeric" required="true">
		<cfargument name="email_bill_new" type="numeric" required="true">
		<cfargument name="mobile_bill_new" type="numeric" required="true">
		<cfargument name="email_bill_upd" type="numeric" required="true">
		<cfargument name="mobile_bill_upd" type="numeric" required="true">
		<cfargument name="email_bill_paid" type="numeric" required="true">
		<cfargument name="mobile_bill_paid" type="numeric" required="true">
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#user_notify
			SET email_file_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_file_new#" maxlength="1">,
				mobile_file_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_file_new#" maxlength="1">,
				email_file_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_file_upd#" maxlength="1">,
				mobile_file_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_file_upd#" maxlength="1">,
				email_file_com = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_file_com#" maxlength="1">,
				mobile_file_com = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_file_com#" maxlength="1">,
				email_issue_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_issue_new#" maxlength="1">,
				mobile_issue_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_issue_new#" maxlength="1">,
				email_issue_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_issue_upd#" maxlength="1">,
				mobile_issue_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_issue_upd#" maxlength="1">,
				email_issue_com = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_issue_com#" maxlength="1">,
				mobile_issue_com = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_issue_com#" maxlength="1">,
				email_msg_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_msg_new#" maxlength="1">,
				mobile_msg_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_msg_new#" maxlength="1">,
				email_msg_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_msg_upd#" maxlength="1">,
				mobile_msg_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_msg_upd#" maxlength="1">,
				email_msg_com = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_msg_com#" maxlength="1">,
				mobile_msg_com = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_msg_com#" maxlength="1">,
				email_mstone_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_mstone_new#" maxlength="1">,
				mobile_mstone_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_mstone_new#" maxlength="1">,
				email_mstone_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_mstone_upd#" maxlength="1">,
				mobile_mstone_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_mstone_upd#" maxlength="1">,
				email_mstone_com = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_mstone_com#" maxlength="1">,
				mobile_mstone_com = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_mstone_com#" maxlength="1">,
				email_todo_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_todo_new#" maxlength="1">,
				mobile_todo_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_todo_new#" maxlength="1">,
				email_todo_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_todo_upd#" maxlength="1">,
				mobile_todo_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_todo_upd#" maxlength="1">,
				email_todo_com = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_todo_com#" maxlength="1">,
				mobile_todo_com = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_todo_com#" maxlength="1">,
				email_time_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_time_new#" maxlength="1">,
				mobile_time_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_time_new#" maxlength="1">,
				email_time_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_time_upd#" maxlength="1">,
				mobile_time_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_time_upd#" maxlength="1">,
				email_bill_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_bill_new#" maxlength="1">,
				mobile_bill_new = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_bill_new#" maxlength="1">,
				email_bill_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_bill_upd#" maxlength="1">,
				mobile_bill_upd = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_bill_upd#" maxlength="1">,
				email_bill_paid = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_bill_paid#" maxlength="1">,
				mobile_bill_paid = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_bill_paid#" maxlength="1">
			WHERE projectid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35"> 
		</cfquery>
	</cffunction>
		
	<cffunction name="remove" access="public" returnType="boolean" output="false"
				hint="Removes user role.">
		<cfargument name="projectID" type="string" required="false" default="">		
		<cfargument name="userID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
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