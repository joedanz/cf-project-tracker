<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif StructKeyExists(url,"reg")>
	<cfset project = application.project.getDistinct(url.p)>
	<cfif project.allow_reg>
		<cfset application.role.add(url.p,session.user.userid,'0',project.reg_file_view,project.reg_file_edit,project.reg_file_comment,project.reg_issue_view,project.reg_issue_edit,project.reg_issue_assign,project.reg_issue_resolve,project.reg_issue_close,project.reg_issue_comment,project.reg_msg_view,project.reg_msg_edit,project.reg_msg_comment,project.reg_mstone_view,project.reg_mstone_edit,project.reg_mstone_comment,project.reg_todolist_view,project.reg_todolist_edit,project.reg_todo_edit,project.reg_todo_comment,project.reg_time_view,project.reg_time_edit,project.reg_bill_view,project.reg_bill_edit,project.reg_bill_rates,project.reg_bill_invoices,project.reg_bill_markpaid,project.reg_svn)>
		<cfset application.notify.add(session.user.userid,url.p)>
	</cfif>
	<cflocation url="index.cfm" addtoken="false">
</cfif>

<cfif session.user.admin>
	<cfset projects = application.project.get()>
<cfelse>
	<cfset projects = application.project.get(session.user.userid)>
</cfif>

<cfif not session.user.admin and projects.recordCount eq 1>
	<cflocation url="project.cfm?p=#projects.projectid#" addtoken="false">
	<cfabort>
</cfif>

<cfset projects_reg = application.project.getDistinct(allowReg=true)>
<cfquery name="active_projects" dbtype="query">
	select * from projects where status = 'Active'
</cfquery>
<cfquery name="onhold_projects" dbtype="query">
	select * from projects where status = 'On-Hold'
</cfquery>
<cfquery name="arch_projects" dbtype="query">
	select * from projects where status = 'Archived'
</cfquery>
<cfquery name="allow_reg_projects" dbtype="query">
	select * from projects_reg where projectid not in (
	<cfif active_projects.recordCount>'#replace(ValueList(active_projects.projectid),",","','","ALL")#'<cfelse>''</cfif>)
</cfquery>
<cfif not projects.recordCount>
	<cfset QueryAddRow(projects)>
	<cfset QuerySetCell(projects, "projectID", "0")>
	<cfif session.user.admin>
		<cfset newInstall = true>
	<cfelse>
		<cfset noProjects = true>
	</cfif>
</cfif>
<cfset visible_project_list_mstones = "">
<cfset visible_project_list_issues = "">
<cfloop query="projects">
	<cfif mstone_view gt 0>
		<cfset visible_project_list_mstones = listAppend(visible_project_list_mstones,projectID)>
	</cfif>
</cfloop>
<cfloop query="projects">
	<cfif issue_view gt 0>
		<cfset visible_project_list_issues = listAppend(visible_project_list_issues,projectID)>
	</cfif>
</cfloop>
<cfset activity = application.activity.get('',valueList(projects.projectID),'true')>
<cfif listLen(visible_project_list_mstones)>
	<cfset milestones_overdue = application.milestone.get('','','overdue','',visible_project_list_mstones)>
	<cfset milestones_upcoming = application.milestone.get('','','upcoming','1',visible_project_list_mstones)>
<cfelse>
	<cfset milestones_overdue = QueryNew("milestoneID,dueDate","VarChar,Date")>
	<cfset milestones_upcoming = QueryNew("milestoneID,dueDate","VarChar,Date")>
</cfif>
<cfif listLen(visible_project_list_issues)>
	<cfset issues = application.issue.get('','','New|Accepted|Assigned',visible_project_list_issues)>
