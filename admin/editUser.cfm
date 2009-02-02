<cfsetting enablecfoutputonly="true">

<cfset variables.errors = "">

<cfparam name="form.from" default="admin">
<cfif StructKeyExists(url,"from")>
	<cfset form.from = url.from>
</cfif>

<cfif StructKeyExists(form,"submit")>
	<cfparam name="form.admin" default="0">
	<cfparam name="form.active" default="0">
	<cfparam name="form.projectids" default="">
	<cfparam name="form.adminids" default="">
	<cfparam name="form.svnids" default="">
	
	<cfif not compare(trim(form.username),'')>
		<cfset variables.errors = variables.errors & '<li>You must enter a username.</li>'>
	</cfif>
	
	<cfif compare(trim(form.email),'') and not request.udf.isEmail(trim(form.email))>
		<cfset variables.errors = variables.errors & '<li>The email address you entered was invalid.</li>'>
	</cfif>
	
	<cfswitch expression="#form.submit#">
		<cfcase value="Add User">
			<cfif not compare(trim(form.password),'')>
				<cfset variables.errors = errors & '<li>You must enter a password.</li>'>
			</cfif>
			<cfif not compare(errors,'')>
				<cfset qCheckUser = application.user.get('','',form.username)>
				<cfif not qCheckUser.recordCount>
					<cfset newID = createUUID()>
					<cfset application.user.adminCreate(newID,form.firstName,form.lastName,form.username,form.password,trim(form.email),request.udf.NumbersOnly(form.phone),request.udf.NumbersOnly(form.mobile),form.carrierID,form.admin,form.active)>
					<cfloop list="#form.projectids#" index="i">
						<cfif listFind(form.adminids,i)>
							<cfset project_admin = 1>
						<cfelse>	
							<cfset project_admin = 0>	
						</cfif>
						<cfif listFind(form.svnids,i)>
							<cfset svn = 1>
						<cfelse>	
							<cfset svn = 0>	
						</cfif>
						<cfset application.role.add(i,newID,project_admin,ListGetAt(form.files,listFind(form.all_proj_ids,i)),ListGetAt(form.issues,listFind(form.all_proj_ids,i)),ListGetAt(form.msgs,listFind(form.all_proj_ids,i)),ListGetAt(form.mstones,listFind(form.all_proj_ids,i)),ListGetAt(form.todos,listFind(form.all_proj_ids,i)),ListGetAt(form.timetrack,listFind(form.all_proj_ids,i)),ListGetAt(form.billing,listFind(form.all_proj_ids,i)),svn)>
						<cfif find(i,form.projectids)>
							<cfset application.notify.add(newID,i,'0','0','0','0','0','0','0','0','0','0')>
						</cfif>
					</cfloop>
					<cfif not compare(form.from,'admin')>
						<cflocation url="users.cfm" addtoken="false">
					<cfelse>
						<cflocation url="../people.cfm?p=#url.p#" addtoken="false">
					</cfif>
				<cfelse>
					<cfset variables.errors = "Username already exists!">
				</cfif>
			</cfif>
		</cfcase>
		<cfcase value="Update User">
			<cfif not compare(errors,'')>
				<cfset application.user.adminUpdate(form.userid,form.firstName,form.lastName,form.username,form.password,trim(form.email),request.udf.NumbersOnly(form.phone),request.udf.NumbersOnly(form.mobile),form.carrierID,form.admin,form.active)>
				<cfset application.role.remove(userID=form.userid)>
				<cfset application.notify.remove(userID=form.userid)>
				<cfloop list="#form.projectids#" index="i">
					<cfif listFind(form.adminids,i)>
						<cfset project_admin = 1>
					<cfelse>	
						<cfset project_admin = 0>	
					</cfif>
					<cfif listFind(form.svnids,i)>
						<cfset svn = 1>
					<cfelse>	
						<cfset svn = 0>	
					</cfif>
					<cfset application.role.add(i,form.userid,project_admin,ListGetAt(form.files,listFind(form.all_proj_ids,i)),ListGetAt(form.issues,listFind(form.all_proj_ids,i)),ListGetAt(form.msgs,listFind(form.all_proj_ids,i)),ListGetAt(form.mstones,listFind(form.all_proj_ids,i)),ListGetAt(form.todos,listFind(form.all_proj_ids,i)),ListGetAt(form.timetrack,listFind(form.all_proj_ids,i)),ListGetAt(form.billing,listFind(form.all_proj_ids,i)),svn)>
					<cfif find(i,form.projectids)>
						<cfparam name="form.email_files_#replace(i,'-','','ALL')#" default="0">
						<cfparam name="form.mobile_files_#replace(i,'-','','ALL')#" default="0">
						<cfparam name="form.email_issues_#replace(i,'-','','ALL')#" default="0">
						<cfparam name="form.mobile_issues_#replace(i,'-','','ALL')#" default="0">
						<cfparam name="form.email_msgs_#replace(i,'-','','ALL')#" default="0">
						<cfparam name="form.mobile_msgs_#replace(i,'-','','ALL')#" default="0">
						<cfparam name="form.email_mstones_#replace(i,'-','','ALL')#" default="0">
						<cfparam name="form.mobile_mstones_#replace(i,'-','','ALL')#" default="0">
						<cfparam name="form.email_todos_#replace(i,'-','','ALL')#" default="0">
						<cfparam name="form.mobile_todos_#replace(i,'-','','ALL')#" default="0">
						<cfset application.notify.add(form.userid,i,Evaluate("form.email_files_"&replace(i,'-','','ALL')),Evaluate("form.mobile_files_"&replace(i,'-','','ALL')),Evaluate("form.email_issues_"&replace(i,'-','','ALL')),Evaluate("form.mobile_issues_"&replace(i,'-','','ALL')),Evaluate("form.email_msgs_"&replace(i,'-','','ALL')),Evaluate("form.mobile_msgs_"&replace(i,'-','','ALL')),Evaluate("form.email_mstones_"&replace(i,'-','','ALL')),Evaluate("form.mobile_mstones_"&replace(i,'-','','ALL')),Evaluate("form.email_todos_"&replace(i,'-','','ALL')),Evaluate("form.mobile_todos_"&replace(i,'-','','ALL')))>
					</cfif>
				</cfloop>
				<cfif not compare(form.from,'admin')>
					<cflocation url="users.cfm" addtoken="false">
				<cfelse>
					<cflocation url="../people.cfm?p=#url.p#" addtoken="false">
				</cfif>
			</cfif>
		</cfcase>
	</cfswitch>
