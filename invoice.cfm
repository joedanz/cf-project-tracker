<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<!---
	Filename: 		invoice.cfm
	Designers:		Emilie McGregor
	Created: 		1/15/2009 17:00:07 PM
	Description:	Page for creating project invoices
--->

<cfif StructKeyExists(form,"project")>
	<cfset url.p = form.p>
</cfif>

<cfparam name="form.c" default="">
<cfparam name="url.p" default="">
<cfparam name="url.f" default="">
<cfparam name="form.Invoice" default="">
<cfparam name="form.startDate" default="">
<cfparam name="form.endDate" default="">
<cfparam name="form.invoiceType" default="full">

<cfif not session.user.admin and not session.user.invoice and not (compare(url.p,'') and userRole.bill_invoices)>
	<cfoutput><h2>No Permissions for Invoicing!</h2></cfoutput><cfabort>
</cfif>

<cfif compare(url.p,'')>
	<cfset projects = application.project.get(projectID=url.p)>
	<cfset project = projects>
	<cfset invoiceClient = application.client.get(clientID=projects.clientID)>
<cfelse>
	<cfset clients = application.client.get()>
	<cfset projects = application.project.get()>
	<cfif compare(form.invoice,'')  >
		<cfset invoiceClient = application.client.get(clientID=form.c)>
		<cfset projects = application.project.get(clientID=form.c)>
	</cfif>
</cfif>

<cfif compare(form.startDate,'')  AND  NOT compare(form.endDate,'') >
	<cfset form.endDate = #DateFormat(Now(), "mm/dd/yyyy")#>
</cfif>

<!--- Loads header/footer --->

