<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
<cfset projectUsers = application.project.projectUsers(url.p,'','lastLogin desc')>
<cfset activity = application.activity.get(url.p,'true')>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Overview" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<span class="rightmenu">
						<a href="editMessage.cfm?p=#url.p#" class="add">Message</a> |
						<a href="editTodolist.cfm?p=#url.p#" class="add">To-do list</a> |
						<a href="editMilestone.cfm?p=#url.p#" class="add">Milestone</a> |
						<a href="editIssue.cfm?p=#url.p#" class="add">Issue</a>
					</span>					
					
					<h2 class="overview">Project overview</h2>
				</div>
				<div class="content">
					<div class="wrapper">
				 		<cfif project.display><div class="fs12">#project.description#</div></cfif>

<cfif activity.recordCount>
<table class="activity">
	<caption><span style="float:right;font-size:.85em;font-weight:normal;"><a href="rss.cfm?p=#url.p#&type=act" class="feed">RSS</a></span>Recent Activity</caption>
	<tbody>
	<cfloop query="activity">
	<tr class="<cfif currentRow mod 2>even<cfelse>odd</cfif>"><td><div class="catbox
		<cfswitch expression="#type#">
			<cfcase value="Issue">issue">Issue</cfcase>		
			<cfcase value="Message">message">Message</cfcase>
			<cfcase value="Milestone">milestone">Milestone</cfcase>
			<cfcase value="To-Do List">todolist">Task List</cfcase>
			<cfcase value="File">file">File</cfcase>
			<cfcase value="Project">project">Project</cfcase>			
			<cfdefaultcase>>#type#</cfdefaultcase>
		</cfswitch>	
	</div></td>
	<td>#DateFormat(stamp,"d mmm")#</td>
	<td><cfswitch expression="#type#">
			<cfcase value="Issue"><a href="issues.cfm?p=#url.p#&i=#id#">#name#</a></cfcase>		
			<cfcase value="Message"><a href="messages.cfm?p=#url.p#&mid=#id#">#name#</a></cfcase>
			<cfcase value="Milestone"><a href="milestones.cfm?p=#url.p#&m=#id#">#name#</a></cfcase>
			<cfcase value="Task List"><a href="todos.cfm?p=#url.p#&t=#id#">#name#</a></cfcase>
			<cfcase value="File"><a href="files.cfm?p=#url.p#&f=#id#">#name#</a></cfcase>
			<cfcase value="Project"><a href="project.cfm?p=#url.p#">#name#</a></cfcase>
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

	<!--- right column --->
	<div class="right">
		<div class="header"><h3>People on this project</h3></div>
		<div class="content">
			<ul class="people">
				<cfloop query="projectUsers">
				<li><div class="b">#firstName# #lastName#</div><div style="font-weight:normal;font-size:.9em;color:##666;"><cfif compare(userID,session.user.userID)><cfif isDate(lastLogin)>Last login 
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
	<img src="./images/alert.png" height="16" width="16" alt="Alert!" style="vertical-align:middle;" /> Project Not Found.
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">