</cfif>

<cfparam name="form.firstName" default="">
<cfparam name="form.lastName" default="">
<cfparam name="form.username" default="">
<cfparam name="form.password" default="">
<cfparam name="form.email" default="">
<cfparam name="form.phone" default="">
<cfparam name="form.mobile" default="">
<cfparam name="form.carrierID" default="">
<cfparam name="form.admin" default="0">
<cfparam name="form.active" default="0">

<cfset projects = application.project.getDistinct()>

<cfif StructKeyExists(url,"u")>
	<cfset user = application.user.get(url.u)>
	<cfset form.firstName = user.firstName>
	<cfset form.lastName = user.lastName>
	<cfset form.username = user.username>
	<cfset form.email = user.email>
	<cfset form.phone = user.phone>
	<cfset form.mobile = user.mobile>
	<cfset form.carrierID = user.carrierID>
	<cfset form.admin = user.admin>
	<cfset form.active = user.active>
	<cfset user_projects = application.project.get(url.u)>
	<cfset notifications = application.project.userNotify(url.u)>
	<cfquery name="admin_projects" dbtype="query">
		select * from user_projects where admin = 1
	</cfquery>
	<cfset form.all_proj_ids = "">
	<cfset form.files = "">
	<cfset form.issues = "">
	<cfset form.msgs = "">
	<cfset form.mstones = "">
	<cfset form.todos = "">
	<cfset form.timetrack = "">
	<cfset form.billing = "">
	<cfset form.svn = "">
	<cfloop query="projects">
		<cfset form.all_proj_ids = listAppend(form.all_proj_ids,projectid)>
		<cfif listFind(valueList(user_projects.projectid),projectid)>
			<cfset projectid_loc = listFind(valueList(user_projects.projectid),projectid)>
			<cfset form.files = listAppend(form.files,listGetAt(valueList(user_projects.files),projectid_loc))>
			<cfset form.issues = listAppend(form.issues,listGetAt(valueList(user_projects.issues),projectid_loc))>
			<cfset form.msgs = listAppend(form.msgs,listGetAt(valueList(user_projects.msgs),projectid_loc))>
			<cfset form.mstones = listAppend(form.mstones,listGetAt(valueList(user_projects.mstones),projectid_loc))>
			<cfset form.todos = listAppend(form.todos,listGetAt(valueList(user_projects.todos),projectid_loc))>
			<cfset form.timetrack = listAppend(form.timetrack,listGetAt(valueList(user_projects.timetrack),projectid_loc))>
			<cfset form.billing = listAppend(form.billing,listGetAt(valueList(user_projects.billing),projectid_loc))>
			<cfset form.svn = listAppend(form.svn,listGetAt(valueList(user_projects.svn),projectid_loc))>
		<cfelse>
			<cfset form.files = listAppend(form.files,'0')>
			<cfset form.issues = listAppend(form.issues,'0')>
			<cfset form.msgs = listAppend(form.msgs,'0')>
			<cfset form.mstones = listAppend(form.mstones,'0')>
			<cfset form.todos = listAppend(form.todos,'0')>
			<cfset form.timetrack = listAppend(form.timetrack,'0')>
			<cfset form.billing = listAppend(form.billing,'0')>
			<cfset form.svn = listAppend(form.svn,'0')>
		</cfif>
	</cfloop>
