<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<!---
	Filename: 		reports.cfm
	Designers:		Emilie McGregor
	Created: 		2/2/2009 11:27:35 AM
	Description:	Page for creating reports
--->

<cfif StructKeyExists(form,"project")>
	<cfset url.p = form.p>
</cfif>

<cfparam name="form.c" default="">
<cfparam name="form.u" default="">
<cfparam name="url.p" default="">
<cfparam name="url.f" default="">
<cfparam name="url.report" default="">
<cfparam name="form.startDate" default="">
<cfparam name="form.endDate" default="">
<cfparam name="form.invoiceType" default="full">

<cfset projects = application.project.get(projectID=url.p,clientID=form.c,userID=form.u)>
<cfif compare(url.p,'')>
	<cfset project = projects>
	<cfset url.report = "">
</cfif>

<cfif not compare(url.report,'user')>
	<cfif compare(url.p,'')>
		<cfset users = application.project.projectUsers(projectID=url.p)>	
	<cfelse>
		<cfset users = application.user.get(activeOnly='true')>		
	</cfif>
</cfif>

<cfif not compare(url.report,'client')>
	<cfset clients = application.client.get() />
</cfif>

<cfif compare(form.startDate,'') AND NOT compare(form.endDate,'')>
	<cfset form.endDate = #DateFormat(DateConvert("local2Utc",Now()), "mm/dd/yyyy")#>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Reports" project="#IIf(isDefined("project.name"),'project.name','')#" projectid="#url.p#" svnurl="#IIf(isDefined("project.svnurl"),'project.svnurl','')#">

