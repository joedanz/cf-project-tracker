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
			SELECT fileID,title,category,description,filename,serverfilename,filetype,
				filesize,uploaded,uploadedBy,u.firstName, u.lastName
			FROM #variables.tableprefix#files f LEFT JOIN #variables.tableprefix#users u
				ON f.uploadedBy = u.userID
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
			<cfif compare(arguments.fileID,'')>
				AND fileID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.category,'')>
				AND category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#" maxlength="50">
			</cfif>
			<cfif compare(arguments.uploadedBy,'')>
				AND uploadedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uploadedBy#" maxlength="35">
			</cfif>
		</cfquery>
		<cfreturn qGetFiles>
	</cffunction>
	
	<cffunction name="categories" access="public" returnType="query" output="false"
				hint="Returns message categories.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfset var qGetCategories = "">
		<cfquery name="qGetCategories" datasource="#variables.dsn#">
			SELECT distinct category FROM #variables.tableprefix#files
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
			ORDER BY category
		</cfquery>
		<cfreturn qGetCategories>
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
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#files (fileID, projectID, title, category, description, filename, serverfilename, filetype, filesize, uploaded, uploadedBy)
				VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="200">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#" maxlength="50">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#" maxlength="1000">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#" maxlength="150">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.serverfilename#" maxlength="150">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filetype#" maxlength="4">, 
						<cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.filesize#">, 
						#Now()#, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uploadedBy#" maxlength="35">		
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
				category = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.category#" maxlength="50">, 
				description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#" maxlength="1000">
			WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
				AND fileID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#" maxlength="35">
		</cfquery>		
	</cffunction>

	<cffunction name="delete" access="public" returntype="void" output="false"
				hint="Deletes a pp_files record.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="fileID" type="uuid" required="true">
		<cfargument name="uploadedBy" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#files 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
					AND fileID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#" maxlength="35">
					AND uploadedBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.uploadedBy#" maxlength="35">
		</cfquery>		
	</cffunction>

</cfcomponent>
