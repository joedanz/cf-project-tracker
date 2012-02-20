<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfset variables.errors = "">

<cfparam name="form.from" default="admin">
<cfif StructKeyExists(url,"from")>
	<cfset form.from = url.from>
</cfif>

<cfif StructKeyExists(form,"submit")>
	<cfparam name="form.admin" default="0">
	<cfparam name="form.report" default="0">
	<cfparam name="form.invoice" default="0">
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
					<cfset application.user.adminCreate(newID,form.firstName,form.lastName,form.username,form.password,trim(form.email),request.udf.NumbersOnly(form.phone),request.udf.NumbersOnly(form.mobile),form.carrierID,form.locale,form.timezone,form.admin,form.report,form.invoice,form.active)>
					<cfloop list="#form.projectids#" index="i">
						<cfif listFind(form.adminids,i)>
							<cfset project_admin = 1>
						<cfelse>	
							<cfset project_admin = 0>	
						</cfif>
						<cfset project = application.project.getDistinct(i)>
						<cfset application.role.add(i,newID,project_admin,project.reg_file_view,project.reg_file_edit,project.reg_file_comment,project.reg_issue_view,project.reg_issue_edit,project.reg_issue_assign,project.reg_issue_resolve,project.reg_issue_close,project.reg_issue_comment,project.reg_msg_view,project.reg_msg_edit,project.reg_msg_comment,project.reg_mstone_view,project.reg_mstone_edit,project.reg_mstone_comment,project.reg_todolist_view,project.reg_todolist_edit,project.reg_todo_edit,project.reg_todo_comment,project.reg_time_view,project.reg_time_edit,project.reg_bill_view,project.reg_bill_edit,project.reg_bill_rates,project.reg_bill_invoices,project.reg_bill_markpaid,project.reg_report,project.reg_svn)>
						<cfif find(i,form.projectids)>
							<cfif request.udf.isEmail(trim(form.email))>
								<cfset application.notify.add(newID,i,'1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0','1','0')>
							<cfelse>
								<cfset application.notify.add(newID,i)>
							</cfif>
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
				<cfset application.user.adminUpdate(form.userid,form.firstName,form.lastName,form.username,form.password,trim(form.email),request.udf.NumbersOnly(form.phone),request.udf.NumbersOnly(form.mobile),form.carrierID,form.locale,form.timezone,form.admin,form.report,form.invoice,form.active)>
				<cfif not compare(form.from,'admin')>
					<cflocation url="users.cfm" addtoken="false">
				<cfelse>
					<cflocation url="../people.cfm?p=#url.p#" addtoken="false">
				</cfif>
			</cfif>
		</cfcase>
	</cfswitch>
</cfif>

<cfif StructKeyExists(url,"u")>
	<cfset user = application.user.get(url.u)>
	<cfset projects = application.project.get(url.u)>
	<cfset form.firstName = user.firstName>
	<cfset form.lastName = user.lastName>
	<cfset form.username = user.username>
	<cfset form.email = user.email>
	<cfset form.phone = user.phone>
	<cfset form.mobile = user.mobile>
	<cfset form.carrierID = user.carrierID>
	<cfif compare(user.locale,'')>
		<cfset form.locale = user.locale>
	<cfelse>
		<cfset form.locale = application.settings.default_locale>
	</cfif>
	<cfif compare(user.timezone,'')>
		<cfset form.timezone = user.timezone>
	<cfelse>
		<cfset form.timezone = application.settings.default_timezone>
	</cfif>
	<cfset form.admin = user.admin>
	<cfset form.report = user.report>
	<cfset form.invoice = user.invoice>
	<cfset form.active = user.active>
	<cfset user_projects = application.project.get(url.u)>
	<cfset notifications = application.project.userNotify(url.u)>
	<cfquery name="admin_projects" dbtype="query">
		select * from user_projects where admin = 1
	</cfquery>
<cfelse> <!--- new user --->
	<cfset projects = application.project.get()>
	<cfset form.firstName = "">
	<cfset form.lastName = "">
	<cfset form.username = "">
	<cfset form.password = "">
	<cfset form.email = "">
	<cfset form.phone = "">
	<cfset form.mobile = "">
	<cfset form.carrierID = "">
	<cfset form.locale = application.settings.default_locale>
	<cfset form.timezone = application.settings.default_timezone>
	<cfset form.admin = 0>
	<cfset form.report = 0>
	<cfset form.invoice = 0>
	<cfset form.active = 1>
</cfif>

<cfif not isDefined("application.carriers")>
	<cfset application.carriers = application.carrier.get(activeOnly=true)>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Admin">

<cfhtmlhead text="<script type='text/javascript' src='#application.settings.mapping#/js/jquery.history_remote.pack.js'></script>
<script type='text/javascript' src='#application.settings.mapping#/js/jquery.tabs.pack.js'></script>
<link rel='stylesheet' href='#application.settings.mapping#/css/jquery.tabs.css' media='screen,projection' type='text/css' />
<!--[if lte IE 7]>
<link rel='stylesheet' href='#application.settings.mapping#/css/jquery.tabs-ie.css' type='text/css' media='projection, screen' />
<![endif]-->
<script type='text/javascript'>
	$(document).ready(function() {
		$('##container1').tabs();
		$('##perm').columnHover();
	});
