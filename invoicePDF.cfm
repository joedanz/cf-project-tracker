<!---
	Filename: 		invoicePDF.cfm
	Designers:		Emilie McGregor
	Created: 		1/29/2009 10:30:41 AM
	Description:	File for generating pdfs.
--->





<cfsetting enablecfoutputonly="true">

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
			<img src="#application.settings.userFilesMapping#/company/#application.settings.invoice_logo#" alt="#application.settings.company_name# Company Logo" />
			<br/><br/>
		</td>
		<td style="text-align:right; vertical-align:top;">
			<h2>Invoice</h2>
			<cfif compare(form.startDate,'') AND compare(form.endDate,'') >
			<h4>Services Redered</h4>
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
			
			<cfset timelines = application.timetrack.get(clientID=form.c,userID=form.u,startDate=form.startDate,endDate=form.endDate) />
			
			<cfquery name="projectSummary" dbtype="query">
				SELECT 	SUM(hours) as totalHours, name
				FROM 	timelines
				GROUP BY name
			</cfquery>
			<cfquery name="total" dbtype="query">
				SELECT 	SUM(totalHours) as hours
				FROM 	projectSummary
			</cfquery>
			<br/>
			
			<h4>Summary</h4>
			<br/>
			<table class="clean full" id="time" style="border-top:2px solid ##000;">
		  		<thead>
					<tr>
						<th class="first">Project</th>
						<th style="width:25%;">Hours</th>
					</tr>
				</thead>
				<tbody>	
				<cfloop query="projects">
					<cfquery name="theHours" dbtype="query">
						SELECT 	totalHours
						FROM 	projectSummary
						WHERE name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#" />
					</cfquery>
					<tr>
						<td>#name#</td>
						<td>#theHours.totalHours#</td>
					</tr>
				</cfloop>
				</tbody>
				<tfoot>
					<cfset totalHours = #NumberFormat(total.hours,"0.00")# />
					<tr class="last">
						<td class="tar b">TOTAL:&nbsp;&nbsp;&nbsp;</td>
						<td class="b"><span id="totalhours">#totalHours#</span> X $#application.settings.hourly_rate# per hour</td>
					</tr>
					<tr class="last">
						<td class="tar b">$:&nbsp;&nbsp;&nbsp;</td>
						<cftry>
							<cfset money = totalHours * application.settings.hourly_rate>
							<cfcatch><cfset money = 0></cfcatch>
						</cftry>
						<td class="b"><span id="totalhours">#NumberFormat(money,"0.00")#</span></td>
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