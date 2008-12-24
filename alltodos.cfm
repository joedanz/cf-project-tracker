<cfsetting enablecfoutputonly="true">

<cfset projects = application.project.get(session.user.userid)>
<cfquery name="active_projects" dbtype="query">
	select * from projects where status = 'Active'
</cfquery>
<cfquery name="onhold_projects" dbtype="query">
	select * from projects where status = 'On-Hold'
</cfquery>
<cfquery name="arch_projects" dbtype="query">
	select * from projects where status = 'Archived'
</cfquery>
<cfif not projects.recordCount>
	<cfset QueryAddRow(projects)>
	<cfset QuerySetCell(projects, "projectID", "0")>
</cfif>
<cfset visible_project_list = "">
<cfloop query="projects">
	<cfif todos gt 0>
		<cfset visible_project_list = listAppend(visible_project_list,projectID)>
	</cfif>
</cfloop>
<cfset todolists = application.todolist.get('','',visible_project_list)>
<cfset todos = application.todo.get('','','','rank,added','',visible_project_list)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; To-Dos">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="todo">To-do items across all your projects</h2>
				</div>
				<div class="content">
				 	<div class="wrapper">

					<cfif todolists.recordCount>
					 	
					<div id="listWrapper">
					<cfloop query="todolists">
					<div class="todolist" id="#todolistID#" style="margin-bottom:20px;">
					
					<h3 class="padtop padbottom list"><a href="project.cfm?p=#projectID#">#projName#</a> : <a href="todos.cfm?p=#projectID#&t=#todolistID#">#title#</a></h3>
						<div class="tododetail">
						<cfquery name="todos_notcompleted" dbtype="query">
							select * from todos where todolistID = '#todolistID#' and completed IS NULL
						</cfquery>
						<ul class="nobullet" id="todoitems#todolistID#">
						<cfloop query="todos_notcompleted">
						<li class="li#todolistID#" id="#todoID#"><input type="checkbox" name="todoID" value="#todoID#" class="cb#todolistID#" onclick="mark_complete('#projectID#','#todolistID#','#todoID#','#replace(todoID,'-','','all')#');" /> #task#<cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)</span></cfif></li>
						<li><div id="edititemform#todoID#" style="display:none;background-color:##ddd;padding:5px;">
						</div>
						</li>
												
						</cfloop>
						</ul>
						</div>
						
					</div>
					</cfloop>
					</div>

					<cfelse>
						<div class="warn">You have no to-do items.</div> 	
					</cfif>					 	
					 	
					 	
					</div>
				</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">

		<h3><a href="editProject.cfm" class="add">Create a new project</a></h3><br />

		<cfif active_projects.recordCount>
		<div class="header"><h3>Your projects</h3></div>
		<div class="content">
			<ul>
				<cfloop query="active_projects">
					<li><a href="project.cfm?p=#projectID#">#name#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>
		
		<cfif onhold_projects.recordCount>
		<div class="header"><h3>On-Hold projects</h3></div>
		<div class="content">
			<ul>
				<cfloop query="onhold_projects">
					<li><a href="project.cfm?p=#projectID#">#name#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>
		
		<cfif arch_projects.recordCount>
		<div class="header"><h3>Archived projects</h3></div>
		<div class="content">
			<ul>
				<cfloop query="arch_projects">
					<li><a href="project.cfm?p=#projectID#">#name#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>

	</div>
		
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">