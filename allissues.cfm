<cfsetting enablecfoutputonly="true">

<cfparam name="form.projectIDfilter" default="">
<cfparam name="form.type" default="">
<cfparam name="form.severity" default="">
<cfparam name="form.status" default="Open">
<cfparam name="form.assignedTo" default="">

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
	<cfif issues gt 0>
		<cfset visible_project_list = listAppend(visible_project_list,projectID)>
	</cfif>
</cfloop>
<cfset projectUsers = application.project.projectUsers('','0','lastName, firstName',visible_project_list)>
<cfset issues = application.issue.get(form.projectIDfilter,'',form.status,visible_project_list,form.type,form.severity,form.assignedTo)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Issues">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="milestone">Issues across all your projects</h2>
				</div>
				<div class="content">
				 	<div class="wrapper">
					 	

						 <div class="mb10" style="background-color:##ffc;padding:8px;border:1px solid ##ccc;">

						 	<form action="#cgi.script_name#" method="post" style="float:right;">
						 		<input type="submit" value="Show All" />
						 	</form>
							
							<form action="#cgi.script_name#" method="post">
								
							<select name="projectIDfilter">
								<option value="">Project</option>
								<cfloop query="projects">
									<option value="#projectID#"<cfif not compare(form.projectIDfilter,projectID)> selected="selected"</cfif>>#name#</option>
								</cfloop>
							</select>
								
						 	<select name="type">
						 		<option value="">Type</option>
						 		<option value="Bug"<cfif not compare(form.type,'Bug')> selected="selected"</cfif>>Bug</option>
						 		<option value="Enhancement"<cfif not compare(form.type,'Enhancement')> selected="selected"</cfif>>Enhancement</option>
						 	</select>
						 	
						 	<select name="severity">
							 	<option value="">Severity</option>
								<option value="Critical"<cfif not compare(form.severity,'Critical')> selected="selected"</cfif>>Critical</option>
								<option value="Major"<cfif not compare(form.severity,'Major')> selected="selected"</cfif>>Major</option>
								<option value="Normal"<cfif not compare(form.severity,'Normal')> selected="selected"</cfif>>Normal</option>
								<option value="Minor"<cfif not compare(form.severity,'Minor')> selected="selected"</cfif>>Minor</option>
								<option value="Trivial"<cfif not compare(form.severity,'Trivial')> selected="selected"</cfif>>Trivial</option>
						 	</select>
						 	
						 	<select name="status">
						 		<option value="">Status</option>
						 		<option value="Open"<cfif not compare(form.status,'Open')> selected="selected"</cfif>>Bug</option>
						 		<option value="Closed"<cfif not compare(form.status,'Closed')> selected="selected"</cfif>>Enhancement</option>						 		
						 	</select>
						 	
						 	<select name="assignedTo">
						 		<option value="">Assigned To</option>
						 		<cfloop query="projectUsers">
						 			<option value="#userID#"<cfif not compare(form.assignedTo,userID)> selected="selected"</cfif>>#firstName# #lastName#</option>
						 		</cfloop>
						 	</select>
						 	
						 	<input type="submit" value="Filter" />
						 	</form>
						 	
						 </div>	

					 	<cfif issues.recordCount>
					 	<div style="border:1px solid ##ddd;" class="mb20">
					 	<table class="activity full" id="issues">
						<caption class="plain">#form.status# Issues</caption>
						<thead>
							<tr>
								<th>ID</th>
								<th>Project</th>
								<th>Issue</th>
								<th>Type</th>
								<th>Severity</th>
								<th>Assigned To</th>
								<th>Reported</th>
								<th>Updated</th>
							</tr>
						</thead>
						<tbody>
						<cfset thisRow = 1>
						<cfloop query="issues">
						<tr class="<cfif thisRow mod 2 eq 0>even<cfelse>odd</cfif>">
							<td><a href="issue.cfm?p=#projectID#&i=#issueID#">#shortID#</a></td>
							<td><a href="project.cfm?p=#projectID#">#name#</a></td>
							<td>#issue#</td>
							<td>#type#</td>
							<td>#severity#</td>
							<td>#assignedFirstName# #assignedLastName#</td>
							<td>#DateFormat(created,"d mmm")#</td>
							<td>#DateFormat(updated,"d mmm")#</td>
						</tr>
						<cfset thisRow = thisRow + 1>
						</cfloop>
						</tbody>
						</table>
						</div>
						<cfelse>
							<div class="warn">No issues have been submitted.</div>
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