<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
<cfset projectUsers = application.project.projectUsers(url.p,'0','lastLogin desc')>
<cfif project.mstones gt 0>
	<cfset milestones_overdue = application.milestone.get(url.p,'','overdue')>
	<cfset milestones_upcoming = application.milestone.get(url.p,'','upcoming','1')>
</cfif>
<cfif project.issues gt 0>
	<cfset issues = application.issue.get(url.p,'','Open')>
</cfif>
<cfset activity = application.activity.get(url.p,'','true')>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Overview" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfsavecontent variable="js">
<cfoutput>
<script type='text/javascript'>
$(document).ready(function(){
	<cfif project.issues gt 0 and issues.recordCount>
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
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

			<div class="header">
				<span class="rightmenu">
					<cfif project.msgs gt 1>
					<a href="editMessage.cfm?p=#url.p#" class="add">Message</a>
					</cfif>
					<cfif project.todos gt 1>
						| <a href="editTodolist.cfm?p=#url.p#" class="add">To-do list</a>
					</cfif>
					<cfif project.mstones gt 1>
						| <a href="editMilestone.cfm?p=#url.p#" class="add">Milestone</a>
					</cfif>
					<cfif project.issues gt 1>
						| <a href="editIssue.cfm?p=#url.p#" class="add">Issue</a>
					</cfif>
				</span>					
				
				<h2 class="overview">Project overview</h2>
			</div>
			<div class="content">
				<div class="wrapper">
				
				<cfif project.display><div class="fs12 mb20">#project.description#</div></cfif>
				
				<cfif project.mstones gt 0>
					<cfif milestones_overdue.recordCount>
					<div class="overdue">
					<div class="mb5 b" style="color:##f00;border-bottom:1px solid ##f00;">Late Milestones</div>
					<ul class="nobullet">
						<cfloop query="milestones_overdue">
						<cfset daysDiff = DateDiff("d",dueDate,Now())>
						<li><span class="b" style="color:##f00;"><cfif daysDiff eq 0>Today<cfelseif daysDiff eq 1>Yesterday<cfelse>#daysDiff# days ago</cfif>:</span> 
						<a href="milestone.cfm?p=#projectID#&m=#milestoneID#">#name#</a>
						<cfif compare(lastName,'')><span style="font-size:.9em;">(#firstName# #lastName# is responsible)</span></cfif>
						</li>
						</cfloop>
					</ul>
					</div><br />
					</cfif>
	
					<!--- due in next 14 days calendar --->
					<cfquery name="ms_next_14" dbtype="query">
						select * from milestones_upcoming where dueDate <= 
						<cfqueryparam value="#CreateODBCDate(DateAdd("d",13,Now()))#" cfsqltype="CF_SQL_DATE" />
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
								select name from milestones_upcoming where dueDate = 
								<cfqueryparam value="#CreateODBCDate(DateAdd("d",i,Now()))#" cfsqltype="CF_SQL_DATE" />
							</cfquery>
							<cfif i eq 0>
								<td class="today"><span class="b">TODAY</span>
							<cfelse>
								<td<cfif todays_ms.recordCount> class="active"</cfif>><cfif i eq 1>#Left(MonthAsString(Month(DateAdd("d",i,Now()))),3)#</cfif>
								#DateFormat(DateAdd("d",i,Now()),"d")#
							</cfif>
							<cfif todays_ms.recordCount>
								<ul class="cal_ms">
								<cfloop query="todays_ms">
									<li>#name#</li>
								</cfloop>
								</ul>
							</cfif>
							</td>
						</cfloop>	
						</tr>
						<tr>
						<cfloop index="i" from="7" to="13">
							<cfquery name="todays_ms" dbtype="query">
								select name from milestones_upcoming where dueDate = 
								<cfqueryparam value="#CreateODBCDate(DateAdd("d",i,Now()))#" cfsqltype="CF_SQL_DATE" />
							</cfquery>
							<td<cfif todays_ms.recordCount> class="active"</cfif>><cfif i eq 1>#Left(MonthAsString(Month(DateAdd("d",i,Now()))),3)#</cfif>
								#DateFormat(DateAdd("d",i,Now()),"d")#
							<cfif todays_ms.recordCount>
								<ul class="cal_ms">
								<cfloop query="todays_ms">
									<li>#name#</li>
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
						<span style="float:right;font-size:.75em;"><a href="##" onclick="upcoming_milestones('#url.p#','1');$(this).addClass('subactive');$('##threem').removeClass('subactive');$('##all').removeClass('subactive');" class="sublink subactive" id="onem">1 month</a> | <a href="##" onclick="upcoming_milestones('#url.p#','3');$('##onem').removeClass('subactive');$(this).addClass('subactive');$('##all').removeClass('subactive');" class="sublink" id="threem">3 months</a> | <a href="##" onclick="upcoming_milestones('#url.p#','');$('##onem').removeClass('subactive');$('##threem').removeClass('subactive');$(this).addClass('subactive');" class="sublink" id="all">All</a></span>
						Upcoming Milestones</div>	
					<ul class="nobullet" id="upcoming_milestones">
						<cfloop query="milestones_upcoming">
							<cfset daysDiff = DateDiff("d",CreateDate(year(Now()),month(Now()),day(Now())),dueDate)>
						<li><span class="b"><cfif daysDiff eq 0>Today<cfelseif daysDiff eq 1>Tomorrow<cfelse>#daysDiff# days away</cfif>:</span> 
							<a href="milestone.cfm?p=#projectID#&m=#milestoneID#">#name#</a>
							<cfif compare(lastName,'')><span style="font-size:.9em;">(#firstName# #lastName# is responsible)</span></cfif>
						</li>
						</cfloop>
					</ul><br />
					</cfif>
				</cfif>
				
				<cfif project.issues gt 0 and issues.recordCount>
					<div style="border:1px solid ##ddd;" class="mb20">
					<table class="activity full" id="issues">
					<caption class="plain">Open Issues</caption>
					<thead>
						<tr>
							<th>ID</th>
							<th>Type</th>
							<th>Severity</th>
							<th>Issue</th>
							<th>Assigned To</th>
							<th>Reported</th>
						</tr>
					</thead>
					<tbody>
						<cfset thisRow = 1>
						<cfloop query="issues">
						<tr class="<cfif thisRow mod 2 eq 0>even<cfelse>odd</cfif>">
							<td><a href="issue.cfm?p=#url.p#&i=#issueID#">#shortID#</a></td>
							<td>#type#</td>
							<td>#severity#</td>
							<td>#issue#</td>
							<td>#assignedFirstName# #assignedLastName#</td>
							<td>#DateFormat(created,"d mmm")#</td>			
						</tr>
						<cfset thisRow = thisRow + 1>
						</cfloop>
					</tbody>
					</table>
					</div>
				</cfif>
				
				<cfif activity.recordCount>
				<div style="border:1px solid ##ddd;">
				<div style="background-color:##eee;font-weight:bold;font-size:1.2em;padding:5px;">
				<span class="feedlink"><a href="rss.cfm?u=#session.user.userID#&p=#url.p#&type=act" class="feed">RSS Feed</a></span>Recent Activity
				</div>
				
				<table class="activity full" id="activity">
					<thead>
						<tr>
							<th>Type</th>
							<th>Date</th>
							<th>Title</th>
							<th>Action</th>
							<th>User</th>
						</tr>
					</thead>
					<tbody>
					<cfset thisRow = 1>
					
					<cfloop query="activity">						
						<cfif not ((not compareNoCase(type,'issue') and project.issues eq 0) or (not compareNoCase(type,'message') and project.msgs eq 0) or (not compareNoCase(type,'milestone') and project.mstones eq 0) or (not compareNoCase(type,'to-do list') and project.todos eq 0) or (not compareNoCase(type,'file') and project.files eq 0))>
						<tr class="<cfif thisRow mod 2>even<cfelse>odd</cfif>"><td><div class="catbox
							<cfswitch expression="#type#">
								<cfcase value="Issue">issue">Issue</cfcase>		
								<cfcase value="Message">message">Message</cfcase>
								<cfcase value="Milestone">milestone">Milestone</cfcase>
								<cfcase value="To-Do List">todolist">To-Do List</cfcase>
								<cfcase value="File">file">File</cfcase>
								<cfcase value="Project">project">Project</cfcase>			
								<cfdefaultcase>>#type#</cfdefaultcase>
							</cfswitch>	
						</div></td>
						<td>#DateFormat(stamp,"d mmm")#</td>
						<td><cfswitch expression="#type#">
								<cfcase value="Issue"><a href="issue.cfm?p=#url.p#&i=#id#">#name#</a></cfcase>		
								<cfcase value="Message"><a href="message.cfm?p=#url.p#&m=#id#">#name#</a></cfcase>
								<cfcase value="Milestone"><a href="milestones.cfm?p=#url.p#&m=#id#">#name#</a></cfcase>
								<cfcase value="To-Do List"><a href="todos.cfm?p=#url.p#&t=#id#">#name#</a></cfcase>
								<cfcase value="File"><a href="files.cfm?p=#url.p#&f=#id#">#name#</a></cfcase>
								<cfcase value="Project"><a href="project.cfm?p=#url.p#">#name#</a></cfcase>
								<cfdefaultcase>#name#</cfdefaultcase>
							</cfswitch>
							</td>
						<td class="g">#activity# by</td>
						<td>#firstName# #lastName#</td>
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
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">
	
		<cfif compare(project.clientID,'')>
			<div class="header"><h3>Client</h3></div>
			<div class="content">
				<ul>
					<li>#project.clientName#</li>
				</ul>
			</div>
		</cfif>
	
		<div class="header"><h3>Project Owner</h3></div>
		<div class="content">
			<ul>
				<li>#project.ownerFirstName# #project.ownerLastName#</li>
			</ul>
		</div>
	
		<div class="header"><h3>People on this project</h3></div>
		<div class="content">
			<ul class="people">
				<cfloop query="projectUsers">
				<li><div class="b">#firstName# #lastName#<cfif admin> (admin)</cfif></div>
				<div style="font-weight:normal;font-size:.9em;color:##666;"><cfif compare(userID,session.user.userID)><cfif isDate(lastLogin)>Last login 
					<cfif DateDiff("n",lastLogin,Now()) lt 60>
						#DateDiff("n",lastLogin,Now())# minutes
					<cfelseif DateDiff("h",lastLogin,Now()) lt 24>
						#DateDiff("h",lastLogin,Now())# hours
					<cfelseif DateDiff("d",lastLogin,Now()) lt 31>
						#DateDiff("d",lastLogin,Now())# days
					<cfelseif DateDiff("m",lastLogin,Now()) lt 12>
						#DateDiff("m",lastLogin,Now())# months
					<cfelse>
						#DateDiff("y",lastLogin,Now())# year<cfif DateDiff("y",lastLogin,Now()) gt 1>s</cfif>
					</cfif> ago
					<cfelse>Never logged in</cfif><cfelse>Currently logged in</cfif></div></li>
				</cfloop>
			</ul>
		</div>
	</div>
<cfelse>
	<img src="./images/alert.gif" height="16" width="16" alt="Alert!" style="vertical-align:middle;" /> Project Not Found.
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">