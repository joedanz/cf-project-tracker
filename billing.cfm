<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>

<cfif project.billing eq 0 and not session.user.admin>
	<cfoutput><h2>You do not have permission to access billing!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfset projectUsers = application.project.projectUsers(url.p,'0','firstName, lastName')>
<cfset milestones_completed = application.milestone.get(projectID=url.p,withRate=true,type='completed')>
<cfset milestones_incomplete = application.milestone.get(projectID=url.p,withRate=true,type='incomplete')>
<cfset timelines = application.timetrack.get(projectID=url.p)>
<cfset totalIncMSFee = 0>
<cfset totalComMSFee = 0>
<cfset totalHours = 0>
<cfset totalFee = 0>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Billing" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text="<script type='text/javascript'>
	$(document).ready(function(){
	  	$('.date-pick').datepicker();
	});
</script>">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left full">
		<div class="main">

			<div class="header">
				<h2 class="bill">Billing</h2>
			</div>
			<div class="content">
			 	<div class="wrapper">

					<cfif milestones_incomplete.recordCount>
						<fieldset class="bill mb15">
							<legend>Incomplete Milestones</legend>
	
							<table class="clean full" id="time">
							 	<thead>
									<tr>
										<th class="first">Due Date</th>
										<th>Name</th>
										<th>Person</th>
										<th>Fee</th>
										<th class="tac">Billed</th>
										<th class="tac">Paid</th>
										<th>Description</th>
									</tr>
								</thead>
								<tbody>	
								<cfloop query="milestones_incomplete">
									<cfif isNumeric(rate)>
										<cfset thisUserID = userid>
										<tr id="r#milestoneid#">
											<td class="first">#DateFormat(dueDate,"mmm d, yyyy")#</td>
											<td>#name#</td>
											<td>#firstName# #lastName#</td>
											<td>$#NumberFormat(rate,"0")#</td>
											<td class="tac"><input type="checkbox" id="b_#milestoneid#" value="1"<cfif billed eq 1> checked="checked"</cfif> onclick="set_bill('#milestoneID#','milestone','b_');" /></td>
											<td class="tac"><input type="checkbox" id="p_#milestoneid#" value="1"<cfif paid eq 1> checked="checked"</cfif> onclick="set_bill('#milestoneID#','milestone','p_');" /></td>
											<td>#description#</td>
										</tr>
										<cfif isNumeric(rate)>
											<cfset totalIncMSFee = totalIncMSFee + rate>
										</cfif>
									</cfif>
								</cfloop>
								</tbody>
								<tfoot>
									<tr class="last">
										<td class="tar b" colspan="3">TOTAL FEE:&nbsp;&nbsp;&nbsp;</td>
										<td class="b">$#NumberFormat(totalIncMSFee,"0")#</td>
										<td colspan="5">&nbsp;</td>
									</tr>
								</tfoot>
							</table>
	
						</fieldset>
					</cfif>

					<cfif milestones_completed.recordCount>
						<fieldset class="bill mb15">
							<legend>Completed Milestones</legend>
							
							<table class="clean full" id="time">
							 	<thead>
									<tr>
										<th class="first">Due Date</th>
										<th>Name</th>
										<th>Person</th>
										<th>Fee</th>
										<th class="tac">Billed</th>
										<th class="tac">Paid</th>
										<th>Description</th>
									</tr>
								</thead>
								<tbody>	
								<cfloop query="milestones_completed">
									<cfif isNumeric(rate)>
										<cfset thisUserID = userid>
										<tr id="r#milestoneid#">
											<td class="first">#DateFormat(dueDate,"mmm d, yyyy")#</td>
											<td>#name#</td>
											<td>#firstName# #lastName#</td>
											<td>$#NumberFormat(rate,"0")#</td>
											<td class="tac"><input type="checkbox" id="b_#milestoneid#" value="1"<cfif billed eq 1> checked="checked"</cfif> onclick="set_bill('#milestoneID#','milestone','b_');" /></td>
											<td class="tac"><input type="checkbox" id="p_#milestoneid#" value="1"<cfif paid eq 1> checked="checked"</cfif> onclick="set_bill('#milestoneid#','milestone','b_');" /></td>
											<td>#description#</td>
										</tr>
										<cfif isNumeric(rate)>
											<cfset totalComMSFee = totalComMSFee + rate>
										</cfif>
									</cfif>
								</cfloop>
								</tbody>
								<tfoot>
									<tr class="last">
										<td class="tar b" colspan="3">TOTAL FEE:&nbsp;&nbsp;&nbsp;</td>
										<td class="b">$#NumberFormat(totalComMSFee,"0")#</td>
										<td colspan="5">&nbsp;</td>
									</tr>
								</tfoot>
							</table>
							
						</fieldset>
					</cfif>
					
					<cfif timelines.recordCount>
						<fieldset class="bill">
							<legend>Hourly Billing</legend>
						
						 	<table class="clean full" id="time">
							 	<thead>
									<tr>
										<th class="first">Date</th>
										<th>Person</th>
										<th>Hours</th>
										<th>Billing Category</th>
										<th>Fee</th>
										<th class="tac">Billed</th>
										<th class="tac">Paid</th>
										<th>Description</th>
									</tr>
								</thead>
								<tbody>	
								<cfloop query="timelines">
									<cfif isNumeric(rate)>
										<cfset thisUserID = userid>
										<tr id="r#timetrackid#">
											<td class="first">#DateFormat(dateStamp,"mmm d, yyyy")#</td>
											<td>#firstName# #lastName#</td>
											<td class="b">#numberFormat(hours,"0.00")#</td>
											<td>#category#<cfif compare(category,'')> ($#NumberFormat(rate,"0")#/hr)</cfif></td>
											<td><cfif isNumeric(rate)>$#NumberFormat(rate*hours,"0")#</cfif></td>
											<td class="tac"><input type="checkbox" id="b_#timetrackid#" value="1"<cfif billed eq 1> checked="checked"</cfif> onclick="set_bill('#timetrackid#','timetrack','b_');" /></td>
											<td class="tac"><input type="checkbox" id="p_#timetrackid#" value="1"<cfif paid eq 1> checked="checked"</cfif> onclick="set_bill('#timetrackid#','timetrack','p_');" /></td>
											<td><cfif compare(itemType,'')><span class="catbox #itemtype#">#itemtype#</span> <a href="todos.cfm?p=#projectID###id_#replace(todolistID,'-','','all')#">#task#</a><cfif compare(description,'')> - </cfif></cfif>#description#</td>
										</tr>
										<cfset totalHours = totalHours + hours>
										<cfif isNumeric(rate)>
											<cfset totalFee = totalFee + (rate*hours)>
										</cfif>
									</cfif>
								</cfloop>
								</tbody>
								<tfoot>
									<tr class="last">
										<td colspan="2" class="tar b">TOTAL:&nbsp;&nbsp;&nbsp;</td>
										<td class="b"><span id="totalhours">#NumberFormat(totalHours,"0.00")#</span></td>
										<td class="tar b">TOTAL FEE:&nbsp;&nbsp;&nbsp;</td>
										<td class="b">$#NumberFormat(totalFee,"0")#</td>
										<td colspan="3">&nbsp;</td>
									</tr>
								</tfoot>
							</table>
					 	</fieldset>
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