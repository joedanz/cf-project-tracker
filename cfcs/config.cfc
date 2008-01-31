<cfcomponent displayName="Config" hint="Sets application settings.">

	<cffunction name="init" access="public" returnType="config" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="save" access="public" returnType="boolean" output="false"
				hint="Sets application settings.">
		<cfargument name="app_title" type="string" required="true">
		<cfargument name="default_style" type="string" required="true">
		
		<cfquery datasource="#variables.dsn#">
			UPDATE #application.settings.tableprefix#settings
				SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.app_title#" maxlength="250">
					WHERE setting = 'app_title'
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			UPDATE #application.settings.tableprefix#settings
				SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.default_style#">
					WHERE setting = 'default_style'
		</cfquery>
		
		<cfreturn true>
	</cffunction>
	
</cfcomponent>