<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Login">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2>Please login...</h2>
				</div>
				<div class="content">
					<div class="wrapper">

<style>
a:link, a:visited {color:##00f;}</style>
	
<div id="login">
	
<cfif StructKeyExists(variables,"error")>
<div class="alert b">#error#</div><br />
</cfif>	
	
<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="loginform" id="login">

<cfparam name="form.username" default="">
<cfparam name="form.remain" default="0">
<label for="username" style="display:block;">Username:</label>
<input type="text" id="username" name="username" value="#form.username#" size="20" class="focusField" /><br />
<label for="pass" style="display:block;">Password:</label>
<input type="password" id="pass" name="password" size="20" /><br />
<input type="checkbox" name="remain" id="remain" value="1"<cfif form.remain eq 1> checked="checked"</cfif> /> 
<label for="remain" id="rem"><span class="b">Keep me signed in</span><br />
<small>for 2 weeks unless I sign out</small></label><br />
<input type="submit" value="Login" class="sub">
<input type="hidden" name="logon" value="true">
<cfloop item="field" collection="#form#">
	<cfif compareNoCase(field,'username') and compareNoCase(field,'password') and compareNoCase(field,'remain')>
		<input type="hidden" name="#field#" value="#form[field]#" />
	</cfif>
</cfloop>
</form>
</div>	
<a href="forgot.cfm">Lost your username or password?</a>

<cfif application.settings.allowRegister>
	<br/><br/><a href="#application.settings.mapping#/register.cfm" title="Logout">Register for an account</a>
</cfif>

<script type="text/javascript">
	document.forms[0].username.focus();
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