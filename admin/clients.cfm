<cfsetting enablecfoutputonly="true">

<cfset clients = application.client.get()>

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
					
					<cfif clients.recordCount>				 	
					 	<table class="clean full">
						 	<tr>
								<th class="tac">##</th>
								<th>Client Name</th>
								<th>Contact Name</th>
								<th class="tac">Projects</th>
								<th class="tac">Active</th>
								<th class="tac">Edit</th>
							</tr>
						<cfloop query="clients">
							<tr>
								<td class="tac b">#currentRow#)</td>
								<td>#name#</td>
								<td>#contactName#</td>
								<td class="tac">#NumberFormat(numProjects)#</td>
								<td class="tac"><img src="../images/<cfif active>close<cfelse>cancel</cfif>.gif" height="16" width="16" border="0" alt="#YesNoFormat(active)#" /></td>
								<td class="tac"><a href="editClient.cfm?c=#clientid#">edit</a></td>
							</tr>					
						</cfloop>
						</table>
					<cfelse>
						<div class="warn">No clients have been added.</div>
					</cfif>
					
					<br /><a href="editClient.cfm" class="b add">Add A New Client</a>

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