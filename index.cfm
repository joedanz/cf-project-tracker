<cfsetting enablecfoutputonly="true">

<cfset projects = application.project.get(session.user.userid)>
<cfif projects.recordCount eq 1>
	<cflocation url="project.cfm?p=#projects.projectid#" addtoken="false">
	<cfabort>
</cfif>
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
<cfset activity = application.activity.get('',valueList(projects.projectID),'true')>
<cfset milestones_overdue = application.milestone.get('','','overdue','',valueList(projects.projectID))>
<cfset milestones_upcoming = application.milestone.get('','','upcoming','1',valueList(projects.projectID))>
<cfset issues = application.issue.get('','','Open',valueList(projects.projectID))>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Home">

<cfsavecontent variable="js">
<cfoutput>
<script type='text/javascript'>
$(document).ready(function(){
	<cfif issues.recordCount>
	$('##issues').tableSorter({
			sortColumn: 'ID',		// Integer or String of the name of the column to sort by
			sortClassAsc: 'headerSortUp',		// Class name for ascending sorting action to header
			sortClassDesc: 'headerSortDown',	// Class name for descending sorting action to header
			highlightClass: 'highlight', 		// class name for sort column highlighting
			headerClass: 'theader'
	});
	</cfif>
	<cfif activity.recordCount>
	$('##activity').tableSorter({
			sortClassAsc: 'headerSortUp',		
			sortClassDesc: 'headerSortDown',	
			highlightClass: 'highlight', 		
			headerClass: 'theader'
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

			<div class="header">
				<h2 class="activity full">Latest activity across all your projects</h2>
			</div>
			<div class="content">
				<div class="wrapper">

					<cfif milestones_overdue.recordCount>
					<div class="overdue">
					<div class="mb5 b" style="color:##f00;border-bottom:1px solid ##f00;">Late Milestones</div>
					<ul class="nobullet">
						<cfloop query="milestones_overdue">
							<cfset daysago = DateDiff("d",dueDate,Now())>
						<li><span class="b" style="color:##f00;"><cfif daysago eq 0>Today<cfelse>#daysago# day<cfif daysago neq 1>s</cfif> ago</cfif>:</span> 
							<a href="milestone.cfm?p=#projectID#&m=#milestoneID#">#name#</a>
							<span style="font-size:.9em;">(<a href="project.cfm?p=#projectID#" class="b">#projName#</a><cfif compare(lastName,'')> | #firstName# #lastName# is responsible</cfif>)</span>
						</li>
						</cfloop>
					</ul>
					</div><br />
					</cfif>
					
					<!--- due in next 14 days calendar --->
					<cfquery name="ms_next_14" dbtype="query">
						select * from milestones_upcoming where dueDate <= #CreateODBCDate(DateAdd("d",13,Now()))#
					</cfquery>
					<cfif ms_next_14.recordCount>
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
						<tr>
						<cfloop index="i" from="0" to="6">
							<cfquery name="todays_ms" dbtype="query">
								select name,projName from milestones_upcoming where dueDate = #CreateODBCDate(DateAdd("d",i,Now()))#
							</cfquery>
							<cfif i eq 0>
								<td class="today"><span class="b">TODAY</span>
							<cfelse>
								<td<cfif todays_ms.recordCount> class="active"</cfif>><cfif i eq 1>#Left(MonthAsString(Month(Now())),3)#</cfif>
								#DateFormat(DateAdd("d",i,Now()),"d")#
							</cfif>
							<cfif todays_ms.recordCount>
								<ul class="cal_ms">
								<cfloop query="todays_ms">
									<li>#name# (#projName#)</li>
								</cfloop>
								</ul>
							</cfif>
							</td>
						</cfloop>	
						</tr>
						<tr>
						<cfloop index="i" from="7" to="13">
							<cfquery name="todays_ms" dbtype="query">
								select name,projName from milestones_upcoming where dueDate = #CreateODBCDate(DateAdd("d",i,Now()))#
							</cfquery>
							<td<cfif todays_ms.recordCount> class="active"</cfif>><cfif i eq 1>#Left(MonthAsString(Month(Now())),3)#</cfif>
								#DateFormat(DateAdd("d",i,Now()),"d")#
							<cfif todays_ms.recordCount>
								<ul class="cal_ms">
								<cfloop query="todays_ms">
									<li>#name# (#projName#)</li>
								</cfloop>
								</ul>
							</cfif>
							</td>
						</cfloop>	
						</tr>
					</table>
					<br />
					</cfif>						
					
					<cfif milestones_upcoming.recordCount>
					<div class="mb5 b" style="border-bottom:1px solid ##000;">
						
					<span style="float:right;font-size:.75em;"><a href="##" onclick="all_upcoming_milestones('1');$(this).addClass('subactive');$('##threem').removeClass('subactive');$('##all').removeClass('subactive');" class="sublink subactive" id="onem">1 month</a> | <a href="##" onclick="all_upcoming_milestones('3');$('##onem').removeClass('subactive');$(this).addClass('subactive');$('##all').removeClass('subactive');" class="sublink" id="threem">3 months</a> | <a href="##" onclick="all_upcoming_milestones('');$('##onem').removeClass('subactive');$('##threem').removeClass('subactive');$(this).addClass('subactive');" class="sublink" id="all">All</a></span>
						
						Upcoming Milestones</div>
					<ul class="nobullet" id="upcoming_milestones">
						<cfloop query="milestones_upcoming">
							<cfset daysDiff = DateDiff("d",CreateDate(year(Now()),month(Now()),day(Now())),dueDate)>
						<li><span class="b"><cfif daysDiff eq 0>Today<cfelseif daysDiff eq 1>Tomorrow<cfelse>#daysDiff# days away</cfif>:</span> 
							<a href="milestone.cfm?p=#projectID#&m=#milestoneID#">#name#</a>
							<span style="font-size:.9em;">(<a href="project.cfm?p=#projectID#" class="b">#projName#</a><cfif compare(lastName,'')> | #firstName# #lastName# is responsible</cfif>)</span>
						</li>
						</cfloop>
					</ul><br />
					</cfif>


				 	<cfif issues.recordCount>
					<div style="border:1px solid ##ddd;" class="mb20">
				 	<table class="svn" id="issues">
					<caption class="plain">Open Issues</caption>	 	
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
					<cfloop query="issues">
					<tr>
						<td><a href="issue.cfm?p=#projectID#&i=#issueID#">#shortID#</a></td>
						<td>#name#</td>
						<td>#issue#</td>
						<td>#type#</td>
						<td>#severity#</td>
						<td>#assignedFirstName# #assignedLastName#</td>
						<td>#DateFormat(created,"d mmm")#</td>
						<td>#DateFormat(updated,"d mmm")#</td>
					</tr>
					</cfloop>
					</tbody>
					</table>
					</div>
					</cfif>		


					<cfif activity.recordCount>
					<div style="border:1px solid ##ddd;">
					<div style="background-color:##eee;font-weight:bold;font-size:1.2em;padding:5px;">
					<span class="feedlink"><a href="rss.cfm?u=#session.user.userID#&type=allact" class="feed">RSS Feed</a></span>Recent Activity
					</div>
					<table class="activity full" id="activity">
						<thead>
							<tr>
								<th>Project</th>
								<th>Type</th>
								<th>Date</th>
								<th>Title</th>
								<th>Action</th>
								<th>User</th>
							</tr>
						</thead>
						<tbody>
						<cfloop query="activity">
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
								<cfdefaultcase>">#type#</cfdefaultcase>
							</cfswitch>	
						</div></td>
						<td>#DateFormat(stamp,"d mmm")#</td>
						<td><cfswitch expression="#type#">
								<cfcase value="Issue"><a href="issue.cfm?p=#projectID#&i=#id#">#name#</a></cfcase>		
								<cfcase value="Message"><a href="message.cfm?p=#projectID#&m=#id#">#name#</a></cfcase>
								<cfcase value="Milestone"><a href="milestones.cfm?p=#projectID#&m=#id#">#name#</a></cfcase>
								<cfcase value="To-Do List"><a href="todos.cfm?p=#projectID#&t=#id#">#name#</a></cfcase>
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
					</div>
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

	<!--- right column --->
	<div class="right">

		<cfif session.user.admin>
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
		
	</div>
		
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">