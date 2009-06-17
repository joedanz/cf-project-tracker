<cfsetting enablecfoutputonly="true">

<cfset variables.errors = "">

<cfparam name="form.from" default="admin">
<cfif StructKeyExists(url,"from")>
	<cfset form.from = url.from>
</cfif>

<cfif StructKeyExists(form,"submit")>
	<cfparam name="form.email_file_new" default="0">
	<cfparam name="form.mobile_file_new" default="0">
	<cfparam name="form.email_file_upd" default="0">
	<cfparam name="form.mobile_file_upd" default="0">
	<cfparam name="form.email_file_com" default="0">
	<cfparam name="form.mobile_file_com" default="0">
	<cfparam name="form.email_issue_new" default="0">
	<cfparam name="form.mobile_issue_new" default="0">
	<cfparam name="form.email_issue_upd" default="0">
	<cfparam name="form.mobile_issue_upd" default="0">
	<cfparam name="form.email_issue_com" default="0">
	<cfparam name="form.mobile_issue_com" default="0">
	<cfparam name="form.email_msg_new" default="0">
	<cfparam name="form.mobile_msg_new" default="0">
	<cfparam name="form.email_msg_upd" default="0">
	<cfparam name="form.mobile_msg_upd" default="0">
	<cfparam name="form.email_msg_com" default="0">
	<cfparam name="form.mobile_msg_com" default="0">
	<cfparam name="form.email_mstone_new" default="0">
	<cfparam name="form.mobile_mstone_new" default="0">
	<cfparam name="form.email_mstone_upd" default="0">
	<cfparam name="form.mobile_mstone_upd" default="0">
	<cfparam name="form.email_mstone_com" default="0">
	<cfparam name="form.mobile_mstone_com" default="0">
	<cfparam name="form.email_todo_new" default="0">
	<cfparam name="form.mobile_todo_new" default="0">
	<cfparam name="form.email_todo_upd" default="0">
	<cfparam name="form.mobile_todo_upd" default="0">
	<cfparam name="form.email_todo_com" default="0">
	<cfparam name="form.mobile_todo_com" default="0">
	<cfparam name="form.email_time_new" default="0">
	<cfparam name="form.mobile_time_new" default="0">
	<cfparam name="form.email_time_upd" default="0">
	<cfparam name="form.mobile_time_upd" default="0">
	<cfparam name="form.email_bill_new" default="0">
	<cfparam name="form.mobile_bill_new" default="0">
	<cfparam name="form.email_bill_upd" default="0">
	<cfparam name="form.mobile_bill_upd" default="0">
	<cfparam name="form.email_bill_paid" default="0">
	<cfparam name="form.mobile_bill_paid" default="0">
	<cfset application.notify.update(url.u,url.p,form.email_file_new,form.mobile_file_new,form.email_file_upd,form.mobile_file_upd,form.email_file_com,form.mobile_file_com,form.email_issue_new,form.mobile_issue_new,form.email_issue_upd,form.mobile_issue_upd,form.email_issue_com,form.mobile_issue_com,form.email_msg_new,form.mobile_msg_new,form.email_msg_upd,form.mobile_msg_upd,form.email_msg_com,form.mobile_msg_com,form.email_mstone_new,form.mobile_mstone_new,form.email_mstone_upd,form.mobile_mstone_upd,form.email_mstone_com,form.mobile_mstone_com,form.email_todo_new,form.mobile_todo_new,form.email_todo_upd,form.mobile_todo_upd,form.email_todo_com,form.mobile_todo_com,form.email_time_new,form.mobile_time_new,form.email_time_upd,form.mobile_time_upd,form.email_bill_new,form.mobile_bill_new,form.email_bill_upd,form.mobile_bill_upd,form.email_bill_paid,form.mobile_bill_paid)>
	<cflocation url="editUser.cfm?u=#url.u###projects" addtoken="false">
</cfif>

<cfparam name="form.admin" default="0">

