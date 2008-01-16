<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(form,"submit")>
	<cfparam name="form.email_todos" default="0">
	<cfparam name="form.mobile_todos" default="0">
	<cfparam name="form.email_mstones" default="0">
	<cfparam name="form.mobile_mstones" default="0">
	<cfparam name="form.email_issues" default="0">
	<cfparam name="form.mobile_issues" default="0">
	<cfparam name="form.admin" default="0">
	<cfparam name="form.active" default="0">
	<cfswitch expression="#form.submit#">
		<cfcase value="Add User">
			<cfset qCheckUser = application.user.get('','',form.username)>
			<cfif not qCheckUser.recordCount>
				<cfset application.user.adminCreate(form.userid,form.firstName,form.lastName,form.username,form.password,form.email,request.udf.NumbersOnly(form.phone),request.udf.NumbersOnly(form.mobile),form.carrierID,form.email_todos,form.mobile_todos,form.email_mstones,form.mobile_mstones,form.email_issues,form.mobile_issues,form.admin,form.active)>
				<cflocation url="users.cfm" addtoken="false">
			<cfelse>
				<cfset variables.error = "Username already exists!">
			</cfif>
		</cfcase>
		<cfcase value="Update User">
			<cfset application.user.adminUpdate(form.userid,form.firstName,form.lastName,form.username,form.password,form.email,request.udf.NumbersOnly(form.phone),request.udf.NumbersOnly(form.mobile),form.carrierID,form.email_todos,form.mobile_todos,form.email_mstones,form.mobile_mstones,form.email_issues,form.mobile_issues,form.admin,form.active)>
			<cfset application.role.remove('',form.userid)>
			<cfparam name="form.projectid" default="">
			<cfloop list="#form.projectid#" index="i">
				<cfset application.role.add(i,form.userid,ListGetAt(form.role,listFind(form.all_proj_ids,i)))>
			</cfloop>
			<cflocation url="users.cfm" addtoken="false">
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
<cfparam name="form.email_todos" default="0">
<cfparam name="form.mobile_todos" default="0">
<cfparam name="form.email_mstones" default="0">
<cfparam name="form.mobile_mstones" default="0">
<cfparam name="form.email_issues" default="0">
<cfparam name="form.mobile_issues" default="0">
<cfparam name="form.admin" default="0">
<cfparam name="form.active" default="0">

<cfif StructKeyExists(url,"u")>
	<cfset user = application.user.get(url.u)>
	<cfset form.firstName = user.firstName>
	<cfset form.lastName = user.lastName>
	<cfset form.username = user.username>
	<cfset form.email = user.email>
	<cfset form.phone = user.phone>
	<cfset form.mobile = user.mobile>
	<cfset form.carrierID = user.carrierID>
	<cfset form.email_todos = user.email_todos>
	<cfset form.mobile_todos = user.mobile_todos>
	<cfset form.email_mstones = user.email_mstones>
	<cfset form.mobile_mstones = user.mobile_mstones>
	<cfset form.email_issues = user.email_issues>
	<cfset form.mobile_issues = user.mobile_issues>
	<cfset form.admin = user.admin>
	<cfset form.active = user.active>
	<cfset user_projects = application.project.get(url.u)>
<cfelse>
	<cfset user_projects = QueryNew('projectID')>
	<cfparam name="form.projectid" default="">
	<cfloop list="#form.projectid#" index="i">
		<cfset QueryAddRow(user_projects)>
		<cfset QuerySetCell(user_projects, 'projectid', i)>		
	</cfloop>
</cfif>

<cfset projects = application.project.getDistinct()>
<cfparam name="form.all_proj_ids" default="#valueList(projects.projectid)#">
<cfset default_roles = "">
<cfloop query="projects">
	<cfset default_roles = listAppend(default_roles,'0')>
