<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(form,"submit")>
	<cfset application.config.save(form.app_title,form.default_style)>
	<cfset application.settings.app_title = form.app_title>
	<cfset application.settings.default_style = form.default_style>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Admin">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header" style="margin-bottom:0;">
					<h2 class="admin">Administration</h2>
				</div>
				<ul class="submenu mb20">
					<cfinclude template="menu.cfm">
				</ul>
				<div class="content">
					<div class="wrapper">
					 	
					<form action="#cgi.script_name#" method="post" name="edit" id="edit" class="frm">
						<p>
						<label for="title" class="req">Application Title:</label>
						<input type="text" name="app_title" id="title" class="short" value="#application.settings.app_title#" />
						</p>
						<p>
						<label for="defstyle" class="req">Default Style:</label>
						<select name="default_style" id="defstyle">
							<option value="blue"<cfif not compare(application.settings.default_style,'blue')> selected="selected"</cfif>>Blue</option>
							<option value="green"<cfif not compare(application.settings.default_style,'green')> selected="selected"</cfif>>Green</option>
							<option value="grey"<cfif not compare(application.settings.default_style,'grey')> selected="selected"</cfif>>Grey</option>
							<option value="red"<cfif not compare(application.settings.default_style,'red')> selected="selected"</cfif>>Red</option>					
						</select> <span style="font-size:80%">(Note: you can set your personal style under <a href="account.cfm?editStyle">My Settings</a>)</span>
						</p>				
	
						<label for="submit">&nbsp;</label>
						<input type="submit" class="button" name="submit" id="submit" value="Update Settings" onclick="return confirmSubmit1();" />				
					</form>						 	
				 	
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
		<cfinclude template="rightmenu.cfm">
	</div>
		
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">