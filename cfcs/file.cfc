<cfcomponent displayName="file" hint="Methods dealing with uploaded project files.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="file" output="false"
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
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="fileID" type="string" required="false" default="">
		<cfargument name="categoryID" type="string" required="false" default="">
		<cfargument name="uploadedBy" type="string" required="false" default="">
		<cfargument name="orderBy" type="string" required="false" default="date">
		<cfset var qGetFiles = "">
		<cfset var datesOnly = arrayNew(1)>
	    <cfset var leftChar = arrayNew(1)>

		<cfquery name="qGetFiles" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT f.fileID, f.title, f.categoryID, f.description, f.filename, f.serverfilename, f.filetype,
				f.filesize,f.uploaded,f.uploadedBy,u.firstName, u.lastName, fc.category
			FROM #variables.tableprefix#files f 
				LEFT JOIN #variables.tableprefix#users u ON f.uploadedBy = u.userID
				LEFT JOIN #variables.tableprefix#categories fc on f.categoryID = fc.categoryID
			WHERE f.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			<cfif compare(arguments.fileID,'')>
				AND f.fileID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.categoryID,'')>
				AND f.categoryID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.categoryID#" maxlength="35">
			</cfif>
			<cfif compare(arguments.uploadedBy,'')>
				AND f.uploadedBy = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.uploadedBy#" maxlength="35">
			</cfif>
			AND fc.type = 'file'
			ORDER BY <cfswitch expression="#arguments.orderBy#">
						<cfcase value="alpha">f.title asc</cfcase>
						<cfcase value="date">f.uploaded desc</cfcase>
					</cfswitch>
		  </cfquery>
		  
		  <cfloop query="qGetFiles">
			  <cfset datesOnly[currentRow] = DateFormat(uploaded)>
			  <cfset leftChar[currentRow] = left(title,1)>
		  </cfloop>
		  <cfset queryAddColumn(qGetFiles,"uploadDate",datesOnly)>
		  <cfset queryAddColumn(qGetFiles,"leftChar",leftChar)>
		  
		<cfreturn qGetFiles>
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
			<cfset catID = application.category.add(arguments.projectID,arguments.category,'file')>
		</cfif>
		<!--- insert record --->		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
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
		<cfset var catID = "">
		<!--- determine if new category --->
		<cfif request.udf.IsCFUUID(arguments.category)>
			<cfset catID = arguments.category>
		<cfelse>
			<cfset catID = application.category.add(arguments.projectID,arguments.category,'file')>
		</cfif>
		<!--- update record --->
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#files SET
				title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#" maxlength="200">, 
				categoryid = <cfqueryparam cfsqltype="cf_sql_char" value="#catID#" maxlength="35">, 
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
		<cfset var thisFile = "">
		<cfset var remainingFiles = "">
		
		<!--- get file details and delete from file system --->
		<cfset thisFile = get(arguments.projectID,arguments.fileID)>
		<cftry>
			<cffile action="delete" file="#application.userFilesPath##url.p#/#thisFile.serverfilename#">
			<cfcatch></cfcatch>
		</cftry>
		<cfset remainingFiles = get(arguments.projectID)>
		<cfif remainingFiles.recordCount eq 0>
			<cfdirectory action="delete" directory="#application.userFilesPath##arguments.projectID#">
		</cfif>
		
		<!--- delete database record --->
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#files 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
					AND fileID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">
					AND uploadedBy = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.uploadedBy#" maxlength="35">
		</cfquery>
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#file_attach 
				WHERE fileID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">
		</cfquery>				
	</cffunction>

	<cffunction name="getFileList" access="public" returnType="query" output="false"
				hint="Returns files associated with a message or issue.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="itemID" type="uuid" required="true">
		<cfargument name="type" type="string" required="false">
		<cfset var qGetFileList = "">
		<cfquery name="qGetFileList" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT f.fileID,f.title,f.filetype,f.filename,f.serverfilename,f.filesize,f.uploaded,c.category
			FROM #variables.tableprefix#file_attach fa
				JOIN #variables.tableprefix#files f ON fa.fileID = f.fileID
				JOIN #variables.tableprefix#categories c on f.categoryID = c.categoryID
			WHERE f.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND fa.itemID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.itemID#" maxlength="35">
				AND fa.type = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.type#" maxlength="6">
		</cfquery>
		<cfreturn qGetFileList>
	</cffunction>

	<cffunction name="attachFile" access="public" returnType="boolean" output="false"
				hint="Add file attachment to message or issue.">
		<cfargument name="itemID" type="uuid" required="true">
		<cfargument name="fileID" type="uuid" required="true">
		<cfargument name="type" type="string" required="true">		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#file_attach (itemID,fileID,type)
				VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.itemID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.type#" maxlength="6">)
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="removeAttachments" access="public" returnType="boolean" output="false"
				hint="Remove file attachment from message or issue.">
		<cfargument name="itemID" type="uuid" required="true">
		<cfargument name="type" type="string" required="true">		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#file_attach
			WHERE itemID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.itemID#" maxlength="35">
				AND type = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.type#" maxlength="6">
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="checkFile" access="public" returnType="query" output="false"
				hint="Returns files associated with a message.">
		<cfargument name="fileID" type="uuid" required="true">
		<cfset var qCheckFile = "">
		<cfquery name="qCheckFile" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT type
			FROM #variables.tableprefix#file_attach
			WHERE fileID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.fileID#" maxlength="35">
		</cfquery>
		<cfreturn qCheckFile>
	</cffunction>

	<cffunction name="getCatFiles" access="public" returnType="query" output="false"
				hint="Returns file categories with issue count.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfset var qGetCategories = "">
		<cfquery name="qGetCategories" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT c.categoryID, c.category, count(f.fileID) as numFiles
			FROM #variables.tableprefix#categories c left join #variables.tableprefix#files f
				ON c.categoryID = f.categoryID
			WHERE c.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND c.type = 'file'
			GROUP BY c.categoryID, c.category
			ORDER BY c.category
		</cfquery>
		<cfreturn qGetCategories>
	</cffunction>	

</cfcomponent>