</cfloop>
<cfparam name="form.role" default="#default_roles#">

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Admin">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
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

				 	<cfif StructKeyExists(variables,'error')>
				 	<h4 class="alert b r i mb15">#variables.error#</h4>
				 	</cfif>
				 	
				 	<form action="#cgi.script_name#" method="post" class="frm">
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
						<label for="username">Username:</label> 
						<input type="text" name="username" id="username" value="#HTMLEditFormat(form.username)#" maxlength="30" class="shorter" />
						</p>
						<p>
						<label for="password">Password:</label> 
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

							<cfoutput query="application.mobile" group="country">
							<optgroup label="#country#">
							<cfoutput>
							<option value="#carrierID#"<cfif not compare(form.carrierID,carrierID)> selected="selected"</cfif>>#carrier#</option>
							</cfoutput>
							</cfoutput>
						
						<cfoutput>
							</select> <span style="font-size:85%;" class="i">(used for SMS notifications)
						</p>				
						<p>
						<label for="admin">Admin?</label>
						<input type="checkbox" name="admin" id="admin" value="1" class="checkbox"<cfif form.admin> checked="checked"</cfif> />
						</p>
						<p>
						<label for="active">Active?</label>
						<input type="checkbox" name="active" id="active" value="1" class="checkbox"<cfif form.active> checked="checked"</cfif> />
						</p>
						</fieldset>
						
						<fieldset class="mb15">
						 	<legend>Notifications</legend>
						 	
							<table class="admin half mb15">
							<tr><th>Action</th><th class="tac">Email</th><th class="tac">Mobile</th></tr>
							<tr>
								<td class="tal">New To-Dos</td>
								<td class="tac"><input type="checkbox" name="email_todos" value="1"<cfif form.email_todos> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_todos" value="1"<cfif form.mobile_todos> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> /></td>
							</tr>
							<tr>
								<td class="tal">New Milestones</td>
								<td class="tac"><input type="checkbox" name="email_mstones" value="1"<cfif form.email_mstones> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_mstones" value="1"<cfif form.mobile_mstones> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> /></td>
							</tr>
							<tr>
								<td class="tal">New Issues</td>
								<td class="tac"><input type="checkbox" name="email_issues" value="1"<cfif form.email_issues> checked="checked"</cfif> /></td>
								<td class="tac"><input type="checkbox" name="mobile_issues" value="1"<cfif form.mobile_issues> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> /></td>
							</tr>
							</table>						 	
						 	
						 </fieldset>
						
						<fieldset class="mb20">
							<legend>Projects</legend>
							<cfloop query="projects">
							<p>
							<input type="checkbox" name="projectid" value="#projectid#" id="p_#replace(projectid,'-','','ALL')#" class="cb"<cfif listFind(valueList(user_projects.projectid),projectid)> checked="checked"</cfif> />&nbsp;<label for="p_#replace(projectid,'-','','ALL')#" class="cb">#name#</label>
							<cfif StructKeyExists(url,"u")> <!--- update --->
								<cfset thisProjectRole = application.role.get(url.u,projectid)>
								<select name="role">
									<option value="User"<cfif not compare(thisProjectRole.role,'User')> selected="selected"</cfif>>User</option>
									<option value="Admin"<cfif not compare(thisProjectRole.role,'Admin')> selected="selected"</cfif>>Admin</option>
									<option value="Read-Only"<cfif not compare(thisProjectRole.role,'Read-Only')> selected="selected"</cfif>>Read-Only</option>
								</select>	
							<cfelse> <!--- new user --->
								<select name="role">
									<option value="User"<cfif not compare(ListGetAt(form.role,listFind(form.all_proj_ids,projectid)),'User')> selected="selected"</cfif>>User</option>
									<option value="Admin"<cfif not compare(ListGetAt(form.role,listFind(form.all_proj_ids,projectid)),'Admin')> selected="selected"</cfif>>Admin</option>
									<option value="Read-Only"<cfif not compare(ListGetAt(form.role,listFind(form.all_proj_ids,projectid)),'Read-Only')> selected="selected"</cfif>>Read-Only</option>
								</select>	
							</cfif>
							</p>
							<input type="hidden" name="all_proj_ids" value="#projectid#" />
							</cfloop>
						
						</fieldset>
						
						<p>
						<input type="submit" name="submit" value="<cfif StructKeyExists(url,"u")>Update<cfelse>Add</cfif> User" class="button shorter" />
						or <a href="users.cfm">Cancel</a>
						</p>
						<cfif StructKeyExists(url,"u")>
							<input type="hidden" name="userid" value="#url.u#" />
						</cfif>
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