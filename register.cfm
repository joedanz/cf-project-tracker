<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif not application.settings.allowRegister>
	<cfoutput><h2>No Auto-Registration Allowed!</h2></cfoutput>
	<cfabort>
</cfif>

<cfparam name="form.firstName" default="">
<cfparam name="form.lastName" default="">
<cfparam name="form.username" default="">
<cfparam name="form.password" default="">
<cfparam name="form.email" default="">
<cfparam name="form.projectID" default="">
<cfparam name="errors" default="">

<cfif StructKeyExists(form,"register")>
	<cfif not compare(trim(form.username),'')>
		<cfset errors = errors & '<li class="alert">You must enter a username.</li>'>
	</cfif>
	<cfif not compare(trim(form.password),'')>
		<cfset errors = errors & '<li class="alert">You must enter a password.</li>'>
	</cfif>
	<cfif not request.udf.isEmail(trim(form.email))>
		<cfset errors = errors & '<li class="alert">You must enter a valid email address.</li>'>
	</cfif>
	<cfif not compare(trim(form.projectID),'')>
		<cfset errors = errors & '<li class="alert">You must select at least one project.</li>'>
	</cfif>
	<cfset findUser = application.user.get(username=trim(form.username))>
	<cfif findUser.recordCount>
		<cfset errors = errors & '<li class="alert">The username you selected is already being used.</li>'>
	</cfif>
	
	<cfif findUser.recordCount eq 0 and not compare(errors,'')>
		<cfset newID = createUUID()>
		<!--- add user --->	
		<cfset application.user.selfRegister(newID,form.firstName,form.lastName,form.username,form.password,form.email)>
		<!--- add default roles for selected projects --->
		<cfloop list="#form.projectID#" index="i">
			<!--- get project default roles --->
			<cfset project = application.project.getDistinct(i)>
			<!--- assign default project roles --->
			<cfset application.role.add(i,newID,'0',project.reg_file_view,project.reg_file_edit,project.reg_file_comment,project.reg_issue_view,project.reg_issue_edit,project.reg_issue_assign,project.reg_issue_resolve,project.reg_issue_close,project.reg_issue_comment,project.reg_msg_view,project.reg_msg_edit,project.reg_msg_comment,project.reg_mstone_view,project.reg_mstone_edit,project.reg_mstone_comment,project.reg_todolist_view,project.reg_todolist_edit,project.reg_todo_edit,project.reg_todo_comment,project.reg_time_view,project.reg_time_edit,project.reg_bill_view,project.reg_bill_edit,project.reg_bill_rates,project.reg_bill_invoices,project.reg_bill_markpaid,project.reg_svn)>
		</cfloop>
		<cflocation url="confirm.cfm" addtoken="false">
	</cfif>
</cfif>

<cfset projects = application.project.getDistinct(allowReg=true)>

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Register">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

			<div class="header">
				<h2>Register</h2>
			</div>
			<div class="content">
				<div class="wrapper">
					
					<cfif isDefined("success")>
						<div class="successbox">
							
						</div>
					<cfelse>	
					
						<cfif compare(errors,'')>
							<div class="alertbox">
								One or more errors have occurred with your submission:
								<ul class="errors">
									#errors#
								</ul>
							</div>
						</cfif>
	
					 	<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="frm">
	
							 <fieldset class="mb15">
							 	<legend>Projects</legend>
							 	<ul class="projects">
								<cfloop query="projects">
									<li>
										<input type="checkbox" name="projectID" value="#projectID#" id="p#currentRow#" class="checkbox"<cfif projects.recordCount eq 1 or listFind(form.projectID,projectID)> checked="checked"</cfif> /> 
										<label for="p#currentRow#">#name#</label>
									</li>
								</cfloop>
								</ul>
							 </fieldset>
							 
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
							<label for="password" class="req">Password:</label> 
							<input type="text" name="password" id="password"<cfif not StructKeyExists(url,"u")> value="#HTMLEditFormat(form.password)#"</cfif> maxlength="20" class="shorter" />
							</p>
							<p>
							<label for="email" class="req">Email:</label> 
							<input type="text" name="email" id="email" value="#HTMLEditFormat(form.email)#" maxlength="120" />
							</p>									 	
							 </fieldset>
	
							<input type="submit" name="register" class="button" value="Register Now" />
	
						</form>
					</cfif>
					
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