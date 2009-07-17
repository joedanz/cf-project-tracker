<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(form,"submit")>
	<cfset application.config.save(form.app_title,form.default_style,form.default_locale,form.default_timezone)>
	<cfset application.settings.app_title = form.app_title>
	<cfset application.settings.default_style = form.default_style>
	<cfset application.settings.default_locale = form.default_locale>
	<cfset application.settings.default_timezone = form.default_timezone>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Admin">

<cfhtmlhead text="<script type='text/javascript'>
	function confirmSubmit1() {
		var errors = '';
		if (document.edit.app_title.value == '') {errors = errors + '   ** You must enter an application title.\n';}
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
						<label for="locale">Default Locale:</label>
						<select name="default_locale" id="locale">
							<cfloop list="#Server.Coldfusion.SupportedLocales#" index="i">
								<option value="#i#"<cfif not compare(i,application.settings.default_locale)> selected="selected"</cfif>>#i#</option>
							</cfloop>
						</select>
						</p>
						<p>
						<label for="deftz">Default Timezone:</label>
						<select name="default_timezone" id="deftz" size="10">
							<cfloop from="1" to="#ArrayLen(application.timezones)#" index="i">
								<option value="#application.timezones[i]#"<cfif not compare(application.timezones[i],application.settings.default_timezone)> selected="selected"</cfif>>#application.timezones[i]#</option>
							</cfloop>
						</select>
						</p>
						<p>
						<label for="defstyle">Default Style:</label>
						<select name="default_style" id="defstyle">
							<option value="blue"<cfif not compare(application.settings.default_style,'blue')> selected="selected"</cfif>>Blue</option>
							<option value="green"<cfif not compare(application.settings.default_style,'green')> selected="selected"</cfif>>Green</option>
							<option value="grey"<cfif not compare(application.settings.default_style,'grey')> selected="selected"</cfif>>Grey</option>
							<option value="red"<cfif not compare(application.settings.default_style,'red')> selected="selected"</cfif>>Red</option>					
						</select> <span style="font-size:80%">(Note: you can set your personal options under <a href="../account.cfm##skin">My Account</a>)</span>
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