<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif StructKeyExists(form,"submit")>
	<cfparam name="form.googlecal_enable" default="0">
	<cfset variables.tzOffset = application.timezone.getTZOffset(tz=form.googlecal_timezone)>
	<cfset application.config.saveCalendar(form.googlecal_enable,form.googlecal_user,form.googlecal_pass,form.googlecal_timezone,variables.tzOffset)>
	<cfset application.settings.googlecal_enable = form.googlecal_enable>
	<cfset application.settings.googlecal_user = form.googlecal_user>
	<cfset application.settings.googlecal_pass = form.googlecal_pass>
	<cfset application.settings.googlecal_timezone = form.googlecal_timezone>
	<cfset application.settings.googlecal_offset = variables.tzOffset>
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
					<label class="half" for="googlecal_enable">Enable Google Calendar:</label>
					<input type="checkbox" name="googlecal_enable" id="googlecal_enable" value="1" class="cb"<cfif application.settings.googlecal_enable> checked="checked"</cfif> />
					</p>
					<p>
					<label class="half" for="googlecal_user">Google Calendar Username:</label>
					<input type="text" name="googlecal_user" id="googlecal_user" class="short2" value="#application.settings.googlecal_user#" />
					</p>
					<p>
					<label class="half" for="googlecal_pass">Google Calendar Password:</label>
					<input type="password" name="googlecal_pass" id="googlecal_user" class="short2" value="#application.settings.googlecal_pass#" />
					</p>
					<p>
						<label class="half" for="deftz">Google Calendar Timezone:</label>
						<select name="googlecal_timezone" id="deftz" size="10">
							<cfloop from="1" to="#ArrayLen(application.timezones)#" index="i">
								<option value="#application.timezones[i]#"<cfif not compare(application.timezones[i],application.settings.googlecal_timezone)> selected="selected"</cfif>>#application.timezones[i]#</option>
							</cfloop>
						</select>
					</p>
										
					<label class="half" for="submit">&nbsp;</label>
					<input type="submit" class="button" name="submit" id="submit" value="Update Calendar Settings" />				
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