<cfcomponent displayName="Clients" hint="Methods dealing with mobile clients.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="client" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns mobile carriers.">
		<cfargument name="clientID" type="string" required="false" default="">
		<cfargument name="activeOnly" type="boolean" required="false" default="false">
		<cfset var qGet = "">

		<cfquery name="qGet" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT c.clientID, c.name, c.address, c.city, c.locality, c.country, c.postal, c.phone, c.fax, 
				c.contactName, c.contactPhone, c.contactEmail, c.website, c.notes, c.active, 
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
		<cfargument name="contactEmail" type="string" required="true">
		<cfargument name="website" type="string" required="true">
		<cfargument name="notes" type="string" required="true">
		<cfargument name="active" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#clients (clientID, name, address, city, locality, country, postal, 
				phone, fax,	contactName, contactPhone, contactEmail, website, notes, active )
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
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactEmail#" maxlength="150">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.website#" maxlength="150">,
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
		<cfargument name="contactEmail" type="string" required="true">
		<cfargument name="website" type="string" required="true">
		<cfargument name="notes" type="string" required="true">
		<cfargument name="active" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
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
					contactEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactEmail#" maxlength="150">,
					website = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.website#" maxlength="150">,
					notes = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.notes#">,
					active = <cfqueryparam cfsqltype="cf_sql_tinyiny" value="#arguments.active#">
				WHERE clientID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.clientID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
	
	<cffunction name="getRates" access="public" returnType="query" output="false"
				hint="Returns mobile carriers.">
		<cfargument name="clientID" type="string" required="true">
		<cfset var qGetRates = "">

		<cfquery name="qGetRates" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT r.rateID, r.category, r.rate, count(tt.rateID) as numLines
				FROM #variables.tableprefix#client_rates r 
					LEFT JOIN #variables.tableprefix#timetrack tt ON r.rateID = tt.rateID
				WHERE clientID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.clientID#" maxlength="35">
			GROUP BY r.rateID, r.category, r.rate
			ORDER BY r.category
		</cfquery>
		<cfreturn qGetRates>
	</cffunction>

	<cffunction name="addRate" access="public" returnType="boolean" output="false"
				hint="Adds a client rate.">	
		<cfargument name="rateID" type="string" required="true">
		<cfargument name="clientID" type="string" required="true">
		<cfargument name="category" type="string" required="true">
		<cfargument name="rate" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#client_rates (rateID, clientID, category, rate )
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.rateID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.clientID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.rate#">)
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="deleteRate" access="public" returnType="boolean" output="false"
				hint="Deletes a client rate.">	
		<cfargument name="rateID" type="string" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#client_rates 
			WHERE rateID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.rateID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>

</cfcomponent>