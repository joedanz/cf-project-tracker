<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfset variables.errors = "">

<cfparam name="form.from" default="site">
<cfif StructKeyExists(url,"from")>
	<cfset form.from = url.from>
</cfif>

<cfif StructKeyExists(form,"submit")>
	<cfparam name="form.admin" default="0">
	<cfset application.role.remove(projectID=url.p,userID=url.u)>
	<cfset application.role.add(url.p,url.u,form.admin,form.file_view,form.file_edit,form.file_comment,form.issue_view,form.issue_edit,form.issue_assign,form.issue_resolve,form.issue_close,form.issue_comment,form.msg_view,form.msg_edit,form.msg_comment,form.mstone_view,form.mstone_edit,form.mstone_comment,form.todolist_view,form.todolist_edit,form.todo_edit,form.todo_comment,form.time_view,form.time_edit,form.bill_view,form.bill_edit,form.bill_rates,form.bill_invoices,form.bill_markpaid,form.report,form.svn)>
	<cfif not compareNoCase(form.from,'admin')>
		<cflocation url="admin/editUser.cfm?u=#url.u###projects" addtoken="false">
	<cfelse>
		<cflocation url="people.cfm?p=#url.p#" addtoken="false">
	</cfif>
</cfif>

<cfparam name="form.admin" default="0">

