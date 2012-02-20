<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif StructKeyExists(form,"submit")>
	<cfset application.config.saveCompany(form.company_name)>
	<cfset application.settings.company_name = form.company_name>
	<cfif compare(form.imagefile,'')>
		<cfif compare(application.settings.company_logo,'')>
			<cftry>
				<cffile action="delete" file="#application.userFilesPath#company/#application.settings.company_logo#">
				<cfcatch></cfcatch>
			</cftry>
		</cfif>
		<cffile action="upload" accept="image/gif,image/jpg,image/jpeg,image/png" filefield="imagefile"
			destination = "#application.userFilesPath#company/" nameConflict = "MakeUnique">
		<cfset application.config.saveCompanyLogo(cffile.serverFile)>
		<cfset application.settings.company_logo = cffile.serverFile>
	</cfif>
	<cfif compare(form.invimagefile,'')>
		<cfif compare(application.settings.invoice_logo,'')>
			<cftry>
				<cffile action="delete" file="#application.userFilesPath#company/#application.settings.company_logo#">
				<cfcatch></cfcatch>
			</cftry>
		</cfif>
		<cffile action="upload" accept="image/gif,image/jpg,image/jpeg,image/png" filefield="invimagefile"
			destination = "#application.userFilesPath#company/" nameConflict = "MakeUnique">
		<cfset application.config.saveInvoiceLogo(cffile.serverFile)>
		<cfset application.settings.invoice_logo = cffile.serverFile>
	</cfif>
<cfelseif StructKeyExists(url,"rmvimg")>
	<cftry>
		<cffile action="delete" file="#application.userFilesPath#company/#application.settings.company_logo#">
		<cfcatch></cfcatch>
	</cftry>
	<cfset application.config.deleteCompanyLogo()>
	<cfset application.settings.company_logo = "">
<cfelseif StructKeyExists(url,"rmvinvimg")>
	<cftry>
		<cffile action="delete" file="#application.userFilesPath#company/#application.settings.invoice_logo#">
		<cfcatch></cfcatch>
	</cftry>
	<cfset application.config.deleteInvoiceLogo()>
	<cfset application.settings.invoice_logo = "">
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
							<img src="#application.settings.userFilesMapping#/company/#application.settings.company_logo#" border="0" alt="#application.settings.company_name#" style="border:1px solid ##666;" />
							<a href="#cgi.script_name#?rmvimg">remove</a>
							</p>
						</cfif>
						<p>
						<p>
						<label for="invimgfile">Invoice Logo:</label>
						<input type="file" name="invimagefile" id="invimgfile" />
						</p>				
						<cfif compare(application.settings.invoice_logo,'')>
							<p>
							<label for="img">&nbsp;</label>
							<img src="#application.settings.userFilesMapping#/company/#application.settings.invoice_logo#" border="0" alt="#application.settings.company_name#" style="border:1px solid ##666;" />
							<a href="#cgi.script_name#?rmvinvimg">remove</a>
							</p>
						</cfif>		
	
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