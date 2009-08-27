<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<!---
	Filename: 		invoicePDF.cfm
	Designers:		Emilie McGregor
	Created: 		1/29/2009 10:30:41 AM
	Description:	File for generating pdfs.
--->

<cfparam name="form.c" default="">
<cfparam name="form.p" default="">
<cfparam name="url.f" default="">
<cfparam name="form.Invoice" default="">
<cfparam name="form.startDate" default="">
<cfparam name="form.endDate" default="">
<cfparam name="form.invoiceType" default="full">

<cfif compare(form.p,'')>
	<cfset projects = application.project.get(projectID=form.p) />			
	<cfset invoiceClient = application.client.get(clientID=projects.clientID) />
<cfelse>
	<cfset clients = application.client.get() />
	<cfif compare(form.Invoice,'')  >
		<cfset invoiceClient = application.client.get(clientID=form.c) />
		<cfset projects = application.project.get(clientID=form.c) />
	</cfif>
</cfif>

<cfif compare(form.Invoice,'')  AND  NOT compare(form.endDate,'') >
	<cfset form.endDate = #DateFormat(Now(), "mm/dd/yyyy")#>
</cfif>

<cfdocument format="pdf">
	
<cfoutput>
<link rel="stylesheet" href="#application.settings.mapping#/css/all_styles.css" media="all" type="text/css" />
<style type="text/css">
	body{ background:##fff;	}
</style>
	
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
						<th>Project</th>
						<th style="width:20%;">Hours</th>
						<th style="width:20%;">Total</th>
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
							<td>#name#</td>
							<td><cfif compare(hours.totalHours,'')>#hours.totalHours#<cfelse>0.0</cfif></td>
							<td>#DollarFormat(totalAmount)#</td>
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
</cfoutput>

</cfdocument>

<cfsetting enablecfoutputonly="false">