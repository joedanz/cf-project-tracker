<cfsetting enablecfoutputonly="true">

<!--- Loads header/footer --->
<cfmodule template="../../tags/layout.cfm" templatename="main" title="Project Tracker &raquo; Automated DB Install">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2>Automated Database Installation</h2>
				</div>
				<div class="content">
					<div class="wrapper">

						<cfif StructKeyExists(form,"submit")>
							
							<cftry>
								
								<!---<cfset DataMgr.loadTable("pt_activity")>
								<cfset DataMgr.loadTable("pt_carriers")>
								<cfset DataMgr.loadTable("pt_categories")>
								<cfset DataMgr.loadTable("pt_clients")>
								<cfset DataMgr.loadTable("pt_comments")>
								<cfset DataMgr.loadTable("pt_file_attach")>
								<cfset DataMgr.loadTable("pt_files")>
								<cfset DataMgr.loadTable("pt_issues")>
								<cfset DataMgr.loadTable("pt_message_notify")>
								<cfset DataMgr.loadTable("pt_messages")>
								<cfset DataMgr.loadTable("pt_milestones")>
								<cfset DataMgr.loadTable("pt_project_users")>
								<cfset DataMgr.loadTable("pt_projects")>
								<cfset DataMgr.loadTable("pt_screenshots")>
								<cfset DataMgr.loadTable("pt_settings")>
								<cfset DataMgr.loadTable("pt_tags")>
								<cfset DataMgr.loadTable("pt_todolists")>
								<cfset DataMgr.loadTable("pt_todos")>
								<cfset DataMgr.loadTable("pt_users")>
								<pre>#XmlFormat(DataMgr.getXML())#</pre>--->
								
								<cfset CreateObject("component","db_structure").init(application.DataMgr,application.settings.tableprefix)>
								<h4><em><strong>Database Created Successfully!</strong><br /><br /><a href="../../index.cfm?reinit">Click here to continue.</em></h4>
								<cfcatch>
									<h4><em>Error Creating Database!</em></h4>
								</cfcatch>
							</cftry>
						<cfelse>
							<h4>Using <strong>settings.<cfif not compare(cgi.server_name,'127.0.0.1')>local<cfelse>ini</cfif>.cfm</strong> from <strong>config</strong> directory:</h4>
							
							<h4>
							<ul style="margin:10px 30px;">
								<li><strong>Datasource Name:</strong> #application.settings.dsn#</li>
								<li><strong>Database Type:</strong> #application.settings.dbtype#</li>
								<li><strong>Table Prefix:</strong> #application.settings.tableprefix#</li>
							</ul>
							</h4>
							
							<form action="#cgi.script_name#?reinit" method="post">
								To refresh settings after making changes, <input type="submit" name="refresh" value="Click Here" />.
							</form><br />
							
							<form action="#cgi.script_name#" method="post">
								To create tables with these settings, <input type="submit" name="submit" value="Click Here" />.
							</form>			
						</cfif>
											
				 	</div>
				</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="#application.settings.mapping#/footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">

	</div>
		
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">