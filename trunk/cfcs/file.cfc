<cfcomponent displayName="file" hint="Methods dealing with uploaded project files.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="file" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns projects.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="fileID" type="string" required="false" default="">
		<cfargument name="category" type="string" required="false" default="">
		<cfargument name="uploadedBy" type="string" required="false" default="">
		<cfset var qGetFiles = "">
		<cfquery name="qGetFiles" datasource="#variables.dsn#">
			SELECT f.fileID, f.title, f.categoryID, f.description, f.filename, f.serverfilename, f.filetype,
				f.filesize,f.uploaded,f.uploadedBy,u.firstName, u.lastName, fc.category
			FROM #variables.tableprefix#files f 
				LEFT JOIN #variables.tableprefix#users u ON f.uploadedBy = u.userID
				LEFT JOIN #variables.tableprefix#categories fc on f.categoryID = fc.categoryID
			WHERE f.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			<cfif compare(arguments.fileID,'')>
				AND f.fileID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.category,'')>
				AND f.categoryID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.categoryID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.uploadedBy,'')>
				AND f.uploadedBy = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.uploadedBy#" maxlength="35">
			</cfif>
			AND fc.type = 'file'
		</cfquery>
		<cfreturn qGetFiles>
	</cffunction>
	
	<cffunction name="categories" access="public" returnType="query" output="false"
				hint="Returns message categories.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfset var qGetCategories = "">
		<cfquery name="qGetCategories" datasource="#variables.dsn#">
			SELECT distinct categoryID, category FROM #variables.tableprefix#categories
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND type = 'file'
			ORDER BY category
		</cfquery>
		<cfreturn qGetCategories>
	</cffunction>		

	<cffunction name="addCategory" access="public" returnType="string" output="false"
				hint="Adds a file category.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="category" type="string" required="true">
		<cfset var newID = createUUID()>
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#categories (projectID,categoryID,type,category)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					'#newID#','file',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#" maxlength="80">)
		</cfquery>
		<cfreturn newID>
	</cffunction>

	<cffunction name="add" access="public" returntype="void" output="false"
				hint="Inserts a pp_files record.">
		<cfargument name="fileID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="category" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="filename" type="string" required="true">
		<cfargument name="serverfilename" type="string" required="true">
		<cfargument name="filetype" type="string" required="true">
		<cfargument name="filesize" type="numeric" required="true">
		<cfargument name="uploadedBy" type="string" required="true">
		<cfset var catID = "">
		<!--- determine if new category --->
		<cfif request.udf.IsCFUUID(arguments.category)>
			<cfset catID = arguments.category>
		<cfelse>
			<cfset catID = addCategory(arguments.projectID,arguments.category)>
		</cfif>
		<!--- insert record --->		
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#files (fileID, projectID, title, categoryID, description, filename, serverfilename, filetype, filesize, uploaded, uploadedBy)
				VALUES(<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="200">, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#catID#" maxlength="35">, 
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#" maxlength="150">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.serverfilename#" maxlength="150">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filetype#" maxlength="4">, 
						<cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.filesize#">, 
						#Now()#, 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.uploadedBy#" maxlength="35">		
						)
		</cfquery>		
	</cffunction>

	<cffunction name="update" access="public" returntype="void" output="false"
				hint="Updates a pp_files record.">
		<cfargument name="fileID" type="string" required="true">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="category" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#files SET
				title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="200">, 
				categoryid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.categoryid#" maxlength="35">, 
				description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND fileID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">
		</cfquery>		
	</cffunction>

	<cffunction name="delete" access="public" returntype="void" output="false"
				hint="Deletes a pp_files record.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="fileID" type="uuid" required="true">
		<cfargument name="uploadedBy" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#files 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
					AND fileID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">
					AND uploadedBy = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.uploadedBy#" maxlength="35">
		</cfquery>		
	</cffunction>

</cfcomponent>
