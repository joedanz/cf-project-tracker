<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Confirm Registration">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

			<div class="header">
				<h2>Confirm Registration</h2>
			</div>
			<div class="content">
				<div class="wrapper">
					
					<cfif StructKeyExists(url,"u") and application.user.confirm(url.u)>
							<div class="successbox">
								Your email address has been confirmed and your account is now active.
								<a href="login.cfm">Click here to login</a>
							</div>
					<cfelse>
						<cfif StructKeyExists(url,"u")>
							<div class="alert b r">
								Your email address was unable to be confirmed.  Please try again...
							</div>
						</cfif>

						<form action="#cgi.script_name#" method="get" class="frm">
							<p>
							<label for="ccode" class="full">Please enter your confirmation code:</label>
							<input type="text" name="u" class="short mr5" id="ccode" style="float:left;" />
							<input type="submit" value="Go" class="button" style="width:30px;" />
							</p>
						</form>
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