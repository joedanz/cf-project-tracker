<cfsetting enablecfoutputonly="true">

<!--- Loads header/footer --->
<cfmodule template="../tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Install">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2>Database Installation</h2>
				</div>
				<div class="content">
					<div class="wrapper">

						<p>In order to use the Project Tracker, a copy of the database must be setup on your server.</p>
						<cfif StructKeyExists(application,"DataMgr")>
							<p>To do this automatically, run the <a href="./DataMgr/db_install.cfm">database install script</a> which uses Steve Bryant's <a href="http://datamgr.riaforge.org">DataMgr</a> to install the tables for you.</p>
							<p>You can also do this by manually running
						<cfelse>	
							<p>You must manually run
						</cfif>
							 the included install script for your system from <a href="./db_schemas/">this directory</a>.<br /><a href="./db_schemas/sqlserver.sql">SQL Server</a>, <a href="./db_schemas/mysql.sql">mySQL</a>, and <a href="./db_schemas/oracle.sql">Oracle</a> scripts are included.</p>  
						<p>You may want to install the database manually if you are using international character sets.<p>
						<p>If you are upgrading, <a href="./upgrade_from/">check the upgrade directory</a> for install scripts to get your version caught up.</p>
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