<cfsavecontent variable="js">
<cfoutput>
<script type='text/javascript'>
	$(document).ready(function(){
	  	$('.date-pick').datepicker();
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

			<div class="header headernomb">
				<form action="#cgi.script_name#?#cgi.query_string#" method="post">		
					<h2>Report 
						<cfif compare(url.p,'')>on the &quot;#projects.name#&quot; project
							<cfif compare(url.p,'') and session.user.admin or session.user.report or 1>
							<span class="sma norm"> or <a href="#cgi.script_name#?report=all">across all projects</a></span>
							</cfif>
						<cfelse>
							across all projects <span class="norm sma">or on
								<select name="p">
									<cfloop query="projects">
										<option value="#projectid#">#name#</option>
									</cfloop>
								</select>
								<input type="submit" name="project" value="Go" />
							</span>
						</cfif>
					</h2>
				</form>
					
				<span class="norm sm">
					<cfswitch expression="#url.report#">
						<cfdefaultcase>
							<span class="b">Complete</span> 
							/ <a href="#cgi.script_name#?p=#url.p#&report=user">by User</a>
							<cfif not compare(url.p,'') and (session.user.admin or session.user.report)> 
								/ <a href="#cgi.script_name#?p=#url.p#&report=client">by Client</a>
							</cfif>
						</cfdefaultcase>
						<cfcase value="user">
							<a href="#cgi.script_name#?p=#url.p#">Complete</a>
							/ <span class="b">by User</span>
							<cfif not compare(url.p,'') and (session.user.admin or session.user.report)> 
								/ <a href="#cgi.script_name#?p=#url.p#&report=client">by Client</a>
							</cfif>
						</cfcase>
						<cfcase value="client">
							<a href="#cgi.script_name#?p=#url.p#">Complete</a>
							/ <a href="#cgi.script_name#?p=#url.p#&report=user">by User</a>
							/ <span class="b">by Client</span>
						</cfcase>
					</cfswitch>
				</span>
				<br/><br/>
				
				<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="frm">				
					<cfif not compare(url.p,'') and report IS "client">
						<cfquery name="clientsWithProjects" dbtype="query">
							SELECT * FROM clients WHERE numProjects > 0
						</cfquery>
						
						<p>
						<label for="c" >Client:</label>
						<select name="c" id="c">
							<cfloop query="clientsWithProjects">
								  <option value="#clientID#"<cfif form.c EQ clientID > selected="selected"</cfif>>#name# (#numProjects# project<cfif numProjects GT 0>s</cfif>)</option>
							</cfloop> 
						</select>
						</p>
					</cfif>
					<cfif report IS "user">
							
						<p>
						<label for="u" >Programmer:</label>
						<select name="u" id="u">
							<cfloop query="users">
								  <option value="#userID#"<cfif form.u EQ userID > selected="selected"</cfif>>#firstName# #lastName#</option>
							</cfloop> 
						</select>
						</p>
					</cfif>
					<p>
					<label for="startDate">Start Date:</label>
					<input type="text" name="startDate" id="startDate" value="#form.startDate#" class="shortest date-pick" />
					</p>
					<p>
					<label for="endDate">End Date:</label>
					<input type="text" name="endDate" id="endDate" value="#form.endDate#" class="shortest date-pick" />
					</p>
					<label for="submit">&nbsp;</label>
					<input type="submit" value="Generate Report" class="button" class="shortest" />		
					<input type="hidden" name="generate" value="generate" id="generate" />		
				</form>
			</div>
				
			<cfif StructKeyExists(form,'generate')>

				<div class="content">
					<div class="wrapper">
						<div class="searchresult odd" style="background-color:##fff;">
							
							<table style="width:100%;">
								<tr>
									<td style="text-align:left; vertical-align:top;">
										<cfif compare(application.settings.invoice_logo,'')>
											<img src="#application.settings.userFilesMapping#/company/#application.settings.invoice_logo#" alt="#application.settings.company_name# Company Logo" />
										<cfelse>
											<h1>#application.settings.company_name#</h1>
										</cfif>
										<br/><br/>
									</td>
									<td style="text-align:right; vertical-align:top;">
										<h2>Report</h2>
										<cfif compare(form.startDate,'') AND compare(form.endDate,'') >
										<h4>Services Rendered</h4>
										<h4>#startDate# - #endDate#</h4>
										</cfif>
										<br /><form name="generatePDF" action="reportPDF.cfm" target="_blank" method="post"  style="float:right;" >
											<button type="submit" name="makePDF" class="button">Generate PDF Version <img src="images/filetypes/icon_pdf.gif" alt="Generate PDF" class="vam" /></button>
											<input type="hidden" name="u"  id="u" value="#form.u#" />
											<input type="hidden" name="invoice" value="invoice" id="invoice" />
											<input type="hidden" name="startDate"  id="startDate" value="#form.startDate#" />
											<input type="hidden" name="endDate"  id="endDate" value="#form.endDate#" />
											<input type="hidden" name="invoiceType"  id="invoiceType" value="#form.invoiceType#" />
										 	<input type="hidden" name="p"  id="p" value="#url.p#" />
										 	<input type="hidden" name="u"  id="u" value="#form.u#" />
										 	<input type="hidden" name="report"  id="report" value="#report#" />
										 	<input type="hidden" name="c"  id="c" value="#form.c#" />
										</form>
									</td>
								</tr>
								<tr>
									<td style="text-align:left; vertical-align:top;">
										<h4>#application.settings.company_name#</h4><br/>
									</td>
									<td style="text-align:right; vertical-align:top;">
										Date: #DateFormat(Now(), "mmmm dd, yyyy")#
									</td>
								</tr>										
								
								<cfset timelines = application.timetrack.get(projectID=url.p,userID=form.u,clientID=form.c,startDate=form.startDate,endDate=form.endDate) />

								<cfif session.user.admin or session.user.report>
								<cfquery name="byClient" dbtype="query">
									SELECT		SUM(CAST(hours as DECIMAL)) as totalHours, client
									FROM 		timelines
									GROUP BY	client
								</cfquery>

								<tr>
									<td colspan="2">
										<h3>Breakdown of Hours by Client</h3>
									</td>
								</tr>
								<tr>
									<td>
									<cfchart format="png" showBorder = "no" chartheight=400 chartwidth=400 xaxisTitle="" yaxisTitle="Total"
										dataBackgroundColor="FFFFFF" backgroundColor="FFFFFF" foregroundColor="000000">
										<cfchartseries type="pie" paintStyle="light" colorlist="##660099, ##9999FF">
											<cfloop index="i" from="1" to="#byClient.recordcount#" >
												<cfif byClient.client[i] IS "">
													<cfset label = "Miscellaneous" />
												<cfelse>
													<cfset label = byClient.client[i] />
												</cfif>
												<cfchartdata item="#label#" value="#byClient.totalHours[i]#">
											</cfloop>
										</cfchartseries>
									</cfchart>
									</td>
									<td>
										<table class="clean full" id="time" style="border-top:2px solid ##000;">
									 	<thead>
											<tr>
												<th>Client</th>
												<th>Hours</th>
											</tr>
										</thead>
										<tbody>
											<cfloop query="byClient">
											<tr>
												<td><cfif compare(client,'')>#client#<cfelse>Miscellaneous</cfif></td>
												<td>#totalHours#</td>
											</tr>
											</cfloop>
										</tbody>
										</table>
									</td>
								</tr>
								</cfif>
					
								<cfif session.user.admin or session.user.report and not compare(url.p,'')>
								<cfquery name="byProject" dbtype="query">
									SELECT		SUM(CAST(hours as DECIMAL)) as totalHours, name
									FROM 		timelines
									GROUP BY	name
								</cfquery>
						
								<tr>
									<td colspan="2">
										<h3>Breakdown of Hours by Project</h3>
									</td>
								</tr>
								<tr>
									<td>
									<cfchart format="png" showBorder = "no" chartheight=400 chartwidth=400
										dataBackgroundColor="FFFFFF" backgroundColor="FFFFFF"
										foregroundColor="000000" xaxisTitle="" yaxisTitle="Total">
										<cfchartseries type="pie" paintStyle="light" colorlist="##660099, ##9999FF">
											<cfloop index="i" from="1" to="#byProject.recordcount#" >
												<cfchartdata item="#byProject.name[i]#" value="#byProject.totalHours[i]# ">
											</cfloop>
										</cfchartseries>
									</cfchart>
									</td>
									<td>
										<table class="clean full" id="time" style="border-top:2px solid ##000;">
									 	<thead>
											<tr>
												<th>Project</th>
												<th>Hours</th>
											</tr>
										</thead>
										<tbody>
											<cfloop query="byProject">
											<tr>
												<td>#name#</td>
												<td>#totalHours#</td>
											</tr>
											</cfloop>
										</tbody>
										</table>
									</td>
								</tr>
								</cfif>
											
								<cfquery name="byUser" dbtype="query">
									SELECT		SUM(CAST(hours as DECIMAL)) as totalHours, firstName, lastName
									FROM 		timelines
									GROUP BY	firstName, lastName
								</cfquery>
								<tr>
									<td colspan="2">
										<h3>Breakdown of Hours by User</h3>
									</td>
								</tr>
								<tr>
									
									<cfif byUser.RecordCount>
										<td>
										<cfchart format="png" showBorder="no" chartheight=400	chartwidth=400
											dataBackgroundColor="FFFFFF" backgroundColor="FFFFFF"	
											foregroundColor="000000" xaxisTitle="" yaxisTitle="Total">
											<cfchartseries type="pie" paintStyle="light" colorlist="##660099, ##9999FF">
												<cfloop index="i" from="1" to="#byUser.recordcount#" >
													<cfchartdata item="#byUser.firstName[i]# #byUser.lastName[i]#" value="#byUser.totalHours[i]# ">
												</cfloop>
											</cfchartseries>
										</cfchart>
										</td>
										<td>
											<table class="clean full" id="time" style="border-top:2px solid ##000;">
											 	<thead>
													<tr>
														<th>Programmer</th>
														<th>Hours</th>
													</tr>
												</thead>
												<tbody>
													<cfloop query="byUser">
													<tr>
														<td>#firstName# #lastName#</td>
														<td>#totalHours#</td>
													</tr>
													</cfloop>
												</tbody>
											</table>	
										</td>
									<cfelse>
										<td colspan="2">
										<br/>
										<div class="alert">No time tracking records found for that <cfif StructKeyExists(form,"startDay")>period<cfelse>item</cfif>.</div>
										<br/>
										</td>
									</cfif>
								</tr>
									
								<cfquery name="byCategory" dbtype="query">
									SELECT		category, SUM(CAST(hours as DECIMAL)) as totalHours
									FROM 		timelines
									GROUP BY	category
								</cfquery>
								<tr>
									<td colspan="2">
										<h3>Breakdown of Hours by Category of Work</h3>
									</td>
								</tr>
								<tr>
									<td>
									 <cfchart format="png" dataBackgroundColor="FFFFFF" backgroundColor="FFFFFF"	
										foregroundColor="000000" showBorder="no" chartheight=400 chartwidth=400
										xaxisTitle="" yaxisTitle="Total">
										<cfchartseries type="pie" paintStyle="light" colorlist="##660099, ##9999FF">
											<cfloop index="i" from="1" to="#byCategory.recordcount#" >
												<cfif byCategory.category[i] IS "">
													<cfset label = "Miscellaneous" />
												<cfelse>
													<cfset label = byCategory.category[i] />
												</cfif>
												<cfchartdata item="#label#" value="#byCategory.totalHours[i]# ">
											</cfloop>
										</cfchartseries>
									</cfchart>
									</td>
									<td>
										<table class="clean full" id="time" style="border-top:2px solid ##000;">
										 	<thead>
												<tr>
													<th>Category</th>
													<th>Hours</th>
												</tr>
											</thead>
											<tbody>
												<cfloop query="byCategory">
												<tr>
													<td><cfif compare(category,'')>#category#<cfelse>Miscellaneous</cfif></td>
													<td>#totalHours#</td>
												</tr>
												</cfloop>
											</tbody>
										</table>
									</td>
								</tr>
							</table>
								
						</div>
									
					</div>
				</div>

			</cfif>
			
		</div> <!--- end ##main --->
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="#application.settings.mapping#/footer.cfm">
		</div>	  
	</div> <!--- end ##left --->

	<!--- right column --->
	<div class="right">

	</div>
		
</div> <!--- end ##container --->
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">