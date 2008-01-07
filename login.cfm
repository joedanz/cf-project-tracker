<cfsetting enablecfoutputonly="true">

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
<label for="username" style="display:block;">Username:</label>
<input type="text" id="username" name="username" value="#form.username#" size="20" class="login" onfocus="$(this).addClass('loginactive');" onblur="$(this).removeClass('loginactive');" /><br />
<label for="pass" style="display:block;">Password:</label>
<input type="password" id="pass" name="password" size="20" class="login" onfocus="$(this).addClass('loginactive');" onblur="$(this).removeClass('loginactive');" /><br />
<input type="submit" value="Login" class="sub">
<input type="hidden" name="logon" value="true">
</form>
</div>	
<a href="forgot.cfm">Lost your username or password?</a>

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