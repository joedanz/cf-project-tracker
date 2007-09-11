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

	<CFFUNCTION NAME="add" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Inserts a pp_files record.">
		<CFARGUMENT NAME="fileID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="projectID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="title" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="category" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="description" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="filename" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="serverfilename" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="filetype" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="filesize" TYPE="numeric" REQUIRED="true">
		<CFARGUMENT NAME="uploadedBy" TYPE="string" REQUIRED="true">
		<CFQUERY DATASOURCE="#variables.dsn#">
			INSERT INTO pt_files (fileID, projectID, title, category, description, filename, serverfilename, filetype, filesize, uploaded, uploadedBy)
				VALUES(<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.fileID#" MAXLENGTH="35">,
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#" MAXLENGTH="35">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.title#" MAXLENGTH="200">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.category#" MAXLENGTH="50">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.description#" MAXLENGTH="1000">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.filename#" MAXLENGTH="150">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.serverfilename#" MAXLENGTH="150">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.filetype#" MAXLENGTH="4">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_BIGINT" VALUE="#ARGUMENTS.filesize#">, 
						#Now()#, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.uploadedBy#" MAXLENGTH="35">		
						)
		</cfquery>		
	</CFFUNCTION>

	<CFFUNCTION NAME="update" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Updates a pp_files record.">
		<CFARGUMENT NAME="fileID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="projectID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="title" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="category" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="description" TYPE="string" REQUIRED="true">
		<CFQUERY DATASOURCE="#variables.dsn#">
			UPDATE pt_files SET
				title = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.title#" MAXLENGTH="200">, 
				category = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.category#" MAXLENGTH="50">, 
				description = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.description#" MAXLENGTH="1000">
			WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#" MAXLENGTH="35">
				AND fileID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.fileID#" MAXLENGTH="35">
		</cfquery>		
	</CFFUNCTION>

	<CFFUNCTION NAME="delete" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Deletes a pp_files record.">
		<CFARGUMENT NAME="projectID" TYPE="uuid" REQUIRED="true">
		<CFARGUMENT NAME="fileID" TYPE="uuid" REQUIRED="true">
		<CFARGUMENT NAME="uploadedBy" TYPE="uuid" REQUIRED="true">
		<CFQUERY DATASOURCE="#variables.dsn#">
			DELETE FROM pt_files 
				WHERE projectID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.projectID#" MAXLENGTH="35">
					AND fileID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.fileID#" MAXLENGTH="35">
					AND uploadedBy = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.uploadedBy#" MAXLENGTH="35">
		</cfquery>		
	</CFFUNCTION>

</CFCOMPONENT>
