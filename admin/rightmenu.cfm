<cfsetting enablecfoutputonly="true">

<cfoutput>
	<cfif compare(application.settings.company_logo,'')>
		<img src="#application.settings.userFilesMapping#/company/#application.settings.company_logo#" border="0" alt="#application.settings.company_name#" /><br />
	</cfif>


	<cfif not application.isBD and StructKeyExists(application,"DataMgr")>
		<!--- no backup on blue dragon - cfzip doesn't work the same way --->
		<div class="header"><h3 class="save">Backup / Restore</h3></div>
		<div class="content">
			Backing up a project stores all of your data in a WDDX file.  You can restore all of your project data from the backup file at any time.<br /><br />
	
			<a href="backup.cfm" class="backup">Create Backup File</a><br /><br />
			
			<a href="backup.cfm?action=choose" class="folder">View Backup Files</a>
		</div>
	</cfif>
</cfoutput>

<cfsetting enablecfoutputonly="false">