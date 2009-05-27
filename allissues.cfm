<cfsetting enablecfoutputonly="true">

<cfparam name="form.projectIDfilter" default="">
<cfparam name="form.type" default="">
<cfparam name="form.severity" default="">
<cfparam name="form.status" default="New|Accepted|Assigned">
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
	<cfif issue_view gt 0>
		<cfset visible_project_list = listAppend(visible_project_list,projectID)>
	</cfif>
</cfloop>
<cfif not listLen(visible_project_list)>
	<cfset visible_project_list = "NONE">
</cfif>
<cfset projectUsers = application.project.projectUsers(projectIDlist=visible_project_list,useList=true)>
<cfset issues = application.issue.get(form.projectIDfilter,'',form.status,visible_project_list,form.type,form.severity,form.assignedTo)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; All Issues">

<cfsavecontent variable="js">
<cfoutput>
<script type='text/javascript'>
$(document).ready(function(){
	<cfif issues.recordCount>
    $.tablesorter.addParser({ 
        id: 'severity', 
        is: function(s) {  
            return false; // return false so this parser is not auto detected
        }, 
        format: function(s) { 
            return s.toLowerCase().replace(/critical/,4).replace(/major/,3).replace(/normal/,2).replace(/minor/,1).replace(/trivial/,0); 
        }, 
        type: 'numeric' 
    });
	$.tablesorter.addParser({ 
        id: 'status', 
        is: function(s) {  
            return false; // return false so this parser is not auto detected
        }, 
        format: function(s) { 
            return s.toLowerCase().replace(/closed/,3).replace(/resolved/,2).replace(/assigned/,1).replace(/accepted/,1).replace(/new/,0); 
        }, 
        type: 'numeric' 
    });
	$('##issues').tablesorter({
			cssHeader: 'theader',
			sortList: [[0,0]],
			headers: { 4: { sorter:'severity' }, 5: { sorter:'statuses' }, 7: { sorter:'usLongDate' }, 8: { sorter:'usLongDate' }, 9: { sorter:'usLongDate' } },
			widgets: ['zebra']  
	});
	</cfif>
});
</script>
</cfoutput>
</cfsavecontent>

<cfhtmlhead text="#js#">

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
						 		<option value="New"<cfif not compare(form.status,'New')> selected="selected"</cfif>>New</option>
						 		<option value="Assigned"<cfif not compare(form.status,'Assigned')> selected="selected"</cfif>>Assigned</option>
						 		<option value="Resolved"<cfif not compare(form.status,'Resolved')> selected="selected"</cfif>>Resolved</option>
						 		<option value="Closed"<cfif not compare(form.status,'Closed')> selected="selected"</cfif>>Closed</option>						 		
						 	</select>
						 	
						 	<input type="submit" value="Filter" />
						 	</form>
						 	
						 </div>	

					 	<cfif issues.recordCount>
					 	<div style="border:1px solid ##ddd;" class="mb20">
					 	<table class="activity full tablesorter" id="issues">
						<caption class="plain"><cfif compare(form.status,'New|Accepted|Assigned')>#form.status#<cfelse>Open</cfif> Issues</caption>
						<thead>
							<tr>
								<th>ID</th>
								<th>Project</th>
								<th>Issue</th>
								<th>Type</th>
								<th>Severity</th>
								<th>Status</th>
								<th>Assigned To</th>
								<th>Reported</th>
								<th>Updated</th>
								<th>Due Date</th>
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
							<td>#status#</td>
							<td>#assignedFirstName# #assignedLastName#</td>
							<td>#DateFormat(created,"mmm dd, yyyy")#</td>
							<td>#DateFormat(updated,"mmm dd, yyyy")#</td>
							<td>#DateFormat(dueDate,"mmm dd, yyyy")#</td>
						</tr>
						<cfset thisRow = thisRow + 1>
						</cfloop>
						</tbody>
						</table>
						</div>
						<cfelse>
							<div class="warn">No issues <cfif compare(form.type,'') or compare(form.severity,'') or compare(form.status,'') or compare(form.assignedTo,'')>match your criteria<cfelse>have been submitted</cfif>.</div>
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
		<cfif compare(application.settings.company_logo,'')>
			<img src="#application.settings.userFilesMapping#/#application.settings.company_logo#" border="0" alt="#application.settings.company_name#" /><br />
		</cfif>

		<form action="#cgi.script_name#" method="post">
		<div class="b">Show issues assigned to:</div>
		<select name="assignedTo" onchange="this.form.submit();">
			<option value="">Anyone</a>
			<option value="#session.user.userid#"<cfif not compare(session.assignedTo,session.user.userID)> selected="selected"</cfif>>Me (#session.user.firstName# #session.user.lastName#)</a>
			<cfloop query="projectUsers">
				<cfif compare(session.user.userid,userID)>
				<option value="#userID#"<cfif not compare(session.assignedTo,userID)> selected="selected"</cfif>>#lastName#, #firstName#</option>
				</cfif>
			</cfloop>
		</select>
		</form><br />

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