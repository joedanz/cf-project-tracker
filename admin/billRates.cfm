<cfsetting enablecfoutputonly="true">

<cfset client = application.client.get(url.c)>
<cfset rates = application.client.getRates(url.c)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Admin &raquo; Clients &raquo; Bill Rates">

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
					<h3>#client.name# &raquo; Billing Rates</h3>

					<cfif rates.recordCount>
					<ul id="client_rates" class="mt15 ml40">
						<cfloop query="rates">
							<li id="r#rateID#">#category# - #DollarFormat(rate)#/hr&nbsp;<cfif numLines eq 0> <a href="##" class="x" onclick="delete_client_rate('#rateID#');return false;"></a><cfelse> <span class="sm g">(#numLines# time tracking item<cfif numLines gt 1>s</cfif>)</span></cfif></li>
						</cfloop>
					</ul>
					<cfelse>
						<div class="alert mt15 b r i">There are no billing rates set for this client.</div>
					</cfif>
					
					<br /><a href="##" class="b add" onclick="$('##add').slideDown();return false;">Add New Billing Category</a><br />
						<form class="frm" id="add" style="display:none;">
						<table class="input2 mt10">
							<thead>
								<tr>
									<th>Category</th>
									<th>Rate</th>
									<th>&nbsp;</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><input type="text" name="category" id="category" class="short" /></td>
									<td><input type="text" name="rate" id="rate" class="tiny" /></td>
									<td><input type="button" class="button2" value="Add" onclick="add_client_rate('#url.c#');" /> or <a href="##" onclick="$('##add').slideUp();return false;">Cancel</a></td>
								</tr>
							</tbody>
						</table>
						</form>
						
						<br /><a href="clients.cfm" class="b back">Return to Clients</a>
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