<cfsetting enablecfoutputonly="true">

<cfparam name="form.password" default="">
<cfparam name="form.password2" default="">

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Reset Password">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2>Reset Password</h2>
				</div>
				<div class="content">
					<div class="wrapper">

<cfif compareNoCase(hash(url.u),url.h)>
	<div class="alertbox">
		You are not authorized to reset this password.
	</div>
<cfelse>

	<cfif StructKeyExists(form,"submit") and compare(form.password,'') and not compareNoCase(form.password,form.password2)>
	
		<cfset application.user.setPassword(url.u,form.password)>
		<div class="successbox">
			Your password has been reset.  <a href="#application.settings.mapping#/">Click here to login</a>
		</div>
	
	<cfelse>

		<cfif StructKeyExists(form,"submit")>
			<cfif not compare(form.password,'') or not compare(form.password2,'')>
			<div class="alertbox">
				You must provide a new password plus confirmation.
			</div>
			<cfelseif compareNoCase(form.password,form.password2)>
			<div class="alertbox">
				The passwords you provided did not match.
			</div>
			</cfif>
		</cfif>

		<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="loginform" class="forgot">
		<p>Please provide a new password for your account.</p>
		
		<p>
		<label for="email">New Password:</label>
		<input type="password" id="pass" name="password" value="#form.password#" class="forgot" />
		</p><br />
		
		<p>
		<label for="email">Confirm Password:</label>
		<input type="password" id="pass" name="password2" value="#form.password2#" class="forgot" />
		</p><br />
		
		<input type="submit" value="Set New Password" name="submit" class="button" />
		</form>
		
		<script type="text/javascript">
			document.forms[0].password.focus();
		</script>
	
	</cfif>
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