<cfelse> <!--- new user --->
	<cfset user_projects = QueryNew('projectID')>
	<cfparam name="form.projectids" default="">
	<cfloop list="#form.projectids#" index="i">
		<cfset QueryAddRow(user_projects)>
		<cfset QuerySetCell(user_projects, 'projectid', i)>		
	</cfloop>
	<cfset admin_projects = QueryNew('projectID')>
	<cfparam name="form.adminids" default="">
	<cfloop list="#form.adminids#" index="i">
		<cfset QueryAddRow(admin_projects)>
		<cfset QuerySetCell(admin_projects, 'projectid', i)>		
	</cfloop>
	<cfset default_roles = "">
	<cfloop query="projects">
		<cfset default_roles = listAppend(default_roles,'2')>
	</cfloop>
	<cfparam name="form.all_proj_ids" default="#valueList(projects.projectid)#">
	<cfparam name="form.files" default="#default_roles#">
	<cfparam name="form.issues" default="#default_roles#">
	<cfparam name="form.msgs" default="#default_roles#">
	<cfparam name="form.mstones" default="#default_roles#">
	<cfparam name="form.todos" default="#default_roles#">
	<cfparam name="form.timetrack" default="#default_roles#">
	<cfparam name="form.billing" default="#default_roles#">
	<cfparam name="form.svn" default="#replace(default_roles,'2','1','all')#">
</cfif>

<cfif not isDefined("application.carriers")>
	<cfset application.carriers = application.carrier.get(activeOnly=true)>
