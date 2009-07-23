<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfset variables.errors = "">

<cfif StructKeyExists(form,"submit")>
	<cfparam name="form.active" default="0">
	
	<cfif not compare(trim(form.carrier),'')>
		<cfset variables.errors = variables.errors & "<li>You must enter the carrier name.</li>">
	</cfif>	
	<cfif not compare(trim(form.suffix),'')>
		<cfset variables.errors = variables.errors & "<li>You must enter the email suffix.</li>">
	</cfif>	
	
	<cfif not compare(variables.errors,'')>
	<cfswitch expression="#form.submit#">
		<cfcase value="Add Carrier">
			<cfset application.carrier.add(form.carrier,form.countryCode,form.country,form.prefix,form.suffix,form.active)>
		</cfcase>
		<cfcase value="Update Carrier">
			<cfset application.carrier.update(form.carrierID,form.carrier,form.countryCode,form.country,form.prefix,form.suffix,form.active)>
		</cfcase>
	</cfswitch>
	<cfset application.carriers = application.carrier.get('','true')>
	<cflocation url="carriers.cfm" addtoken="false">
	</cfif>
</cfif>

<cfparam name="form.carrier" default="">
<cfparam name="form.countryCode" default="">
<cfparam name="form.country" default="">
<cfparam name="form.prefix" default="">
<cfparam name="form.suffix" default="">
<cfparam name="form.active" default="1">

<cfif StructKeyExists(url,"c")>
	<cfset carrier = application.carrier.get(url.c)>
	<cfset form.carrier = carrier.carrier>
	<cfset form.countryCode = carrier.countryCode>
	<cfset form.country = carrier.country>
	<cfset form.prefix = carrier.prefix>
	<cfset form.suffix = carrier.suffix>
	<cfset form.active = carrier.active>
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
				<ul class="submenu mb15">
					<cfinclude template="menu.cfm">
				</ul>
				<div class="content">
					<div class="wrapper">
				 	
				 	<h3 class="mb10"><cfif StructKeyExists(url,"c")>Edit<cfelse>Add New</cfif> Carrier</h3>

				 	<cfif compare(variables.errors,'')>
				 	<div class="error">
					 	<h4 class="alert b r">An Error Has Occurred</h3>
					 	<ul>#variables.errors#</ul>
					</div>
				 	</cfif>
				 	
				 	<form action="#cgi.script_name#" method="post" class="frm">
					 	<fieldset class="mb15">
						 	<legend>Carrier Information</legend>
						<p>
						<label for="carrier" class="req">Carrier:</label> 
						<input type="text" name="carrier" id="carrier" value="#HTMLEditFormat(form.carrier)#" maxlength="20" class="shorter" />
						</p>
						<p>
						<label for="countryCode">Country Code:</label> 
						<input type="text" name="countryCode" id="countryCode" value="#HTMLEditFormat(form.countryCode)#" maxlength="2" class="shorter" />
						</p>
						<p>
						<label for="country">Country:</label> 
						<input type="text" name="country" id="country" value="#HTMLEditFormat(form.country)#" size="20" maxlength="20" class="shorter" />
						</p>						
						<p>
						<label for="prefix">Number Prefix:</label> 
						<input type="text" name="prefix" id="prefix" value="#HTMLEditFormat(form.prefix)#" maxlength="3" class="shorter" />
						</p>
						<p>
						<label for="suffix" class="req">Email Suffix:</label> 
						<input type="text" name="suffix" id="suffix" value="#HTMLEditFormat(form.suffix)#" maxlength="40" class="shorter" />
						</p>
						<p>
						<label for="active">Active?</label>
						<input type="checkbox" name="active" id="active" value="1" class="checkbox"<cfif form.active> checked="checked"</cfif> />
						</p>
						</fieldset>
						
						<p>
						<input type="submit" name="submit" value="<cfif StructKeyExists(url,"c")>Update<cfelse>Add</cfif> Carrier" class="button shorter" />
						or <a href="users.cfm">Cancel</a>
						</p>
						<cfif StructKeyExists(url,"c")>
							<input type="hidden" name="carrierID" value="#url.c#" />
						</cfif>
						</fieldset>
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