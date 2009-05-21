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
<cfelseif StructKeyExists(form,"submit2")>
	<cfif not compareNoCase(form.pass1,form.pass2)>
		<cfset newPass = form.pass1>
	<cfelse>		
		<cfset newPass = "">
	</cfif>
	<cfset application.user.acctUpdate(session.user.userID,form.username,newPass)>
	<cfset session.user.username = form.username>
	<cfset whichTab = 3>
<cfelseif StructKeyExists(form,"submitimage")>
	<!--- this include prevents invalid tag error from on earlier versions --->
	<cfif application.isCF8 or application.isRailo>
		<cfinclude template="img_proc_acct_cf8.cfm">
	<cfelseif application.isBD>
		<cfinclude template="img_proc_acct_bd.cfm">
	</cfif>
	<cfset whichTab = 4>
<cfelseif StructKeyExists(url,"rmvimg")>
	<cftry>
	<cffile action="delete" file="#application.userFilesPath#avatars/#session.user.userid#_72.jpg">
	<cffile action="delete" file="#application.userFilesPath#avatars/#session.user.userid#_48.jpg">
	<cffile action="delete" file="#application.userFilesPath#avatars/#session.user.userid#_24.jpg">
	<cffile action="delete" file="#application.userFilesPath#avatars/#session.user.userid#_16.jpg">
	<cfcatch></cfcatch>
	</cftry>
	<cfset application.user.setImage(session.user.userID,0)>
	<cfset whichTab = 4>
<cfelseif StructKeyExists(form,"style")>
	<cfset session.style = form.style>
	<cfset application.user.setStyle(session.user.userID,form.style)>
	<cfset whichTab = 5>
	<cfif not application.isCF8 and not application.isBD and not application.isRailo>
		<cfset whichTab = whichTab - 1>
	</cfif>
