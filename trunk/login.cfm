<cfsetting enablecfoutputonly="true">

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# &raquo; Login">

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

	
<div id="login">
	
<cfif isDefined("error")>
<div id="error" style="text-align:center; background-color:##ccc;padding:2px; border:1px dotted ##00f; width:350px; position:absolute;top:120px;left:500px;">
<div id="errorheader" class="s14 b r i" style="padding:2px; background-color:##bbb;font-weight:bold;"><img src="/stdimages/alert.gif" height="16" width="16" border="0" alt="Alert!" align="absmiddle"> An Error Has Occurred!</div>
<div style="padding:2px;color:##333;" class="b i">#error#</div>
</div>
</cfif>	
	
<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="loginform">

<cfparam name="form.username" default="">
<label for="username" class="s14 b" style="display:block;">AKO ID:</label>
<input type="text" id="username" name="username" value="#form.username#" size="20" style="width:180px;border:2px solid ##999;padding:4px;margin-bottom:5px;" onfocus="this.style.border='2px solid ##f00';this.style.background='##d9ecff';" onblur="this.style.border='2px solid ##999';this.style.background='##fff';" /><br />
<label for="pass" class="s14 b" style="display:block;">AKO Password:</label>
<input type="password" id="pass" name="password" size="20" style="width:180px;border:2px solid ##999;padding:4px;margin-bottom:10px;" onfocus="this.style.border='2px solid ##f00';this.style.background='##d9ecff';" onblur="this.style.border='2px solid ##999';this.style.background='##fff';" /><br />
<input type="submit" value="Login" style="width:125px;padding:3px;font-family:Trebuchet MS, Verdana,Arial;" class="s14 b">
<input type="hidden" name="logon" value="true">
</form>
</div>	

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