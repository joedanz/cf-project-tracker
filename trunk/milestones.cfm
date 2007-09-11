<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>

<cfif isDefined("url.c")> <!--- mark completed --->
	<cfset application.milestone.markCompleted(url.c,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.c,url.ms,'marked completed')>
<cfelseif isDefined("url.a")> <!--- mark active --->
	<cfset application.milestone.markActive(url.a,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.a,url.ms,'reactivated')>
<cfelseif isDefined("url.d")> <!--- delete --->
	<cfset application.milestone.remove(url.d,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.d,url.ms,'deleted')>
</cfif>

<cfset milestones1 = application.milestone.get(url.p,'','overdue')>
<cfset milestones2 = application.milestone.get(url.p,'','upcoming')>
<cfset milestones3 = application.milestone.get(url.p,'','completed')>
<cfset messages = application.message.get(url.p)>
<cfset todolists = application.todolist.get(url.p)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Milestones" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<span class="rightmenu">
						<a href="editMilestone.cfm?p=#url.p#" class="add">Add New Milestone</a>
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
						<cfset daysago1 = DateDiff("d",dueDate,Now())>
							<div class="milestone">
							<div class="date late"><span class="b">#daysago1# day<cfif daysago1 neq 1>s</cfif> ago</span> (#DateFormat(dueDate,"dddd, d mmmm, yyyy")#)<cfif userid neq 0><span style="color:##666;"> - For #firstName# #lastName#</span></cfif></div>
							<div id="m#milestoneid#" style="display:none;" class="markcomplete">Moving to Completed - just a second...</div>
							<h3><input type="checkbox" name="milestoneid" value="#milestoneid#" onclick="$('##m#milestoneid#').show();window.location='#cgi.script_name#?p=#url.p#&c=#milestoneid#&ms=#URLEncodedFormat(name)#';" style="vertical-align:middle;" /> #name# <span style="font-size:.65em;font-weight:normal;">[<a href="editMilestone.cfm?p=#url.p#&m=#milestoneid#">edit</a>]</span></h3>
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
							<li class="sub"><a href="tasks.cfm?p=#url.p#&tlid=#todolistid#">#title#</a> - Added #DateFormat(added,"d mmm, yyyy")# for #firstName# #lastName#</li>
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
						<cfset daysago1 = DateDiff("d",Now(),dueDate)>
							<div class="milestone">
							<div class="date upcoming"><span class=" b">#DateFormat(dueDate,"dddd, d mmmm, yyyy")#</span> - #daysago1# day<cfif daysago1 neq 1>s</cfif> away<cfif userid neq 0><span style="color:##666;"> - For #firstName# #lastName#</span></cfif></div>
							<div id="m#milestoneid#" style="display:none;" class="markcomplete">Moving to Completed - just a second...</div>
							<h3><input type="checkbox" name="milestoneid" value="#milestoneid#" onclick="$('##m#milestoneid#').show();window.location='#cgi.script_name#?p=#url.p#&c=#milestoneid#&ms=#URLEncodedFormat(name)#';" style="vertical-align:middle;" /> #name# <span style="font-size:.65em;font-weight:normal;">[<a href="editMilestone.cfm?p=#url.p#&m=#milestoneid#">edit</a>]</span></h3>
							<!---<cfif compare(description,'')><div class="desc">#description#</div></cfif>--->
							
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
							<li class="sub"><a href="tasks.cfm?p=#url.p#&tlid=#tasklistid#">#title#</a> - Added #DateFormat(added,"d mmm, yyyy")# for #firstName# #lastName#</li>
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
							<div class="date late"><span class="completed b">#DateFormat(dueDate,"dddd, mmmm d, yyyy")#</span><cfif userid neq 0><span style="color:##666;"> - For #firstName# #lastName#</span></cfif></div>
							<div id="m#milestoneid#" style="display:none;" class="markcomplete">Moving to <cfif DateDiff("d",dueDate,Now())>Late<cfelse>Upcoming</cfif> - just a second...</div>
							<h3><input type="checkbox" name="milestoneid" value="#milestoneid#" onclick="$('##m#milestoneid#').show();window.location='#cgi.script_name#?p=#url.p#&a=#milestoneid#&ms=#URLEncodedFormat(name)#';" style="vertical-align:middle;" checked="checked" /> #name# <span style="font-size:.65em;font-weight:normal;">[<a href="editMilestone.cfm?p=#url.p#&m=#milestoneid#">edit</a>]</span></h3>
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
							<h5 class="sub">Task Lists:</h5>
							<ul class="sub">
							<cfloop query="tl">
							<li class="sub"><a href="tasks.cfm?p=#url.p#&tlid=#todolistid#">#title#</a> - Added #DateFormat(added,"d mmm, yyyy")# for #firstName# #lastName#</li>
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

	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">