</script>
">

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
					
				 	<h3 class="mb10 ml20"><cfif StructKeyExists(url,"u")>Edit User &raquo; #form.firstName# #form.lastName#<cfelse>Add New User</cfif></h3>

				 	<cfif compare(variables.errors,'')>
				 	<div class="wrapper">
					 	<div class="error">
						 	<h4 class="alert b r">An Error Has Occurred</h3>
						 	<ul>#variables.errors#</ul>
						</div>
					</div>
				 	</cfif>

					<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="frm">
			 	
				 	<div id="container1">
		            <ul>
		                <li><a href="##user"><span>User Information</span></a></li>
		                <li><a href="##projects"><span>Projects</span></a></li>
				 	</ul>
				 	<div id="user">

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
								<option value="">&nbsp;</option>
						</cfoutput>

						<cfoutput query="application.carriers" group="country">
						<optgroup label="#country#">
						<cfoutput>
						<option value="#carrierID#"<cfif not compare(form.carrierID,carrierID)> selected="selected"</cfif>>#HTMLEditFormat(carrier)#</option>
						</cfoutput>
						</optgroup>
						</cfoutput>
						
						<cfoutput>
							</select> <span style="font-size:85%;" class="i">(used for SMS notifications)</span>
						</p>
						<p>
						<label for="locale">Locale:</label>
						<select name="locale" id="locale">
						<cfloop list="#Server.Coldfusion.SupportedLocales#" index="i">
							<option value="#i#"<cfif not compare(i,form.locale)> selected="selected"</cfif>>#i#</option>
						</cfloop>				
						</select>
						</p>
						<p>
						<label for="timezone">Timezone:</label>
						<select name="timezone" id="timezone" size="10">
						<cfloop from="1" to="#ArrayLen(application.timezones)#" index="i">
							<option value="#application.timezones[i]#"<cfif not compare(application.timezones[i],form.timezone)> selected="selected"</cfif>>#application.timezones[i]#</option>
						</cfloop>				
						</select>
						</p>		
						<p>
						<label for="admin">Global Admin?</label>
						<input type="checkbox" name="admin" id="admin" value="1" class="checkbox"<cfif form.admin> checked="checked"</cfif> />
						</p>
						<p>
						<label for="report">Global Reporting?</label>
						<input type="checkbox" name="report" id="report" value="1" class="checkbox"<cfif form.report> checked="checked"</cfif> />
						</p>
						<p>
						<label for="invoice">Global Invoicing?</label>
						<input type="checkbox" name="invoice" id="invoice" value="1" class="checkbox"<cfif form.invoice> checked="checked"</cfif> />
						</p>
						<p>
						<label for="active">Active?</label>
						<input type="checkbox" name="active" id="active" value="1" class="checkbox"<cfif form.active> checked="checked"</cfif> />
						</p>
					
						<p><label>&nbsp;</label>
						<input type="submit" name="submit" value="<cfif StructKeyExists(url,"u")>Update<cfelse>Add</cfif> User" class="button shorter" />
						or <a href="<cfif not compare(form.from,'admin')>users.cfm<cfelse>../people.cfm?p=#url.p#</cfif>">Cancel</a>
						</p>
					
					</div>
					
					<div id="projects" class="wrapper">

						<table id="perm" class="admin full permissions mt20">
						<thead>
						<tr>
							<th class="tal">Project</th>
							<th>Active</th>
							<th>Admin</th>
							<cfif StructKeyExists(url,"u")>
								<th>Permissions</th>
								<th>Notifications</th>
							</cfif>
						</tr>
						</thead>
						<tbody>
						<cfloop query="projects">
						<tr>
							<td class="tal"><label for="p_#replace(projectid,'-','','ALL')#" class="cb">#name#</label></td>
							<cfif StructKeyExists(url,"u")>
								<td><img src="../images/<cfif listFind(valueList(user_projects.projectid),projectid)>close<cfelse>cancel</cfif>.gif" height="16" width="16" border="0" alt="#YesNoFormat(listFind(valueList(user_projects.projectid),projectid))#" /></td>
								<td><img src="../images/<cfif listFind(valueList(admin_projects.projectid),projectid)>close<cfelse>cancel</cfif>.gif" height="16" width="16" border="0" alt="#YesNoFormat(listFind(valueList(admin_projects.projectid),projectid))#" /></td>
								<td><a href="../userPermissions.cfm?u=#url.u#&amp;p=#projectID#&amp;from=admin">Permissions</a></td>
								<td><a href="userNotifications.cfm?u=#url.u#&amp;p=#projectID#">Notifications</a></td>
							<cfelse>
								<td><input type="checkbox" name="projectids" value="#projectID#" /></td>
								<td><input type="checkbox" name="adminids" value="#projectID#" />
								<input type="hidden" name="all_proj_ids" value="#projectid#" /></td>
							</cfif>
						</tr>
						</cfloop>
						</tbody>
						</table>
				 	</div>
				</div>

				<cfif StructKeyExists(url,"u")>
					<input type="hidden" name="userid" value="#url.u#" />
				</cfif>
				<input type="hidden" name="from" value="#form.from#" />

				</form>&nbsp;

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