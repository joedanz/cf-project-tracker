<cfsetting enablecfoutputonly="true">

<cfparam name="whichTab" default="">
<cfset variables.errors = "">

<cfif StructKeyExists(form,"submit1")>
	<cfif compare(trim(form.email),'') and not request.udf.isEmail(trim(form.email))>
		<cfset variables.errors = variables.errors & '<li>The email address you entered was invalid.</li>'>
	<cfelse>
		<cfset application.user.userUpdate(session.user.userID,form.firstname,form.lastname,form.email,request.udf.NumbersOnly(form.phone),request.udf.NumbersOnly(form.mobile),form.carrierID)>
	</cfif>
	<cfset session.user.firstName = form.firstname>
	<cfset session.user.lastName = form.lastname>
	<cfset session.user.email = form.email>
	<cfset session.user.phone = form.phone>
	<cfset session.user.mobile = form.mobile>
	<cfset session.user.carrierID = form.carrierID>
<cfelseif StructKeyExists(form,"notifysub")>
	<cfloop list="#notify_proj_ids#" index="i">
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
		<cfset application.notify.update(session.user.userid,i,Evaluate("form.email_files_"&replace(i,'-','','ALL')),Evaluate("form.mobile_files_"&replace(i,'-','','ALL')),Evaluate("form.email_issues_"&replace(i,'-','','ALL')),Evaluate("form.mobile_issues_"&replace(i,'-','','ALL')),Evaluate("form.email_msgs_"&replace(i,'-','','ALL')),Evaluate("form.mobile_msgs_"&replace(i,'-','','ALL')),Evaluate("form.email_mstones_"&replace(i,'-','','ALL')),Evaluate("form.mobile_mstones_"&replace(i,'-','','ALL')),Evaluate("form.email_todos_"&replace(i,'-','','ALL')),Evaluate("form.mobile_todos_"&replace(i,'-','','ALL')))>
	</cfloop>
	<cfset whichTab = 3>	
<cfelseif StructKeyExists(form,"submit2")>
	<cfif not compareNoCase(form.pass1,form.pass2)>
		<cfset newPass = form.pass1>
	<cfelse>		
		<cfset newPass = "">
	</cfif>
	<cfset application.user.acctUpdate(session.user.userID,form.username,newPass)>
	<cfset session.user.username = form.username>
	<cfset whichTab = 4>
<cfelseif StructKeyExists(form,"submitimage")>
	<!--- this include prevents invalid tag error from on earlier versions --->
	<cfif application.isCF8 or application.isRailo>
		<cfinclude template="img_proc_acct_cf8.cfm">
	<cfelseif application.isBD>
		<cfinclude template="img_proc_acct_bd.cfm">
	</cfif>
	<cfset whichTab = 5>
<cfelseif StructKeyExists(url,"rmvimg")>
	<cftry>
	<cffile action="delete" file="#application.userFilesPath#avatars/#session.user.userid#_72.jpg">
	<cffile action="delete" file="#application.userFilesPath#avatars/#session.user.userid#_48.jpg">
	<cffile action="delete" file="#application.userFilesPath#avatars/#session.user.userid#_24.jpg">
	<cffile action="delete" file="#application.userFilesPath#avatars/#session.user.userid#_16.jpg">
	<cfcatch></cfcatch>
	</cftry>
	<cfset application.user.setImage(session.user.userID,0)>
	<cfset whichTab = 5>
<cfelseif StructKeyExists(form,"style")>
	<cfset session.style = form.style>
	<cfset application.user.setStyle(session.user.userID,form.style)>
	<cfset whichTab = 6>
	<cfif not application.isCF8 and not application.isBD and not application.isRailo>
		<cfset whichTab = whichTab - 1>
	</cfif>
<cfelseif StructKeyExists(url,"editStyle")>
	<cfset whichTab = 6>
	<cfif not application.isCF8 and not application.isBD and not application.isRailo>
		<cfset whichTab = whichTab - 1>
	</cfif>
<cfelseif StructKeyExists(url,"rp")>
	<cfset application.role.remove(url.rp,session.user.userid)>
</cfif>

<cfset user = application.user.get(session.user.userid)>
<cfset projects = application.project.get(session.user.userid)>
<cfset notifications = application.project.userNotify(session.user.userid)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; My Account">

