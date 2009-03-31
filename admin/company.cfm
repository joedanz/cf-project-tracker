<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(form,"submit")>
	<cfset application.config.saveCompany(form.company_name,form.hourly_rate)>
	<cfset application.settings.company_name = form.company_name>
	<cfset application.settings.hourly_rate = form.hourly_rate>
	<cfif compare(form.imagefile,'')>
		<!--- this include prevents invalid tag error from on earlier versions --->
		<cfif application.isCF8 or application.isRailo>
			<cfinclude template="img_company_cf8.cfm">
		<cfelseif application.isBD>
			<cfinclude template="img_company_bd.cfm">
		</cfif>
	</cfif>
<cfelseif StructKeyExists(url,"rmvimg")>
	<cftry>
		<cffile action="delete" file="#ExpandPath('.' & application.settings.userFilesPath)##application.settings.company_logo#">
		<cfcatch></cfcatch>
	</cftry>
	<cfset application.config.deleteCompanyLogo()>
	<cfset application.settings.company_logo = "">
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
					 	
					<form action="#cgi.script_name#" method="post" name="edit" id="edit" class="frm" enctype="multipart/form-data">
						<p>
						<label for="company_name">Company Name:</label>
						<input type="text" name="company_name" id="company_name" class="short2" value="#application.settings.company_name#" />
						</p>
						<p>
						<label for="imgfile">Company Logo:</label>
						<input type="file" name="imagefile" id="imgfile" />
						</p>				
						<cfif compare(application.settings.company_logo,'')>
						<p>
						<label for="img">&nbsp;</label>
						<img src="#application.settings.userFilesMapping#/#application.settings.company_logo#" border="0" alt="#application.settings.company_name#" style="border:1px solid ##666;" />
						<a href="#cgi.script_name#?rmvimg">remove</a>
						<!---
						<cfelse>
						<img src="../images/your_logo.gif" height="74" width="145" border="0" alt="Your Logo Here" style="border:1px solid ##666;" />
						--->
						</p>
						</cfif>
						<p>
						<label for="hourly_rate">Base Hourly Rate:</label>
						$ <input type="text" name="hourly_rate" id="hourly_rate" class="tiny" value="#application.settings.hourly_rate#" />
						</p>			
	
						<label for="submit">&nbsp;</label>
						<input type="submit" class="button" name="submit" id="submit" value="Update Company" />				
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