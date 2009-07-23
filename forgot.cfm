<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfparam name="form.username" default="">
<cfparam name="form.email" default="">

<cfif StructKeyExists(form,"subpass")> <!--- forgot password --->
	<cfset findPassword = application.user.findPassword(form.username)>
	<cfif findPassword.recordCount eq 1>
		<cfset success = "Your password has been emailed to <em>#findPassword.email#</em>">
		
		<cfsavecontent variable="theMessage">
		<cfoutput>Hi #findPassword.firstName#,

Please visit the following link to reset your #application.settings.app_title# password: 
#application.settings.rootURL##application.settings.mapping#/reset.cfm?u=#findPassword.userid#&h=#hash(findPassword.userid)#
		</cfoutput>
		</cfsavecontent>
		
		<cfif not compare(application.settings.mailServer,'')>
			<cfmail to="#findPassword.email#" from="#application.settings.adminEmail#" subject="#application.settings.app_title# | Your Password">#theMessage#</cfmail>
		<cfelse>
			<cfmail to="#findPassword.email#" from="#application.settings.adminEmail#" subject="#application.settings.app_title# | Your Password"
				server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
		</cfif>
		
		<cfset form.username = ''>
	<cfelse>
		<cfset error = "User name not found.">
	</cfif>	
<cfelseif StructKeyExists(form,"subuser")> <!--- forgot username --->
	<cfif request.udf.isEmail(form.email)>
		<cfset findUsername = application.user.findUsername(form.email)>
		<cfif findUsername.recordCount eq 1>
			<cfset success = "The username for #findUsername.firstName# #findUsername.lastName# has been emailed to #form.email#">
			
			<cfsavecontent variable="theMessage">
			<cfoutput>Hi #findUsername.firstName#,

You requested recovery of your #application.settings.app_title# username. 

Your username is:

  #findUsername.username#

Please keep your username and password safe to prevent unauthorized access.

You can login at:
#application.settings.rootURL##application.settings.mapping#
			</cfoutput>
			</cfsavecontent>
			
			<cfif not compare(application.settings.mailServer,'')>
				<cfmail to="#form.email#" from="#application.settings.adminEmail#" subject="#application.settings.app_title# | Your Username">#theMessage#</cfmail>
			<cfelse>
				<cfmail to="#form.email#" from="#application.settings.adminEmail#" subject="#application.settings.app_title# | Your Username"
					server="#application.settings.mailServer#" username="#application.settings.mailUsername#" password="#application.settings.mailPassword#">#theMessage#</cfmail>
			</cfif>	
				
			<cfset form.email = ''>
		<cfelse>
			<cfset error = "Email address not found.">
		</cfif>
	<cfelse>
		<cfset error = "Email address provided is not valid.">
	</cfif>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Login">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2>Retrieve Lost Credentials</h2>
				</div>
				<div class="content">
					<div class="wrapper">


<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="loginform" class="forgot">
<h3>Forgot your username?</h3>
<p>Enter your email address below, and we'll email you the username we have on file.</p>
<cfif StructKeyExists(form,"subuser")>
	<cfif StructKeyExists(variables,"error")>
		<div class="alert b r i">#error#</div>
	<cfelseif StructKeyExists(variables,"success")>
		<div class="success b i g">#success#</div>
	</cfif><br />
</cfif>
<label for="email">Email Address:</label>
<input type="text" id="email" name="email" value="#form.email#" class="forgot" />
<input type="submit" value="Email My Username" name="subuser" class="sub" />
</form>

<hr size="1" style="margin:25px 0 20px 0;" />

<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="loginform" class="forgot">
<h3>Forgot your password?</h3>
<p>Enter your username below, and we'll email you a link to reset your password.</p>
<cfif StructKeyExists(form,"subpass")>
	<cfif StructKeyExists(variables,"error")>
		<div class="alertbox">#error#</div>
	<cfelseif StructKeyExists(variables,"success")>
		<div class="successbox">#success#</div>		
	</cfif><br />
</cfif>
<label for="username">Username:</label>
<input type="text" id="username" name="username" value="#form.username#" class="forgot uname" />
<input type="submit" value="Email My Password" name="subpass" class="sub" />
</form>

<script type="text/javascript">
	<cfif StructKeyExists(form,"subpass")>
		document.forms[1].username.focus();
	<cfelse>
		document.forms[0].email.focus();
	</cfif>
</script>


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