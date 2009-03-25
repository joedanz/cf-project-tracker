<cfcomponent displayName="Config" hint="Sets application settings.">

	<cffunction name="init" access="public" returnType="config" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="save" access="public" returnType="boolean" output="false"
				hint="Sets application settings.">
		<cfargument name="app_title" type="string" required="true">
		<cfargument name="default_style" type="string" required="true">
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #application.settings.tableprefix#settings
				SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.app_title#" maxlength="250">
					WHERE setting = 'app_title'
		</cfquery>
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #application.settings.tableprefix#settings
				SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.default_style#">
					WHERE setting = 'default_style'
		</cfquery>
		
		<cfreturn true>
	</cffunction>

	<cffunction name="saveNotification" access="public" returnType="boolean" output="false"
				hint="Sets application settings.">
		<cfargument name="email_subject_prefix" type="string" required="true">
		<cfargument name="sms_subject_prefix" type="string" required="true">
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #application.settings.tableprefix#settings
				SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email_subject_prefix#" maxlength="250">
					WHERE setting = 'email_subject_prefix'
		</cfquery>
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #application.settings.tableprefix#settings
				SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sms_subject_prefix#" maxlength="250">
					WHERE setting = 'sms_subject_prefix'
		</cfquery>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="saveAPI" access="public" returnType="boolean" output="false"
				hint="Sets application API settings.">
		<cfargument name="enable_api" type="string" required="true">
		<cfargument name="api_key" type="string" required="true">
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #application.settings.tableprefix#settings
				SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.enable_api#" maxlength="1">
					WHERE setting = 'enable_api'
		</cfquery>
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #application.settings.tableprefix#settings
				SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.api_key#" maxlength="35">
					WHERE setting = 'api_key'
		</cfquery>
		
		<cfreturn true>
	</cffunction>
	
	<cffunction name="saveAPIKey" access="public" returnType="boolean" output="false"
				hint="Sets application API settings.">
		<cfargument name="api_key" type="string" required="true">
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #application.settings.tableprefix#settings
				SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.api_key#" maxlength="35">
					WHERE setting = 'api_key'
		</cfquery>

		<cfreturn true>
	</cffunction>	
	
</cfcomponent>