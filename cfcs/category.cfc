<cfcomponent displayName="category" hint="Methods dealing with categories.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="category" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns categories.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="type" type="string" required="true">
		<cfargument name="categoryID" type="string" required="false" default="">
		<cfset var qGetCategories = "">
		<cfquery name="qGetCategories" datasource="#variables.dsn#">
			SELECT distinct categoryID, category FROM #variables.tableprefix#categories
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				<cfif compare(ARGUMENTS.categoryID,'')> AND categoryID = 
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.categoryID#" maxlength="35">
				</cfif>
				AND type = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.type#" maxlength="5">
			ORDER BY category
		</cfquery>
		<cfreturn qGetCategories>
	</cffunction>		

	<cffunction name="add" access="public" returnType="string" output="false"
				hint="Adds a category.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="category" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfset var newID = createUUID()>
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#categories (projectID,categoryID,type,category)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					'#newID#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" maxlength="5">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#" maxlength="80">)
		</cfquery>
		<cfreturn newID>
	</cffunction>

	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a category.">
		<cfargument name="categoryID" type="string" required="true">
		<cfargument name="category" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#categories
			SET	category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#" maxlength="80">
			WHERE categoryID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.categoryID#" maxlength="35">  
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="delete" access="public" returnType="boolean" output="false"
				hint="Deletes a category.">
		<cfargument name="categoryID" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#categories
			WHERE categoryID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.categoryID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
</cfcomponent>
