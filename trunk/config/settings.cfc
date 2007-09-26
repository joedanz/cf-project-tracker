<cfcomponent displayName="Config" hint="Core CFC for the application. Main purpose is to handle settings.">

	<cffunction name="getSettings" access="public" returnType="struct" output="false"
				hint="Returns application settings as a structure.">
		
	    <cfargument name="iniFile" required="false" default="settings.ini.cfm">
	    
		<!--- load the settings from the ini file --->
		<cfset var settingsFile = replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all") & arguments.iniFile>
		<cfset var iniData = getProfileSections(settingsFile)>
		<cfset var r = structNew()>
		<cfset var key = "">
		
		<cfloop index="key" list="#iniData.settings#">
			<cfset r[key] = getProfileString(settingsFile,"settings",key)>
			<cfif key is "dsn">
				<cfset dsn = r[key]>
			</cfif>
		</cfloop>
		
		<cfquery name="getSettings" datasource="#dsn#">
			SELECT setting,settingValue FROM #r['tableprefix']#settings
		</cfquery>
		<cfloop query="getSettings">
			<cfset r['#setting#'] = settingValue>
		</cfloop>
		
		<cfreturn r>
		
	</cffunction>
	
	<cffunction name="setSettings" access="public" returnType="boolean" output="false"
				hint="Sets application settings.">
		<cfargument name="dsn" type="string" required="true">
		<cfargument name="app_title" type="string" required="true">
		<cfargument name="default_style" type="string" required="true">
		
		<cfquery datasource="#arguments.dsn#">
			UPDATE #application.settings.tableprefix#settings
				SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.app_title#" maxlength="250">
					WHERE setting = 'app_title'
		</cfquery>
		<cfquery datasource="#arguments.dsn#">
			UPDATE #application.settings.tableprefix#settings
				SET settingValue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.default_style#">
					WHERE setting = 'default_style'
		</cfquery>
		
		<cfreturn true>
	</cffunction>
	
</cfcomponent>