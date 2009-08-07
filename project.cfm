<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfparam name="url.p" default="">
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset projectUsers = application.project.projectUsers(url.p,'0','lastLogin desc')>
<cfif session.user.admin or project.mstone_view eq 1>
	<cfset milestones_overdue = application.milestone.get(url.p,'','overdue')>
	<cfset milestones_upcoming = application.milestone.get(url.p,'','upcoming','1')>
</cfif>
<cfif session.user.admin or project.issue_view eq 1>
	<cfset issues = application.issue.get(url.p,'','New|Accepted|Assigned')>
</cfif>
<cfset activity = application.activity.get(url.p,'','true')>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Overview" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfsavecontent variable="js">
<cfoutput>
<script type='text/javascript'>
$(document).ready(function(){
	<cfif project.issue_view and issues.recordCount>
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
			headers: { 2: { sorter:'severity' }, 3: { sorter:'statuses' }, 6: { sorter:'usLongDate' }, 7: { sorter:'usLongDate' }, 8: { sorter:'usLongDate' } },
			widgets: ['zebra']  
	});
	</cfif>
	<cfif activity.recordCount>
	$('##activity').tablesorter({
			cssHeader: 'theader',
			sortList: [[4,1]],
			headers: { 4: { sorter:'usLongDate' } },
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
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

			<div class="header">
				<span class="rightmenu">
					<cfif session.user.admin or project.msg_edit eq 1>
					<a href="editMessage.cfm?p=#url.p#" class="add">Message</a>
					</cfif>
					<cfif session.user.admin or project.todolist_edit eq 1>
						| <a href="editTodolist.cfm?p=#url.p#" class="add">To-do list</a>
					</cfif>
					<cfif session.user.admin or project.mstone_edit eq 1>
						| <a href="editMilestone.cfm?p=#url.p#" class="add">Milestone</a>
					</cfif>
					<cfif session.user.admin or project.issue_edit eq 1>
						| <a href="editIssue.cfm?p=#url.p#" class="add">Issue</a>
					</cfif>
				</span>					
				
				<h2 class="overview">Project overview</h2>
			</div>
			<div class="content">
				<div class="wrapper">
				
				<cfif project.display and compare(project.description,'') and compare(project.description,'<br />')><div class="fs12 mb20">#project.description#</div></cfif>
				
				<cfif project.mstone_view or project.issue_view>
					<!--- due in next 14 days calendar --->
					<cfif project.mstone_view>
						<cfquery name="ms_next_14" dbtype="query">
							select * from milestones_upcoming where dueDate <= 
							<cfqueryparam value="#CreateODBCDate(DateAdd("d",13,Now()))#" cfsqltype="CF_SQL_DATE" />
						</cfquery>
					</cfif>
					<cfif project.issue_view>
						<cfquery name="issues_next_14" dbtype="query">
							select * from issues where dueDate <= 
							<cfqueryparam value="#CreateODBCDate(DateAdd("d",13,Now()))#" cfsqltype="CF_SQL_DATE" />
						</cfquery>
					</cfif>
					<cfif (project.mstone_view and ms_next_14.recordCount) or (project.issue_view and issues_next_14.recordCount)>
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
								<cfif project.mstone_view>
									<cfquery name="todays_ms" dbtype="query">
										select milestoneid,name from milestones_upcoming where dueDate = 
										<cfqueryparam value="#CreateODBCDate(DateAdd("d",i,Now()))#" cfsqltype="CF_SQL_DATE" />
									</cfquery>
								</cfif>
								<cfif project.issue_view>
									<cfquery name="todays_issues" dbtype="query">
										select issueid,issue from issues where dueDate = 
										<cfqueryparam value="#CreateODBCDate(DateAdd("d",i,Now()))#" cfsqltype="CF_SQL_DATE" />
									</cfquery>
								</cfif>
								<cfif i eq 0>
									<td class="today"><span class="b">TODAY</span>
								<cfelse>
									<cfif (project.mstone_view and todays_ms.recordCount) or (project.issue_view and todays_issues.recordCount gt 0)>
										<td class="active"><span class="b"><cfif i eq 1 or DatePart("d",DateAdd("d",i,Now())) eq 1>#Left(MonthAsString(Month(DateAdd("d",i,Now()))),3)#</cfif>
										#LSDateFormat(DateAdd("d",i,Now()),"d")#</span>
									<cfelse>
										<td><cfif i eq 1 or DatePart("d",DateAdd("d",i,Now())) eq 1>#Left(MonthAsString(Month(DateAdd("d",i,Now()))),3)#</cfif>
										#LSDateFormat(DateAdd("d",i,Now()),"d")#
									</cfif>
								</cfif>
								<ul class="cal_ms">
								<cfif project.mstone_view and todays_ms.recordCount>
									<cfloop query="todays_ms">
										<li><a href="milestone.cfm?p=#url.p#&m=#milestoneID#">#name#</a> (milestone)</li>
									</cfloop>
								</cfif>
								<cfif project.issue_view and todays_issues.recordCount>
									<cfloop query="todays_issues">
										<li><a href="issue.cfm?p=#url.p#&i=#issueID#">#issue#</a> (issue)</li>
									</cfloop>
								</cfif>
								</ul>
							</td>
							<cfif i mod 7 eq 6></tr></cfif>
						</cfloop>
					</table>
					<br />
					</cfif>

					<cfif project.mstone_view and milestones_overdue.recordCount>
						<div class="overdue">
						<div class="mb5 b" style="color:##f00;border-bottom:1px solid ##f00;">Late Milestones</div>
						<ul class="nobullet">
							<cfloop query="milestones_overdue">
							<cfset daysDiff = DateDiff("d",dueDate,Now())>
							<li><span class="b" style="color:##f00;"><cfif daysDiff eq 0>Today<cfelseif daysDiff eq 1>Yesterday<cfelse>#daysDiff# days ago</cfif>:</span> 
							<a href="milestone.cfm?p=#projectID#&m=#milestoneID#">#name#</a>
							<cfif compare(lastName,'')><span class="sm">(#firstName# #lastName# is responsible)</span></cfif>
							</li>
							</cfloop>
						</ul>
						</div><br />
					</cfif>

					<cfif project.mstone_view and milestones_upcoming.recordCount>
					<div class="mb5 b" style="border-bottom:1px solid ##000;">
						<span style="float:right;font-size:.75em;"><a href="##" onclick="upcoming_milestones('#url.p#','1');$(this).addClass('subactive');$('##threem').removeClass('subactive');$('##all').removeClass('subactive');return false;" class="sublink subactive" id="onem">1 month</a> | <a href="##" onclick="upcoming_milestones('#url.p#','3');$('##onem').removeClass('subactive');$(this).addClass('subactive');$('##all').removeClass('subactive');return false;" class="sublink" id="threem">3 months</a> | <a href="##" onclick="upcoming_milestones('#url.p#','');$('##onem').removeClass('subactive');$('##threem').removeClass('subactive');$(this).addClass('subactive');return false;" class="sublink" id="all">All</a></span>
						Upcoming Milestones</div>	
					<ul class="nobullet" id="upcoming_milestones">
						<cfloop query="milestones_upcoming">
							<cfset daysDiff = DateDiff("d",CreateDate(year(Now()),month(Now()),day(Now())),dueDate)>
						<li><span class="b"><cfif daysDiff eq 0>Today<cfelseif daysDiff eq 1>Tomorrow<cfelse>#daysDiff# days away</cfif>:</span> 
							<a href="milestone.cfm?p=#projectID#&m=#milestoneID#">#name#</a>
							<cfif compare(lastName,'')><span class="sm">(#firstName# #lastName# is responsible)</span></cfif>
						</li>
						</cfloop>
					</ul><br />
					</cfif>
				</cfif>

				<cfif project.issue_view and issues.recordCount>
					<div style="border:1px solid ##ddd;" class="mb20">
					<table class="activity full tablesorter" id="issues">
					<caption class="plain">Open Issues</caption>
					<thead>
						<tr>
							<th>ID</th>
							<th>Type</th>
							<th>Severity</th>
							<th>Status</th>
							<th>Issue</th>
							<th>Assigned To</th>
							<th>Reported</th>
							<th>Updated</th>
							<th>Due Date</th>
						</tr>
					</thead>
					<tbody>
						<cfset thisRow = 1>
						<cfloop query="issues">
						<tr>
							<td><a href="issue.cfm?p=#url.p#&i=#issueID#">#shortID#</a></td>
							<td>#type#</td>
							<td>#severity#</td>
							<td>#status#</td>
							<td><a href="issue.cfm?p=#url.p#&i=#issueID#">#issue#</a></td>
							<td>#assignedFirstName# #assignedLastName#</td>
							<td>#LSDateFormat(DateAdd("h",session.tzOffset,created),"mmm dd, yyyy")#</td>
							<td><cfif isDate(updated)>#LSDateFormat(DateAdd("h",session.tzOffset,updated),"mmm dd, yyyy")#</cfif></td>
							<td>#LSDateFormat(dueDate,"mmm dd, yyyy")#</td>
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
				<span class="feedlink"><a href="rss.cfm?u=#session.user.userID#&p=#url.p#&type=act" class="feed">RSS Feed</a></span>Recent Activity
				</div>
				
				<table class="activity full tablesorter" id="activity">
					<thead>
						<tr>
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
						<cfif session.user.admin or ((not compareNoCase(type,'issue') and project.issue_view eq 1) or (not compareNoCase(type,'message') and project.msg_view eq 1) or (not compareNoCase(type,'milestone') and project.mstone_view eq 1) or (not compareNoCase(type,'to-do list') and project.todolist_view eq 1) or (not compareNoCase(type,'file') and project.file_view eq 1))>
						<tr><td><div class="catbox
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
								<cfcase value="Issue"><a href="issue.cfm?p=#url.p#&i=#id#">#name#</a></cfcase>		
								<cfcase value="Message"><a href="message.cfm?p=#url.p#&m=#id#">#name#</a></cfcase>
								<cfcase value="Milestone"><a href="milestones.cfm?p=#url.p#&m=#id#">#name#</a></cfcase>
								<cfcase value="To-Do"><a href="todos.cfm?p=#url.p###id_#id#">#name#</a></cfcase>
								<cfcase value="To-Do List"><a href="todos.cfm?p=#url.p#&t=#id#">#name#</a></cfcase>
								<cfcase value="File"><a href="files.cfm?p=#url.p#&f=#id#">#name#</a></cfcase>
								<cfcase value="Project"><a href="project.cfm?p=#url.p#">#name#</a></cfcase>
								<cfcase value="Screenshot"><a href="issue.cfm?p=#url.p#&i=#id###screen">#name#</a></cfcase>
								<cfdefaultcase>#name#</cfdefaultcase>
							</cfswitch>
							</td>
						<td class="g">#activity# by</td>
						<td>#firstName# #lastName#</td>
						<td>#LSDateFormat(DateAdd("h",session.tzOffset,stamp),"mmm d, yyyy")# <cfif application.settings.clockHours eq 12>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"h:mmtt")#<cfelse>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"HH:mm")#</cfif></td>
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
		<cfif compare(project.logo_img,'')>
			<img src="#application.settings.userFilesMapping#/projects/#project.logo_img#" border="0" alt="#project.name#" class="projlogo" />
		</cfif>
			
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

		<div class="header"><h3>Status</h3></div>
		<div class="content">
			<ul>
				<li>#project.status#</li>
			</ul>
		</div>
		
		<div class="header"><h3>People on this project</h3></div>
		<div class="content">
			<ul class="people">
				<cfloop query="projectUsers">
				<li><div class="b">#firstName# #lastName#<cfif admin> (admin)</cfif></div>
				<div class="sm g norm"><cfif compare(userID,session.user.userID)><cfif isDate(lastLogin)>Last login 
						#request.udf.relativeTime(DateAdd("h",session.tzOffset,lastLogin))#
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