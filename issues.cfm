<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfparam name="url.p" default="">
<cfparam name="form.type" default="">
<cfparam name="form.severity" default="">
<cfparam name="form.status" default="New|Accepted">
<cfparam name="form.assignedTo" default="">
<cfparam name="form.milestone" default="">

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset projectUsers = application.project.projectUsers(url.p)>
<cfset issues = application.issue.get(url.p,'',form.status,'',form.type,form.severity,form.assignedTo,form.milestone)>
<cfset milestones = application.milestone.get(url.p)>

<cfif project.issues eq 0 and not session.user.admin>
	<cfoutput><h2>You do not have permission to access issues!!!</h2></cfoutput>
	<cfabort>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Issues" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text="<script type='text/javascript'>
$(document).ready(function(){
    $.tablesorter.addParser({ 
        id: 'statuses', 
        is: function(s) {  
            return false; // return false so this parser is not auto detected
        }, 
        format: function(s) { 
            return s.toLowerCase().replace(/trivial/,4).replace(/minor/,3).replace(/normal/,2).replace(/major/,1).replace(/critical/,0); 
        }, 
        type: 'numeric' 
    });
    $.tablesorter.addParser({
		id: 'usMonthOnlyDate',
		is: function(s) {
			return s.match(new RegExp(/^[A-Za-z]{3,10}\.? [0-9]{1,2}$/));
		},
		format: function(s) {
			s += ', ' + new Date().getYear();
			return $.tablesorter.formatFloat((new Date(s)).getTime());;
		}, 
        type: 'numeric' 
	});
	$('##issues').tablesorter({
			cssHeader: 'theader',
			sortList: [[0,0]],
			headers: { 3: { sorter:'statuses' }, 6: { sorter:'usMonthOnlyDate' }, 7: { sorter:'usMonthOnlyDate' } },
			widgets: ['zebra']  
	});
});
</script>
">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="issues">All issues</h2>
				</div>
				<div class="content">
				 	<div class="wrapper">
					 	
					 	<cfif issues.recordCount or (compare(form.type,'') or compare(form.severity,'') or compare(form.status,'') or compare(form.assignedTo,'') or compare(form.milestone,''))>
						 	
						 <div class="mb10" id="issuefilter">

						 	<form action="#cgi.script_name#?p=#url.p#" method="post" style="float:right;">
							 	<input type="hidden" name="status" value="" />
						 		<input type="submit" value="Show All" />
						 	</form>
							
							<form action="#cgi.script_name#?p=#url.p#" method="post">						 
						 	<select name="type">
						 		<option value="">Type</option>
						 		<option value="Bug"<cfif not compare(form.type,'Bug')> selected="selected"</cfif>>Bug</option>
						 		<option value="Enhancement"<cfif not compare(form.type,'Enhancement')> selected="selected"</cfif>>Enhancement</option>
						 	</select>
						 	
						 	<select name="severity">
							 	<option value="">Severity</option>
								<option value="Critical"<cfif not compare(form.severity,'Critical')> selected="selected"</cfif>>Critical</option>
								<option value="Major"<cfif not compare(form.severity,'Major')> selected="selected"</cfif>>Major</option>
								<option value="Normal"<cfif not compare(form.severity,'Normal')> selected="selected"</cfif>>Normal</option>
								<option value="Minor"<cfif not compare(form.severity,'Minor')> selected="selected"</cfif>>Minor</option>
								<option value="Trivial"<cfif not compare(form.severity,'Trivial')> selected="selected"</cfif>>Trivial</option>
						 	</select>
						 	
						 	<select name="status">
						 		<option value="">Status</option>
						 		<option value="New"<cfif not compare(form.status,'New')> selected="selected"</cfif>>New</option>
						 		<option value="Accepted"<cfif not compare(form.status,'Accepted')> selected="selected"</cfif>>Accepted</option>
						 		<option value="Resolved"<cfif not compare(form.status,'Resolved')> selected="selected"</cfif>>Resolved</option>
						 		<option value="Closed"<cfif not compare(form.status,'Closed')> selected="selected"</cfif>>Closed</option>						 		
						 	</select>
						 	
						 	<select name="assignedTo">
						 		<option value="">Assigned To</option>
						 		<cfloop query="projectUsers">
						 			<option value="#userID#"<cfif not compare(form.assignedTo,userID)> selected="selected"</cfif>>#firstName# #lastName#</option>
						 		</cfloop>
						 	</select>
						 	
						 	<select name="milestone">
						 		<option value="">Milestone</option>
						 		<cfloop query="milestones">
						 			<option value="#milestoneID#"<cfif not compare(form.milestone,milestoneID)> selected="selected"</cfif>>#name#</option>
						 		</cfloop>
						 	</select>						 	
						 	
						 	<input type="submit" value="Filter" />
						 	</form>
						 	
						 </div>	
						 </cfif>
						 
						<cfif issues.recordCount>
					 	<div style="border:1px solid ##ddd;" class="mb20">
					 	<table class="activity full tablesorter" id="issues">
						<caption class="plain">#replace(form.status,'|',' &amp; ')# Issues</caption>
						<thead>
							<tr>
								<th>ID</th>
								<th>Type</th>
								<th>Severity</th>
								<th>Issue</th>
								<th>Status</th>
								<th>Assigned To</th>
								<th>Reported</th>
								<th>Updated</th>
							</tr>
						</thead>
						<tbody>
						<cfset thisRow = 1>
						<cfloop query="issues">
						<tr>
							<td><a href="issue.cfm?p=#url.p#&i=#issueID#">#shortID#</a></td>
							<td>#type#</td>
							<td>#severity#</td>
							<td><a href="issue.cfm?p=#url.p#&i=#issueID#">#issue#</a></td>
							<td>#status#</td>
							<td>#assignedFirstName# #assignedLastName#</td>
							<td>#DateFormat(created,"mmm d")#</td>
							<td>#DateFormat(updated,"mmm d")#</td>
						</tr>
						<cfset thisRow = thisRow + 1>
						</cfloop>
						</tbody>
						</table>
						</div>
						<cfelse>
							<div class="warn">No issues <cfif compare(form.type,'') or compare(form.severity,'') or compare(form.status,'') or compare(form.assignedTo,'') or compare(form.milestone,'')>match your criteria<cfelse>have been submitted</cfif>.</div>
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
		
		<cfif project.issues gt 1>
		<h3><a href="editIssue.cfm?p=#url.p#" class="add">Submit new issue</a></h3><br />
		</cfif>
		
	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">