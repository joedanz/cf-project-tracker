<cfsetting enablecfoutputonly="true">

<cfset carriers = application.carrier.get()>

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
				 	
				 	<table class="clean full">
					 	<tr>
							<th class="tac">##</th>
							<th>Carrier</th>
							<th class="tac">Country Code</th>
							<th>Country</th>
							<th class="tac">Prefix</th>
							<th>Suffix</th>
							<th class="tac">Active</th>
							<th class="tac">Edit</th>
						</tr>
					<cfloop query="carriers">
						<tr>
							<td class="tac b">#currentRow#)</td>
							<td>#carrier#</td>
							<td class="tac">#countryCode#</td>
							<td>#country#</td>
							<td class="tac">#prefix#</td>
							<td>#suffix#</td>
							<td class="tac"><img src="../images/<cfif active>close<cfelse>cancel</cfif>.gif" height="16" width="16" border="0" alt="#YesNoFormat(active)#" /></td>
							<td class="tac"><a href="editCarrier.cfm?c=#carrierid#">edit</a></td>
						</tr>					
					</cfloop>
					</table><br />
					<a href="editCarrier.cfm" class="b add">Add A New Carrier</a>

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