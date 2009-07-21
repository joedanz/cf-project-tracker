<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>

<cfif not session.user.admin and not project.mstones eq 1>
	<cfoutput><h2>You do not have permission to access milestones!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfif StructKeyExists(url,"c")> <!--- mark completed --->
	<cfset application.milestone.markCompleted(url.c,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.c,url.ms,'marked completed')>
<cfelseif StructKeyExists(url,"a")> <!--- mark active --->
	<cfset application.milestone.markActive(url.a,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.a,url.ms,'reactivated')>
<cfelseif StructKeyExists(url,"d")> <!--- delete --->
	<cfset application.milestone.remove(url.d,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.d,url.ms,'deleted')>
</cfif>

<cfset milestones1 = application.milestone.get(url.p,'','overdue')>
<cfset milestones2 = application.milestone.get(url.p,'','upcoming')>
<cfset milestones3 = application.milestone.get(url.p,'','completed')>
<cfset messages = application.message.get(url.p)>
<cfset todolists = application.todolist.get(url.p)>
<cfset issues = application.issue.get(url.p)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="../mobile/mobile" title="#project.name# &raquo; Milestones" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<span class="rightmenu">
						
					</span>
					
					<h2 class="milestone">All milestones &nbsp;<span style="font-size:.75em;font-weight:normal;color:##666;">Today is #DateFormat(Now(),"d mmm")#</h2>
				</div>
				<div class="content">
					<div class="wrapper">
					<cfif milestones1.recordCount or milestones2.recordCount or milestones3.recordCount>			
					
					<cfif milestones1.recordCount>		
						<div class="milestones late">
						<div class="header late">Late</div>
						<cfloop query="milestones1">
						<cfset daysago = DateDiff("d",dueDate,Now())>
							<div class="milestone">
							<div class="date late"><span class="b"><cfif daysago eq 0>Today<cfelseif daysago eq 1>Yesterday<cfelse>#daysago# days ago</cfif></span> (#DateFormat(dueDate,"dddd, d mmmm, yyyy")#)<cfif userid neq 0><span style="color:##666;"> - Assigned to #firstName# #lastName#</span></cfif></div>
							<div id="m#milestoneid#" style="display:none;" class="markcomplete">Moving to Completed - just a second...</div>
							<cfif project.mstones eq 2>
								<h3><input type="checkbox" name="milestoneid" value="#milestoneid#" onclick="$('##m#milestoneid#').show();window.location='#cgi.script_name#?p=#url.p#&c=#milestoneid#&ms=#URLEncodedFormat(name)#';" style="vertical-align:middle;" /> <a href="milestone.cfm?p=#url.p#&m=#milestoneid#">#name#</a> <span style="font-size:.65em;font-weight:normal;">[<a href="editMilestone.cfm?p=#url.p#&m=#milestoneid#">edit</a>]</span></h3>
							<cfelse>
								<h3>#name#</h3>
							</cfif>
							<cfif compare(description,'')><div class="desc">#description#</div></cfif>
							
							<cfquery name="msgs" dbtype="query">
								select messageid,title,stamp,firstName,lastName,commentcount from messages where milestoneid = '#milestoneid#'
							</cfquery>
							<cfif msgs.recordCount>
							<h5 class="sub">Messages:</h5>
							<ul class="sub">
							<cfloop query="msgs">
							<li class="sub"><a href="message.cfm?p=#url.p#&m=#messageid#">#title#</a> - Posted #DateFormat(stamp,"d mmm, yyyy")# by #firstName# #lastName#<cfif commentcount gt 0> <span class="i">(#commentcount# comments)</span></cfif></li>
							</cfloop>
							</ul>
							</cfif>
							
							<cfquery name="tl" dbtype="query">
								select todolistid,title,added,firstName,lastName,completed_count,uncompleted_count 
								from todolists where milestoneid = '#milestoneid#'
							</cfquery>
							<cfif tl.recordCount>
							<h5 class="sub">To-Do Lists:</h5>
							<ul class="sub">
							<cfloop query="tl">
							<li class="sub"><a href="todos.cfm?p=#url.p#&tlid=#todolistid#">#title#</a> - #completed_count# complete / #uncompleted_count# pending - Added #DateFormat(added,"d mmm, yyyy")# for #firstName# #lastName#</li>
							</cfloop>
							</ul>	
							</cfif>
						
							<cfquery name="iss" dbtype="query">
								select issueID, shortID, issue, status, created, assignedFirstName, assignedLastName
								from issues where milestoneid = '#milestoneid#'
							</cfquery>
							<cfif iss.recordCount>
							<h5 class="sub">Issues:</h5>
							<ul class="sub">
							<cfloop query="iss">
							<li class="sub"><a href="issue.cfm?p=#url.p#&i=#issueid#">#shortid# - #issue#</a> (#status#) - Added #DateFormat(created,"d mmm, yyyy")# for #assignedFirstName# #assignedLastName#</li>
							</cfloop>
							</ul>	
							</cfif>						
						
							</div>	
						</cfloop>
						</div>					
					</cfif>
					
					
		
					<cfif milestones2.recordCount>		
						<div class="milestones upcoming">
						<div class="header upcoming">Upcoming</div>
						<cfloop query="milestones2">
						<cfset daysago = DateDiff("d",CreateDate(year(Now()),month(Now()),day(Now())),dueDate)>
							<div class="milestone">
							<div class="date upcoming"><span class=" b"><cfif daysago eq 0>Today<cfelseif daysago eq 1>Tomorrow<cfelse>#daysago# days away</cfif></span> (#DateFormat(dueDate,"dddd, d mmmm, yyyy")#) <cfif userid neq 0><span style="color:##666;"> - Assigned to #firstName# #lastName#</span></cfif></div>
							<div id="m#milestoneid#" style="display:none;" class="markcomplete">Moving to Completed - just a second...</div>
							<cfif project.mstones eq 1>
								<h3>#name#</h3>
							<cfelse>
							<h3><input type="checkbox" name="milestoneid" value="#milestoneid#" onclick="$('##m#milestoneid#').show();window.location='#cgi.script_name#?p=#url.p#&c=#milestoneid#&ms=#URLEncodedFormat(name)#';" style="vertical-align:middle;" /> <a href="milestone.cfm?p=#url.p#&m=#milestoneid#">#name#</a> <span style="font-size:.65em;font-weight:normal;">[<a href="editMilestone.cfm?p=#url.p#&m=#milestoneid#">edit</a>]</span></h3>
							</cfif>
							<cfif compare(description,'')><div class="desc">#description#</div></cfif>
							
							<cfquery name="msgs" dbtype="query">
								select messageid,title,stamp,firstName,lastName,commentcount from messages where milestoneid = '#milestoneid#'
							</cfquery>
							<cfif msgs.recordCount>
							<h5 class="sub">Messages:</h5>
							<ul class="sub">
							<cfloop query="msgs">
							<li class="sub"><a href="message.cfm?p=#url.p#&m=#messageid#">#title#</a> - Posted #DateFormat(stamp,"d mmm, yyyy")# by #firstName# #lastName#<cfif commentcount gt 0> <span class="i">(#commentcount# comments)</span></cfif></li>
							</cfloop>
							</ul>
							</cfif>
							
							<cfquery name="tl" dbtype="query">
								select todolistid,title,added,firstName,lastName from todolists where milestoneid = '#milestoneid#'
							</cfquery>
							<cfif tl.recordCount>
							<h5 class="sub">To-Do List:</h5>
							<ul class="sub">
							<cfloop query="tl">
							<li class="sub"><a href="todos.cfm?p=#url.p#&tlid=#todolistid#">#title#</a> - Added #DateFormat(added,"d mmm, yyyy")# for #firstName# #lastName#</li>
							</cfloop>
							</ul>	
							</cfif>
						
							<cfquery name="iss" dbtype="query">
								select issueID, shortID, issue, created, assignedFirstName, assignedLastName
								from issues where milestoneid = '#milestoneid#'
							</cfquery>
							<cfif iss.recordCount>
							<h5 class="sub">Issues:</h5>
							<ul class="sub">
							<cfloop query="iss">
							<li class="sub"><a href="issue.cfm?p=#url.p#&i=#issueid#">#shortid# - #issue#</a> - Added #DateFormat(created,"d mmm, yyyy")# for #assignedFirstName# #assignedLastName#</li>
							</cfloop>
							</ul>	
							</cfif>							
						
							</div>	
						</cfloop>
						</div>					
					</cfif>
					
					
					
					<cfif milestones3.recordCount>		
						<div class="milestones completed">
						<div class="header completed">Completed</div>
						<cfloop query="milestones3">
							<div class="milestone">
							<div class="date late"><span class="completed b">#DateFormat(dueDate,"dddd, mmmm d, yyyy")#</span><cfif userid neq 0><span style="color:##666;"> - Assigned to #firstName# #lastName#</span></cfif></div>
							<div id="m#milestoneid#" style="display:none;" class="markcomplete">Moving to <cfif DateDiff("d",dueDate,Now())>Late<cfelse>Upcoming</cfif> - just a second...</div>
							<cfif project.mstones eq 1>
								<h3>#name#</h3>
							<cfelse>
								<h3><input type="checkbox" name="milestoneid" value="#milestoneid#" onclick="$('##m#milestoneid#').show();window.location='#cgi.script_name#?p=#url.p#&a=#milestoneid#&ms=#URLEncodedFormat(name)#';" style="vertical-align:middle;" checked="checked" /> <a href="milestone.cfm?p=#url.p#&m=#milestoneid#">#name#</a> <span style="font-size:.65em;font-weight:normal;">[<a href="editMilestone.cfm?p=#url.p#&m=#milestoneid#">edit</a>]</span></h3>
							</cfif>
							<cfif compare(description,'')><div class="desc">#description#</div></cfif>
							
							<cfquery name="msgs" dbtype="query">
								select messageid,title,stamp,firstName,lastName,commentcount from messages where milestoneid = '#milestoneid#'
							</cfquery>
							<cfif msgs.recordCount>
							<h5 class="sub">Messages:</h5>
							<ul class="sub">
							<cfloop query="msgs">
							<li class="sub"><a href="message.cfm?p=#url.p#&m=#messageid#">#title#</a> - Posted #DateFormat(stamp,"d mmm, yyyy")# by #firstName# #lastName#<cfif commentcount gt 0> <span class="i">(#commentcount# comments)</span></cfif></li>
							</cfloop>
							</ul>
							</cfif>
							
							<cfquery name="tl" dbtype="query">
								select todolistid,title,added,firstName,lastName from todolists where milestoneid = '#milestoneid#'
							</cfquery>
							<cfif tl.recordCount>
							<h5 class="sub">To-Do Lists:</h5>
							<ul class="sub">
							<cfloop query="tl">
							<li class="sub"><a href="todos.cfm?p=#url.p#&tlid=#todolistid#">#title#</a> - Added #DateFormat(added,"d mmm, yyyy")# for #firstName# #lastName#</li>
							</cfloop>
							</ul>	
							</cfif>

							<cfquery name="iss" dbtype="query">
								select issueID, shortID, issue, created, assignedFirstName, assignedLastName
								from issues where milestoneid = '#milestoneid#'
							</cfquery>
							<cfif iss.recordCount>
							<h5 class="sub">Issues:</h5>
							<ul class="sub">
							<cfloop query="iss">
							<li class="sub"><a href="issue.cfm?p=#url.p#&i=#issueid#">#shortid# - #issue#</a> - Added #DateFormat(created,"d mmm, yyyy")# for #assignedFirstName# #assignedLastName#</li>
							</cfloop>
							</ul>	
							</cfif>	

							</div>	
						</cfloop>
						</div>					
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
		<cfif project.mstones gt 1>
		<h3><a href="editMilestone.cfm?p=#url.p#" class="add">Add a new milestone</a></h3><br />
		</cfif>	
	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">