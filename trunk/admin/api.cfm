<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(form,"submit")>
	<cfparam name="form.enable_api" default="0">
	<cfset application.config.saveAPI(form.enable_api,form.api_key)>
	<cfset application.settings.enable_api = form.enable_api>
	<cfset application.settings.api_key = form.api_key>
<cfelseif StructKeyExists(url,"newkey")>
	<cfset newKey = createUUID()>
	<cfset form.api_key = newKey>
	<cfset application.settings.api_key = newKey>
	<cfset application.config.saveAPIKey(newKey)>
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
					<label for="enable">Enable API:</label>
					<input type="checkbox" name="enable_api" id="enable" value="1" class="cb"<cfif application.settings.enable_api> checked="checked"</cfif> />
					</p>
					<p>
					<label for="api_key">API Key:</label>
					<input type="text" name="api_key" id="api_key" class="short" value="#application.settings.api_key#" /> <a href="#cgi.script_name#?newkey">generate new key</a>
					</p>
					
					<label for="submit">&nbsp;</label>
					<input type="submit" class="button" name="submit" id="submit" value="Update API Settings" />				
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

	</div>
		
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">