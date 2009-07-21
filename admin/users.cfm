<cfsetting enablecfoutputonly="true">

<cfset users = application.user.get()>

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
							<th>Full Name</th>
							<th>Username</th>
							<th>Last Login</th>
							<th class="tac">Admin</th>
							<th class="tac">Active</th>
							<th class="tac">Edit</th>
						</tr>
					<cfloop query="users">
						<tr>
							<td class="tac b">#currentRow#)</td>
							<td>#lastName#, #firstName#</td>
							<td>#username#</td>
							<td><cfif isDate(lastLogin)>#DateFormat(DateAdd("h",session.tzOffset,lastLogin),"m/d/yyyy")#</cfif></td>
							<td class="tac"><cfif admin><img src="../images/close.gif" height="16" width="16" border="0" alt="#YesNoFormat(admin)#" /><cfelse>&nbsp;</cfif></td>
							<td class="tac"><img src="../images/<cfif active>close<cfelse>cancel</cfif>.gif" height="16" width="16" border="0" alt="#YesNoFormat(active)#" /></td>
							<td class="tac"><a href="editUser.cfm?u=#userid#">edit</a></td>
						</tr>
					</cfloop>
					</table><br />
					<a href="editUser.cfm" class="b add">Add A New User</a>

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