<cfsetting enablecfoutputonly="true">

<cfparam name="whichTab" default="">

<cfif StructKeyExists(form,"submit1")>
	<cfset application.user.userUpdate(session.user.userID,form.firstname,form.lastname,form.email,form.phone)>
	<cfset session.user.firstName = form.firstname>
	<cfset session.user.lastName = form.lastname>
	<cfset session.user.email = form.email>
	<cfset session.user.phone = form.phone>
<cfelseif StructKeyExists(form,"submit2")>
	<cfif not compareNoCase(form.pass1,form.pass2)>
		<cfset newPass = form.pass1>
	<cfelse>		
		<cfset newPass = "">
	</cfif>
	<cfset application.user.acctUpdate(session.user.userID,form.username,newPass)>
	<cfset session.user.username = form.username>
	<cfset whichTab = 2>
<cfelseif StructKeyExists(form,"submitimage")>
	<cfif application.isCF8> <!--- include prevents invalid tag error from on earlier versions --->
		<cfinclude template="img_proc_acct_cf8.cfm">
	<cfelseif application.isBD>
		<cfinclude template="img_proc_acct_bd.cfm">
	</cfif>
	<cfset whichTab = 3>
<cfelseif StructKeyExists(url,"rmvimg")>
	<cftry>
	<cffile action="delete" file="#ExpandPath('./images/avatars')#/#session.user.userid#_72.jpg">
	<cffile action="delete" file="#ExpandPath('./images/avatars')#/#session.user.userid#_48.jpg">
	<cffile action="delete" file="#ExpandPath('./images/avatars')#/#session.user.userid#_24.jpg">
	<cffile action="delete" file="#ExpandPath('./images/avatars')#/#session.user.userid#_16.jpg">
	<cfcatch></cfcatch>
	</cftry>
	<cfset application.user.setImage(session.user.userID,0)>
	<cfset whichTab = 3>
<cfelseif StructKeyExists(form,"style")>
	<cfset session.style = form.style>
	<cfset application.user.setStyle(session.user.userID,form.style)>
	<cfset whichTab = 4>
	<cfif not application.isCF8 and not application.isBD>
		<cfset whichTab = whichTab - 1>
	</cfif>
<cfelseif StructKeyExists(url,"editStyle")>
	<cfset whichTab = 4>
	<cfif not application.isCF8 and not application.isBD>
		<cfset whichTab = whichTab - 1>
	</cfif>
</cfif>

<cfset user = application.user.get(session.user.userid)>

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
<script type='text/javascript' src='#application.settings.mapping#/js/jquery/jquery.history_remote.pack.js'></script>
<script type='text/javascript' src='#application.settings.mapping#/js/jquery/jquery.tabs.pack.js'></script>
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
				
		        <div id="container1">
		            <ul>
		                <li><a href="##user"><span>General Info</span></a></li>
						<li><a href="##account"><span>Account Info</span></a></li>
		                <cfif application.isCF8 or application.isBD>
							<li><a href="##avatar"><span>Avatar</span></a></li>
						</cfif>
		                <li><a href="##skin"><span>Style</span></a></li>
		            </ul>
		            <div id="user">   
						<form action="#cgi.script_name#" method="post" name="edit" id="edit" class="frm">
							<p>
							<label for="fname" class="req">First Name:</label>
							<input type="text" name="firstname" id="fname" value="#user.firstName#" maxlength="12" />
							</p>
							<p>
							<label for="lname" class="req">Last Name:</label>
							<input type="text" name="lastname" id="lname" value="#user.lastName#" maxlength="20" />
							</p>				
							<p>
							<label for="email" class="req">Email:</label>
							<input type="text" name="email" id="email" value="#user.email#" maxlength="120" />
							</p>
							<p>
							<label for="phone">Phone:</label>
							<input type="text" name="phone" id="phone" value="#user.phone#" maxlength="15" />
							</p>
							<label for="submit">&nbsp;</label>
							<input type="submit" class="button" name="submit1" id="submit1" value="Update Account" onclick="return confirmSubmit1();" />				
						</form>								
		            </div>
		            <div id="account">            
						<form action="#cgi.script_name#" method="post" name="editacct" id="editacct" class="frm">
							<p>
							<label for="user" class="req">Username:</label>
							<input type="text" name="username" id="username" value="#user.username#" maxlength="20" />
							</p>					
							<p>
							<label for="pass1">New Password:</label>
							<input type="text" name="pass1" id="pass1" value="" maxlength="20" />
							</p>
							<p>
							<label for="pass2">Confirm Password:</label>
							<input type="text" name="pass2" id="pass2" value="" maxlength="20" />
							</p>
							<label for="submit">&nbsp;</label>
							<input type="submit" class="button" name="submit2" id="submit2" value="Update Account" onclick="return confirmSubmit2();" />				
						</form>								
		            </div>
					<cfif application.isCF8 or application.isBD>			
		            <div id="avatar">
						<form action="#cgi.script_name#" method="post" name="edit" id="avatar" class="frm" enctype="multipart/form-data">
							<p>
							<label for="img">&nbsp;</label>
							<cfif user.avatar eq 1>
							<img src="./images/avatars/#session.user.userid#_72.jpg" height="72" width="72" border="0" alt="#user.firstName# #user.lastName#" style="border:1px solid ##666;" />
							<a href="#cgi.script_name#?rmvimg">remove</a>
							<cfelse>
							<img src="./images/noavatar72.gif" height="72" width="72" border="0" alt="No Avatar" style="border:1px solid ##666;" />
							</cfif>
							</p>
							<p>
							<label for="imgfile">Profile Image:</label>
							<input type="file" name="imagefile" id="imgfile" />
							</p>				
							<label for="submit">&nbsp;</label>
							<input type="submit" class="button" name="submitimage" id="submit" value="Upload Image" />				
						</form>
		            </div>
					</cfif>
		            <div id="skin">
						<form action="#cgi.script_name#" method="post" name="edit" id="headerform" class="frm">
							<p>
							<label for="headstyle">Set Style:</label>
							<select name="style" id="headstyle">
								<option value="blue"<cfif not compare(user.style,'blue')> selected="selected"</cfif>>Blue</option>
								<option value="green"<cfif not compare(user.style,'green')> selected="selected"</cfif>>Green</option>
								<option value="grey"<cfif not compare(user.style,'grey')> selected="selected"</cfif>>Grey</option>
								<option value="red"<cfif not compare(user.style,'red')> selected="selected"</cfif>>Red</option>
							</select>
							</p>
							<label for="submit">&nbsp;</label>					
							<input type="submit" class="button" name="skinsub" id="skinsub" value="Set Style" />				
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