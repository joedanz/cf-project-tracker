<cfsetting enablecfoutputonly="true">

<cfset projects = application.project.get(session.user.userid)>
<cfset activity = application.activity.get('','true')>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.title# &raquo; Home">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="activity">Latest activity across all your projects</h2>
				</div>
				<div class="content">
					<div class="wrapper">


<cfif activity.recordCount>
<table class="activity">
	<caption>Recent Activity</caption>
	<tbody>
	<cfloop query="activity">
	<tr>
		<td><a href="project.cfm?p=#projectID#" title="#projectName#">#projectName#</a></td>
		<td><div class="catbox
		<cfswitch expression="#type#">
			<cfcase value="Issue">issue">Issue</cfcase>		
			<cfcase value="Message">message">Message</cfcase>
			<cfcase value="Milestone">milestone">Milestone</cfcase>
			<cfcase value="To-Do List">todolist">Task List</cfcase>
			<cfcase value="File">file">File</cfcase>
			<cfcase value="Project">project">Project</cfcase>
			<cfdefaultcase>">#type#</cfdefaultcase>
		</cfswitch>	
	</div></td>
	<td>#DateFormat(stamp,"d mmm")#</td>
	<td><cfswitch expression="#type#">
			<cfcase value="Issue"><a href="issues.cfm?p=#projectID#&i=#id#">#name#</a></cfcase>		
			<cfcase value="Message"><a href="messages.cfm?p=#projectID#&mid=#id#">#name#</a></cfcase>
			<cfcase value="Milestone"><a href="milestones.cfm?p=#projectID#&m=#id#">#name#</a></cfcase>
			<cfcase value="Task List"><a href="todos.cfm?p=#projectID#&t=#id#">#name#</a></cfcase>
			<cfcase value="File"><a href="files.cfm?p=#projectID#&f=#id#">#name#</a></cfcase>
			<cfcase value="Project"><a href="project.cfm?p=#projectID#">#name#</a></cfcase>
			<cfdefaultcase>#name#</cfdefaultcase>
		</cfswitch>
		</td>
	<td class="g">#activity# by</td>
	<td>#firstName# #lastName#</td>
	</tr>
	</cfloop>
	</tbody>
</table>
<cfelse>
	<div class="warn">There is no recent activity.</div>
</cfif>


				 	</div>
				</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

<cfquery name="active_projects" dbtype="query">
	select * from projects where status = 'Active'
</cfquery>
<cfquery name="onhold_projects" dbtype="query">
	select * from projects where status = 'On-Hold'
</cfquery>
<cfquery name="arch_projects" dbtype="query">
	select * from projects where status = 'Archived'
</cfquery>

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