<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<!---
	Filename: 		invoice_project.cfm
	Designers:		Emilie McGregor
	Created: 		1/29/2009 11:19:52 AM
	Description:	Main invoice templated included in both invoice.cfm and invoicePDF.cfm
--->

<cfset timelines = application.timetrack.get(projectID=projectID,userID=form.u,startDate=form.startDate,endDate=form.endDate) />

<cfoutput>
<br/>	
<h4>#name# - Work Breakdown</h4>
<br/>
<cfif timelines.RecordCount>
	<cfset totalHours = 0>
	<cfset totalAmount = 0>
 	<table class="clean full" id="time" style="border-top:2px solid ##000;"> 	
	 	<cfswitch expression="#invoiceType#">		 			
		 	<cfcase value="date">
			 	<cfquery name="timelinesByDate" dbtype="query">
				 	SELECT SUM(CAST(hours as DECIMAL)) as hours, dateStamp
				 	FROM timelines
				 	GROUP BY dateStamp
			 	</cfquery>
			 		<thead>
					<tr>
						<th class="first" style="width:88%;">Date</th>
						<th class="tar">Hours</th>
					</tr>
				</thead>
				<tbody>	
				<cfloop query="timelinesByDate">			
					<tr>
						<td class="first">#LSDateFormat(dateStamp,"mmm d, yyyy")#</td>
						<td class="tar b">#numberFormat(hours,"0.00")#</td>
					</tr>
					<cfset totalHours = totalHours + hours>
				</cfloop>
				</tbody>
				<tfoot>
					<tr class="last">
						<td class="first tar b">TOTAL:</td>
						<td class="tar b"><span id="totalhours">#NumberFormat(totalHours,"0.00")#</span></td>
					</tr>
				</tfoot>
		 	</cfcase>		
			<cfcase value="category">
		 		<cfquery name="timelinesByCategory" dbtype="query">
				 	SELECT SUM(CAST(hours as DECIMAL)) as hours, category
				 	FROM timelines
				 	GROUP BY category
			 	</cfquery>
			 		<thead>
					<tr>
						<th class="first" style="width:88%;">Category</th>
						<th class="tar">Hours</th>
					</tr>
				</thead>
				<tbody>	
				<cfloop query="timelinesByCategory">
					<tr>
						<td class="first">
							<cfif category IS NOT "">#category#
							<cfelse>
							Unfiled
							</cfif>
						</td>
						<td class="tar b">#numberFormat(hours,"0.00")#</td>
					</tr>
					<cfset totalHours = totalHours + hours>
				</cfloop>
				</tbody>
				<tfoot>
					<tr class="last">
						<td class="tar b">TOTAL:</td>
						<td class="tar b"><span id="totalhours">#NumberFormat(totalHours,"0.00")#</span></td>
					</tr>
				</tfoot>
		 	</cfcase>		
			<cfcase value="full">
		 		<thead>
					<tr>
						<th class="first" style="width:15%;">Date</th>
						<th style="width:15%;">Category</th>
						<th style="width:50%;">Description</th>
						<th style="width:10%;" class="tar">Rate</th>
						<th style="width:10%;" class="tar">Hours</th>
					</tr>
				</thead>
				<tbody>	
				<cfloop query="timelines">
					<tr>
						<td class="first">#LSDateFormat(dateStamp,"mmm d, yyyy")#</td>
						<td>
							<cfif compare(category,'')>
								#category#
							<cfelse>
								Unassigned
							</cfif>
						</td>
						<td>
						<cfif compare(itemType,'')><span class="catbox #itemtype#">#itemtype#</span> 
						<cfswitch expression="#itemType#">
							<cfcase value="todo,to-do">
								<a href="todos.cfm?p=#projectID###id_#replace(todolistID,'-','','all')#">#task#</a>		
							</cfcase>		
							<cfcase value="issue">
								<a href="issue.cfm?p=#projectID#&amp;i=#itemID#"> #issue#</a>
							</cfcase>	
						</cfswitch>
						</cfif>#description#</td>
						<td class="tar">#numberFormat(hours,"0.00")#</td>
						<td class="tar"><cfif compare(category,'')>#DollarFormat(rate)#<cfelse>$0.00</cfif></td>
					</tr>
					<cfset totalHours = totalHours + hours>
					<cfif compare(category,'')><cfset totalAmount = totalAmount + (rate * hours)></cfif>
				</cfloop>
				</tbody>
				<tfoot>
					<tr class="last">
						<td colspan="3" class="tar b">TOTALS:</td>
						<td class="b tar"><span id="totalhours">#NumberFormat(totalHours,"0.00")#</span></td>
						<td class="b tar"><span id="totalamount">#DollarFormat(totalAmount)#</span></td>
					</tr>
				</tfoot>
		 	</cfcase>	 	
		 </cfswitch>	 		 	
	</table>
<cfelse>
	<div class="alert">No detail records found for that <cfif StructKeyExists(form,"startDay")>period<cfelse>project</cfif>.</div><br/>
</cfif>
</cfoutput>						

<cfsetting enablecfoutputonly="false">						