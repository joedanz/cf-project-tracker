<cfsetting enablecfoutputonly="true">

<cfif session.user.admin>
	<cfset projects = application.project.get()>
<cfelse>
	<cfset projects = application.project.get(session.user.userid)>
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
<cfset visible_project_list = "">
<cfloop query="projects">
	<cfif mstones gt 0>
		<cfset visible_project_list = listAppend(visible_project_list,projectID)>
	</cfif>
</cfloop>
<cfset milestones_overdue = application.milestone.get('','','overdue','',visible_project_list,session.assignedTo)>
<cfset milestones_upcoming = application.milestone.get('','','upcoming','',visible_project_list,session.assignedTo)>
<cfset projectUsers = application.project.projectUsers(projectIDlist=visible_project_list)>
<cfif compare(session.assignedTo,'')>
	<cfset user = application.user.get(session.assignedTo)>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Milestones">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="milestone"><cfif compare(session.assignedTo,'')>#user.firstName# #user.lastName#'s<cfelse>Everyone's</cfif> milestones across all projects</h2>
				</div>
				<div class="content">
				 	<div class="wrapper">
					 	<cfif milestones_overdue.recordCount or milestones_upcoming.recordCount>
						 	
							<cfif milestones_overdue.recordCount>
							<div class="mb5 b" style="color:##f00;border-bottom:1px solid ##f00;">Late Milestones</div>
							<ul class="nobullet mb20">
								<cfloop query="milestones_overdue">
									<cfset daysago = DateDiff("d",dueDate,Now())>
								<li><span class="b" style="color:##f00;"><cfif daysago eq 0>Today<cfelseif daysago eq 1>Yesterday<cfelse>#daysago# day ago</cfif>:</span> 
									<a href="milestone.cfm?p=#projectID#&m=#milestoneID#">#name#</a>
									<span class="sm">(<a href="project.cfm?p=#projectID#" class="b">#projName#</a><cfif compare(lastName,'')> | #firstName# #lastName# is responsible</cfif>)</span>
								</li>
								</cfloop>
							</ul>
							</cfif>
							
							<cfif milestones_upcoming.recordCount>
							<div class="mb5 b" style="border-bottom:1px solid ##000;">Upcoming Milestones</div>
							<ul class="nobullet mb20">
								<cfloop query="milestones_upcoming">
									<cfset daysago = DateDiff("d",Now(),dueDate)>
								<li><span class="b"><cfif daysago eq 0>Tomorrow<cfelse>#daysago+1# day<cfif daysago neq 1>s</cfif> away</cfif>:</span> 
									<a href="milestones.cfm?p=#projectID#">#name#</a>
									<span class="sm">(<a href="project.cfm?p=#projectID#" class="b">#projName#</a><cfif compare(lastName,'')> | #firstName# #lastName# is responsible</cfif>)</span>
								</li>
								</cfloop>
							</ul>
							</cfif>

							<cfset startDate = CreateDate(year(Now()),month(Now()),1)>
							<cfset endDate = CreateDate(year(dateAdd("m",2,Now())),month(dateAdd("m",2,Now())),daysInMonth(dateAdd("m",2,Now())))>
							<cfset totalDays = daysInMonth(Now()) + daysInMonth(dateAdd("m",1,Now())) + daysInMonth(dateAdd("m",2,Now()))>
							<cfset thisDay = 1>

							<!--- due in next 3 months calendar --->
							<cfquery name="ms_upcoming" dbtype="query">
								select * from milestones_upcoming where dueDate between 
								<cfqueryparam value="#CreateODBCDate(startDate)#" cfsqltype="CF_SQL_DATE" />
								and <cfqueryparam value="#CreateODBCDate(endDate)#" cfsqltype="CF_SQL_DATE" />
							</cfquery>
							
							<cfif ms_upcoming.recordCount>
							<cfset dayOfWeek = 2>
							<table border="0" cellpadding="0" cellspacing="1" width="100%" id="milestone_cal">
								<tr>
									<th>&nbsp;</th>
									<cfloop index="i" from="0" to="6">
										<th>#Left(dayOfWeekAsString(dayOfWeek),3)#</th>
										<cfset dayOfWeek = dayOfWeek + 1>
										<cfif dayOfWeek eq 8>
											<cfset dayOfWeek = 1>
										</cfif>
									</cfloop>
								</tr>
								<cfloop from="0" to="2" index="m">
									<cfset thisMonthDay = 0>
									<cfset thisMonthDays = daysInMonth(dateAdd("m",m,Now()))>
									<cfset dayOfWeekStart = dayOfWeek(createDate(year(dateAdd("m",m,Now())),month(dateAdd("m",m,Now())),'1'))>
									
									<cfif dayOfWeekStart eq 1>
										<cfset realDayOfWeekStart = 7>
									<cfelse>
										<cfset realDayOfWeekStart = dayOfWeekStart - 1>
									</cfif>
									<cfset rows = (thisMonthDays + realDayOfWeekStart - 1) \ 7>
									<cfif (thisMonthDays + realDayOfWeekStart - 1) mod 7>
										<cfset rows = rows + 1>
									</cfif>
									
									<cfloop from="1" to="#rows#" index="w">
									<tr>
										<cfif w eq 1>
											<td rowspan="#rows#" class="mth">#Left(MonthAsString(datePart("m",dateAdd("m",m,Now()))),3)#</td>
										</cfif>
										<cfloop from="2" to="8" index="i">
											<cfif (dayOfWeekStart eq i mod 7 or dayOfWeekStart eq i) and thisMonthDay eq 0>
												<cfset thisMonthDay = 1>
											</cfif>
											<cfif thisMonthDay eq 0 or thisMonthDay gt thisMonthDays>
												<td class="blank">&nbsp;</td>
											<cfelse>
												<cfset thisDay = CreateDate(year(dateAdd("m",m,Now())),month(dateAdd("m",m,Now())),thisMonthDay)>
												<cfquery name="todays_ms" dbtype="query">
													select milestoneid,name,projectid,projName from milestones_upcoming where dueDate = 
													<cfqueryparam value="#CreateODBCDate(thisDay)#" cfsqltype="CF_SQL_DATE" />
												</cfquery>
												<cfif thisDay eq createDate(year(Now()),month(Now()),day(Now()))>
													<td class="today"><span class="b">TODAY</span>
												<cfelse>
													<cfif todays_ms.recordCount><td class="active"><span class="b">#thisMonthDay#</span><cfelse><td>#thisMonthDay#</cfif>
												</cfif>
												
												<ul class="cal_ms">
													<cfif todays_ms.recordCount>
														<cfloop query="todays_ms">
															<li><a href="milestone.cfm?p=#projectID#&m=#milestoneID#">#name#</a> (<a href="project.cfm?p=#projectID#">#projName#</a>)</li>
														</cfloop>
													</cfif>
												</ul>
												
												</td>
												<cfset thisMonthDay = thisMonthDay + 1>
											</cfif>
										</cfloop>
									</tr>
									</cfloop>

								</cfloop>
								
							</table>
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

		<form action="#cgi.script_name#" method="post">
		<div class="b">Show milestones assigned to:</div>
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