<cfsetting enablecfoutputonly="true">

<cfset variables.errors = "">

<cfif StructKeyExists(form,"submit")>
	<cfparam name="form.active" default="0">
	
	<cfif not compare(trim(form.name),'')>
		<cfset variables.errors = variables.errors & "<li>You must enter the client name.</li>">
	</cfif>
	
	<cfif not compare(variables.errors,'')>
	<cfswitch expression="#form.submit#">
		<cfcase value="Add Client">
			<cfset application.client.add(form.name,form.address,form.city,form.locality,form.country,form.postal,form.phone,form.fax,form.contactName,form.contactPhone,form.notes,form.active)>
		</cfcase>
		<cfcase value="Update Client">
			<cfset application.client.update(form.clientID,form.name,form.address,form.city,form.locality,form.country,form.postal,form.phone,form.fax,form.contactName,form.contactPhone,form.notes,form.active)>
		</cfcase>
	</cfswitch>
	<cflocation url="clients.cfm" addtoken="false">
	</cfif>
</cfif>

<cfparam name="form.name" default="">
<cfparam name="form.address" default="">
<cfparam name="form.city" default="">
<cfparam name="form.locality" default="">
<cfparam name="form.country" default="">
<cfparam name="form.postal" default="">
<cfparam name="form.phone" default="">
<cfparam name="form.fax" default="">
<cfparam name="form.contactName" default="">
<cfparam name="form.contactPhone" default="">
<cfparam name="form.notes" default="">
<cfparam name="form.active" default="1">

<cfif StructKeyExists(url,"c")>
	<cfset client = application.client.get(url.c)>
	<cfset form.name = client.name>
	<cfset form.address = client.address>
	<cfset form.city = client.city>
	<cfset form.locality = client.locality>
	<cfset form.country = client.country>
	<cfset form.postal = client.postal>
	<cfset form.phone = client.phone>
	<cfset form.fax = client.fax>
	<cfset form.contactName = client.contactName>
	<cfset form.contactPhone = client.contactPhone>
	<cfset form.notes = client.notes>
	<cfset form.active = client.active>
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
				 	
				 	<h3 class="mb10"><cfif StructKeyExists(url,"c")>Edit<cfelse>Add New</cfif> Client</h3>

				 	<cfif compare(variables.errors,'')>
				 	<div class="error">
					 	<h4 class="alert b r">An Error Has Occurred</h3>
					 	<ul>#variables.errors#</ul>
					</div>
				 	</cfif>
				 	
				 	<form action="#cgi.script_name#" method="post" class="frm">
					 	<fieldset class="mb15">
						 	<legend>Client Information</legend>
						<p>
						<label for="name" class="req">Name:</label> 
						<input type="text" name="name" id="name" value="#HTMLEditFormat(form.name)#" maxlength="150" class="short" />
						</p>						
						<p>
						<label for="address">Address:</label> 
						<textarea name="address" id="address" class="address">#HTMLEditFormat(form.address)#</textarea>
						</p>
						<p>
						<label for="city">City:</label> 
						<input type="text" name="city" id="city" value="#HTMLEditFormat(form.city)#" maxlength="150" class="short" />
						</p>
						<p>
						<label for="locality">Locality/State:</label> 
						<input type="text" name="locality" id="locality" value="#HTMLEditFormat(form.locality)#" maxlength="200" class="short" />
						</p>
						<p>
						<label for="country">Country:</label> 
						<input type="text" name="country" id="country" value="#HTMLEditFormat(form.country)#" size="35" class="short" />
						</p>						
						<p>
						<label for="postal">Postal Code:</label> 
						<input type="text" name="postal" id="postal" value="#HTMLEditFormat(form.postal)#" maxlength="40" class="shorter" />
						</p>
						<p>
						<label for="phone">Phone:</label> 
						<input type="text" name="phone" id="phone" value="#HTMLEditFormat(form.phone)#" maxlength="40" class="shorter" />
						</p>
						<p>
						<label for="fax">Fax:</label> 
						<input type="text" name="fax" id="fax" value="#HTMLEditFormat(form.fax)#" maxlength="40" class="shorter" />
						</p>
						<p>
						<label for="contactName">Contact Name:</label> 
						<input type="text" name="contactName" id="contactName" value="#HTMLEditFormat(form.contactName)#" maxlength="60" class="shorter" />
						</p>
						<p>
						<label for="contactPhone">Contact Phone:</label> 
						<input type="text" name="contactPhone" id="contactPhone" value="#HTMLEditFormat(form.contactPhone)#" maxlength="40" class="shorter" />
						</p>
						<p>
						<label for="notes">Notes:</label> 
						<textarea name="notes" id="notes" class="short">#HTMLEditFormat(form.notes)#</textarea>
						</p>
						<p>
						<label for="active">Active?</label>
						<input type="checkbox" name="active" id="active" value="1" class="checkbox"<cfif form.active> checked="checked"</cfif> />
						</p>
						</fieldset>
						
						<p>
						<input type="submit" name="submit" value="<cfif StructKeyExists(url,"c")>Update<cfelse>Add</cfif> Client" class="button shorter" />
						or <a href="users.cfm">Cancel</a>
						</p>
						<cfif StructKeyExists(url,"c")>
							<input type="hidden" name="clientID" value="#url.c#" />
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