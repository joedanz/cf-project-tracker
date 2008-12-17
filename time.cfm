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

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Time Tracking" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left full">
		<div class="main">

				<div class="header">
					<h2 class="time">Time Tracking</h2>
				</div>
				<div class="content">
				 	<div class="wrapper">
					 	
					 	<table>
							<thead>
								<tr>
									<th>Date</th>
									<th>Person</th>
									<th>Hours</th>
									<th>Description</th>
									<th></th>
								</tr>
							</thead>
							<tbody>
								
							</tbody>
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