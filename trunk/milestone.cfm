<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>

<cfif StructKeyExists(url,"c")> <!--- mark completed --->
	<cfset application.milestone.markCompleted(url.m,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.m,url.ms,'marked completed')>
<cfelseif StructKeyExists(url,"a")> <!--- mark active --->
	<cfset application.milestone.markActive(url.m,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.m,url.ms,'reactivated')>
<cfelseif StructKeyExists(url,"d")> <!--- delete --->
	<cfset application.milestone.remove(url.d,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.d,url.ms,'deleted')>
</cfif>

<cfset milestone = application.milestone.get(url.p,url.m)>
<cfset messages = application.message.get(url.p,'','',url.m)>
<cfset todolists = application.todolist.get(url.p,'','',url.m)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Milestone Detail" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<cfif compare(project.role,'Read-Only')>
					<span class="rightmenu">
						<a href="editMilestone.cfm?p=#url.p#&m=#url.m#" class="edit">Edit Milestone</a>
					</span>
					</cfif>
					
					<h2 class="milestone">Milestone Detail</h2>
				</div>
				<div class="content">
					<div class="wrapper">

						<cfset daysago = DateDiff("d",milestone.dueDate,CreateDate(year(Now()),month(Now()),day(Now())))>
						<div class="milestones <cfif isDate(milestone.completed)>completed<cfelseif daysago gte 1>late<cfelse>upcoming</cfif>">
						<div class="header <cfif isDate(milestone.completed)>completed">Completed<cfelseif daysago gte 1>late">Late<cfelse>upcoming">Upcoming</cfif></div>
						<cfloop query="milestone">
						
							<div class="milestone">
							<div class="date <cfif isDate(milestone.completed)>completed<cfelseif daysago gte 1>late<cfelse>upcoming</cfif>"><span class="b"><cfif daysago eq 0>Today<cfelseif daysago eq 1>Yesterday<cfelseif daysAgo gt 1>#daysago# days ago<cfelseif daysAgo eq -1>Tomorrow<cfelse>#Abs(daysago)# days away</cfif></span> (#DateFormat(dueDate,"dddd, d mmmm, yyyy")#)<cfif userid neq 0><span style="color:##666;"> - For #firstName# #lastName#</span></cfif></div>
							<div id="m#milestoneid#" style="display:none;" class="markcomplete">Moving to <cfif not isDate(milestone.completed)>Completed<cfelseif DateDiff("d",dueDate,Now())>Late<cfelse>Upcoming</cfif> - just a second...</div>
							<cfif not compare(project.role,'Read-Only')>
								<h3>#name#</h3>
							<cfelse>
								<h3><input type="checkbox" name="milestoneid" value="#milestoneid#" onclick="$('##m#milestoneid#').show();window.location='#cgi.script_name#?p=#url.p#&<cfif isDate(milestone.completed)>a<cfelse>c</cfif>=1&m=#milestoneid#&ms=#URLEncodedFormat(name)#';" style="vertical-align:middle;"<cfif isDate(milestone.completed)> checked="checked"</cfif> /> #name#</h3>
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
						
							</div>	
						</cfloop>
						</div>					


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