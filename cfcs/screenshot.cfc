<cfcomponent displayName="screenshot" hint="Methods dealing with uploaded project files.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="screenshot" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="get" access="public" returnType="query" output="false"
				hint="Returns projects.">
		<cfargument name="issueID" type="uuid" required="true">
		<cfargument name="fileID" type="string" required="false" default="">
		<cfset var qGetScreenshots = "">
		<cfquery name="qGetScreenshots" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT s.fileID, s.title, s.description, s.filename, s.serverfilename, s.filetype,
				s.filesize,s.uploaded,s.uploadedBy,u.firstName, u.lastName
			FROM #variables.tableprefix#screenshots s 
				LEFT JOIN #variables.tableprefix#users u ON s.uploadedBy = u.userID
			WHERE s.issueID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#" maxlength="35">
			<cfif compare(arguments.fileID,'')>
				AND s.fileID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">
			</cfif>
		</cfquery>
		<cfreturn qGetScreenshots>
	</cffunction>

	<cffunction name="add" access="public" returntype="void" output="false"
				hint="Inserts a pp_files record.">
		<cfargument name="fileID" type="string" required="true">
		<cfargument name="issueID" type="string" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="filename" type="string" required="true">
		<cfargument name="serverfilename" type="string" required="true">
		<cfargument name="filetype" type="string" required="true">
		<cfargument name="filesize" type="numeric" required="true">
		<cfargument name="uploadedBy" type="string" required="true">

		<!--- insert record --->		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#screenshots (fileID, issueID, title, description, filename, serverfilename, filetype, filesize, uploaded, uploadedBy)
				VALUES(<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#" maxlength="35">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="200">,  
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
		<cfargument name="issueID" type="string" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#screenshots SET
				title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="200">, 
				description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">
			WHERE issueID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#" maxlength="35">
				AND fileID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">
		</cfquery>		
	</cffunction>

	<cffunction name="delete" access="public" returntype="void" output="false"
				hint="Deletes a pp_files record.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="issueID" type="uuid" required="true">
		<cfargument name="fileID" type="uuid" required="true">
		<cfargument name="uploadedBy" type="uuid" required="true">
		<cfset var thisFile = "">
		<cfset var remainingFiles = "">
		
		<!--- get file details and delete from file system --->
		<cfset thisFile = get(arguments.issueID,arguments.fileID)>
		<cftry>
			<cffile action="delete" file="#application.userFilesPath##url.p#/#thisFile.serverfilename#">
			<cfcatch></cfcatch>
		</cftry>
		<cfset remainingFiles = get(arguments.projectID)>
		<cfif remainingFiles.recordCount eq 0>
			<cfdirectory action="delete" directory="#application.userFilesPath##arguments.projectID#">
		</cfif>

		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#screenshots 
				WHERE issueID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.issueID#" maxlength="35">
					AND fileID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">
					AND uploadedBy = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.uploadedBy#" maxlength="35">
		</cfquery>
	</cffunction>

</cfcomponent>