<cfelse>
	<cfset issues = QueryNew("issueID,dueDate","VarChar,Date")>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Home">

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
			headers: { 3: { sorter:'severity' }, 4: { sorter:'statuses' }, 7: { sorter:'usLongDate' }, 8: { sorter:'usLongDate' }, 9: { sorter:'usLongDate' } },
			widgets: ['zebra']  
	});
	</cfif>
	<cfif activity.recordCount>
	$('##activity').tablesorter({
			cssHeader: 'theader',
			sortList: [[5,1]],
			headers: { 5: { sorter:'usLongDate' } },
			widgets: ['zebra']
	});
	$('table##activity').Scrollable(250,'');
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

			<cfif isDefined("newInstall") or isDefined("noProjects")>
			<div class="header">
				<h2 class="activity full">Welcome to the #application.settings.app_title#!</h2>
			</div>
			<div class="content">
				<div class="wrapper">
					
					<cfif isDefined("newInstall")>
						<h4 class="alert">It appears that this is your first time running the application.</h4><br />
						<cfif session.user.admin>
							<h4>The first thing you'll want to do is to <a href="editProject.cfm">create a new project</a>.</h4><br />
							<h4>You may want to <a href="./admin/editClient.cfm">add a client</a> first if the project applies to one.</h4>
						<cfelse>
							<p>Please have an administrator login to create the first project.</p>
						</cfif>
					<cfelse>
						<h4 class="alert">You are not currently assigned to any projects.</h4><br />
						You must be added by an administrator<cfif allow_reg_projects.recordCount> or you may join one of the projects at right</cfif>.
					</cfif>
			 	</div>
			</div>

			<cfelse>

			<div class="header">
				<h2 class="activity full">Latest activity across all your projects</h2>
			</div>
			<div class="content">
				<div class="wrapper">
					
					<!--- due in next 14 days calendar --->
					<cfquery name="ms_next_14" dbtype="query">
						select * from milestones_upcoming where dueDate <= 
						<cfqueryparam value="#CreateODBCDate(DateAdd("d",13,Now()))#" cfsqltype="CF_SQL_DATE" />
					</cfquery>
					<cfquery name="issues_next_14" dbtype="query">
						select * from issues where dueDate <= 
						<cfqueryparam value="#CreateODBCDate(DateAdd("d",13,Now()))#" cfsqltype="CF_SQL_DATE" />
					</cfquery>
					<cfif ms_next_14.recordCount or issues_next_14.recordCount>
					<div class="mb5 b" style="border-bottom:1px solid ##000;">Due in the next 14 days</div>
					<cfset theDay = dayOfWeek(now())>
					<table border="0" cellpadding="0" cellspacing="1" width="100%" id="milestone_cal">
						<tr>
						<cfloop index="i" from="0" to="6">
							<th>#Left(dayOfWeekAsString(theDay),3)#</th>
							<cfset theDay = theDay + 1>
							<cfif theDay eq 8>
								<cfset theDay = 1>
							</cfif>
						</cfloop>
						</tr>
						<cfloop index="i" from="0" to="13">
							<cfif i mod 7 eq 0><tr></cfif>
								<cfquery name="todays_ms" dbtype="query">
									select milestoneid,name,projectid,projName from milestones_upcoming where dueDate = 
									<cfqueryparam value="#CreateODBCDate(DateAdd("d",i,Now()))#" cfsqltype="CF_SQL_DATE" />
								</cfquery>
								<cfquery name="todays_issues" dbtype="query">
									select issueid,issue,projectid,name from issues where dueDate = 
									<cfqueryparam value="#CreateODBCDate(DateAdd("d",i,Now()))#" cfsqltype="CF_SQL_DATE" />
								</cfquery>
								<cfif i eq 0>
									<td class="today"><span class="b">TODAY</span>
								<cfelse>
									<cfif todays_ms.recordCount or todays_issues.recordCount>
										<td class="active"><span class="b"><cfif i eq 1 or DatePart("d",DateAdd("d",i,Now())) eq 1>#Left(MonthAsString(Month(DateAdd("d",i,Now()))),3)#</cfif>
										#LSDateFormat(DateAdd("d",i,Now()),"d")#</span>
									<cfelse>
										<td><cfif i eq 1 or DatePart("d",DateAdd("d",i,Now())) eq 1>#Left(MonthAsString(Month(DateAdd("d",i,Now()))),3)#</cfif>
										#LSDateFormat(DateAdd("d",i,Now()),"d")#
									</cfif>
								</cfif>
								<ul class="cal_ms">
									<cfif todays_ms.recordCount>
										<cfloop query="todays_ms">
											<li><a href="milestone.cfm?p=#projectID#&m=#milestoneID#">#name#</a> (<a href="project.cfm?p=#projectID#">#projName#</a>) (milestone)</li>
										</cfloop>
									</cfif>
									<cfif todays_issues.recordCount>
										<cfloop query="todays_issues">
											<li><a href="issue.cfm?p=#projectID#&i=#issueID#">#issue#</a> (<a href="project.cfm?p=#projectID#">#name#</a>) (issue)</li>
										</cfloop>
									</cfif>
								</ul>
							</td>
							<cfif i mod 7 eq 6></tr></cfif>
						</cfloop>
					</table>
					<br />
					</cfif>						
					
					<cfif listLen(visible_project_list_mstones) and milestones_overdue.recordCount>
					<div class="overdue">
					<div class="mb5 b" style="color:##f00;border-bottom:1px solid ##f00;">Late Milestones</div>
					<ul class="nobullet">
						<cfloop query="milestones_overdue">
							<cfset daysago = DateDiff("d",dueDate,Now())>
						<li><span class="b" style="color:##f00;"><cfif daysago eq 0>Today<cfelse>#daysago# day<cfif daysago neq 1>s</cfif> ago</cfif>:</span> 
							<a href="milestone.cfm?p=#projectID#&m=#milestoneID#">#name#</a>
							<span class="sm">(<a href="project.cfm?p=#projectID#" class="b">#projName#</a><cfif compare(lastName,'')> | #firstName# #lastName# is responsible</cfif>)</span>
						</li>
						</cfloop>
					</ul>
					</div><br />
					</cfif>
					
					<cfif listLen(visible_project_list_mstones) and milestones_upcoming.recordCount>
					<div class="mb5 b" style="border-bottom:1px solid ##000;">
						
					<span style="float:right;font-size:.75em;"><a href="##" onclick="all_upcoming_milestones('1');$(this).addClass('subactive');$('##threem').removeClass('subactive');$('##all').removeClass('subactive');" class="sublink subactive" id="onem">1 month</a> | <a href="##" onclick="all_upcoming_milestones('3');$('##onem').removeClass('subactive');$(this).addClass('subactive');$('##all').removeClass('subactive');" class="sublink" id="threem">3 months</a> | <a href="##" onclick="all_upcoming_milestones('');$('##onem').removeClass('subactive');$('##threem').removeClass('subactive');$(this).addClass('subactive');" class="sublink" id="all">All</a></span>
						
						Upcoming Milestones</div>
					<ul class="nobullet" id="upcoming_milestones">
						<cfloop query="milestones_upcoming">
							<cfset daysDiff = DateDiff("d",CreateDate(year(Now()),month(Now()),day(Now())),dueDate)>
						<li><span class="b"><cfif daysDiff eq 0>Today<cfelseif daysDiff eq 1>Tomorrow<cfelse>#daysDiff# days away</cfif>:</span> 
							<a href="milestone.cfm?p=#projectID#&m=#milestoneID#">#name#</a>
							<span class="sm">(<a href="project.cfm?p=#projectID#" class="b">#projName#</a><cfif compare(lastName,'')> | #firstName# #lastName# is responsible</cfif>)</span>
						</li>
						</cfloop>
					</ul><br />
					</cfif>


				 	<cfif listLen(visible_project_list_issues) and issues.recordCount>
					<div style="border:1px solid ##ddd;" class="mb20">
				 	<table class="activity full tablesorter" id="issues">
					<caption class="plain">Open Issues</caption>	 	
					<thead>
						<tr>
							<th>ID</th>
							<th>Project</th>
							<th>Type</th>
							<th>Severity</th>
							<th>Status</th>
							<th>Issue</th>
							<th>Assigned To</th>
							<th>Reported</th>
							<th>Updated</th>
							<th>Due</th>
						</tr>
					</thead>
					<tbody>
					<cfset thisRow = 1>
					<cfloop query="issues">
					<tr>
						<td><a href="issue.cfm?p=#projectID#&i=#issueID#">#shortID#</a></td>
						<td><a href="project.cfm?p=#projectID#">#name#</a></td>
						<td>#type#</td>
						<td>#severity#</td>
						<td>#status#</td>
						<td><a href="issue.cfm?p=#projectID#&i=#issueID#">#issue#</a></td>
						<td>#assignedFirstName# #assignedLastName#</td>
						<td>#LSDateFormat(DateAdd("h",session.tzOffset,created),"mmm dd, yyyy")#</td>
						<td><cfif isDate(updated)>#DateFormat(DateAdd("h",session.tzOffset,updated),"mmm dd, yyyy")#</cfif></td>
						<td><cfif isDate(dueDate)>#LSDateFormat(dueDate,"mmm dd, yyyy")#</cfif></td>
					</tr>
					<cfset thisRow = thisRow + 1>
					</cfloop>
					</tbody>
					</table>
					</div>
					</cfif>		


					<cfif activity.recordCount>
					<div style="border:1px solid ##ddd;">
					<div style="background-color:##eee;font-weight:bold;font-size:1.2em;padding:5px;margin-bottom:1px;">
					<span class="feedlink"><a href="rss.cfm?u=#session.user.userID#&type=allact" class="feed">RSS Feed</a></span>Recent Activity
					</div>
					<table class="activity full tablesorter" id="activity">
						<thead>
							<tr>
								<th>Project</th>
								<th>Type</th>
								<th>Title</th>
								<th>Action</th>
								<th>User</th>
								<th>Timestamp</th>
							</tr>
						</thead>
						<tbody>
							
						<cfset thisRow = 1>
						<cfloop query="activity">
							<cfif session.user.admin or ((not compareNoCase(type,'issue') and issue_view eq 1) or (not compareNoCase(type,'message') and msg_view eq 1) or (not compareNoCase(type,'milestone') and mstone_view eq 1) or (not compareNoCase(type,'to-do list') and todolist_view eq 1) or (not compareNoCase(type,'file') and file_view eq 1))>
							<tr>
								<td><a href="project.cfm?p=#projectID#" title="#projectName#">#projectName#</a></td>
								<td><div class="catbox
								<cfswitch expression="#type#">
									<cfcase value="Issue">issue">Issue</cfcase>		
									<cfcase value="Message">message">Message</cfcase>
									<cfcase value="Milestone">milestone">Milestone</cfcase>
									<cfcase value="To-Do List">todolist">To-Do List</cfcase>
									<cfcase value="File">file">File</cfcase>
									<cfcase value="Project">project">Project</cfcase>
									<cfcase value="Screenshot">screenshot">Screenshot</cfcase>
									<cfdefaultcase>#type#">#type#</cfdefaultcase>
								</cfswitch>	
							</div></td>
							<td><cfswitch expression="#type#">
									<cfcase value="Issue"><a href="issue.cfm?p=#projectID#&i=#id#">#name#</a></cfcase>		
									<cfcase value="Message"><a href="message.cfm?p=#projectID#&m=#id#">#name#</a></cfcase>
									<cfcase value="Milestone"><a href="milestones.cfm?p=#projectID#&m=#id#">#name#</a></cfcase>
									<cfcase value="To-Do"><a href="todos.cfm?p=#projectID###id_#id#">#name#</a></cfcase>
									<cfcase value="To-Do List"><a href="todos.cfm?p=#projectID#&t=#id#">#name#</a></cfcase>
									<cfcase value="File"><a href="files.cfm?p=#projectID#&f=#id#">#name#</a></cfcase>
									<cfcase value="Project"><a href="project.cfm?p=#projectID#">#name#</a></cfcase>
									<cfcase value="Screenshot"><a href="issue.cfm?p=#projectID#&i=#id###screen">#name#</a></cfcase>
									<cfdefaultcase>#name#</cfdefaultcase>
								</cfswitch>
								</td>
							<td class="g">#activity# by</td>
							<td>#firstName# #lastName#</td>
							<td>#LSDateFormat(DateAdd("h",session.tzOffset,stamp),"mmm d, yyyy")# <cfif application.settings.clockHours eq 12>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"h:mm tt")#<cfelse>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"HH:mm")#</cfif></td>
							</tr>
							<cfset thisRow = thisRow + 1>
							</cfif>
						</cfloop>
						</tbody>
					</table>
					</div>
					<cfelse>
						<div class="warn">There is no recent activity.</div>
					</cfif>


			 	</div>
			</div>
			
			</cfif>
			
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

		<cfif session.user.admin>
			<cfif isDefined("newInstall")>
				<h3><a href="./admin/editClient.cfm" class="add">Add a new client</a></h3><br />
			</cfif>
			<h3><a href="editProject.cfm" class="add">Create a new project</a></h3><br />
		</cfif>

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
		
		<cfif allow_reg_projects.recordCount>
		<div class="header"><h3>Projects you can join</h3></div>
		<div class="content">
			<ul>
				<cfloop query="allow_reg_projects">
					<li><a href="#cgi.script_name#?reg=1&p=#projectID#">#name#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>
		
	</div>

</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">