<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif StructKeyExists(form,"submit")>
	<cfset application.config.saveNotification(form.email_subject_prefix,form.sms_subject_prefix)>
	<cfset application.settings.email_subject_prefix = form.email_subject_prefix>
	<cfset application.settings.sms_subject_prefix = form.sms_subject_prefix>
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
						<label for="esp">Email Subject Prefix:</label>
						<input type="text" name="email_subject_prefix" id="esp" class="shorter" value="#application.settings.email_subject_prefix#" />
						</p>
						<p>
						<label for="ssp">SMS Subject Prefix:</label>
						<input type="text" name="sms_subject_prefix" id="ssp" class="shorter" value="#application.settings.sms_subject_prefix#" />
						</p>

						<label for="submit">&nbsp;</label>
						<input type="submit" class="button" name="submit" id="submit" value="Update Notification Settings" onclick="return confirmSubmit1();" />				
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