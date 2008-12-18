<cfsetting enablecfoutputonly="true">

<cfparam name="application.settings.app_title" default="Project Tracker">

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title=" &raquo; Error">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="alert">An Error Has Occurred</h2>
				</div>
				<div class="content">
					<div class="wrapper">

						<cfif not compare(error.message,'Element SETTINGS.APP_TITLE is undefined in APPLICATION.')>
							It appears this may be the first time you're running Project Tracker.<br />
							&nbsp; -- If so, you should <a href="./install/index.cfm">run the install script</a> in order to setup your database.<br />
							&nbsp; -- If not, please check the <strong>dsn</strong> value in your settings file and <strong><a href="#cgi.script_name#?reinit">reinit</a></strong>.<br />
						<cfelse>
							<cfif application.settings.showError>
								#error.diagnostics#
								<hr size="1" />
							</cfif>
							
							<h5><em>Please try again or contact your administrator.</em></h5>
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