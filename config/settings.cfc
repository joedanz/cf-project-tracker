<cfcomponent displayName="Config" hint="Core CFC for the application. Main purpose is to handle settings.">

	<cffunction name="getSettings" access="public" returnType="struct" output="false"
				hint="Returns application settings as a structure.">
		
	    <cfargument name="iniFile" required="false" default="settings.ini.cfm">
	    
		<!--- load the settings from the ini file --->
		<cfset var settingsFile = replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all") & arguments.iniFile>
		<cfset var iniData = getProfileSections(settingsFile)>
		<cfset var r = structNew()>
		<cfset var key = "">
		<cfset var dsn = "">
		<cfset var getSettings = "">
		
		<cfloop index="key" list="#iniData.settings#">
			<cfset r[key] = getProfileString(settingsFile,"settings",key)>
			<cfif key is "dsn">
				<cfset dsn = r[key]>
			</cfif>
		</cfloop>
		
		<cftry>
			<cfquery name="getSettings" datasource="#dsn#">
				SELECT setting,settingValue FROM #r['tableprefix']#settings
			</cfquery>
			<cfloop query="getSettings">
				<cfset r['#setting#'] = settingValue>
			</cfloop>
			<cfcatch></cfcatch>
		</cftry>
		
		<cfreturn r>
		
	</cffunction>
	
</cfcomponent>