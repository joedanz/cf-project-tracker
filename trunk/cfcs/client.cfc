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
		<cfargument name="clientID" type="string" required="false" default="">
		<cfargument name="activeOnly" type="boolean" required="false" default="false">
		<cfset var qGet = "">

		<cfquery name="qGet" datasource="#variables.dsn#">
			SELECT c.clientID, c.name, c.address, c.city, c.locality, c.country, c.postal, c.phone, c.fax, 
				c.contactName, c.contactPhone, c.notes, c.active, 
				(select count(*) from #variables.tableprefix#projects p where p.clientID = c.clientID) as numProjects
				FROM #variables.tableprefix#clients c
				WHERE 0 = 0
				<cfif compare(arguments.clientID,'')>
					AND clientID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.clientID#" maxlength="35">
				<cfelseif arguments.activeOnly>
					AND c.active = 1
				</cfif>
			ORDER BY name
		</cfquery>
		<cfreturn qGet>
	</cffunction>
	
	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Adds a project.">	
		<cfargument name="name" type="string" required="true">
		<cfargument name="address" type="string" required="true">
		<cfargument name="city" type="string" required="true">
		<cfargument name="locality" type="string" required="true">
		<cfargument name="country" type="string" required="true">
		<cfargument name="postal" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="fax" type="string" required="true">
		<cfargument name="contactName" type="string" required="true">
		<cfargument name="contactPhone" type="string" required="true">
		<cfargument name="notes" type="string" required="true">
		<cfargument name="active" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#clients (clientID, name, address, city, locality, country, postal, 
				phone, fax,	contactName, contactPhone, notes, active )
			VALUES ('#createUUID()#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="150">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.address#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#" maxlength="150">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locality#" maxlength="200">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postal#" maxlength="40">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone#" maxlength="40">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fax#" maxlength="40">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactName#" maxlength="60">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactPhone#" maxlength="40">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.notes#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">)
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a carrier.">
		<cfargument name="clientID" type="uuid" required="true">		
		<cfargument name="name" type="string" required="true">
		<cfargument name="address" type="string" required="true">
		<cfargument name="city" type="string" required="true">
		<cfargument name="locality" type="string" required="true">
		<cfargument name="country" type="string" required="true">
		<cfargument name="postal" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="fax" type="string" required="true">
		<cfargument name="contactName" type="string" required="true">
		<cfargument name="contactPhone" type="string" required="true">
		<cfargument name="notes" type="string" required="true">
		<cfargument name="active" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#clients 
				SET name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="150">,
					address = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.address#">,
					city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.city#" maxlength="150">,
					locality = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locality#" maxlength="200">,
					country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.country#" maxlength="35">,
					postal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.postal#" maxlength="40">,
					phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone#" maxlength="40">,
					fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fax#" maxlength="40">,
					contactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactName#" maxlength="40">,
					contactPhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactPhone#" maxlength="40">,
					notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.notes#">,
					active = <cfqueryparam cfsqltype="cf_sql_tinyiny" value="#arguments.active#">
				WHERE clientID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.clientID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		

</cfcomponent>