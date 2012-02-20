<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfset projects = application.project.getDistinct()>

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
							<th>Project Name</th>
							<th>Client</th>
							<th class="tac">Status</th>
							<th class="tac">Edit</th>
						</tr>
					<cfloop query="projects">
						<tr>
							<td class="tac b">#currentRow#)</td>
							<td>#name#</td>
							<td>#clientName#</td>
							<td class="tac">#status#</td>
							<td class="tac"><a href="../editProject.cfm?from=admin&amp;p=#projectid#">edit</a></td>
						</tr>					
					</cfloop>
					</table><br />
					<a href="../editProject.cfm?from=admin" class="b add">Add A New Project</a>

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