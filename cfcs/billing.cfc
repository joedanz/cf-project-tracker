<cfcomponent displayName="Billing" hint="Methods dealing with billing.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="billing" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="set" access="public" returnType="boolean" output="false"
				hint="Sets bill/paid value.">
		<cfargument name="itemID" type="string" required="true">
		<cfargument name="itemType" type="string" required="true">
		<cfargument name="itemWhich" type="string" required="true">
		<cfargument name="itemValue" type="string" required="true">

		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix##arguments.itemType#<cfif not compareNoCase(arguments.itemType,'milestone')>s</cfif>
			SET #itemWhich# = 
				<cfswitch expression="#arguments.itemValue#">
					<cfcase value="true,checked">1</cfcase>
					<cfcase value="false,undefined">0</cfcase>
				</cfswitch>
			WHERE #arguments.itemType#ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>

</cfcomponent>