</cfif>

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
				 	
				 	<h3 class="mb10"><cfif StructKeyExists(url,"u")>Edit<cfelse>Add New</cfif> User</h3>

				 	<cfif compare(variables.errors,'')>
				 	<div class="error">
					 	<h4 class="alert b r">An Error Has Occurred</h3>
					 	<ul>#variables.errors#</ul>
					</div>
				 	</cfif>
				 	
				 	<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="frm">
					 	<fieldset class="mb15">
						 	<legend>User Information</legend>
						<p>
						<label for="firstName">First Name:</label> 
						<input type="text" name="firstName" id="firstName" value="#HTMLEditFormat(form.firstName)#" maxlength="12" class="shorter" />
						</p>
						<p>
						<label for="lastName">Last Name:</label> 
						<input type="text" name="lastName" id="lastName" value="#HTMLEditFormat(form.lastName)#" maxlength="20" class="shorter" />
						</p>
						<p>
						<label for="username" class="req">Username:</label> 
						<input type="text" name="username" id="username" value="#HTMLEditFormat(form.username)#" maxlength="30" class="shorter" />
						</p>
						<p>
						<label for="password"<cfif not StructKeyExists(url,"u")> class="req"</cfif>>Password:</label> 
						<input type="text" name="password" id="password"<cfif not StructKeyExists(url,"u")> value="#HTMLEditFormat(form.password)#"</cfif> maxlength="20" class="shorter" />
						</p>
						<p>
						<label for="email">Email:</label> 
						<input type="text" name="email" id="email" value="#HTMLEditFormat(form.email)#" maxlength="120" />
						</p>
						<p>
						<label for="phone">Phone:</label> 
						<input type="text" name="phone" id="phone" value="#HTMLEditFormat(request.udf.phoneFormat(form.phone,"(xxx) xxx-xxxx"))#" maxlength="15" class="shorter" />
						</p>
						<p>
						<label for="mobile">Mobile:</label> 
						<input type="text" name="mobile" id="mobile" value="#HTMLEditFormat(request.udf.phoneFormat(form.mobile,"(xxx) xxx-xxxx"))#" maxlength="15" class="shorter" />
						</p>
						<p>
							<label for="carrier">Carrier:</label>
							<select name="carrierID" id="carrier">
								<option value=""></option>
						</cfoutput>

						<cfoutput query="application.carriers" group="country">
						<optgroup label="#country#">
						<cfoutput>
						<option value="#carrierID#"<cfif not compare(form.carrierID,carrierID)> selected="selected"</cfif>>#carrier#</option>
						</cfoutput>
						</cfoutput>
						
						<cfoutput>
							</select> <span style="font-size:85%;" class="i">(used for SMS notifications)
						</p>				
						<p>
						<label for="admin">Global Admin?</label>
						<input type="checkbox" name="admin" id="admin" value="1" class="checkbox"<cfif form.admin> checked="checked"</cfif> />
						</p>
						<p>
						<label for="active">Active?</label>
						<input type="checkbox" name="active" id="active" value="1" class="checkbox"<cfif form.active> checked="checked"</cfif> />
						</p>
						</fieldset>
						
						<fieldset class="mb15">
							<legend>Projects</legend>
							
							<table class="admin full permissions">
							<tr>
								<th class="tal">Project</th>
								<th>Active</th>
								<th>Admin</th>
								<th>Files</th>
								<th>Issues</th>
								<th>Messages</th>
								<th>Milestones</th>
								<th>To-Dos</th>
								<th>Time Tracking</th>
								<th>Billing</th>
								<th>SVN</th>
							</tr>
							<cfloop query="projects">
							<tr>
								<td class="tal"><label for="p_#replace(projectid,'-','','ALL')#" class="cb">#name#</label></td>
								<td><input type="checkbox" name="projectids" value="#projectid#" id="p_#replace(projectid,'-','','ALL')#" class="cb"<cfif listFind(valueList(user_projects.projectid),projectid)> checked="checked"</cfif> /></td>
								<td><input type="checkbox" name="adminids" value="#projectid#" id="a_#replace(projectid,'-','','ALL')#" class="cb"<cfif listFind(valueList(admin_projects.projectid),projectid)> checked="checked"</cfif> /></td>
								<td>
									<select name="files" onchange="if (this.selectedIndex > 0) $('##a_#replace(projectid,'-','','ALL')#').attr('checked','');">
										<option value="2"<cfif ListGetAt(form.files,listFind(form.all_proj_ids,projectid)) eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif ListGetAt(form.files,listFind(form.all_proj_ids,projectid)) eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif ListGetAt(form.files,listFind(form.all_proj_ids,projectid)) eq 0> selected="selected"</cfif>>None</option>
									</select>
								</td>
								<td>
									<select name="issues" onchange="if (this.selectedIndex > 0) $('##a_#replace(projectid,'-','','ALL')#').attr('checked','');">
										<option value="2"<cfif ListGetAt(form.issues,listFind(form.all_proj_ids,projectid)) eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif ListGetAt(form.issues,listFind(form.all_proj_ids,projectid)) eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif ListGetAt(form.issues,listFind(form.all_proj_ids,projectid)) eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td>
									<select name="msgs" onchange="if (this.selectedIndex > 0) $('##a_#replace(projectid,'-','','ALL')#').attr('checked','');">
										<option value="2"<cfif ListGetAt(form.msgs,listFind(form.all_proj_ids,projectid)) eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif ListGetAt(form.msgs,listFind(form.all_proj_ids,projectid)) eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif ListGetAt(form.msgs,listFind(form.all_proj_ids,projectid)) eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td>
									<select name="mstones" onchange="if (this.selectedIndex > 0) $('##a_#replace(projectid,'-','','ALL')#').attr('checked','');">
										<option value="2"<cfif ListGetAt(form.mstones,listFind(form.all_proj_ids,projectid)) eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif ListGetAt(form.mstones,listFind(form.all_proj_ids,projectid)) eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif ListGetAt(form.mstones,listFind(form.all_proj_ids,projectid)) eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td>
									<select name="todos" onchange="if (this.selectedIndex > 0) $('##a_#replace(projectid,'-','','ALL')#').attr('checked','');">
										<option value="2"<cfif ListGetAt(form.todos,listFind(form.all_proj_ids,projectid)) eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif ListGetAt(form.todos,listFind(form.all_proj_ids,projectid)) eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif ListGetAt(form.todos,listFind(form.all_proj_ids,projectid)) eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td>
									<select name="timetrack" onchange="if (this.selectedIndex > 0) $('##a_#replace(projectid,'-','','ALL')#').attr('checked','');">
										<option value="2"<cfif ListGetAt(form.timetrack,listFind(form.all_proj_ids,projectid)) eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif ListGetAt(form.timetrack,listFind(form.all_proj_ids,projectid)) eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif ListGetAt(form.timetrack,listFind(form.all_proj_ids,projectid)) eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td>
									<select name="billing" onchange="if (this.selectedIndex > 0) $('##a_#replace(projectid,'-','','ALL')#').attr('checked','');">
										<option value="2"<cfif ListGetAt(form.billing,listFind(form.all_proj_ids,projectid)) eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif ListGetAt(form.billing,listFind(form.all_proj_ids,projectid)) eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif ListGetAt(form.billing,listFind(form.all_proj_ids,projectid)) eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td><input type="checkbox" name="svnids" value="#projectid#" id="p_#replace(projectid,'-','','ALL')#" class="cb" onchange="if (this.checked == false) $('##a_#replace(projectid,'-','','ALL')#').attr('checked','');"<cfif ListGetAt(form.svn,listFind(form.all_proj_ids,projectid)) eq 1> checked="checked"</cfif> /></td>
								<input type="hidden" name="all_proj_ids" value="#projectid#" />
							</tr>
							</cfloop>
							</table>
						
						</fieldset>

						<cfif StructKeyExists(url,"u")>
						<fieldset class="mb20">
						 	<legend>Notifications</legend>
							<table class="admin full mb10 notify">
							<tr>
								<th class="tal">Project</th>
								<th class="tac">Files</th>
								<th class="tac">Issues</th>
								<th class="tac">Messages</th>
								<th class="tac">Milestones</th>
								<th class="tac">To-Dos</th>
		
							</tr>
							<cfloop query="notifications">
							<tr>
								<td class="tal">#name#</td>
								<td class="tac">
									<input type="checkbox" name="email_files_#replace(projectID,'-','','ALL')#" id="e_f_#projectID#" value="1"<cfif email_files> checked="checked"</cfif> />
									<label for="e_f_#projectID#"><img src="../images/email.png" height="16" width="16" border="0" alt="Email" /></label> &nbsp;
									<label for="m_f_#projectID#"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile" /></label><input type="checkbox" name="mobile_files_#replace(projectID,'-','','ALL')#" id="m_f_#projectID#" value="1"<cfif mobile_files> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> />				
								</td>
								<td class="tac">
									<input type="checkbox" name="email_issues_#replace(projectID,'-','','ALL')#" id="e_i_#projectID#" value="1"<cfif email_issues> checked="checked"</cfif> />
									<label for="e_i_#projectID#"><img src="../images/email.png" height="16" width="16" border="0" alt="Email" /></label> &nbsp;
									<label for="m_i_#projectID#"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile" /></label><input type="checkbox" name="mobile_issues_#replace(projectID,'-','','ALL')#" id="m_i_#projectID#" value="1"<cfif mobile_issues> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> />
								</td>
								<td class="tac">
									<input type="checkbox" name="email_msgs_#replace(projectID,'-','','ALL')#" id="e_msg_#projectID#" value="1"<cfif email_msgs> checked="checked"</cfif> />
									<label for="e_msg_#projectID#"><img src="../images/email.png" height="16" width="16" border="0" alt="Email" /></label> &nbsp;
									<label for="m_msg_#projectID#"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile" /></label><input type="checkbox" name="mobile_msgs_#replace(projectID,'-','','ALL')#" id="m_msg_#projectID#" value="1"<cfif mobile_msgs> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> />
								</td>
								<td class="tac">
									<input type="checkbox" name="email_mstones_#replace(projectID,'-','','ALL')#" id="e_m_#projectID#" value="1"<cfif email_mstones> checked="checked"</cfif> />
									<label for="e_m_#projectID#"><img src="../images/email.png" height="16" width="16" border="0" alt="Email" /></label> &nbsp;
									<label for="m_m_#projectID#"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile" /></label><input type="checkbox" name="mobile_mstones_#replace(projectID,'-','','ALL')#" id="m_m_#projectID#" value="1"<cfif mobile_mstones> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> />
								</td>
								<td class="tac">
									<input type="checkbox" name="email_todos_#replace(projectID,'-','','ALL')#" id="e_t_#projectID#" value="1"<cfif email_todos> checked="checked"</cfif> />
									<label for="e_t_#projectID#"><img src="../images/email.png" height="16" width="16" border="0" alt="Email" /></label> &nbsp;
									<label for="m_t_#projectID#"><img src="../images/phone.png" height="16" width="16" border="0" alt="Mobile" /></label><input type="checkbox" name="mobile_todos_#replace(projectID,'-','','ALL')#" id="m_t_#projectID#" value="1"<cfif mobile_todos> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> />
								<input type="hidden" name="notify_proj_ids" value="#projectid#" />
								</td>
							</tr>
							</cfloop>
							</table>
						 	
						 	<cfif not isNumeric(user.mobile)>
								<h6 class="b r i">Note: User must have a valid mobile number to enable Mobile Notifications.</h6>
							</cfif>
						 </fieldset>
						</cfif>
					
						<p>
						<input type="submit" name="submit" value="<cfif StructKeyExists(url,"u")>Update<cfelse>Add</cfif> User" class="button shorter" />
						or <a href="<cfif not compare(form.from,'admin')>users.cfm<cfelse>../people.cfm?p=#url.p#</cfif>">Cancel</a>
						</p>
						<cfif StructKeyExists(url,"u")>
							<input type="hidden" name="userid" value="#url.u#" />
						</cfif>
						<input type="hidden" name="from" value="#form.from#" />						
						</fieldset>
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