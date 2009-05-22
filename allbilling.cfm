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
	<cfif bill_view gt 0>
		<cfset visible_project_list = listAppend(visible_project_list,projectID)>
	</cfif>
</cfloop>
<cfif not listLen(visible_project_list)>
	<cfset visible_project_list = "NONE">
</cfif>
<cfset projectUsers = application.project.projectUsers('','0','firstName, lastName',visible_project_list)>
<cfset milestones_completed = application.milestone.get(withRate=true,type='completed',projectIDlist=visible_project_list,forID=form.assignedTo)>
<cfset milestones_incomplete = application.milestone.get(withRate=true,type='incomplete',projectIDlist=visible_project_list,forID=form.assignedTo)>
<cfset timelines = application.timetrack.get(projectIDlist=visible_project_list,userID=form.assignedTo)>

<cfset totalIncMSFee = 0>
<cfset totalComMSFee = 0>
<cfset totalHours = 0>
<cfset totalFee = 0>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; All Billing">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="milestone">Billing across all your projects</h2>
				</div>
				<div class="content">
				 	<div class="wrapper">



					<cfif milestones_incomplete.recordCount>
						<fieldset class="bill mb15">
							<legend>Incomplete Milestones</legend>
	
							<table class="clean full" id="time">
							 	<thead>
									<tr>
										<th class="first">Due Date</th>
										<th>Project</th>
										<th>Name</th>
										<th>Person</th>
										<th>Fee</th>
										<th class="tac">Billed</th>
										<th class="tac">Paid</th>
										<th>Description</th>
									</tr>
								</thead>
								<tbody>	
								<cfloop query="milestones_incomplete">
									<cfif isNumeric(rate)>
										<cfset thisUserID = userid>
										<tr id="r#milestoneid#">
											<td class="first">#DateFormat(dueDate,"mmm d, yyyy")#</td>
											<td>#projName#</td>
											<td>#name#</td>
											<td>#firstName# #lastName#</td>
											<td>$#NumberFormat(rate,"0")#</td>
											<td class="tac"><cfif billed eq 1><img src="./images/ok_16x16.gif" height="16" width="16" border="0" alt="Yes" title="Yes" /><cfelse><img src="./images/delete.gif" height="16" width="16" border="0" alt="No" title="No" /></cfif></td>
											<td class="tac"><cfif paid eq 1><img src="./images/ok_16x16.gif" height="16" width="16" border="0" alt="Yes" title="Yes" /><cfelse><img src="./images/delete.gif" height="16" width="16" border="0" alt="No" title="No" /></cfif></td>
											<td>#description#</td>
										</tr>
										<cfif isNumeric(rate)>
											<cfset totalIncMSFee = totalIncMSFee + rate>
										</cfif>
									</cfif>
								</cfloop>
								</tbody>
								<tfoot>
									<tr class="last">
										<td class="tar b" colspan="4">TOTAL FEE:&nbsp;&nbsp;&nbsp;</td>
										<td class="b">$#NumberFormat(totalIncMSFee,"0")#</td>
										<td colspan="5">&nbsp;</td>
									</tr>
								</tfoot>
							</table>
	
						</fieldset>
					</cfif>

					<cfif milestones_completed.recordCount>
						<fieldset class="bill mb15">
							<legend>Completed Milestones</legend>
							
							<table class="clean full" id="time">
							 	<thead>
									<tr>
										<th class="first">Due Date</th>
										<th>Project</th>
										<th>Name</th>
										<th>Person</th>
										<th>Fee</th>
										<th class="tac">Billed</th>
										<th class="tac">Paid</th>
										<th>Description</th>
									</tr>
								</thead>
								<tbody>	
								<cfloop query="milestones_completed">
									<cfif isNumeric(rate)>
										<cfset thisUserID = userid>
										<tr id="r#milestoneid#">
											<td class="first">#DateFormat(dueDate,"mmm d, yyyy")#</td>
											<td>#projName#</td>
											<td>#name#</td>
											<td>#firstName# #lastName#</td>
											<td>$#NumberFormat(rate,"0")#</td>
											<td class="tac"><cfif billed eq 1><img src="./images/ok_16x16.gif" height="16" width="16" border="0" alt="Yes" title="Yes" /><cfelse><img src="./images/delete.gif" height="16" width="16" border="0" alt="No" title="No" /></cfif></td>
											<td class="tac"><cfif paid eq 1><img src="./images/ok_16x16.gif" height="16" width="16" border="0" alt="Yes" title="Yes" /><cfelse><img src="./images/delete.gif" height="16" width="16" border="0" alt="No" title="No" /></cfif></td>
											<td>#description#</td>
										</tr>
										<cfif isNumeric(rate)>
											<cfset totalComMSFee = totalComMSFee + rate>
										</cfif>
									</cfif>
								</cfloop>
								</tbody>
								<tfoot>
									<tr class="last">
										<td class="tar b" colspan="4">TOTAL FEE:&nbsp;&nbsp;&nbsp;</td>
										<td class="b">$#NumberFormat(totalComMSFee,"0")#</td>
										<td colspan="5">&nbsp;</td>
									</tr>
								</tfoot>
							</table>
							
						</fieldset>
					</cfif>
					
					<cfset showTimelines = false>
					<cfloop query="timelines">
						<cfif not showTimelines and isNumeric(rate)>
							<cfset showTimelines = true>
						</cfif>
					</cfloop>
					<cfif timelines.recordCount and showTimelines>
						<fieldset class="bill">
							<legend>Hourly Billing</legend>
						
						 	<table class="clean full" id="time">
							 	<thead>
									<tr>
										<th class="first">Date</th>
										<th>Project</th>
										<th>Person</th>
										<th>Hours</th>
										<th>Billing Category</th>
										<th>Fee</th>
										<th class="tac">Billed</th>
										<th class="tac">Paid</th>
										<th>Description</th>
									</tr>
								</thead>
								<tbody>	
								<cfloop query="timelines">
									<cfif isNumeric(rate)>
										<cfset thisUserID = userid>
										<tr id="r#timetrackid#">
											<td class="first">#DateFormat(dateStamp,"mmm d, yyyy")#</td>
											<td>#name#</td>
											<td>#firstName# #lastName#</td>
											<td class="b">#numberFormat(hours,"0.00")#</td>
											<td>#category#<cfif compare(category,'')> ($#NumberFormat(rate,"0")#/hr)</cfif></td>
											<td><cfif isNumeric(rate)>$#NumberFormat(rate*hours,"0")#</cfif></td>
											<td class="tac"><cfif billed eq 1><img src="./images/ok_16x16.gif" height="16" width="16" border="0" alt="Yes" title="Yes" /><cfelse><img src="./images/delete.gif" height="16" width="16" border="0" alt="No" title="No" /></cfif></td>
											<td class="tac"><cfif paid eq 1><img src="./images/ok_16x16.gif" height="16" width="16" border="0" alt="Yes" title="Yes" /><cfelse><img src="./images/delete.gif" height="16" width="16" border="0" alt="No" title="No" /></cfif></td>
											<td><cfif compare(itemType,'')><span class="catbox #itemtype#">#itemtype#</span> <a href="todos.cfm?p=#projectID###id_#replace(todolistID,'-','','all')#">#task#</a><cfif compare(description,'')> - </cfif></cfif>#description#</td>
										</tr>
										<cfset totalHours = totalHours + hours>
										<cfif isNumeric(rate)>
											<cfset totalFee = totalFee + (rate*hours)>
										</cfif>
									</cfif>
								</cfloop>
								</tbody>
								<tfoot>
									<tr class="last">
										<td colspan="3" class="tar b">TOTAL:&nbsp;&nbsp;&nbsp;</td>
										<td class="b"><span id="totalhours">#NumberFormat(totalHours,"0.00")#</span></td>
										<td class="tar b">TOTAL FEE:&nbsp;&nbsp;&nbsp;</td>
										<td class="b">$#NumberFormat(totalFee,"0")#</td>
										<td colspan="3">&nbsp;</td>
									</tr>
								</tfoot>
							</table>
					 	</fieldset>
				 	</cfif>

					<cfif milestones_incomplete.recordCount eq 0 and milestones_completed.recordCount eq 0 and (timelines.recordCount eq 0 or not showTimelines)>
			 			<div class="warn">No billing information is available.</div>
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
		<div class="b">Show billing for:</div>
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