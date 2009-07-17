<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfparam name="url.p" default="">
<cfparam name="form.type" default="">
<cfparam name="form.severity" default="">
<cfparam name="form.componentID" default="">
<cfparam name="form.versionID" default="">
<cfparam name="form.status" default="New|Accepted|Assigned">
<cfparam name="form.assignedTo" default="">
<cfparam name="form.milestone" default="">

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset components = application.project.component(url.p)>
<cfset versions = application.project.version(url.p)>
<cfset projectUsers = application.project.projectUsers(url.p)>
<cfset issues = application.issue.get(url.p,'',form.status,'',form.type,form.severity,form.assignedTo,form.milestone,form.componentID,form.versionID)>
<cfset milestones = application.milestone.get(url.p)>

<cfif not project.issue_view and not session.user.admin>
	<cfoutput><h2>You do not have permission to access issues!!!</h2></cfoutput>
	<cfabort>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Issues" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text="<script type='text/javascript'>
$(document).ready(function(){
    $.tablesorter.addParser({ 
        id: 'shortid', 
        is: function(s) {  
            return false; // return false so this parser is not auto detected
        }, 
        format: function(s) { 
            return s.toLowerCase().replace(/#LCase(project.ticketPrefix)#/,''); 
        }, 
        type: 'numeric' 
    });
	$.tablesorter.addParser({ 
        id: 'severity', 
        is: function(s) {  
            return false; // return false so this parser is not auto detected
        }, 
        format: function(s) { 
            return s.toLowerCase().replace(/critical/,4).replace(/major/,3).replace(/normal/,2).replace(/minor/,1).replace(/trivial/,0); 
        }, 
        type: 'numeric' 
    });
	$.tablesorter.addParser({ 
        id: 'status', 
        is: function(s) {  
            return false; // return false so this parser is not auto detected
        }, 
        format: function(s) { 
            return s.toLowerCase().replace(/closed/,3).replace(/resolved/,2).replace(/assigned/,1).replace(/accepted/,1).replace(/new/,0); 
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
			headers: { 0: { sorter:'shortid' }, 2: { sorter:'severity' }, 3: { sorter:'status' }, 6: { sorter:'text' }, 8: { sorter:'usLongDate' }, 9: { sorter:'usLongDate' }, 10: { sorter:'usLongDate' } },
			widgets: ['zebra'] 
	});
});
</script>
">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left full">
		<div class="main">

				<div class="header">
					
					<span class="rightmenu">
					<cfif project.issue_edit>
						<a href="editIssue.cfm?p=#url.p#" class="add b">Submit New Issue</a>
					</cfif>
					</span>
					
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
						 		<option value="Assigned"<cfif not compare(form.status,'Assigned')> selected="selected"</cfif>>Assigned</option>
						 		<option value="Resolved"<cfif not compare(form.status,'Resolved')> selected="selected"</cfif>>Resolved</option>
						 		<option value="Closed"<cfif not compare(form.status,'Closed')> selected="selected"</cfif>>Closed</option>						 		
						 	</select>
						 	
						 	<select name="componentID">
								<option value="">Component</option>
								<cfloop query="components">
									<option value="#componentID#"<cfif not compare(form.componentID,componentID)> selected="selected"</cfif>>#component#</option>
								</cfloop>
							</select>
						 	
						 	<select name="versionID">
								<option value="">Version</option>
								<cfloop query="versions">
									<option value="#versionID#"<cfif not compare(form.versionID,versionID)> selected="selected"</cfif>>#version#</option>
								</cfloop>
							</select>
						 	
						 	<select name="assignedTo">
						 		<option value="">Assigned To</option>
						 		<cfloop query="projectUsers">
						 			<option value="#userID#"<cfif not compare(form.assignedTo,userID)> selected="selected"</cfif>>#firstName# #lastName#</option>
						 		</cfloop>
						 	</select>
						 	
						 	<select name="milestone">
						 		<option value="">Milestone</option>
						 		<option value="None"<cfif not compare(form.milestone,'None')> selected="selected"</cfif>>-- None Assigned --</option>
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
						<caption class="plain"><cfif not compareNoCase(form.status,'New|Accepted|Assigned')>New, Accepted &amp; Assiged<cfelse>#replace(form.status,'|',' &amp; ')#</cfif> Issues</caption>
						<thead>
							<tr>
								<th>ID</th>
								<th>Type</th>
								<th>Severity</th>
								<th>Status</th>
								<th>Issue</th>
								<th>Component</th>
								<th>Version</th>
								<th>Assigned To</th>
								<th>Reported</th>
								<th>Updated</th>
								<th>Due Date</th>
							</tr>
						</thead>
						<tbody>
						<cfset thisRow = 1>
						<cfloop query="issues">
						<tr>
							<td><a href="issue.cfm?p=#url.p#&i=#issueID#">#shortID#</a></td>
							<td>#type#</td>
							<td>#severity#</td>
							<td>#status#</td>
							<td><a href="issue.cfm?p=#url.p#&i=#issueID#">#issue#</a></td>
							<td>#component#</td>
							<td>#version#</td>
							<td>#assignedFirstName# #assignedLastName#</td>
							<td>#DateFormat(DateAdd("h",session.tzOffset,created),"mmm dd, yyyy")#</td>
							<td><cfif isDate(updated)>#DateFormat(DateAdd("h",session.tzOffset,updated),"mmm dd, yyyy")#</cfif></td>
							<td>#DateFormat(dueDate,"mmm dd, yyyy")#</td>
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
		
	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">