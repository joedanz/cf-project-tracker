<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfparam name="url.p" default="">
<cfparam name="form.u" default="">

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>

<cfif project.timetrack eq 0 and not session.user.admin>
	<cfoutput><h2>You do not have permission to access time tracking!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfset projectUsers = application.project.projectUsers(url.p,'0','firstName, lastName')>

<cfif compare(form.u,'')>
	<cfset user = application.user.get(form.u)>
</cfif>
<cfif StructKeyExists(form,"startDay")>
	<cfset timelines = application.timetrack.get(projectID=url.p,userID=form.u,startDate=CreateDate(form.startYear,form.startMonth,form.startDay),endDate=CreateDate(form.endYear,form.endMonth,form.endDay))>
<cfelse>
	<cfset timelines = application.timetrack.get(itemID=url.t)>
</cfif>
<cfset totalHours = 0>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Time Tracking" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

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
				<span class="rightmenu">
					<a href="time.cfm?p=#url.p#" class="back">Back to full time report</a>
				</span>
				<h2 class="time">Time Tracking Report</h2>
			</div>
			<div class="content">
			 	<div class="wrapper">
					
					<cfif StructKeyExists(form,"startDay")>
					<h3 class="mb10">
					<cfif compare(form.u,'')>#user.firstName# #user.lastName#<cfelse>Everyone</cfif>'s
					hours from #Left(MonthAsString(form.startMonth),3)# #form.startDay#, #form.startYear# to 
					#Left(MonthAsString(form.endMonth),3)# #form.endDay#, #form.endYear#					
					<span style="font-size:.6em;font-weight:normal;">(<a href="##" onclick="$('##report').slideDown();return false;">Edit This Report</a>)</span>
					</h3>

					<form action="#cgi.script_name#?p=#url.p#" method="post" class="frm">
					<div id="report" class="p10" style="display:none;">
						<span class="b">
						Show <select name="u">
								<option value="">everyone</option>
								<cfloop query="projectUsers">
									<option value="#userid#"<cfif not compare(form.u,userid)> selected="selected"</cfif>>#firstName# #lastName#</option>
								</cfloop>
							</select>'s hours from 
						<select name="startMonth">
							<cfloop from="1" to="12" index="i">
								<option value="#i#"<cfif form.startMonth eq i> selected="selected"</cfif>>#Left(MonthAsString(i),3)#</option>
							</cfloop>						
						</select>
						<select name="startDay">
							<cfloop from="1" to="31" index="i">
								<option value="#i#"<cfif form.startDay eq i> selected="selected"</cfif>>#i#</option>
							</cfloop>						
						</select>
						<select name="startYear">
							<cfloop from="#Year(Now())#" to="#Year(Now())-5#" index="i" step="-1">
								<option value="#i#"<cfif form.startYear eq i> selected="selected"</cfif>>#i#</option>
							</cfloop>						
						</select>
						 to
						<select name="endMonth">
							<cfloop from="1" to="12" index="i">
								<option value="#i#"<cfif form.endMonth eq i> selected="selected"</cfif>>#Left(MonthAsString(i),3)#</option>
							</cfloop>						
						</select>
						<select name="endDay">
							<cfloop from="1" to="31" index="i">
								<option value="#i#"<cfif form.endDay eq i> selected="selected"</cfif>>#i#</option>
							</cfloop>						
						</select>
						<select name="endYear">
							<cfloop from="#Year(Now())#" to="#Year(Now())-5#" index="i" step="-1">
								<option value="#i#"<cfif form.endYear eq i> selected="selected"</cfif>>#i#</option>
							</cfloop>						
						</select>
						</span>
						<input type="submit" value="Create Report" /> or <a href="##" onclick="$('##report').slideUp();return false;">Cancel</a>
					</div>
					</form>
					<cfelse>
						<h3>Time tracking log for #timelines.itemType[1]# item: 
							<cfswitch expression="#timelines.itemType[1]#">
								<cfcase value="to-do">#timelines.task[1]#</cfcase>
							</cfswitch>
						</h3> 
					</cfif>
					
					<cfif timelines.recordCount>
				 	<table class="clean full" id="time" style="border-top:2px solid ##000;">
					 	<thead>
							<tr>
								<th class="first">Date</th>
								<th>Person</th>
								<th>Hours</th>
								<th>Description</th>
								<th></th>
							</tr>
						</thead>
						<tbody>	
						<cfloop query="timelines">
							<cfset thisUserID = userid>
							<tr id="r#replace(timetrackid,'-','','ALL')#">
								<td class="first">#DateFormat(dateStamp,"mmm d, yyyy")#</td>
								<td>#firstName# #lastName#</td>
								<td class="b">#numberFormat(hours,"0.00")#</td>
								<td><cfif compare(itemType,'')><span class="catbox #itemtype#">#itemtype#</span> <a href="todos.cfm?p=#projectID###id_#replace(todolistID,'-','','all')#">#task#</a><cfif compare(description,'')> - </cfif></cfif>#description#</td>
								<td class="tac"><a href="##" onclick="edit_time_row('#projectid#','#timetrackid#','#replace(timetrackid,'-','','ALL')#','#currentRow#')">Edit</a> &nbsp;&nbsp; <a href="##" onclick="delete_time('#projectID#','#timetrackID#','#replace(timetrackid,'-','','ALL')#');" class="delete"></a></td>
							</tr>
							<cfset totalHours = totalHours + hours>
						</cfloop>
						</tbody>
						<tfoot>
							<tr class="last">
								<td colspan="2" class="tar b">TOTAL:&nbsp;&nbsp;&nbsp;</td>
								<td class="b"><span id="totalhours">#NumberFormat(totalHours,"0.00")#</span></td>
								<td colspan="2">&nbsp;</td>
							</tr>
						</tfoot>
					</table>
					<cfelse>
						<div class="alert">No time tracking records found for that <cfif StructKeyExists(form,"startDay")>period<cfelse>item</cfif>.</div>
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