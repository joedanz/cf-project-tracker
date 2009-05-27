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
<cfset visible_project_billlist = "">
<cfloop query="projects">
	<cfif time_view gt 0>
		<cfset visible_project_list = listAppend(visible_project_list,projectID)>
	</cfif>
	<cfif bill_view gt 0>
		<cfset visible_project_billlist = listAppend(visible_project_billlist,projectID)>
	</cfif>
</cfloop>
<cfif not listLen(visible_project_list)>
	<cfset visible_project_list = "NONE">
</cfif>
<cfif not listLen(visible_project_billlist)>
	<cfset visible_project_billlist = "NONE">
</cfif>
<cfset projectUsers = application.project.allProjectUsers(visible_project_list)>
<cfset timelines = application.timetrack.get(projectIDlist=visible_project_list,userID=session.assignedTo)>
<cfset totalHours = 0>
<cfset totalFee = 0>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; All Time Tracking">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="milestone">Time tracking across all your projects</h2>
				</div>
				<div class="content">
				 	<div class="wrapper">

					 	<cfif timelines.recordCount>
						 	<table class="clean full" id="time">
							 	<thead>
									<tr>
										<th class="first">Date</th>
										<th>Project</th>
										<th>Person</th>
										<th>Hours</th>
										<cfif listLen(visible_project_billlist)>
											<th>Billing Category</th>
											<th>Fee</th>
										</cfif>
										<th>Description</th>		
									</tr>
								</thead>
								<tbody>	
								<cfloop query="timelines">
									<cfset thisUserID = userid>
									<tr id="r#timetrackid#">
										<td class="first">#DateFormat(dateStamp,"mmm d, yyyy")#</td>
										<td>#name#</td>
										<td>#firstName# #lastName#</td>
										<td class="b">#numberFormat(hours,"0.00")#</td>
										<cfif listFind(visible_project_billlist,projectID)>
											<td><cfif compare(category,'') and not compareNoCase(clientID,projClientID)>#category# ($#NumberFormat(rate,"0")#/hr)</cfif></td>
											<td><cfif isNumeric(rate) and not compareNoCase(clientID,projClientID)>$#NumberFormat(rate*hours,"0")#</cfif></td>
										<cfelseif listLen(visible_project_billlist)>
											<td colspan="2">&nbsp;</td>
										</cfif>
										<td><cfif compare(itemType,'')><span class="catbox #itemtype#">#itemtype#</span> <a href="todos.cfm?p=#projectID###id_#replace(todolistID,'-','','all')#">#task#</a><cfif compare(description,'')> - </cfif></cfif>#description#</td>
									</tr>
									<cfset totalHours = totalHours + hours>
									<cfif isNumeric(rate) and not compareNoCase(clientID,projClientID)>
										<cfset totalFee = totalFee + (rate*hours)>
									</cfif>
								</cfloop>
								</tbody>
								<tfoot>
									<tr class="last">
										<td colspan="3" class="tar b">TOTAL:&nbsp;&nbsp;&nbsp;</td>
										<td class="b"><span id="totalhours">#NumberFormat(totalHours,"0.00")#</span></td>
										<cfif listLen(visible_project_billlist)>
											<td class="tar b">TOTAL FEE:&nbsp;&nbsp;&nbsp;</td>
											<td class="b"><span id="totalrate">$#NumberFormat(totalFee,"0")#</span></td>
										</cfif>
										<td colspan="3">&nbsp;</td>
									</tr>
								</tfoot>
							</table>

						<cfelse>
							<div class="warn">No time tracking info available<cfif compare(session.assignedTo,'')> for this user</cfif>.</div>
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
			<img src="#application.settings.userFilesMapping#/company/#application.settings.company_logo#" border="0" alt="#application.settings.company_name#" /><br />
		</cfif>
		
		<form action="#cgi.script_name#" method="post">
		<div class="b">Show time tracking assigned to:</div>
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