<cfset user = application.user.get(url.u)>
<cfset project = application.project.get(url.u,url.p)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Admin">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left medium">
		<div class="main">
				
				<div class="header"<cfif not compareNoCase(form.from,'admin')> style="margin-bottom:0;"</cfif>>
					<h2 class="admin">User Permissions</h2>
				</div>
				
				<cfif not compareNoCase(form.from,'admin')>
					<ul class="submenu mb15">
						<cfinclude template="admin/menu.cfm">
					</ul>
				</cfif>

				<div class="content">
					<div class="wrapper">
				 	<h3 class="mb10">#user.firstName# #user.lastName# : #project.name#</h3>
					
					<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="frm">
					
					<p>
						<label for="admin" class="med b">Project Administrator?</label>
						<select name="admin" id="admin" onclick="showPerms();">
							<option value="0"<cfif project.admin eq 0> selected="selected"</cfif>>No</option>
							<option value="1"<cfif project.admin eq 1> selected="selected"</cfif>>Yes</option>
						</select>
					</p>
					
					<div id="fullperms"<cfif project.admin eq 1> style="display:none;"</cfif>>
					<table>
					<tr valign="top"><td width="50%">
					
						<table class="perms full mb10">
							<thead>
								<tr>
									<th class="b">Messages</th>
									<th class="tac b yes">Yes</th>
									<th class="tac b no">No</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>View messages</td>
									<td class="tac"><input type="radio" name="msg_view" value="1"<cfif project.msg_view eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="msg_view" value="0"<cfif project.msg_view eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Post/edit messages</td>
									<td class="tac"><input type="radio" name="msg_edit" value="1"<cfif project.msg_edit eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="msg_edit" value="0"<cfif project.msg_edit eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Comment on messages</td>
									<td class="tac"><input type="radio" name="msg_comment" value="1"<cfif project.msg_comment eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="msg_comment" value="0"<cfif project.msg_comment eq 0> checked="checked"</cfif> /></td>
								</tr>
							</tbody>
						</table>
	
						<table class="perms full mb10">
							<thead>
								<tr>
									<th class="b">To-Dos</th>
									<th class="tac b yes">Yes</th>
									<th class="tac b no">No</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>View to-do lists</td>
									<td class="tac"><input type="radio" name="todolist_view" value="1"<cfif project.todolist_view eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="todolist_view" value="0"<cfif project.todolist_view eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Add/edit to-do lists</td>
									<td class="tac"><input type="radio" name="todolist_edit" value="1"<cfif project.todolist_edit eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="todolist_edit" value="0"<cfif project.todolist_edit eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Add/edit to-do items</td>
									<td class="tac"><input type="radio" name="todo_edit" value="1"<cfif project.todo_edit eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="todo_edit" value="0"<cfif project.todo_edit eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Comment on to-do items</td>
									<td class="tac"><input type="radio" name="todo_comment" value="1"<cfif project.todo_comment eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="todo_comment" value="0"<cfif project.todo_comment eq 0> checked="checked"</cfif> /></td>
								</tr>							
							</tbody>
						</table>
		
	
						<table class="perms full mb10">
							<thead>
								<tr>
									<th class="b">Milestones</th>
									<th class="tac b yes">Yes</th>
									<th class="tac b no">No</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>View milestones</td>
									<td class="tac"><input type="radio" name="mstone_view" value="1"<cfif project.mstone_view eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="mstone_view" value="0"<cfif project.mstone_view eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Add/edit milestones</td>
									<td class="tac"><input type="radio" name="mstone_edit" value="1"<cfif project.mstone_edit eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="mstone_edit" value="0"<cfif project.mstone_edit eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Comment on milestones</td>
									<td class="tac"><input type="radio" name="mstone_comment" value="1"<cfif project.mstone_comment eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="mstone_comment" value="0"<cfif project.mstone_comment eq 0> checked="checked"</cfif> /></td>
								</tr>
							</tbody>
						</table>
	
						<table class="perms full mb10">
							<thead>
								<tr>
									<th class="b">Files</th>
									<th class="tac b yes">Yes</th>
									<th class="tac b no">No</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>View files</td>
									<td class="tac"><input type="radio" name="file_view" value="1"<cfif project.file_view eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="file_view" value="0"<cfif project.file_view eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Upload/edit files</td>
									<td class="tac"><input type="radio" name="file_edit" value="1"<cfif project.file_edit eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="file_edit" value="0"<cfif project.file_edit eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Comment on files</td>
									<td class="tac"><input type="radio" name="file_comment" value="1"<cfif project.file_comment eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="file_comment" value="0"<cfif project.file_comment eq 0> checked="checked"</cfif> /></td>
								</tr>
							</tbody>
						</table>

						<table class="perms full mb10">
							<thead>
								<tr>
									<th class="b">Subversion</th>
									<th class="tac b yes">Yes</th>
									<th class="tac b no">No</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>Access Subversion repository</td>
									<td class="tac"><input type="radio" name="svn" value="1"<cfif project.svn eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="svn" value="0"<cfif project.svn eq 0> checked="checked"</cfif> /></td>
								</tr>
							</tbody>
						</table>

					</td><td width="50%">
					
						<table class="perms full mb10">
							<thead>
								<tr>
									<th class="b">Issues</th>
									<th class="tac b yes">Yes</th>
									<th class="tac b no">No</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>View issues</td>
									<td class="tac"><input type="radio" name="issue_view" value="1"<cfif project.issue_view eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="issue_view" value="0"<cfif project.issue_view eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Add/edit issues</td>
									<td class="tac"><input type="radio" name="issue_edit" value="1"<cfif project.issue_edit eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="issue_edit" value="0"<cfif project.issue_edit eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Assign issues</td>
									<td class="tac"><input type="radio" name="issue_assign" value="1"<cfif project.issue_assign eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="issue_assign" value="0"<cfif project.issue_assign eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Resolve issues</td>
									<td class="tac"><input type="radio" name="issue_resolve" value="1"<cfif project.issue_resolve eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="issue_resolve" value="0"<cfif project.issue_resolve eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Close issues</td>
									<td class="tac"><input type="radio" name="issue_close" value="1"<cfif project.issue_close eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="issue_close" value="0"<cfif project.issue_close eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Comment on issues</td>
									<td class="tac"><input type="radio" name="issue_comment" value="1"<cfif project.issue_comment eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="issue_comment" value="0"<cfif project.issue_comment eq 0> checked="checked"</cfif> /></td>
								</tr>
							</tbody>
						</table>
	
						<table class="perms full mb10">
							<thead>
								<tr>
									<th class="b">Time Tracking</th>
									<th class="tac b yes">Yes</th>
									<th class="tac b no">No</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>View time tracking</td>
									<td class="tac"><input type="radio" name="time_view" value="1"<cfif project.time_view eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="time_view" value="0"<cfif project.time_view eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Add/edit time tracking</td>
									<td class="tac"><input type="radio" name="time_edit" value="1"<cfif project.time_edit eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="time_edit" value="0"<cfif project.time_edit eq 0> checked="checked"</cfif> /></td>
								</tr>
							</tbody>
						</table>
						
						<table class="perms full mb10">
							<thead>
								<tr>
									<th class="b">Reporting</th>
									<th class="tac b yes">Yes</th>
									<th class="tac b no">No</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>Allow reporting</td>
									<td class="tac"><input type="radio" name="report" value="1"<cfif project.report eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="report" value="0"<cfif project.report eq 0> checked="checked"</cfif> /></td>
								</tr>
							</tbody>
						</table>
						
						<table class="perms full mb10">
							<thead>
								<tr>
									<th class="b">Billing</th>
									<th class="tac b yes">Yes</th>
									<th class="tac b no">No</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>View billing</td>
									<td class="tac"><input type="radio" name="bill_view" value="1"<cfif project.bill_view eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="bill_view" value="0"<cfif project.bill_view eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Add/edit billing</td>
									<td class="tac"><input type="radio" name="bill_edit" value="1"<cfif project.bill_edit eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="bill_edit" value="0"<cfif project.bill_edit eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Manage billing rates</td>
									<td class="tac"><input type="radio" name="bill_rates" value="1"<cfif project.bill_rates eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="bill_rates" value="0"<cfif project.bill_rates eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Generate invoices</td>
									<td class="tac"><input type="radio" name="bill_invoices" value="1"<cfif project.bill_invoices eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="bill_invoices" value="0"<cfif project.bill_invoices eq 0> checked="checked"</cfif> /></td>
								</tr>
								<tr>
									<td>Mark items paid</td>
									<td class="tac"><input type="radio" name="bill_markpaid" value="1"<cfif project.bill_markpaid eq 1> checked="checked"</cfif> /></td>
									<td class="tac"><input type="radio" name="bill_markpaid" value="0"<cfif project.bill_markpaid eq 0> checked="checked"</cfif> /></td>
								</tr>
							</tbody>
						</table>


						
					</td></tr>
					</table>
					</div>
					
					<p>
					<input type="submit" name="submit" value="Update Permissions" class="button shorter" />
					or <a href="#application.settings.mapping#/<cfif not compareNoCase(form.from,'admin')>admin/editUser.cfm?u=#url.u###projects<cfelse>people.cfm?p=#url.p#</cfif>">Cancel</a>
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

<script type="text/javascript">
	function showPerms() {
		if ($('##admin').val() == '1') $('##fullperms').slideUp();
		else $('##fullperms').slideDown();
	}
</script>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">