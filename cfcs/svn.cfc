<cfcomponent displayName="Messages" hint="Methods dealing with project messages.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="svn" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="getLinks" access="public" returnType="query" output="false"
				hint="Returns svn links.">
		<cfargument name="itemType" type="string" required="false" default="">
		<cfargument name="itemID" type="string" required="false" default="">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfset var qLinks = "">
		
		<cfquery name="qLinks" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT s.linkID, s.revision
				FROM #variables.tableprefix#svn_link s 
					INNER JOIN #variables.tableprefix#projects p ON s.projectID = p.projectID
					LEFT JOIN #variables.tableprefix##arguments.itemType#s ON #arguments.itemType#ID = s.itemID  
			WHERE 0=0
				<cfif compare(arguments.projectID,'')>
					AND p.projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
				</cfif>
				<cfif compare(arguments.itemID,'')>
   					AND s.itemID = <cfqueryparam value="#arguments.itemID#" cfsqltype="cf_sql_varchar" />
				</cfif>
				<cfif compare(arguments.itemType,'')>
   					AND s.itemType = <cfqueryparam value="#arguments.itemType#" cfsqltype="cf_sql_varchar" maxlength="10" />
				</cfif>
			ORDER BY s.revision desc
		</cfquery>
		<cfreturn qLinks>
	</cffunction>

	<cffunction name="addLink" access="public" returnType="boolean" output="false"
				hint="Adds an svn link.">
		<cfargument name="linkID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="revision" type="numeric" required="true">
		<cfargument name="itemID" type="string" required="true">
		<cfargument name="itemType" type="string" required="true">
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#svn_link (linkID,projectID,revision,itemID,itemType)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.linkID#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.revision#" maxlength="5">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemID#" maxlength="35">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemType#" maxlength="10">
			) 
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="deleteLink" access="public" returnType="boolean" output="false"
				hint="Deletes an svn link.">
		<cfargument name="linkID" type="string" required="true">
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#svn_link
			WHERE linkID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.linkID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>

</CFCOMPONENT>
