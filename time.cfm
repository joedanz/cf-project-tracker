<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfparam name="url.p" default="">

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
<cfset timelines = application.timetrack.get(projectID=url.p)>
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
					<a href="#cgi.script_name#?report" class="report">Create Report</a>
				</span>
				<h2 class="time">Time Tracking</h2>
			</div>
			<div class="content">
			 	<div class="wrapper">

				 	<table class="clean full" id="time">
					 	<thead>
							<tr>
								<th class="first">Date</th>
								<th>Person</th>
								<th>Hours</th>
								<th>Description</th>
								<th></th>
							</tr>
							<tr class="input">
								<td class="first"><input type="text" name="datestamp" id="datestamp" class="shortest date-pick" /></td>
								<td>
									<select name="userID" id="userid">
										<cfloop query="projectUsers">
										<option value="#userid#"<cfif not compare(session.user.userid,userid)> selected="selected"</cfif>>#firstName# #lastName#</option>
										</cfloop>
									</select>
								</td>
								<td><input type="text" name="hours" id="hrs" class="tiny" /></td>
								<td><input type="text" name="description" id="desc" class="short" /></td>
								<td class="tac"><input type="submit" value="Add to log" onclick="add_time_row('#url.p#');" /></td>
							</tr>
						</thead>
						<tbody>	
						<cfloop query="timelines">
							<cfset thisUserID = userid>
							<tr id="r#replace(timetrackid,'-','','ALL')#">
								<td class="first">#DateFormat(dateStamp,"mmm d, yyyy")#</td>
								<td>#firstName# #lastName#</td>
								<td class="b">#numberFormat(hours,"0.00")#</td>
								<td>#description#</td>
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