<cfhtmlhead text="<script type='text/javascript'>
	function confirmSubmit1() {
		var errors = '';
		if (document.edit.firstname.value == '') {errors = errors + '   ** You must enter your first name.\n';}
		if (document.edit.lastname.value == '') {errors = errors + '   ** You must enter your last name.\n';}
		if (document.edit.email.value == '') {errors = errors + '   ** You must enter your email.\n';}
		if (errors != '') {
			alert('Please correct the following errors:\n\n' + errors)
			return false;
		} else return true;
	}
	function confirmSubmit2() {
		var errors = '';
		if (document.editacct.username.value == '') {errors = errors + '   ** You must enter your username.\n';}
		if ((document.editacct.pass1.value != '' || document.editacct.pass2.value != '') && document.editacct.pass1.value != document.editacct.pass2.value) {errors = errors + '   ** The new passwords must match.\n';}
		if (errors != '') {
			alert('Please correct the following errors:\n\n' + errors)
			return false;
		} else return true;
	}
</script>
<script type='text/javascript' src='#application.settings.mapping#/js/jquery.history_remote.pack.js'></script>
<script type='text/javascript' src='#application.settings.mapping#/js/jquery.tabs.pack.js'></script>
<link rel='stylesheet' href='#application.settings.mapping#/css/jquery.tabs.css' media='screen,projection' type='text/css' />
<!--[if lte IE 7]>
<link rel='stylesheet' href='#application.settings.mapping#/css/jquery.tabs-ie.css' type='text/css' media='projection, screen' />
<![endif]-->
<script type='text/javascript'>
	$(function() {
		$('##container1').tabs(#whichTab#);
	});
</script>
">

<cfoutput>
<div id="container">

	<!--- left column --->
	<div class="left">
		<div class="main">

			<div class="header">
				<h2 class="user">Edit account details</h2>
			</div>
			<div class="content">
				
			 	<cfif compare(variables.errors,'')>
			 	<div class="wrapper">
				 	<div class="error">
					 	<h4 class="alert b r">An Error Has Occurred</h3>
					 	<ul>#variables.errors#</ul>
					</div>
				</div>
			 	</cfif>				
				
		        <div id="container1">
		            <ul>
		                <li><a href="##user"><span>General Info</span></a></li>
		                <li><a href="##projects"><span>Projects</span></a></li>
		                <li><a href="##notifications"><span>Notifications</span></a></li>
						<li><a href="##account"><span>Account Info</span></a></li>
		                <cfif application.isCF8 or application.isBD or application.isRailo>
							<li><a href="##avatar"><span>Avatar</span></a></li>
						</cfif>
		                <li><a href="##skin"><span>Style</span></a></li>
		            </ul>
		            <div id="user">   
						<form action="#cgi.script_name#" method="post" name="edit" class="frm">
							<p>
							<label for="fname" class="req">First Name:</label>
							<input type="text" name="firstname" id="fname" value="#HTMLEditFormat(user.firstName)#" maxlength="12" />
							</p>
							<p>
							<label for="lname" class="req">Last Name:</label>
							<input type="text" name="lastname" id="lname" value="#HTMLEditFormat(user.lastName)#" maxlength="20" />
							</p>				
							<p>
							<label for="email">Email:</label>
							<input type="text" name="email" id="email" value="#HTMLEditFormat(user.email)#" maxlength="120" />
							</p>
							<p>
							<label for="phone">Phone:</label>
							<input type="text" name="phone" id="phone" value="#HTMLEditFormat(request.udf.phoneFormat(user.phone,"(xxx) xxx-xxxx"))#" maxlength="15" />
							</p>
							<p>
							<label for="mobile">Mobile:</label>
							<input type="text" name="mobile" id="mobile" value="#HTMLEditFormat(request.udf.phoneFormat(user.mobile,"(xxx) xxx-xxxx"))#" maxlength="15" />
							</p>
							<p>
							<label for="carrier">Carrier:</label>
							<select name="carrierID" id="carrier">
								<option value=""></option>
						</cfoutput>								
								<cfoutput query="application.carriers" group="country">
								<optgroup label="#country#">
								<cfoutput>
								<option value="#carrierID#"<cfif not compare(user.carrierID,carrierID)> selected="selected"</cfif>>#carrier#</option>
								</cfoutput>
								</cfoutput>
						<cfoutput>
							</select> <span style="font-size:85%;" class="i">(used for SMS notifications)
							</p>
							<label for="submit1">&nbsp;</label>
							<input type="submit" class="button" name="submit1" id="submit1" value="Update Account" onclick="return confirmSubmit1();" />				
						</form>								
		            </div>
		            <div id="projects">
						<table class="clean admin full mb10">
						<tr>
							<th>Project</th>
							<th class="tac">Owner</th>
							<th class="tac">Admin</th>
							<th class="tac">Files</th>
							<th class="tac">Issues</th>
							<th class="tac">Messages</th>
							<th class="tac">Milestones</th>
							<th class="tac">To-Dos</th>
							<th class="tac">Time</th>
							<th class="tac">Billing</th>
							<th class="tac">SVN</th>
							<th class="tac">Remove</th>
						</tr>
						<cfloop query="projects">
						<tr>
							<td>#name#</td>
							<td class="tac"><img src="./images/<cfif not compareNoCase(session.user.userid,ownerid)>close<cfelse>cancel</cfif>.gif" height="16" width="16" border="0" alt="#YesNoFormat(compareNoCase(session.user.userid,ownerid))#" /></td>
							<td class="tac"><img src="./images/<cfif admin eq 1>close<cfelse>cancel</cfif>.gif" height="16" width="16" border="0" alt="#YesNoFormat(admin)#" /></td>
							<td class="tac"><cfif files eq 2>Full Access<cfelseif files eq 1>Read-Only<cfelseif files eq 0>None</cfif></td>
							<td class="tac"><cfif issues eq 2>Full Access<cfelseif issues eq 1>Read-Only<cfelseif issues eq 0>None</cfif></td>
							<td class="tac"><cfif msgs eq 2>Full Access<cfelseif msgs eq 1>Read-Only<cfelseif msgs eq 0>None</cfif></td>
							<td class="tac"><cfif mstones eq 2>Full Access<cfelseif mstones eq 1>Read-Only<cfelseif mstones eq 0>None</cfif></td>
							<td class="tac"><cfif todos eq 2>Full Access<cfelseif todos eq 1>Read-Only<cfelseif todos eq 0>None</cfif></td>
							<td class="tac"><cfif timetrack eq 2>Full Access<cfelseif timetrack eq 1>Read-Only<cfelseif timetrack eq 0>None</cfif></td>
							<td class="tac"><cfif billing eq 2>Full Access<cfelseif billing eq 1>Read-Only<cfelseif billing eq 0>None</cfif></td>
							<td class="tac"><img src="./images/<cfif svn eq 1>close<cfelse>cancel</cfif>.gif" height="16" width="16" border="0" alt="#YesNoFormat(svn)#" /></td>
							<td class="tac">[<a href="#cgi.script_name#?rp=#projectid###projects" onclick="return confirm('Are you sure you wish to remove yourself from this project?')">remove</a>]</td>
						</tr>
						</cfloop>
						</table>			
					</div>
		            <div id="notifications">
			            <form action="#cgi.script_name#" method="post" name="edit">
							<table class="clean admin full mb10">
							<tr>
								<th width="25%">Project</th>
								<th class="tac" width="15%">Files</th>
								<th class="tac" width="15%">Issues</th>
								<th class="tac" width="15%">Messages</th>
								<th class="tac" width="15%">Milestones</th>
								<th class="tac" width="15%">To-Dos</th>
	
							</tr>
							<cfloop query="notifications">
								<tr>
									<td class="tal">#name#</td>
									<td class="tac">
										<input type="checkbox" name="email_files_#replace(projectID,'-','','ALL')#" id="e_f_#projectID#" value="1"<cfif email_files> checked="checked"</cfif> />
										<label for="e_f_#projectID#"><img src="./images/email.png" height="16" width="16" border="0" alt="Email" /></label> &nbsp;
										<label for="m_f_#projectID#"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile" /></label><input type="checkbox" name="mobile_files_#replace(projectID,'-','','ALL')#" id="m_f_#projectID#" value="1"<cfif mobile_files> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> />				
									</td>
									<td class="tac">
										<input type="checkbox" name="email_issues_#replace(projectID,'-','','ALL')#" id="e_i_#projectID#" value="1"<cfif email_issues> checked="checked"</cfif> />
										<label for="e_i_#projectID#"><img src="./images/email.png" height="16" width="16" border="0" alt="Email" /></label> &nbsp;
										<label for="m_i_#projectID#"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile" /></label><input type="checkbox" name="mobile_issues_#replace(projectID,'-','','ALL')#" id="m_i_#projectID#" value="1"<cfif mobile_issues> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> />
									</td>
									<td class="tac">
										<input type="checkbox" name="email_msgs_#replace(projectID,'-','','ALL')#" id="e_msg_#projectID#" value="1"<cfif email_msgs> checked="checked"</cfif> />
										<label for="e_msg_#projectID#"><img src="./images/email.png" height="16" width="16" border="0" alt="Email" /></label> &nbsp;
										<label for="m_msg_#projectID#"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile" /></label><input type="checkbox" name="mobile_msgs_#replace(projectID,'-','','ALL')#" id="m_msg_#projectID#" value="1"<cfif mobile_msgs> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> />
									</td>
									<td class="tac">
										<input type="checkbox" name="email_mstones_#replace(projectID,'-','','ALL')#" id="e_m_#projectID#" value="1"<cfif email_mstones> checked="checked"</cfif> />
										<label for="e_m_#projectID#"><img src="./images/email.png" height="16" width="16" border="0" alt="Email" /></label> &nbsp;
										<label for="m_m_#projectID#"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile" /></label><input type="checkbox" name="mobile_mstones_#replace(projectID,'-','','ALL')#" id="m_m_#projectID#" value="1"<cfif mobile_mstones> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> />
									</td>
									<td class="tac">
										<input type="checkbox" name="email_todos_#replace(projectID,'-','','ALL')#" id="e_t_#projectID#" value="1"<cfif email_todos> checked="checked"</cfif> />
										<label for="e_t_#projectID#"><img src="./images/email.png" height="16" width="16" border="0" alt="Email" /></label> &nbsp;
										<label for="m_t_#projectID#"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile" /></label><input type="checkbox" name="mobile_todos_#replace(projectID,'-','','ALL')#" id="m_t_#projectID#" value="1"<cfif mobile_todos> checked="checked"</cfif><cfif not isNumeric(user.mobile)> disabled="disabled"</cfif> />
									<input type="hidden" name="notify_proj_ids" value="#projectid#" />
									</td>
								</tr>
							</cfloop>
							</table>
			
							<input type="submit" class="button" name="notifysub" id="submit5" value="Update Notifications" />
							
							<cfif not isNumeric(user.mobile)>
								<h6 class="b r i mt20">Note: You must have a valid mobile number to enable Mobile Notifications.</h6>
							</cfif>
						</form>
					</div>		            
		            <div id="account">            
						<form action="#cgi.script_name#" method="post" name="editacct" class="frm">
							<p>
							<label for="user" class="req">Username:</label>
							<input type="text" name="username" id="username" value="#HTMLEditFormat(user.username)#" maxlength="20" />
							</p>					
							<p>
							<label for="pass1">New Password:</label>
							<input type="text" name="pass1" id="pass1" value="" maxlength="20" />
							</p>
							<p>
							<label for="pass2">Confirm Password:</label>
							<input type="text" name="pass2" id="pass2" value="" maxlength="20" />
							</p>
							<label for="submit2">&nbsp;</label>
							<input type="submit" class="button" name="submit2" id="submit2" value="Update Account" onclick="return confirmSubmit2();" />				
						</form>								
		            </div>
					<cfif application.isCF8 or application.isBD or application.isRailo>			
		            <div id="avatar">
						<form action="#cgi.script_name#" method="post" name="edit" class="frm" enctype="multipart/form-data">
							<p>
							<label for="img">&nbsp;</label>
							<cfif user.avatar eq 1>
							<img src="#application.settings.userFilesMapping#/avatars/#session.user.userid#_72.jpg" height="72" width="72" border="0" alt="#user.firstName# #user.lastName#" style="border:1px solid ##666;" />
							<a href="#cgi.script_name#?rmvimg">remove</a>
							<cfelse>
							<img src="./images/noavatar72.gif" height="72" width="72" border="0" alt="No Avatar" style="border:1px solid ##666;" />
							</cfif>
							</p>
							<p>
							<label for="imgfile">Profile Image:</label>
							<input type="file" name="imagefile" id="imgfile" />
							</p>				
							<label for="submit3">&nbsp;</label>
							<input type="submit" class="button" name="submitimage" id="submit3" value="Upload Image" />				
						</form>
		            </div>
					</cfif>
		            <div id="skin">
						<form action="#cgi.script_name#" method="post" name="edit" class="frm">
							<p>
							<label for="headstyle">Set Style:</label>
							<select name="style" id="headstyle">
								<option value="blue"<cfif not compare(user.style,'blue')> selected="selected"</cfif>>Blue</option>
								<option value="green"<cfif not compare(user.style,'green')> selected="selected"</cfif>>Green</option>
								<option value="grey"<cfif not compare(user.style,'grey')> selected="selected"</cfif>>Grey</option>
								<option value="red"<cfif not compare(user.style,'red')> selected="selected"</cfif>>Red</option>
								<option value="stars"<cfif not compare(user.style,'stars')> selected="selected"</cfif>>Stars</option>
							</select>
							</p>
							<label for="submit4">&nbsp;</label>					
							<input type="submit" class="button" name="skinsub" id="submit4" value="Set Style" />				
						</form>
		            </div>
		        </div>							

			</div>
		
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">

	</div>

</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">