<cfelseif StructKeyExists(url,"editStyle")>
	<cfset whichTab = 5>
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
<script type='text/javascript' src='#application.settings.mapping#/js/jquery.hoverIntent.js'></script>
<script type='text/javascript' src='#application.settings.mapping#/js/jquery.cluetip.js'></script>
<link rel='stylesheet' href='#application.settings.mapping#/css/jquery.tabs.css' media='screen,projection' type='text/css' />
<!--[if lte IE 7]>
<link rel='stylesheet' href='#application.settings.mapping#/css/jquery.tabs-ie.css' type='text/css' media='projection, screen' />
<![endif]-->
<script type='text/javascript'>
	$(function() {
		$('##container1').tabs(#whichTab#);
		$('a.jt').cluetip({
		  cluetipClass: 'jtip',
		  width:440,
		  local:true, 
		  cursor: 'pointer',
		  arrows: true, 
		  dropShadow: false, 
		  hoverIntent: false
		});
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
							<th class="tac">Permissions</th>
							<th class="tac">Notifications</th>
							<th class="tac">Remove</th>
						</tr>
						<cfloop query="projects">
						<tr id="r#currentRow#">
							<td>#name#</td>
							<td class="tac"><img src="./images/<cfif not compareNoCase(session.user.userid,ownerid)>close<cfelse>cancel</cfif>.gif" height="16" width="16" border="0" alt="#YesNoFormat(compareNoCase(session.user.userid,ownerid))#" /></td>
							<td class="tac">#YesNoIcon('admin')#</td>
							<td class="tac">[<a href="##p#currentRow#" rel="##p#currentRow#" title="#name# Permissions" class="jt">Show Popup</a>]</td>
							<td class="tac"><a href="">[<a href="##n#currentRow#" rel="##n#currentRow#" title="#name# Notifications" class="jt">Show Popup</a> / <a href="projectNotify.cfm?p=#projectID#">Edit</a>]</a></td>
							<td class="tac">[<a href="#cgi.script_name#?rp=#projectid###projects" onclick="return confirm('Are you sure you wish to remove yourself from this project?')">remove</a>]</td>
						</tr>
						</cfloop>
						</table>
						
						<cfloop query="projects">
							<div id="p#currentRow#" style="display:none;">
								<table>
								<tr valign="top"><td width="50%">

									<table class="permspop">
										<thead>
											<tr>
												<th class="b" colspan="2">Messages</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>View messages</td>
												<td class="tac">#YesNoIcon('msg_view')#</td>
											</tr>
											<tr>
												<td>Post/edit messages</td>
												<td class="tac">#YesNoIcon('msg_edit')#</td>
											</tr>
											<tr>
												<td>Comment on messages</td>
												<td class="tac">#YesNoIcon('msg_comment')#</td>
											</tr>
										</tbody>
									</table>

									<table class="permspop">
										<thead>
											<tr>
												<th class="b" colspan="2">To-Dos</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>View to-do lists</td>
												<td class="tac">#YesNoIcon('todolist_view')#</td>
											</tr>
											<tr>
												<td>Add/edit to-do lists</td>
												<td class="tac">#YesNoIcon('todolist_edit')#</td>
											</tr>
											<tr>
												<td>Add/edit to-do items</td>
												<td class="tac">#YesNoIcon('todo_edit')#</td>
											</tr>
											<tr>
												<td>Comment on to-do items</td>
												<td class="tac">#YesNoIcon('todo_comment')#</td>
											</tr>							
										</tbody>
									</table>
			
									<table class="permspop">
										<thead>
											<tr>
												<th class="b" colspan="2">Milestones</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>View milestones</td>
												<td class="tac">#YesNoIcon('mstone_view')#</td>
											</tr>
											<tr>
												<td>Add/edit milestones</td>
												<td class="tac">#YesNoIcon('mstone_edit')#</td>
											</tr>
											<tr>
												<td>Comment on milestones</td>
												<td class="tac">#YesNoIcon('mstone_comment')#</td>
											</tr>
										</tbody>
									</table>
	
									<table class="permspop">
										<thead>
											<tr>
												<th class="b" colspan="2">Files</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>View files</td>
												<td class="tac">#YesNoIcon('file_view')#</td>
											</tr>
											<tr>
												<td>Upload/edit files</td>
												<td class="tac">#YesNoIcon('file_edit')#</td>
											</tr>
											<tr>
												<td>Comment on files</td>
												<td class="tac">#YesNoIcon('file_comment')#</td>
											</tr>
										</tbody>
									</table>
			
								</td><td width="50%">
								
									<table class="permspop">
										<thead>
											<tr>
												<th class="b" colspan="2">Issues</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>View issues</td>
												<td class="tac">#YesNoIcon('issue_view')#</td>
											</tr>
											<tr>
												<td>Add/edit issues</td>
												<td class="tac">#YesNoIcon('issue_edit')#</td>
											</tr>
											<tr>
												<td>Assign issues</td>
												<td class="tac">#YesNoIcon('issue_assign')#</td>
											</tr>
											<tr>
												<td>Resolve issues</td>
												<td class="tac">#YesNoIcon('issue_resolve')#</td>
											</tr>
											<tr>
												<td>Close issues</td>
												<td class="tac">#YesNoIcon('issue_close')#</td>
											</tr>
											<tr>
												<td>Comment on issues</td>
												<td class="tac">#YesNoIcon('issue_comment')#</td>
											</tr>
										</tbody>
									</table>
				
									<table class="permspop">
										<thead>
											<tr>
												<th class="b" colspan="2">Time Tracking</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>View time tracking</td>
												<td class="tac">#YesNoIcon('time_view')#</td>
											</tr>
											<tr>
												<td>Add/edit time tracking</td>
												<td class="tac">#YesNoIcon('time_edit')#</td>
											</tr>
										</tbody>
									</table>
									
									<table class="permspop">
										<thead>
											<tr>
												<th class="b" colspan="2">Billing</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>View billing</td>
												<td class="tac">#YesNoIcon('bill_view')#</td>
											</tr>
											<tr>
												<td>Add/edit billing</td>
												<td class="tac">#YesNoIcon('bill_edit')#</td>
											</tr>
											<tr>
												<td>Manage billing rates</td>
												<td class="tac">#YesNoIcon('bill_rates')#</td>
											</tr>
											<tr>
												<td>Generate invoices</td>
												<td class="tac">#YesNoIcon('bill_invoices')#</td>
											</tr>
											<tr>
												<td>Mark items paid</td>
												<td class="tac">#YesNoIcon('bill_markpaid')#</td>
											</tr>
										</tbody>
									</table>
									
									<table class="permspop">
										<thead>
											<tr>
												<th class="b" colspan="2">Subversion</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>Access Subversion repository</td>
												<td class="tac">#YesNoIcon('svn')#</td>
											</tr>
										</tbody>
									</table>
								
								</td></tr>
								</table>
								</div>
									
								<div id="n#currentRow#" style="display:none;">
								<table>
								<tr valign="top"><td width="50%">
								
									<table class="notifypop">
										<thead>
											<tr>
												<th class="b">Messages</th>
												<th class="tac"><img src="./images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
												<th class="tac"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>New message</td>
												<td class="tac">#YesNoIcon('email_msg_new')#</td>
												<td class="tac">#YesNoIcon('mobile_msg_new')#</td>
											</tr>
											<tr>
												<td>Updated message</td>
												<td class="tac">#YesNoIcon('email_msg_upd')#</td>
												<td class="tac">#YesNoIcon('mobile_msg_upd')#</td>
											</tr>
											<tr>
												<td>Comment on message</td>
												<td class="tac">#YesNoIcon('email_msg_com')#</td>
												<td class="tac">#YesNoIcon('mobile_msg_com')#</td>
											</tr>
										</tbody>
									</table>

									<table class="notifypop">
										<thead>
											<tr>
												<th class="b">To-Dos</th>
												<th class="tac"><img src="./images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
												<th class="tac"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>New to-do item</td>
												<td class="tac">#YesNoIcon('email_todo_new')#</td>
												<td class="tac">#YesNoIcon('mobile_todo_new')#</td>
											</tr>
											<tr>
												<td>Updated to-do item</td>
												<td class="tac">#YesNoIcon('email_todo_upd')#</td>
												<td class="tac">#YesNoIcon('mobile_todo_upd')#</td>
											</tr>
											<tr>
												<td>Comment on to-do item</td>
												<td class="tac">#YesNoIcon('email_todo_com')#</td>
												<td class="tac">#YesNoIcon('mobile_todo_com')#</td>
											</tr>							
										</tbody>
									</table>
				
									<table class="notifypop">
										<thead>
											<tr>
												<th class="b">Milestones</th>
												<th class="tac"><img src="./images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
												<th class="tac"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>New milestone</td>
												<td class="tac">#YesNoIcon('email_mstone_new')#</td>
												<td class="tac">#YesNoIcon('mobile_mstone_new')#</td>
											</tr>
											<tr>
												<td>Updated milestone</td>
												<td class="tac">#YesNoIcon('email_mstone_upd')#</td>
												<td class="tac">#YesNoIcon('mobile_mstone_upd')#</td>
											</tr>
											<tr>
												<td>Comment on milestone</td>
												<td class="tac">#YesNoIcon('email_mstone_com')#</td>
												<td class="tac">#YesNoIcon('mobile_mstone_com')#</td>
											</tr>
										</tbody>
									</table>
									
									<table class="notifypop">
										<thead>
											<tr>
												<th class="b">Files</th>
												<th class="tac"><img src="./images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
												<th class="tac"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>New file</td>
												<td class="tac">#YesNoIcon('email_file_new')#</td>
												<td class="tac">#YesNoIcon('mobile_file_new')#</td>
											</tr>
											<tr>
												<td>Updated file</td>
												<td class="tac">#YesNoIcon('email_file_upd')#</td>
												<td class="tac">#YesNoIcon('mobile_file_upd')#</td>
											</tr>
											<tr>
												<td>Comment on file</td>
												<td class="tac">#YesNoIcon('email_file_com')#</td>
												<td class="tac">#YesNoIcon('mobile_file_com')#</td>
											</tr>
										</tbody>
									</table>
								
								</td><td width="50%">
								
									<table class="notifypop">
										<thead>
											<tr>
												<th class="b">Issues</th>
												<th class="tac"><img src="./images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
												<th class="tac"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>New issue</td>
												<td class="tac">#YesNoIcon('email_issue_new')#</td>
												<td class="tac">#YesNoIcon('mobile_issue_new')#</td>
											</tr>
											<tr>
												<td>Updated issue</td>
												<td class="tac">#YesNoIcon('email_issue_upd')#</td>
												<td class="tac">#YesNoIcon('mobile_issue_upd')#</td>
											</tr>
											<tr>
												<td>Comment on issue</td>
												<td class="tac">#YesNoIcon('email_issue_com')#</td>
												<td class="tac">#YesNoIcon('mobile_issue_com')#</td>
											</tr>
										</tbody>
									</table>
				
									<table class="notifypop">
										<thead>
											<tr>
												<th class="b">Time Tracking</th>
												<th class="tac"><img src="./images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
												<th class="tac"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>New time tracking item</td>
												<td class="tac">#YesNoIcon('email_time_new')#</td>
												<td class="tac">#YesNoIcon('mobile_time_new')#</td>
											</tr>
											<tr>
												<td>Updated time tracking</td>
												<td class="tac">#YesNoIcon('email_time_upd')#</td>
												<td class="tac">#YesNoIcon('mobile_time_upd')#</td>
											</tr>
										</tbody>
									</table>
									
									<table class="notifypop">
										<thead>
											<tr>
												<th class="b">Billing</th>
												<th class="tac"><img src="./images/email.png" height="16" width="16" border="0" alt="Email Notifications" /></th>
												<th class="tac"><img src="./images/phone.png" height="16" width="16" border="0" alt="Mobile Notifications" /></th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>New billing item</td>
												<td class="tac">#YesNoIcon('email_bill_new')#</td>
												<td class="tac">#YesNoIcon('mobile_bill_new')#</td>
											</tr>
											<tr>
												<td>Updated billing item</td>
												<td class="tac">#YesNoIcon('email_bill_upd')#</td>
												<td class="tac">#YesNoIcon('mobile_bill_upd')#</td>
											</tr>
											<tr>
												<td>Billing item marked paid</td>
												<td class="tac">#YesNoIcon('email_bill_paid')#</td>
												<td class="tac">#YesNoIcon('mobile_bill_paid')#</td>
											</tr>
										</tbody>
									</table>
								</td></tr>
								</table>
								</div>
						</cfloop>
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

<cffunction name="YesNoIcon">
	<cfargument name="fieldName" type="string" required="true">
	<cfoutput><img src="./images/<cfif Evaluate(arguments.fieldName) eq 1>close<cfelse>cancel</cfif>.gif" height="16" width="16" border="0" alt="#YesNoFormat(Evaluate(arguments.fieldName))#" /></cfoutput>
</cffunction>

<cfsetting enablecfoutputonly="false">