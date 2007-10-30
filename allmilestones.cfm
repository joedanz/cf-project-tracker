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
<cfset milestones_overdue = application.milestone.get('','','overdue','',valueList(projects.projectID))>
<cfset milestones_upcoming = application.milestone.get('','','upcoming','',valueList(projects.projectID))>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Milestones">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="milestone">Milestones across all your projects</h2>
				</div>
				<div class="content">
				 	<div class="wrapper">
					 	<cfif milestones_overdue.recordCount or milestones_upcoming.recordCount>
						 	
							<cfif milestones_overdue.recordCount>
							<div class="mb5 b" style="color:##f00;border-bottom:1px solid ##f00;">Late Milestones</div>
							<ul class="nobullet mb20">
								<cfloop query="milestones_overdue">
									<cfset daysago = DateDiff("d",dueDate,Now())>
								<li><span class="b" style="color:##f00;"><cfif daysago eq 0>Today<cfelseif daysago eq 1>Yesterday<cfelse>#daysago# day ago</cfif>:</span> 
									<a href="milestones.cfm?p=#projectID#">#name#</a>
									<span style="font-size:.9em;">(<span class="b">#projName#</span><cfif compare(lastName,'')> | #firstName# #lastName# is responsible</cfif>)</span>
								</li>
								</cfloop>
							</ul>
							</cfif>
							
							<cfif milestones_upcoming.recordCount>
							<div class="mb5 b" style="border-bottom:1px solid ##000;">Upcoming Milestones</div>
							<ul class="nobullet mb20">
								<cfloop query="milestones_upcoming">
									<cfset daysago = DateDiff("d",Now(),dueDate)>
								<li><span class="b"><cfif daysago eq 0>Tomorrow<cfelse>#daysago+1# day<cfif daysago neq 1>s</cfif> away</cfif>:</span> 
									<a href="milestones.cfm?p=#projectID#">#name#</a>
									<span style="font-size:.9em;">(<span class="b">#projName#</span><cfif compare(lastName,'')> | #firstName# #lastName# is responsible</cfif>)</span>
								</li>
								</cfloop>
							</ul>
							</cfif>
						 	
						 <cfelse>	
							<div class="warn">No milestones have been added.</div>
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