<cfset user = application.project.userNotify(userID=url.u,projectID=url.p)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Admin">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left medium">
		<div class="main">

				<div class="header" style="margin-bottom:0;">
					<h2 class="admin">Administration</h2>
				</div>
				<ul class="submenu mb15">
					<cfinclude template="menu.cfm">
				</ul>
				<div class="content">
					<div class="wrapper">
				 	<h3<cfif isNumeric(user.mobile)> class="mb10"</cfif>>Notifications &raquo; #user.firstName# #user.lastName# : #user.name#</h3>
				 	
				 	<cfif not isNumeric(user.mobile)>
						<h5 class="b r i mb10">Note: User must have a valid mobile number to enable Mobile Notifications.</h5>
					</cfif>
										
					<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="frm">
					
					<table class="notifylist">
					<tr valign="top"><td width="50%">
					<table class="perms full mb10">
						<thead>
							<tr>
								<th class="b">Files</th>
								<th class="tac"><img src="../images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
								<th class="tac"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>New file</td>
								<td class="tac"><input type="checkbox" name="email_file_new" value="1"<cfif user.email_file_new eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_file_new" value="1"<cfif user.mobile_file_new eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Updated file</td>
								<td class="tac"><input type="checkbox" name="email_file_upd" value="1"<cfif user.email_file_upd eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_file_upd" value="1"<cfif user.mobile_file_upd eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Comment on file</td>
								<td class="tac"><input type="checkbox" name="email_file_com" value="1"<cfif user.email_file_upd eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_file_com" value="1"<cfif user.mobile_file_upd eq 1> checked="checked"</cfif> /></td>
							</tr>
						</tbody>
					</table>

					<table class="perms full mb10">
						<thead>
							<tr>
								<th class="b">Issues</th>
								<th class="tac"><img src="../images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
								<th class="tac"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>New issue</td>
								<td class="tac"><input type="checkbox" name="email_issue_new" value="1"<cfif user.email_issue_new eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_issue_new" value="1"<cfif user.mobile_issue_new eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Updated issue</td>
								<td class="tac"><input type="checkbox" name="email_issue_upd" value="1"<cfif user.email_issue_upd eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_issue_upd" value="1"<cfif user.mobile_issue_upd eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Comment on issue</td>
								<td class="tac"><input type="checkbox" name="email_issue_com" value="1"<cfif user.email_issue_com eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_issue_com" value="1"<cfif user.mobile_issue_com eq 1> checked="checked"</cfif> /></td>
							</tr>
						</tbody>
					</table>
				
					<table class="perms full mb10">
						<thead>
							<tr>
								<th class="b">Messages</th>
								<th class="tac"><img src="../images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
								<th class="tac"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>New message</td>
								<td class="tac"><input type="checkbox" name="email_msg_new" value="1"<cfif user.email_msg_new eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_msg_new" value="1"<cfif user.mobile_msg_new eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Updated message</td>
								<td class="tac"><input type="checkbox" name="email_msg_upd" value="1"<cfif user.email_msg_upd eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_msg_upd" value="1"<cfif user.mobile_msg_upd eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Comment on message</td>
								<td class="tac"><input type="checkbox" name="email_msg_com" value="1"<cfif user.email_msg_com eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_msg_com" value="1"<cfif user.mobile_msg_com eq 1> checked="checked"</cfif> /></td>
							</tr>
						</tbody>
					</table>

					<table class="perms full mb10">
						<thead>
							<tr>
								<th class="b">Milestones</th>
								<th class="tac"><img src="../images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
								<th class="tac"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>New milestone</td>
								<td class="tac"><input type="checkbox" name="email_mstone_new" value="1"<cfif user.email_mstone_new eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_mstone_new" value="1"<cfif user.mobile_mstone_new eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Updated milestone</td>
								<td class="tac"><input type="checkbox" name="email_mstone_upd" value="1"<cfif user.email_mstone_upd eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_mstone_upd" value="1"<cfif user.mobile_mstone_upd eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Comment on milestone</td>
								<td class="tac"><input type="checkbox" name="email_mstone_com" value="1"<cfif user.email_mstone_com eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_mstone_com" value="1"<cfif user.mobile_mstone_com eq 1> checked="checked"</cfif> /></td>
							</tr>
						</tbody>
					</table>
					
					</td><td width="50%">
					
					<table class="perms full mb10">
						<thead>
							<tr>
								<th class="b">To-Dos</th>
								<th class="tac"><img src="../images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
								<th class="tac"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>New to-do item</td>
								<td class="tac"><input type="checkbox" name="email_todo_new" value="1"<cfif user.email_todo_new eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_todo_new" value="1"<cfif user.mobile_todo_new eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Updated to-do item</td>
								<td class="tac"><input type="checkbox" name="email_todo_upd" value="1"<cfif user.email_todo_upd eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_todo_upd" value="1"<cfif user.mobile_todo_upd eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Comment on to-do item</td>
								<td class="tac"><input type="checkbox" name="email_todo_com" value="1"<cfif user.email_todo_com eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_todo_com" value="1"<cfif user.mobile_todo_com eq 1> checked="checked"</cfif> /></td>
							</tr>							
						</tbody>
					</table>

					<table class="perms full mb10">
						<thead>
							<tr>
								<th class="b">Time Tracking</th>
								<th class="tac"><img src="../images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
								<th class="tac"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>New time tracking item</td>
								<td class="tac"><input type="checkbox" name="email_time_new" value="1"<cfif user.email_time_new eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_time_new" value="1"<cfif user.mobile_time_new eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Updated time tracking</td>
								<td class="tac"><input type="checkbox" name="email_time_upd" value="1"<cfif user.email_time_upd eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_time_upd" value="1"<cfif user.mobile_time_upd eq 1> checked="checked"</cfif> /></td>
							</tr>
						</tbody>
					</table>
					
					<table class="perms full mb10">
						<thead>
							<tr>
								<th class="b">Billing</th>
								<th class="tac"><img src="../images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
								<th class="tac"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>New billing item</td>
								<td class="tac"><input type="checkbox" name="email_bill_new" value="1"<cfif user.email_bill_new eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_bill_new" value="1"<cfif user.mobile_bill_new eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Updated billing item</td>
								<td class="tac"><input type="checkbox" name="email_bill_upd" value="1"<cfif user.email_bill_upd eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_bill_upd" value="1"<cfif user.mobile_bill_upd eq 1> checked="checked"</cfif> /></td>
							</tr>
							<tr>
								<td>Billing item marked paid</td>
								<td class="tac"><input type="checkbox" name="email_bill_paid" value="1"<cfif user.email_bill_paid eq 1> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_bill_paid" value="1"<cfif user.mobile_bill_paid eq 1> checked="checked"</cfif> /></td>
							</tr>
						</tbody>
					</table>
				
					</td></tr>
					</table>

					<p>
					<input type="submit" name="submit" value="Update Notifications" class="button shorter" />
					or <a href="editUser.cfm?u=#url.u###projects">Cancel</a>
					</p>
					<input type="hidden" name="from" value="#form.from#" />						

					</form>		

					</div>
				</div>

			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="#application.settings.mapping#/footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">

	</div>
		
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">