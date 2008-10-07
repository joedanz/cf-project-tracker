<cfcomponent displayName="Messages" hint="Methods dealing with project messages.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returnType="search" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>

	<cffunction name="messages" access="public" returnType="query" output="false"
				hint="Returns messages.">
		<cfargument name="searchText" type="string" required="true">
		<cfset var qGet = "">
		<cfquery name="qGet" datasource="#variables.dsn#">
			SELECT u.userID,u.firstName,u.lastName,u.avatar,m.messageID,m.categoryID,m.milestoneID,m.title,m.message,
					m.allowcomments,m.stamp,ms.name,mc.category,
					(SELECT count(commentID) FROM #variables.tableprefix#comments c where m.messageid = c.itemid and type = 'msg') as commentcount,
					(SELECT count(fileID) FROM #variables.tableprefix#file_attach fa where m.messageid = fa.itemid and fa.type = 'msg') as attachcount
			FROM #variables.tableprefix#messages m 
				LEFT JOIN #variables.tableprefix#categories mc ON m.categoryID = mc.categoryID
				LEFT JOIN #variables.tableprefix#users u ON u.userID = m.userID 
				LEFT JOIN #variables.tableprefix#milestones ms ON m.milestoneid = ms.milestoneid
			WHERE mc.type = 'msg' AND (m.title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">
				OR m.message like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchText#%">)
			ORDER BY m.stamp desc
		</cfquery>
		<cfreturn qGet>
	</cffunction>

</CFCOMPONENT>
