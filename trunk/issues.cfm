<cfsetting enablecfoutputonly="true" showdebugoutput="true">

<cfparam name="url.p" default="">
<cfparam name="form.type" default="">
<cfparam name="form.severity" default="">
<cfparam name="form.status" default="">
<cfparam name="form.assignedTo" default="">
<cfparam name="form.milestone" default="">

<cfset project = application.project.get(session.user.userid,url.p)>
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
	$('##issues').tableSorter({
			sortColumn: 'ID',		// Integer or String of the name of the column to sort by
			sortClassAsc: 'headerSortUp',		// Class name for ascending sorting action to header
			sortClassDesc: 'headerSortDown',	// Class name for descending sorting action to header
			highlightClass: 'highlight', 		// class name for sort column highlighting
			headerClass: 'theader'
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
					 	
						<cfif not compare(project.ticketPrefix,'')>
							<div class="warn mb10">A ticket prefix must be set in order to create issues.</div>
						</cfif>					 	
					 	
					 	<cfif issues.recordCount or (compare(form.type,'') or compare(form.severity,'') or compare(form.status,'') or compare(form.assignedTo,'') or compare(form.milestone,''))>
						 	
						 <div class="mb10" style="background-color:##ffc;padding:8px;border:1px solid ##ccc;">

						 	<form action="#cgi.script_name#?p=#url.p#" method="post" style="float:right;">
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
						 		<option value="Open"<cfif not compare(form.status,'Open')> selected="selected"</cfif>>Open</option>
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
					 	<table class="svn" id="issues">
						<thead>
							<tr>
								<th>ID</th>
								<th>Issue</th>
								<th>Type</th>
								<th>Severity</th>
								<th>Status</th>
								<th>Assigned To</th>
								<th>Reported</th>
								<th>Updated</th>
							</tr>
						</thead>
						<tbody>
						<cfloop query="issues">
						<tr>
							<td><a href="issue.cfm?p=#url.p#&i=#issueID#">#shortID#</a></td>
							<td>#issue#</td>
							<td>#type#</td>
							<td>#severity#</td>
							<td>#status#</td>
							<td>#assignedFirstName# #assignedLastName#</td>
							<td>#DateFormat(created,"mmm d")#</td>
							<td>#DateFormat(updated,"mmm d")#</td>
						</tr>
						</cfloop>
						</tbody>
						</table>
						<cfelse>
							<div class="warn">No issues <cfif compare(form.type,'') or compare(form.severity,'') or compare(form.status,'') or compare(form.assignedTo,'') or compare(form.milestone,'')>match your query<cfelse>have been submitted</cfif>.</div>
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
		
		<cfif project.mstones gt 1 and compare(project.ticketPrefix,'')>
		<h3><a href="editIssue.cfm?p=#url.p#" class="add">Submit new issue</a></h3><br />
		</cfif>
		
		<cfif issues.recordCount>
			<!---
		<div class="header"><h3>Severity</h3></div>
		<div class="content">
			<ul>

			</ul>
		</div>
			--->
		</cfif>
		
	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">