<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Search" project="#IIf(isDefined("project.name"),'project.name','')#" projectid="#url.p#" svnurl="#IIf(isDefined("project.svnurl"),'project.svnurl','')#">

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
				
				<form action="#cgi.script_name#?#cgi.query_string#">		
				<h2>Invoice 
					<cfif compare(url.p,'')>
						the &quot;#projects.name#&quot; project<cfif session.user.admin or session.user.invoice><span class="norm sm"> or <a href="#cgi.script_name#">by Client</a></cfif></span>
					<cfelse> 
						by Client
						<span class="norm sma">or on
								<select name="p">
									<cfloop query="projects">
										<option value="#projectid#">#name#</option>
									</cfloop>
								</select>
								<input type="submit" name="project" value="Go" />
						</span>
					</cfif>
				</h2>
				</form><br/>

				<form action="#cgi.script_name#?#cgi.query_string#" method="post" class="frm">					
					<cfif NOT compare(url.p,'')>
						<cfquery name="clientsWithProjects" dbtype="query">
							SELECT * FROM clients WHERE numProjects > 0
						</cfquery>
						
						<p>
						<label for="c" >Client:</label>
						<select name="c" id="c">
							<cfloop query="clientsWithProjects">
								  <option value="#clientID#"  <cfif form.c EQ clientID >selected="true"</cfif> >#name# (#numProjects# project<cfif numProjects GT 0>s</cfif>)</option>
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
					<p>
					<label for="full">Full Invoice</label>
					<input type="radio" name="invoiceType" id="full" value="full" <cfif form.invoiceType EQ "full">checked="true"</cfif> class="shortest"  />
					</p>
					<p>
					<label for="date">Invoice By Date</label> 
					<input type="radio" name="invoiceType" id="date" value="date" <cfif form.invoiceType EQ "date">checked="true"</cfif> class="shortest" />
					</p>
					<p>
					<label for="category">Invoice By Category</label> 
					<input type="radio" name="invoiceType" id="category" value="category" <cfif form.invoiceType EQ "category">checked="true"</cfif> class="shortest" />
					</p>
					
					<label for="submit">&nbsp;</label>
					<input type="submit" value="Generate Invoice" class="button" class="shortest" />
					
					<input type="hidden" name="u" value="" id="u" />
					<input type="hidden" name="invoice" value="invoice" id="invoice" />
					
				</form>
			</div>
			
			<cfif compare(form.invoice,'')>
				
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
									<h2>Invoice</h2>
									<cfif compare(form.startDate,'') AND compare(form.endDate,'') >
									<h4>Services Rendered</h4>
									<h4>#startDate# - #endDate#</h4>
									</cfif>
									<br/><form name="generatePDF" action="invoicePDF.cfm" target="_blank" method="post"  style="float:right;" >
										<button type="submit" name="makePDF" class="button">Generate PDF Version <img src="images/filetypes/icon_pdf.gif" alt="Generate PDF" class="vam" /></button>
										<input type="hidden" name="u"  id="u" value="#form.u#" />
										<input type="hidden" name="invoice" value="invoice" id="invoice" />
										<input type="hidden" name="startDate"  id="startDate" value="#form.startDate#" />
										<input type="hidden" name="endDate"  id="endDate" value="#form.endDate#" />
										<input type="hidden" name="invoiceType"  id="invoiceType" value="#form.invoiceType#" />
									 	<input type="hidden" name="p"  id="p" value="#url.p#" />
									 	<input type="hidden" name="c"  id="c" value="#form.c#" />
									</form>	
								</td>
							</tr>
							<tr>
								<td style="text-align:left; vertical-align:top;">
									<h4>#application.settings.company_name#</h4>
									<br/>
								</td>
								<td style="text-align:right; vertical-align:top;">
									Date: #DateFormat(Now(), "mmmm dd, yyyy")#
								</td>
							</tr>
							<tr>
								<td>
									<table>
										<tr>
											<td class="b" style="width:30px;">TO:</td>
											<td>#invoiceClient.name#</td>
										</tr>
										<tr>
											<td></td>
											<td>#invoiceClient.address#</td>
										</tr>
										<cfif invoiceClient.postal IS NOT "">
										<tr>
											<td></td>
											<td>#invoiceClient.city#, #invoiceClient.locality# #invoiceClient.country# #invoiceClient.postal#</td>
										</tr>
										</cfif>
										<tr>
											<td></td>
											<td>#invoiceClient.phone#</td>
										</tr>
									</table>
									<br/>
								</td>
								<td></td>
							</tr>
							<tr>
								<td colspan="2">
									
									<h4>Summary</h4>
									<br/>
									<table class="clean full" id="time" style="border-top:2px solid ##000;">
								  		<thead>
											<tr>
												<th class="first">Project</th>
												<th style="width:20%;" class="tar">Hours</th>
												<th style="width:20%;" class="tar">Total</th>
											</tr>
										</thead>
										<tbody>	
										<cfset allProjHours = 0>
										<cfset allProjAmount = 0>
										<cfloop query="projects">
											<cfset timelines = application.timetrack.get(projectid=projectID,clientID=form.c,userID=form.u,startDate=form.startDate,endDate=form.endDate) />
											<cfquery name="hours" dbtype="query">
												SELECT 	SUM(CAST(hours as DECIMAL)) as totalHours
												FROM 	timelines
											</cfquery>
											<cfset totalAmount = 0>
											<cfloop query="timelines">
												<cfif compare(category,'')><cfset totalAmount = totalAmount + (rate * hours)></cfif>
											</cfloop>											
											<tr>
												<td class="first">#name#</td>
												<td class="tar"><cfif compare(hours.totalHours,'')>#hours.totalHours#<cfelse>0.0</cfif></td>
												<td class="tar">#DollarFormat(totalAmount)#</td>
											</tr>
											<cfset allProjHours = allProjHours + hours.totalHours>
											<cfset allProjAmount = allProjAmount + totalAmount>
										</cfloop>
										</tbody>
										<tfoot>
											<tr class="last">
												<td class="tar b">TOTALS:</td>
												<td class="b tar"><span id="totalhours">#NumberFormat(allProjHours,"0.00")#</span></td>
												<td class="b tar"><span id="totalamount">#DollarFormat(allProjAmount)#</span></td>
											</tr>
										</tfoot>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<cfloop query="projects">
										<cfinclude template="invoice_detail.cfm">	
									</cfloop>							
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