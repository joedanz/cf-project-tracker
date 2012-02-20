<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">


<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Admin">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header" style="margin-bottom:0;">
					<h2 class="admin">Administration &raquo; Broadcast Message</h2>
				</div>
				<ul class="submenu mb15">
					<cfinclude template="menu.cfm">
				</ul>
				<div class="content">
					<div class="wrapper">
	
						<cfif StructKeyExists(form,"submit")>
							<cfset users = application.user.get()>
							<cfloop query="users">
								<cfif request.udf.isEmail(email)>
									<cfmail from="#application.settings.adminEmail#" to="#email#"
										subject="#form.subject#">#form.body#</cfmail>
								</cfif>
							</cfloop>
							<div class="successbox">Your message has been sent.</div>
						</cfif>
	
						<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="frm">
							<p>
							<label for="subject">Subject:</label>
							<input type="text" name="subject" id="subject" class="short" value="" />
							</p>

							<p>
							<label for="body">Body:</label> 
							<textarea name="body" id="body"></textarea>
							</p>
							
							<p>
							<label for="submit">&nbsp;</label>
							<input type="submit" class="button short" name="submit" id="submit" value="Send Broadcast Message" />				
							</p>
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