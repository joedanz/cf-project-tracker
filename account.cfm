<cfsetting enablecfoutputonly="true">

<cfif isDefined("form.submit")>
	<cfset application.user.userUpdate(session.user.userID,form.firstname,form.lastname,form.akoid,form.email,form.phone)>
<cfelseif isDefined("form.submitimage")>
	<cffile action="upload" accept="image/gif,image/jpg,image/jpeg,image/png" filefield="imagefile"
			destination = "#ExpandPath('./images/avatars')#" nameConflict = "MakeUnique">
	<cfimage action="resize" height="72" width="72" overwrite="yes"
		source="#ExpandPath('./images/avatars')#/#serverFile#"
		destination="#ExpandPath('./images/avatars')#/#session.user.userid#_72.jpg">
	<cfimage action="resize" height="48" width="48" overwrite="yes"
		source="#ExpandPath('./images/avatars')#/#serverFile#"
		destination="#ExpandPath('./images/avatars')#/#session.user.userid#_48.jpg">
	<cfimage action="resize" height="24" width="24" overwrite="yes"
		source="#ExpandPath('./images/avatars')#/#serverFile#"
		destination="#ExpandPath('./images/avatars')#/#session.user.userid#_24.jpg">
	<cfimage action="resize" height="16" width="16" overwrite="yes"
		source="#ExpandPath('./images/avatars')#/#serverFile#"
		destination="#ExpandPath('./images/avatars')#/#session.user.userid#_16.jpg">
	<cffile action="delete" file="#ExpandPath('./images/avatars')#/#serverFile#">
	<cfset application.user.setImage(session.user.userID,1)>
<cfelseif isDefined("url.rmvimg")>	
	<cftry>
	<cffile action="delete" file="#ExpandPath('./images/avatars')#/#session.user.userid#_72.jpg">
	<cffile action="delete" file="#ExpandPath('./images/avatars')#/#session.user.userid#_48.jpg">
	<cffile action="delete" file="#ExpandPath('./images/avatars')#/#session.user.userid#_24.jpg">
	<cffile action="delete" file="#ExpandPath('./images/avatars')#/#session.user.userid#_16.jpg">
	<cfcatch></cfcatch>
	</cftry>
	<cfset application.user.setImage(session.user.userID,0)>
<cfelseif isDefined("form.skin")>
	<cfset session.style = form.style>
	<cfset application.user.setStyle(session.user.userID,form.style)>
</cfif>

<cfset user = application.user.get(session.user.userid)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.title# &raquo; My Accunt">

<cfhtmlhead text="<script type='text/javascript'>
	function confirmSubmit() {
		var errors = '';
		if (document.edit.firstname.value == '') {errors = errors + '   ** You must enter your first name.\n';}
		if (document.edit.lastname.value == '') {errors = errors + '   ** You must enter your last name.\n';}
		if (document.edit.akoid.value == '') {errors = errors + '   ** You must enter your ako id.\n';}
		if (document.edit.email.value == '') {errors = errors + '   ** You must enter your email.\n';}
		if (errors != '') {
			alert('Please correct the following errors:\n\n' + errors)
			return false;
		} else return true;
	}
</script>">

<cfoutput>
<div id="container">

	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="user">Edit account details</h2>
				</div>
				<div class="content">
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
					<label for="ako" class="req">AKO ID:</label>
					<input type="text" name="akoid" id="ako" value="#user.akoid#" maxlength="20" />
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
					<input type="submit" class="button" name="submit" id="submit" value="Update Account" onclick="return confirmSubmit();" />				
				</form>
				
				<cfif application.isCF8>
				<hr noshade="noshade" width="90%" size="5" style="margin-bottom:20px;" />
				<form action="#cgi.script_name#" method="post" name="edit" id="avatar" class="frm" enctype="multipart/form-data">
					<p>
					<label for="img">&nbsp;</label>
					<cfif user.avatar>
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
				</cfif>
				
				<hr noshade="noshade" width="90%" size="5" style="margin-bottom:20px;" />
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