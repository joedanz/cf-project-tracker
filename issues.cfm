<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
<cfset issues = application.issue.get(url.p)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Issues" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

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
					 	
					 	<cfif issues.recordCount>
					 	<table class="svn">
						<thead>
							<tr>
								<th>ID</th>
								<th>Issue</th>
								<th>Type</th>
								<th>Severity</th>
								<th>Assigned To</th>
								<th>Reported</th>
							</tr>
						</thead>
						<tbody>
						<cfloop query="issues">
						<tr>
							<td><a href="editIssue.cfm?p=#url.p#&i=#issueID#">#shortID#</a></td>
							<td>#issue#</td>
							<td>#type#</td>
							<td>#severity#</td>
							<td>#firstName# #lastName#</td>
							<td>#DateFormat(created,"d mmm")#</td>
						</tr>
						</cfloop>
						</tbody>
						</table>
						<cfelse>
							<div class="warn">No issues have been submitted.</div>
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
		
		<h3><a href="editIssue.cfm?p=#url.p#" class="add">Submit an issue</a></h3><br />
		
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