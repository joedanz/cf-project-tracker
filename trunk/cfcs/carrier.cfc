<cfcomponent displayName="Carriers" hint="Methods dealing with mobile carriers.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="carrier" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns mobile carriers.">
		<cfargument name="activeOnly" type="boolean" required="false" default="false">
		<cfset var qGet = "">

		<cfquery name="qGet" datasource="#variables.dsn#">
			SELECT carrierID, carrier, countryCode, country, prefix, suffix, active 
				FROM #variables.tableprefix#carriers
				<cfif arguments.activeOnly>
					AND active = 1
				</cfif>
			ORDER BY countryCode, carrier
		</cfquery>
		<cfreturn qGet>
	</cffunction>		
	
</cfcomponent>