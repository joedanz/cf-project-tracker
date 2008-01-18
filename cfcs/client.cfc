<cfcomponent displayName="Clients" hint="Methods dealing with mobile clients.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="client" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns mobile carriers.">
		<cfargument name="carrierID" type="string" required="false" default="">
		<cfargument name="activeOnly" type="boolean" required="false" default="false">
		<cfset var qGet = "">

		<cfquery name="qGet" datasource="#variables.dsn#">
			SELECT carrierID, carrier, countryCode, country, prefix, suffix, active 
				FROM #variables.tableprefix#carriers
				WHERE 0 = 0
				<cfif compare(arguments.carrierID,'')>
					AND carrierID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.carrierID#" maxlength="35">
				<cfelseif arguments.activeOnly>
					AND active = 1
				</cfif>
			ORDER BY countryCode, carrier
		</cfquery>
		<cfreturn qGet>
	</cffunction>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Adds a project.">	
		<cfargument name="carrier" type="string" required="true">
		<cfargument name="countryCode" type="string" required="true">
		<cfargument name="country" type="string" required="true">
		<cfargument name="prefix" type="string" required="true">
		<cfargument name="suffix" type="string" required="true">
		<cfargument name="active" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#carriers (carrierID,carrier,countryCode,country,prefix,suffix,active)
			VALUES ('#createUUID()#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carrier#" maxlength="20">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.countryCode#" maxlength="2">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country#" maxlength="20">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prefix#" maxlength="3">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.suffix#" maxlength="40">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">)
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a carrier.">
		<cfargument name="carrierID" type="uuid" required="true">		
		<cfargument name="carrier" type="string" required="true">
		<cfargument name="countryCode" type="string" required="true">
		<cfargument name="country" type="string" required="true">
		<cfargument name="prefix" type="string" required="true">
		<cfargument name="suffix" type="string" required="true">
		<cfargument name="active" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#carriers 
				SET carrier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carrier#" maxlength="20">,
					countryCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.countryCode#" maxlength="2">,
					country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country#" maxlength="20">,
					prefix = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.prefix#" maxlength="3">,
					suffix = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.suffix#" maxlength="40">,
					active = <cfqueryparam cfsqltype="cf_sql_tinyiny" value="#arguments.active#">
				WHERE carrierID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.carrierID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
	
</cfcomponent>