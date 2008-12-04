<!--- 2.1 (Build 112) --->
<!--- Last Updated: 2007-07-10 --->
<!--- Created by Steve Bryant 2004-12-08 --->
<!--- Information: sebtools.com --->
<cfcomponent displayname="Data Manager" hint="I manage data interactions with the database. I can be used to handle inserts/updates.">
<cfset variables.DataMgrVersion = "2.1 Beta 2">
<cffunction name="init" access="public" returntype="DataMgr" output="no" hint="I instantiate and return this object.">
	<cfargument name="datasource" type="string" required="yes">
	<cfargument name="database" type="string" required="no">
	<cfargument name="username" type="string" required="no">
	<cfargument name="password" type="string" required="no">
	
	<cfset variables.datasource = arguments.datasource>
	
	<cfif StructKeyExists(arguments,"username") AND StructKeyExists(arguments,"password")>
		<cfset variables.username = arguments.username>
		<cfset variables.password = arguments.password>
	</cfif>
	
	<cfset variables.tables = StructNew()><!--- Used to internally keep track of table fields used by DataMgr --->
	<cfset variables.tableprops = StructNew()><!--- Used to internally keep track of tables properties used by DataMgr --->
	
	<!--- instructions for special processing decisions --->
	<cfset variables.nocomparetypes = "CF_SQL_LONGVARCHAR,CF_SQL_CLOB"><!--- Don't run comparisons against fields of these cf_datatypes for queries --->
	<cfset variables.dectypes = "CF_SQL_DECIMAL"><!--- Decimal types (shouldn't be rounded by DataMgr) --->
	<cfset variables.aggregates = "avg,count,max,min,sum">
	
	<!--- Information for logging --->
	<cfset variables.doLogging = false>
	<cfset variables.logtable = "datamgrLogs">
	
	<!--- This will make sure that if a database is passed the component for that database is returned --->
	<cfif StructKeyExists(arguments,"database") AND ListLast(getMetaData(this).name,".") eq "DataMgr">
		<cfif StructKeyExists(variables,"username") AND StructKeyExists(variables,"password")>
			<cfset this = CreateObject("component","DataMgr_#arguments.database#").init(datasource=arguments.datasource,username=arguments.username,password=arguments.password)>
		<cfelse>
			<cfset this = CreateObject("component","DataMgr_#arguments.database#").init(arguments.datasource)>
		</cfif>
	</cfif>
	
	<cfreturn this>
</cffunction>

<cffunction name="clean" access="public" returntype="struct" output="no" hint="I return a clean version (stripped of MS-Word characters) of the given structure.">
	<cfargument name="Struct" type="struct" required="yes">
	
	<cfset var key = "">
	<cfset var sResult = StructNew()>
	
	<cfscript>
	for (key in arguments.Struct) {
		if ( Len(key) AND isSimpleValue(arguments.Struct[key]) ) {
			// Trim the field value. -- Don't do it! This causes trouble with encrypted strings
			//sResult[key] = Trim(sResult[key]);
			// Replace the special characters that Microsoft uses.
			sResult[key] = arguments.Struct[key];
			sResult[key] = Replace(sResult[key], Chr(8217), Chr(39), "ALL");// apostrophe / single-quote
			sResult[key] = Replace(sResult[key], Chr(8216), Chr(39), "ALL");// apostrophe / single-quote
			sResult[key] = Replace(sResult[key], Chr(8220), Chr(34), "ALL");// quotes
			sResult[key] = Replace(sResult[key], Chr(8221), Chr(34), "ALL");// quotes
			sResult[key] = Replace(sResult[key], Chr(8211), "-", "ALL");// dashes
			sResult[key] = Replace(sResult[key], Chr(8212), "-", "ALL");// dashes
		}
	}
	</cfscript>
	
	<cfreturn sResult>
</cffunction>

<cffunction name="createTable" access="public" returntype="string" output="no" hint="I take a table (for which the structure has been loaded) and create the table in the database.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var CreateSQL = getCreateSQL(arguments.tablename)>
	<cfset var thisSQL = "">
	
	<cfset var ii = 0><!--- generic counter --->
	<cfset var arrFields = getFields(arguments.tablename)><!--- table structure --->
	<cfset var increments = 0>
	
	<!--- Make sure table has no more than one increment field --->
	<cfloop index="ii" from="1" to="#ArrayLen(arrFields)#" step="1">
		<cfif arrFields[ii].Increment>
			<cfset increments = increments + 1>
		</cfif>
	</cfloop>
	<cfif increments GT 1>
		<cfthrow message="#arguments.tablename# has more than one increment field. A table is limited to only one increment field." type="DataMgr" errorcode="MultipleIncrements">
	</cfif>
	
	<!--- try to create table --->
	<cftry>
		<cfloop index="thisSQL" list="#CreateSQL#" delimiters=";"><cfif thisSQL CONTAINS " ">
			<cfset runSQL(thisSQL)>
		</cfif></cfloop>
		<cfcatch><!--- If the ceation fails, throw an error with the sql code used to create the database. --->
			<cfthrow message="SQL Error in Creation. Verify Datasource (#chr(34)##variables.datasource##chr(34)#) is valid." type="DataMgr" detail="#CreateSQL#" errorcode="CreateFailed">
		</cfcatch>
	</cftry>
	
	<cfreturn CreateSQL>
</cffunction>

<cffunction name="CreateTables" access="public" returntype="void" output="no" hint="I create any tables that I know should exist in the database but don't.">
	<cfargument name="tables" type="string" default="#variables.tables#" hint="I am a list of tables to create. If I am not provided createTables will try to create any table that has been loaded into it but does not exist in the database.">

	<cfset var table = "">
	<cfset var dbtables = "">
	<cfset var tablesExist = StructNew()>
	<cfset var qTest = 0>
	<cfset var FailedSQL = "">
	
	<cftry><!--- Try to get a list of tables load in DataMgr --->
		<cfset dbtables = getDatabaseTables()>
	<cfcatch>
	</cfcatch>
	</cftry>
	
	<cfif Len(dbtables)><!--- If we have tables loaded in DataMgr --->
		<cfloop index="table" list="#arguments.tables#">
			<!--- See if this table is loaded in DataMgr --->
			<cfif ListFindNoCase(dbtables, table)>
				<cfset tablesExist[table] = true>
			<cfelse>
				<cfset tablesExist[table] = false><!--- Creatare any table not already loaded in DataMgr --->
			</cfif>
		</cfloop>
	<cfelse><!--- If we don't have tables loaded in DataMgr --->
		<cfloop index="table" list="#arguments.tables#">
			<!--- Assume table exists and then try to run a SQL statement against it --->
			<cfset tablesExist[table] = true>
			<cftry><!--- create any table on which a select statement errors --->
				<cfset qTest = runSQL("SELECT #getMaxRowsPrefix(1)# #escape(variables.tables[table][1].ColumnName)# FROM #escape(table)# #getMaxRowsSuffix(1)#")>
				<cfcatch>
					<cfset tablesExist[table] = false>
				</cfcatch>
			</cftry>
		</cfloop>
	</cfif>
	
	<cfloop index="table" list="#arguments.tables#">
		<!--- Create table if it doesn't exist --->
		<cfif NOT tablesExist[table]>
			<cftry>
				<cfset createTable(table)>
				<cfcatch type="DataMgr">
					<cfif Len(CFCATCH.Detail)>
						<cfset FailedSQL = ListAppend(FailedSQL,CFCATCH.Detail,";")>
					<cfelse>
						<cfset FailedSQL = ListAppend(FailedSQL,CFCATCH.Message,";")>
					</cfif>
				</cfcatch>
			</cftry>
		</cfif>
	</cfloop>
	
	<cfif Len(FailedSQL)>
		<cfthrow message="SQL Error in Creation. Verify Datasource (#chr(34)##variables.datasource##chr(34)#) is valid." type="DataMgr" detail="#FailedSQL#" errorcode="CreateFailed">
	</cfif>
	
</cffunction>

<cffunction name="deleteRecord" access="public" returntype="void" output="no" hint="I delete the record with the given Primary Key(s).">
	<cfargument name="tablename" type="string" required="yes" hint="The name of the table from which to delete a record.">
	<cfargument name="data" type="struct" required="yes" hint="A structure indicating the record to delete. A key indicates a field. The structure should have a key for each primary key in the table.">
	
	<cfset var i = 0><!--- just a counter --->
	<cfset var fields = getUpdateableFields(arguments.tablename)>
	<cfset var pkfields = getPKFields(arguments.tablename)><!--- the primary key fields for this table --->
	<cfset var rfields = getRelationFields(arguments.tablename)><!--- relation fields in table --->
	<cfset var in = arguments.data><!--- The incoming data structure --->
	<cfset var isLogicalDelete = false>
	<cfset var qRelationList = 0>
	<cfset var qRecord = 0>
	<cfset var relatefield = 0>
	<cfset var sqlarray = ArrayNew(1)>
	<cfset var out = 0>
	<cfset var subdatum = StructNew()>
	<cfset var temp2 = 0>
	
	<cfset var pklist = "">
	
	<!--- Make list of primary key fields --->
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfset pklist = ListAppend(pklist,pkfields[i].ColumnName)>
	</cfloop>
	
	<!--- Throw exception if any pkfields are missing from incoming data --->
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfif NOT StructKeyExists(in,pkfields[i].ColumnName)>
			<cfthrow errorcode="RequiresAllPkFields" message="All Primary Key fields (#pklist#) must be used when deleting a record. (Passed = #StructKeyList(in)#)" type="DataMgr">
		</cfif>
	</cfloop>
	
	<!--- Get the record containing the given data --->
	<cfset qRecord = getRecord(arguments.tablename,in)>
	
	<!--- Look for DeletionMark field --->
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif StructKeyExists(fields[i],"Special") AND fields[i].Special eq "DeletionMark">
			<cfif fields[i].CF_DataType eq "CF_SQL_BIT">
				<cfset in[fields[i].ColumnName] = 1>
				<cfset isLogicalDelete = true>
			<cfelseif fields[i].CF_DataType eq "CF_SQL_DATE">
				<cfset in[fields[i].ColumnName] = now()>
				<cfset isLogicalDelete = true>
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- Look for onDelete errors --->
	<cfloop index="i" from="1" to="#ArrayLen(rfields)#" step="1">
		<cfif StructKeyExists(rfields[i].Relation,"onDelete") AND StructKeyExists(rfields[i].Relation,"onDelete") AND rfields[i].Relation["onDelete"] eq "Error">
			<cfif rfields[i].Relation["type"] eq "list" OR ListFindNoCase(variables.aggregates,rfields[i].Relation["type"])>
				
				<cfset subdatum.data = StructNew()>
				<cfset subdatum.advsql = StructNew()>
				
				<cfif StructKeyExists(rfields[i].Relation,"join-table")>
					<cfset subdatum.subadvsql = StructNew()>
					<cfset subdatum.subadvsql.WHERE = "#escape( rfields[i].Relation['join-table'] & '.' & rfields[i].Relation['join-table-field-remote'] )# = #escape( rfields[i].Relation['table'] & '.' & rfields[i].Relation['remote-table-join-field'] )#">
					<cfset subdatum.data[rfields[i].Relation["local-table-join-field"]] = qRecord[rfields[i].Relation["join-table-field-local"]][1]>
					<cfsavecontent variable="subdatum.advsql.WHERE">
					EXISTS (
						#getRecordsSQL(tablename=rfields[i].Relation["join-table"],advsql=subdatum.subadvsql)#
					)
					</cfsavecontent>
				<cfelse>
					<cfset subdatum.data[rfields[i].Relation["join-field-remote"]] = qRecord[rfields[i].Relation["join-field-local"]][1]>
				</cfif>
				
				<cfset qRelationList = getRecords(tablename=rfields[i].Relation["table"],data=subdatum.data,fieldlist=rfields[i].Relation["field"],advsql=subdatum.advsql)>
				
				<cfif qRelationList.RecordCount>
					<cfthrow message="You cannot delete a record in #arguments.tablename# when associated records exist in #rfields[i].Relation.table#." type="DataMgr" errorcode="NoDeletesWithRelated">
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- Look for onDelete cascade --->
	<cfloop index="i" from="1" to="#ArrayLen(rfields)#" step="1">
		<cfif StructKeyExists(rfields[i].Relation,"onDelete") AND StructKeyExists(rfields[i].Relation,"onDelete") AND rfields[i].Relation["onDelete"] eq "Cascade">
			<cfif rfields[i].Relation["type"] eq "list" OR ListFindNoCase(variables.aggregate,rfields[i].Relation["type"])>
				
				<cfset out = StructNew()>
				
				<cfif StructKeyExists(rfields[i].Relation,"join-table")>	
					<cfset out[rfields[i].Relation["join-table-field-local"]] = in[rfields[i].Relation["local-table-join-field"]]>
					<cfset deleteRecords(rfields[i].Relation["join-table"],out)>
				<cfelse>
					<cfset out[rfields[i].Relation["join-table-field-remote"]] = qRecord[rfields[i].Relation["join-table-field-local"]][1]>
					<cfset deleteRecords(rfields[i].Relation["table"],out)>
				</cfif>
				
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- Perform the delete --->
	<cfif isLogicalDelete>
		<cfset updateRecord(arguments.tablename,in)>
	<cfelse>
		<!--- Delete Record --->
		<cfset sqlarray = ArrayNew(1)>
		<cfset ArrayAppend(sqlarray,"DELETE FROM	#escape(arguments.tablename)# WHERE	1 = 1")>
		<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
			<cfset ArrayAppend(sqlarray,"	AND	#escape(pkfields[i].ColumnName)# = ")>
			<cfset ArrayAppend(sqlarray,sval(pkfields[i],in))>
		</cfloop>
		<cfset runSQLArray(sqlarray)>
		
		<!--- Log delete --->
		<cfif variables.doLogging AND NOT arguments.tablename eq variables.logtable>
			<cfinvoke method="logAction">
				<cfinvokeargument name="tablename" value="#arguments.tablename#">
				<cfif ArrayLen(pkfields) eq 1 AND StructKeyExists(in,pkfields[1].ColumnName)>
					<cfinvokeargument name="pkval" value="#in[pkfields[1].ColumnName]#">
				</cfif>
				<cfinvokeargument name="action" value="delete">
				<cfinvokeargument name="data" value="#in#">
				<cfinvokeargument name="sql" value="#sqlarray#">
			</cfinvoke>
		</cfif>
		
	</cfif>

</cffunction>

<cffunction name="getDatabase" access="public" returntype="string" output="no" hint="I return the database platform being used (Access,MS SQL,MySQL etc).">
	<cfreturn "unknown"><!--- This method will get overridden in database-specific DataMgr components --->
</cffunction>

<cffunction name="getDatabaseShortString" access="public" returntype="string" output="no" hint="I return the string that can be found in the driver or JDBC URL for the database platform being used.">
	<cfreturn "unknown"><!--- This method will get overridden in database-specific DataMgr components --->
</cffunction>

<cffunction name="getDatasource" access="public" returntype="string" output="no" hint="I return the datasource used by this Data Manager.">
	<cfreturn variables.datasource>
</cffunction>

<cffunction name="getDBFieldList" access="public" returntype="string" output="no" hint="I return a list of fields in the database for the given table.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var qFields = runSQL("SELECT	#getMaxRowsPrefix(1)# * FROM #escape(arguments.tablename)# #getMaxRowsSuffix(1)#")>
	
	<cfreturn qFields.ColumnList>
</cffunction>

<cffunction name="getFieldList" access="public" returntype="string" output="no" hint="I get a list of fields in DataMgr for the given table.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var i = 0>
	<cfset var fieldlist = "">
	<cfset var bTable = checkTable(arguments.tablename)>
	
	<cfif StructKeyExists(variables.tableprops,arguments.tablename) AND StructKeyExists(variables.tableprops[arguments.tablename],"fieldlist")>
		<cfset fieldlist = variables.tableprops[arguments.tablename]["fieldlist"]>
	<cfelse>
		<!--- Loop over the fields in the table and make a list of them --->
		<cfif StructKeyExists(variables.tables,arguments.tablename)>
			<cfloop index="i" from="1" to="#ArrayLen(variables.tables[arguments.tablename])#" step="1">
				<cfset fieldlist = ListAppend(fieldlist, variables.tables[arguments.tablename][i].ColumnName)>
			</cfloop>
		</cfif>
		<cfset variables.tableprops[arguments.tablename]["fieldlist"] = fieldlist>
	</cfif>
	
	<cfreturn fieldlist>
</cffunction>

<cffunction name="getFields" access="public" returntype="array" output="no" hint="I return an array of all real fields in the given table in DataMgr.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var i = 0><!--- counter --->
	<cfset var arrFields = ArrayNew(1)><!--- array of fields --->
	<cfset var bTable = checkTable(arguments.tablename)><!--- Check whether table is loaded --->
	
	<!--- Loop over the fields and make an array of them --->
	<cfloop index="i" from="1" to="#ArrayLen(variables.tables[arguments.tablename])#" step="1">
		<cfif NOT StructKeyExists(variables.tables[arguments.tablename][i],"Relation")>
			<cfset ArrayAppend(arrFields, variables.tables[arguments.tablename][i])>
		</cfif>
	</cfloop>
	
	<cfreturn arrFields>
</cffunction>

<cffunction name="getMaxRowsPrefix" access="public" returntype="string" output="no" hint="I get the SQL before the field list in the select statement to limit the number of rows.">
	<cfargument name="maxrows" type="numeric" required="yes">
	
	<cfreturn "TOP #arguments.maxrows# ">
</cffunction>

<cffunction name="getMaxRowsSuffix" access="public" returntype="string" output="no" hint="I get the SQL after the query to limit the number of rows.">
	<cfargument name="maxrows" type="numeric" required="yes">
	
	<cfreturn "">
</cffunction>

<cffunction name="getNewSortNum" access="public" returntype="numeric" output="no" hint="I get the value an increment higher than the highest value in the given field to put a record at the end of the sort order.">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="sortfield" type="string" required="yes" hint="The field holding the sort order.">
	
	<cfset var qLast = 0>
	<cfset var result = 0>
	
	<cfset qLast = runSQL("SELECT Max(#escape(arguments.sortfield)#) AS #escape(arguments.sortfield)# FROM #escape(arguments.tablename)#")>
	
	<cfif qLast.RecordCount and isNumeric(qLast[arguments.sortfield][1])>
		<cfset result = qLast[arguments.sortfield][1] + 1>
	<cfelse>
		<cfset result = 1>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="getPKFields" access="public" returntype="array" output="no" hint="I return an array of primary key fields.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var bTable = checkTable(arguments.tablename)><!--- Check whether table is loaded --->
	<cfset var i = 0><!--- counter --->
	<cfset var arrFields = ArrayNew(1)><!--- array of primarykey fields --->
	
	<!--- If pkfields data if stored --->
	<cfif StructKeyExists(variables.tableprops,arguments.tablename) AND StructKeyExists(variables.tableprops[arguments.tablename],"pkfields")>
		<cfset arrFields = variables.tableprops[arguments.tablename]["pkfields"]>
	<cfelse>
		<cfloop index="i" from="1" to="#ArrayLen(variables.tables[arguments.tablename])#" step="1">
			<cfif StructKeyExists(variables.tables[arguments.tablename][i],"PrimaryKey") AND variables.tables[arguments.tablename][i].PrimaryKey>
				<cfset ArrayAppend(arrFields, variables.tables[arguments.tablename][i])>
			</cfif>
		</cfloop>
		<cfset variables.tableprops[arguments.tablename]["pkfields"] = arrFields>
	</cfif>
	
	<cfreturn arrFields>
</cffunction>

<cffunction name="getPrimaryKeyField" access="public" returntype="struct" output="no" hint="I return primary key field for this table.">
	<cfargument name="tablename" type="string" required="yes" hint="The table from which to return a primary key.">
	
	<cfset var aPKFields = getPKFields(arguments.tablename)>
	
	<cfif ArrayLen(aPKFields) NEQ 1>
		<cfthrow message="The #arguments.tablename# does not have a simple primary key and so it cannot be used for this purpose." type="DataMgr" errorcode="NoSimplePrimaryKey">
	</cfif>
	
	<cfreturn aPKFields[1]>
</cffunction>

<cffunction name="getPrimaryKeyFieldName" access="public" returntype="string" output="no" hint="I return primary key field for this table.">
	<cfargument name="tablename" type="string" required="yes" hint="The table from which to return a primary key.">
	
	<cfset var sField = getPrimaryKeyField(arguments.tablename)>
	
	<cfreturn sField.ColumnName>
</cffunction>

<cffunction name="getPKFromData" access="public" returntype="string" output="no" hint="I get the primary key of the record matching the given data.">
	<cfargument name="tablename" type="string" required="yes" hint="The table from which to return a primary key.">
	<cfargument name="fielddata" type="struct" required="yes" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	
	<cfset var qPK = 0><!--- The query used to get the primary key --->
	<cfset var fields = getUpdateableFields(arguments.tablename)><!--- The (non-primarykey) fields for this table --->
	<cfset var pkfields = getPKFields(arguments.tablename)><!--- The primary key field(s) for this table --->
	<cfset var result = 0><!--- The result of this method --->
	
	<!--- This method is only to be used on fields with one pkfield --->
	<cfif ArrayLen(pkfields) NEQ 1>
		<cfthrow message="This method can only be used on tables with exactly one primary key field." type="DataMgr" errorcode="NeedOnePKField">
	</cfif>
	<!--- This method can only be used on tables with updateable fields --->
	<cfif NOT ArrayLen(fields)>
		<cfthrow message="This method can only be used on tables with updateable fields." type="DataMgr" errorcode="NeedUpdateableField">
	</cfif>
	
	<!--- Run query to get primary key value from data fields --->
	<cfset qPK = getRecords(tablename=arguments.tablename,data=arguments.fielddata,fieldlist=pkfields[1].ColumnName)>
	
	<cfif qPK.RecordCount eq 1>
		<cfset result = qPK[pkfields[1].ColumnName][1]>
	<cfelse>
		<cfthrow message="Data Manager: A unique record could not be identified from the given data." type="DataMgr" errorcode="NoUniqueRecord">
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="getRecord" access="public" returntype="query" output="no" hint="I get a recordset based on the primary key value(s) given.">
	<cfargument name="tablename" type="string" required="yes" hint="The table from which to return a record.">
	<cfargument name="data" type="struct" required="yes" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key. Every primary key field should be included.">
	<cfargument name="fieldlist" type="string" default="" hint="A list of fields to return. If left blank, all fields will be returned.">
	
	<cfset var i = 0><!--- A generic counter --->
	<cfset var pkfields = getPKFields(arguments.tablename)>
	<cfset var fields = getUpdateableFields(arguments.tablename)>
	<cfset var in = arguments.data>
	<cfset var totalfields = 0><!--- count of fields --->
	
	<!--- Figure count of fields --->
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfif StructKeyExists(in,pkfields[i].ColumnName) AND isOfType(in[pkfields[i].ColumnName],pkfields[i].CF_DataType)>
			<cfset totalfields = totalfields + 1>
		</cfif>
	</cfloop>
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif StructKeyExists(in,fields[i].ColumnName) AND isOfType(in[fields[i].ColumnName],fields[i].CF_DataType)>
			<cfset totalfields = totalfields + 1>
		</cfif>
	</cfloop>
	
	<!--- Make sure at least one field is passed in --->
	<cfif totalfields eq 0>
		<cfthrow message="The data argument of getRecord must contain at least one field from the #arguments.tablename# table. To get all records, use the getRecords method." type="DataMgr" errorcode="NeedWhereFields">
	</cfif>
	
	<cfreturn getRecords(tablename=arguments.tablename,data=in,fieldlist=arguments.fieldlist)>
</cffunction>

<cffunction name="getRecords" access="public" returntype="query" output="no" hint="I get a recordset based on the data given.">
	<cfargument name="tablename" type="string" required="yes" hint="The table from which to return a record.">
	<cfargument name="data" type="struct" required="no" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	<cfargument name="orderBy" type="string" default="">
	<cfargument name="maxrows" type="numeric" required="no">
	<cfargument name="fieldlist" type="string" default="" hint="A list of fields to return. If left blank, all fields will be returned.">
	<cfargument name="advsql" type="struct" hint="(Development Only) A structure of sqlarrays for each area of a query (SELECT,FROM,WHERE,ORDER BY).">
	
	<cfset var qRecords = 0><!--- The recordset to return --->
	<cfset var rfields = getRelationFields(arguments.tablename)><!--- relation fields in table --->
	<cfset var i = 0><!--- Generic counter --->
	<cfset var hasLists = false>
	<cfset var qRelationList = 0>
	<cfset var temp = 0>

	<!--- Get records --->
	<cfset qRecords = runSQLArray(getRecordsSQL(argumentCollection=arguments))>
	
	<!--- Check for list values in recordset --->
	<cfloop index="i" from="1" to="#ArrayLen(rfields)#" step="1">
		<cfif ListFindNoCase(qRecords.ColumnList,rfields[i].ColumnName)>
			<cfif rfields[i].Relation.type eq "list">
				<cfset hasLists = true>
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- Get list values --->
	<cfif hasLists>
		<cfloop query="qRecords">
			<cfloop index="i" from="1" to="#ArrayLen(rfields)#" step="1">
				<cfif rfields[i].Relation["type"] eq "list" AND ListFindNoCase(qRecords.ColumnList,rfields[i].ColumnName)>
					<cfset fillOutJoinTableRelations(arguments.tablename)>
					<cfset temp = StructNew()>
					<cfset temp.tablename = rfields[i].Relation["table"]>
					<cfset temp.fieldlist = rfields[i].Relation["field"]>
					<cfset temp.advsql = StructNew()>
					<cfset temp.advsql.WHERE = ArrayNew(1)>
					<cfif StructKeyExists(rfields[i].Relation,"sort-field")>
						<cfset temp["orderBy"] = rfields[i].Relation["sort-field"]>
					</cfif>
					
					<cfif StructKeyExists(rfields[i].Relation,"join-table")>
						<cfset temp.join = StructNew()>
						<cfset temp.join["table"] = rfields[i].Relation["join-table"]>
						<cfset temp.join["onleft"] = rfields[i].Relation["remote-table-join-field"]>
						<cfset temp.join["onright"] = rfields[i].Relation["join-table-field-remote"]>
						<cfset ArrayAppend(temp.advsql.WHERE,"#escape(rfields[i].Relation['join-table'] & '.' & rfields[i].Relation['join-table-field-local'] )# = ")>
						<cfset ArrayAppend(temp.advsql.WHERE,sval(getField(arguments.tablename,rfields[i].Relation["local-table-join-field"]),qRecords[rfields[i].ColumnName][CurrentRow]))>
					<cfelse>
						<cfset ArrayAppend(temp.advsql.WHERE,"#escape(rfields[i].Relation['table'] & '.' & rfields[i].Relation['join-field-remote'] )# = ")>
						<cfset ArrayAppend(temp.advsql.WHERE,sval(getField(arguments.tablename,rfields[i].Relation["join-field-local"]),qRecords[rfields[i].ColumnName][CurrentRow]))>
					</cfif>
					<cfset qRelationList = getRecords(argumentCollection=temp)>
					
					<cfset temp = "">
					<cfoutput query="qRelationList">
						<cfif StructKeyExists(rfields[i].Relation,"delimiter")>
							<cfset temp = ListAppend(temp,qRelationList[rfields[i].Relation["field"]][CurrentRow],rfields[i].Relation["delimiter"])>
						<cfelse>
							<cfset temp = ListAppend(temp,qRelationList[rfields[i].Relation["field"]][CurrentRow])>
						</cfif>
						
					</cfoutput>
					<cfset QuerySetCell(qRecords, rfields[i].ColumnName, temp, CurrentRow)>
					
				</cfif>
			</cfloop>
		</cfloop>
	</cfif>
	
	<cfreturn qRecords>
</cffunction>

<cffunction name="getRecordsSQL" access="public" returntype="array" output="no" hint="I get the SQL to get a recordset based on the data given.">
	<cfargument name="tablename" type="string" required="yes" hint="The table from which to return a record.">
	<cfargument name="data" type="struct" required="no" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	<cfargument name="orderBy" type="string" default="">
	<cfargument name="maxrows" type="numeric" required="no">
	<cfargument name="fieldlist" type="string" default="" hint="A list of fields to return. If left blank, all fields will be returned.">
	<cfargument name="function" type="string" default="" hint="A function to run against the results.">
	<cfargument name="advsql" type="struct" hint="(Development Only) A structure of sqlarrays for each area of a query (SELECT,FROM,WHERE,ORDER BY).">
	
	<cfset var fields = getUpdateableFields(arguments.tablename)><!--- non primary-key fields in table --->
	<cfset var in = StructNew()><!--- holder for incoming data (just for readability) --->
	<cfset var pkfields = getPKFields(arguments.tablename)><!--- primary key fields in table --->
	<cfset var rfields = getRelationFields(arguments.tablename)><!--- relation fields in table --->
	<cfset var i = 0><!--- Generic counter --->
	<cfset var colnum = 1>
	<cfset var sqlarray = ArrayNew(1)>
	<cfset var hasLists = false>
	
	<cfif StructKeyExists(arguments,"data")>
		<cfset in = arguments.data>
	</cfif>
	
	<cfif NOT StructKeyExists(arguments,"tablealias")>
		<cfset arguments.tablealias = arguments.tablename>
	</cfif>
	
	<!--- Check for Sorter --->
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif StructKeyExists(fields[i],"Special") AND fields[i].Special eq "Sorter">
			<cfif NOT Len(function) OR ( Len(arguments.fieldlist) eq 0 OR ListFindNoCase(arguments.fieldlist, fields[i].ColumnName) )>
				<cfif NOT ( ListFindNoCase(arguments.orderBy,fields[i].ColumnName) OR ListFindNoCase(arguments.orderBy,escape(fields[i].ColumnName)) )>
					<cfset arguments.orderBy = ListAppend(arguments.orderBy,fields[i].ColumnName)>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- Get Records --->
	<cfset ArrayAppend(sqlarray,"SELECT")>
	<cfif StructKeyExists(arguments,"maxrows")>
		<cfset ArrayAppend(sqlarray,getMaxRowsPrefix(arguments.maxrows))>
	</cfif>
	<cfif Len(arguments.function)>
		<cfif Len(arguments.fieldlist)>
			<cfset ArrayAppend(sqlarray,"#arguments.function#(#escape(arguments.fieldlist)#) AS DataMgr_FunctionResult")>
		<cfelse>
			<cfset ArrayAppend(sqlarray,"#arguments.function#(*) AS DataMgr_FunctionResult")>
		</cfif>
		<cfset colnum = colnum + 1>
	<cfelse>
		<!--- select primary key fields --->
		<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
			<cfif Len(arguments.fieldlist) eq 0 OR ListFindNoCase(arguments.fieldlist, pkfields[i].ColumnName)>
				<cfif colnum gt 1><cfset ArrayAppend(sqlarray,",")></cfif>
				<cfset colnum = colnum + 1>
				<cfset ArrayAppend(sqlarray,"#escape(arguments.tablename & '.' & pkfields[i].ColumnName)#")>
			</cfif>
		</cfloop>
		<!--- select updateable fields --->
		<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
			<cfif Len(arguments.fieldlist) eq 0 OR ListFindNoCase(arguments.fieldlist, fields[i].ColumnName)>
				<cfif colnum gt 1><cfset ArrayAppend(sqlarray,",")></cfif>
				<cfset colnum = colnum + 1>
				<cfset ArrayAppend(sqlarray,"#escape(arguments.tablename & '.' & fields[i].ColumnName)#")>
			</cfif>
		</cfloop>
		<!--- select relational fields --->
		<cfloop index="i" from="1" to="#ArrayLen(rfields)#" step="1">
			<cfif Len(arguments.fieldlist) eq 0 OR ListFindNoCase(arguments.fieldlist, rfields[i].ColumnName)>
				<cfif colnum gt 1><cfset ArrayAppend(sqlarray,",")></cfif>
				<cfset colnum = colnum + 1>
				<cfset ArrayAppend(sqlarray,getFieldSelectSQL(arguments.tablename,rfields[i]["ColumnName"],arguments.tablealias))>
				<cfif rfields[i].Relation.type EQ "list">
					<cfset hasLists = true>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	<cfif StructKeyExists(arguments,"advsql") AND StructKeyExists(arguments.advsql,"SELECT")>
		<cfset ArrayAppend(sqlarray,",")><cfset colnum = colnum + 1>
		<cfset ArrayAppend(sqlarray,arguments.advsql["SELECT"])>
	</cfif>
	
	<!--- Make sure at least one field is retrieved --->
	<cfif colnum eq 1>
		<cfthrow message="At least one valid field must be retrieved from the #arguments.tablename# table (actual fields in table are: #getDBFieldList(arguments.tablename)#) (requested fields: #arguments.fieldlist#)." type="DataMgr" errorcode="NeedSelectFields">
	</cfif>
	<cfset ArrayAppend(sqlarray,"FROM		#escape(arguments.tablename)#")>
	<cfif StructKeyExists(arguments,"advsql") AND StructKeyExists(arguments.advsql,"FROM")>
		<cfset ArrayAppend(sqlarray,arguments.advsql["FROM"])>
	</cfif>
	<cfif StructKeyExists(arguments,"join") AND StructKeyExists(arguments.join,"table")>
		<cfif StructKeyExists(arguments.join,"type") AND ListFindNoCase("inner,left,right", arguments.join.type)>
			<cfset ArrayAppend(sqlarray,"#UCase(arguments.join.type)# JOIN #escape(arguments.join.table)#")>
		<cfelse>
			<cfset ArrayAppend(sqlarray,"INNER JOIN #escape(arguments.join.table)#")>
		</cfif>
		<cfset ArrayAppend(sqlarray,"	ON		#escape( arguments.tablealias & '.' & arguments.join.onleft )# = #escape( arguments.join.table & '.' & arguments.join.onright )#")>
	</cfif>
	<cfset ArrayAppend(sqlarray,"WHERE		1 = 1")>
	<!--- filter by primary keys --->
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfif StructKeyExists(in,pkfields[i].ColumnName) AND isOfType(in[pkfields[i].ColumnName],pkfields[i].CF_DataType)>
			<cfset ArrayAppend(sqlarray,"AND		#escape(pkfields[i].ColumnName)# = ")>
			<cfset ArrayAppend(sqlarray,sval(pkfields[i],in))>
		</cfif>
	</cfloop>
	<!--- filter by updateable fields --->
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif useField(in,fields[i]) AND NOT ListFindNoCase(variables.nocomparetypes,fields[i].CF_DataType)>
			<cfset ArrayAppend(sqlarray,"AND		#escape(fields[i].ColumnName)# = ")>
			<cfset ArrayAppend(sqlarray,sval(fields[i],in))>
		<cfelseif StructKeyExists(fields[i],"Special") AND fields[i].Special eq "DeletionMark">
			<!--- Make sure not to get records that have been logically deleted --->
			<cfset ArrayAppend(sqlarray,"AND		(#escape(fields[i].ColumnName)# = 0 OR #escape(fields[i].ColumnName)# IS NULL)")>
		</cfif>
	</cfloop>
	<!--- Filter by relations --->
	<cfloop index="i" from="1" to="#ArrayLen(rfields)#" step="1">
		<cfif StructKeyExists(in,rfields[i].ColumnName)>
			<cfset ArrayAppend(sqlarray,getFieldWhereSQL(arguments.tablename,rfields[i]["ColumnName"],in,arguments.tablealias))>
		</cfif>
	</cfloop>
	<cfif StructKeyExists(arguments,"advsql") AND StructKeyExists(arguments.advsql,"WHERE")>
		<cfif NOT ( isSimpleValue(arguments.advsql["WHERE"]) AND Left(Trim(arguments.advsql["WHERE"]),3) EQ "AND" )>
			<cfset ArrayAppend(sqlarray,"AND")>
		</cfif>
		<cfset ArrayAppend(sqlarray,arguments.advsql["WHERE"])>
	</cfif>
	<!--- query order --->
	<cfif StructKeyExists(arguments,"advsql") AND StructKeyExists(arguments.advsql,"ORDER BY")>
		<cfif Len(arguments.orderBy) OR StructKeyExists(arguments,"maxrows")>
			<cfset ArrayAppend(sqlarray,",")>
		<cfelse>
			<cfset ArrayAppend(sqlarray,"ORDER BY	")>
		</cfif>
		<cfset ArrayAppend(sqlarray,arguments.advsql["ORDER BY"])>
	<cfelseif Len(arguments.orderBy)>
		<cfset ArrayAppend(sqlarray,"ORDER BY	#arguments.orderBy#")>
		
	<cfelseif StructKeyExists(arguments,"maxrows")>
		<cfset ArrayAppend(sqlarray,"ORDER BY	")>
		<cfif ArrayLen(pkfields) AND pkfields[1].CF_DataType eq "CF_SQL_INTEGER" AND ( ListFindNoCase(arguments.fieldlist,pkfields[1].ColumnName) OR NOT Len(arguments.fieldlist) )>
			<cfif Len(arguments.function)>
				<cfset ArrayAppend(sqlarray,"#arguments.function#(#escape(pkfields[1].ColumnName)#)")>
			<cfelse>
				<cfset ArrayAppend(sqlarray,"#escape(arguments.tablealias & '.' & pkfields[1].ColumnName)#")>
			</cfif>
		<cfelseif Len(arguments.fieldlist)>
			<cfif Len(arguments.function)>
				<cfset ArrayAppend(sqlarray,"#arguments.function#(#escape(arguments.fieldlist)#)")>
			<cfelse>
				<cfset ArrayAppend(sqlarray,"#escape(arguments.fieldlist)#")>
			</cfif>
		<cfelse>
			<cfif Len(arguments.function)>
				<cfset ArrayAppend(sqlarray,"#arguments.function#(#escape(fields[1].ColumnName)#)")>
			<cfelse>
				<cfset ArrayAppend(sqlarray,"#escape(fields[1].ColumnName)#")>
			</cfif>
		</cfif>
	</cfif>
	<cfif StructKeyExists(arguments,"maxrows")>
		<cfset ArrayAppend(sqlarray,"#getMaxRowsSuffix(arguments.maxrows)#")>
	</cfif>
	
	<cfreturn sqlarray>
</cffunction>

<cffunction name="getFieldSelectSQL" access="public" returntype="any" output="no">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="field" type="string" required="yes">
	<cfargument name="tablealias" type="string" required="no">
	<cfargument name="useFieldAlias" type="boolean" default="true">
	
	<cfset var sField = getField(arguments.tablename,arguments.field)>
	<cfset var aSQL = ArrayNew(1)>
	<cfset var sAdvSQL = StructNew()>
	<cfset var sJoin = StructNew()>
	<cfset var sArgs = StructNew()>
	<cfset var temp = "">
	
	<cfif NOT StructKeyExists(arguments,"tablealias")>
		<cfset arguments.tablealias = arguments.tablename>
	</cfif>
	
	<cfif StructKeyExists(sField,"Relation") AND StructKeyExists(sField.Relation,"type")>
		<cfset ArrayAppend(aSQL,"(")>
		<cfswitch expression="#sField.Relation.type#">
		<cfcase value="label">
			<cfset sAdvSQL = StructNew()>
			<cfset sAdvSQL["WHERE"] = ArrayNew(1)>
			<cfset ArrayAppend(sAdvSQL["WHERE"], getFieldSelectSQL(tablename=sField.Relation['table'],field=sField.Relation['join-field-remote'],useFieldAlias=false) )>
			<cfset ArrayAppend(sAdvSQL["WHERE"], " = " )>
			<!--- <cfset ArrayAppend(sAdvSQL["WHERE"], "#escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#" )> --->
			<cfset ArrayAppend(sAdvSQL["WHERE"], getFieldSelectSQL(tablename=arguments.tablename,field=sField.Relation['join-field-local'],tablealias=arguments.tablealias,useFieldAlias=false) )>
			<cfset ArrayAppend(aSQL,getRecordsSQL(tablename=sField.Relation["table"],fieldlist=sField.Relation["field"],maxrows=1,advsql=sAdvSQL))>
		</cfcase>
		<cfcase value="list">
			<cfif StructKeyExists(sField.Relation,"join-table")>
				<cfset temp = escape( arguments.tablealias & "." & sField.Relation["local-table-join-field"] )>
			<cfelse>
				<cfset temp = escape( arguments.tablealias & "." & sField.Relation["join-field-local"] )>
			</cfif>
			<cfset ArrayAppend(aSQL,concat(temp))>
		</cfcase>
		<cfcase value="concat">
			<cfset ArrayAppend(aSQL,"#concatFields(arguments.tablename,sField.Relation['fields'],sField.Relation['delimiter'],arguments.tablealias)#")>
		</cfcase>
		<cfcase value="avg,count,max,min,sum" delimiters=",">
			<cfset sAdvSQL = StructNew()>
			<cfif StructKeyExists(sField.Relation,"join-table")>
				<cfset sJoin = StructNew()>
				<cfset sJoin["table"] = sField.Relation["join-table"]>
				<cfset sJoin["onLeft"] = sField.Relation["remote-table-join-field"]>
				<cfset sJoin["onRight"] = sField.Relation["join-table-field-remote"]>
				<cfset sAdvSQL["WHERE"] = "#escape(sField.Relation['join-table'] & '.' & sField.Relation['join-table-field-local'].ColumnName)# = #escape(arguments.tablealias & '.' & sField.Relation['local-table-join-field'])#">
			<cfelse>
				<cfset sAdvSQL["WHERE"] = "#escape(sField.Relation['table'] & '.' & sField.Relation['join-field-remote'])# = #escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#">
			</cfif>
			<cfset sArgs["tablename"] = sField.Relation["table"]>
			<cfset sArgs["fieldlist"] = sField.Relation["field"]>
			<cfset sArgs["function"] = sField.Relation["type"]>
			<cfset sArgs["advsql"] = sAdvSQL>
			<cfset sArgs["join"] = sJoin>
			<cfif arguments.tablename EQ sField.Relation["table"]>
				<cfset sArgs["tablealias"] = "datamgr_inner_table">
			</cfif>
			<cfset ArrayAppend(aSQL,getRecordsSQL(argumentCollection=sArgs))>
		</cfcase>
		<cfcase value="custom">
			<cfif StructKeyExists(sField.Relation,"sql") AND Len(sField.Relation.sql)>
				<cfset ArrayAppend(aSQL,"#sField.Relation.sql#")>
			<cfelse>
				<cfset ArrayAppend(aSQL,"''")>
			</cfif>
		</cfcase>
		<cfdefaultcase>
			<cfset ArrayAppend(aSQL,"''")>
		</cfdefaultcase>
		</cfswitch>
		<cfset ArrayAppend(aSQL,")")>
		<cfif arguments.useFieldAlias>
			<cfset ArrayAppend(aSQL," AS #escape(sField['ColumnName'])#")>
		</cfif>
	<cfelse>
		<cfset ArrayAppend(aSQL,escape(arguments.tablealias & "." & sField["ColumnName"]))>
	</cfif>
	
	<cfreturn aSQL>
</cffunction>

<cffunction name="getFieldWhereSQL" access="public" returntype="any" output="no">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="field" type="string" required="yes">
	<cfargument name="data" type="struct" required="yes">
	<!--- <cfargument name="operator" type="string" default="="> --->
	<cfargument name="tablealias" type="string" required="no">
	
	<cfset var sField = getField(arguments.tablename,arguments.field)>
	<cfset var aSQL = ArrayNew(1)>
	<cfset var in = data>
	<cfset var sArgs = StructNew()>
	<cfset var temp = 0>
	<!--- <cfset var operators = "=,>,<,>=,<=,LIKE,NOT LIKE,<>,IN">
	
	<cfif NOT ListFindNoCase(operators,arguments.operator)>
		<cfthrow message="#arguments.operator# is not a valid operator. Valid operators are: #operators#" type="DataMgr" errorcode="InvalidOperator">
	</cfif> --->
	
	<cfif NOT StructKeyExists(arguments,"tablealias")>
		<cfset arguments.tablealias = arguments.tablename>
	</cfif>
	
	<cfif StructKeyExists(sField,"Relation") AND StructKeyExists(sField.Relation,"type")>
		<cfswitch expression="#sField.Relation.type#">
		<cfcase value="label">
			<cfset sArgs.tablename = sField.Relation["table"]>
			<cfset sArgs.fieldlist = sField.Relation["field"]>
			<cfset sArgs.maxrows = 1>
			<cfset sArgs.advsql = StructNew()>
			<cfset sArgs.data = StructNew()>
			
			<cfset ArrayAppend(aSQL,"AND	EXISTS (")>
				<cfset sArgs.data[sField.Relation["field"]] = in[sField.ColumnName]>
				<cfset sArgs.advsql["WHERE"] = "#escape(sField.Relation['table'] & '.' & sField.Relation['join-field-remote'])# = #escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#">
				<cfset sArgs.advsql["WHERE"] = "#escape(sField.Relation['table'] & '.' & sField.Relation['join-field-remote'])# = #escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#">
				<cfset ArrayAppend(aSQL,getRecordsSQL(argumentCollection=sArgs))>
			<cfset ArrayAppend(aSQL,")")>
		</cfcase>
		<cfcase value="list">
			<cfset sArgs.tablename = sField.Relation["table"]>
			<cfset sArgs.fieldlist = sField.Relation["field"]>
			<cfset sArgs.maxrows = 1>
			<cfset sArgs.join = StructNew()>
			<cfset sArgs.advsql = StructNew()>
			<cfset sArgs.advsql.WHERE = ArrayNew(1)>
			<cfset temp = ArrayNew(1)>
			
			<cfif StructKeyExists(sField.Relation,"join-table")>
				<cfset sArgs.join.table = sField.Relation["join-table"]>
				<cfset sArgs.join.onLeft = sField.Relation["remote-table-join-field"]>
				<cfset sArgs.join.onRight = sField.Relation["join-table-field-remote"]>
				<cfset ArrayAppend(sArgs.advsql.WHERE,"#escape(sField.Relation['join-table'] & '.' & sField.Relation['join-table-field-local'])# = #escape(arguments.tablealias & '.' & sField.Relation['local-table-join-field'])#")>
			<cfelse>
				<cfset ArrayAppend(sArgs.advsql.WHERE,"#escape(sField.Relation['table'] & '.' & sField.Relation['join-field-remote'])# = #escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#")>
			</cfif>
				<cfset ArrayAppend(sArgs.advsql.WHERE,"			AND		(")>
				<cfset ArrayAppend(sArgs.advsql.WHERE,"							1 = 0")>
				<cfloop index="temp" list="#in[sField.ColumnName]#">
					<cfset ArrayAppend(sArgs.advsql.WHERE,"					OR	#escape(sField.Relation['table'] & '.' & sField.Relation['field'])# = ")>
					<cfset ArrayAppend(sArgs.advsql.WHERE,sval(getField(sField.Relation["table"],sField.Relation["field"]),temp))>
				</cfloop>
				<cfset ArrayAppend(sArgs.advsql.WHERE,"					)")>
			
			<cfset ArrayAppend(aSQL,"AND	EXISTS (")>
				<cfset ArrayAppend(aSQL,getRecordsSQL(argumentCollection=sArgs))>
			<cfset ArrayAppend(aSQL,"		)")>
		</cfcase>
		<cfcase value="concat">
			<cfset ArrayAppend(aSQL,"AND	(")>
				<cfset ArrayAppend(aSQL,"#concat(sField.Relation['fields'],sField.Relation['delimiter'])#")>
			<cfset ArrayAppend(aSQL,")")>
			<cfset ArrayAppend(aSQL,"=")>
			<cfset ArrayAppend(aSQL,queryparam("CF_SQL_VARCHAR",in[sField.ColumnName]))>
		</cfcase>
		<cfcase value="avg,count,max,min,sum" delimiters=",">
			<cfset sArgs.tablename = sField.Relation["table"]>
			<cfset sArgs.fieldlist = sField.Relation["field"]>
			<cfset sArgs.advsql = StructNew()>
			<cfset sArgs.data = StructNew()>
			<cfset sArgs.join = StructNew()>
		
			<cfset sAdvSQL = StructNew()>
			<cfif StructKeyExists(sField.Relation,"join-table")>
				<cfset sArgs.join["table"] = sField.Relation["join-table"]>
				<cfset sArgs.join["onLeft"] = sField.Relation["remote-table-join-field"]>
				<cfset sArgs.join["onRight"] = sField.Relation["join-table-field-remote"]>
				<cfset sArgs.advsql["WHERE"] = "#escape(sField.Relation['join-table'] & '.' & sField.Relation['join-table-field-local'].ColumnName)# = #escape(arguments.tablealias & '.' & sField.Relation['local-table-join-field'])#">
			<cfelse>
				<cfset sArgs.advsql["WHERE"] = "#escape(sField.Relation['table'] & '.' & sField.Relation['join-field-remote'])# = #escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#">
			</cfif>
			<cfset sArgs["function"] = sField.Relation["type"]>
			<cfif arguments.tablename EQ sField.Relation["table"]>
				<cfset sArgs["tablealias"] = "datamgr_inner_table">
			</cfif>
			<cfset ArrayAppend(aSQL,"AND	(")>
				<cfset ArrayAppend(aSQL,getRecordsSQL(argumentCollection=sArgs))>
			<cfset ArrayAppend(aSQL,")")>
			<cfset ArrayAppend(aSQL,"=")>
			<cfset ArrayAppend(aSQL,Val(in[sField.ColumnName]))>
		</cfcase>
		<cfcase value="custom">
			<cfif StructKeyExists(sField.Relation,"sql") AND Len(sField.Relation.sql) AND StructKeyExists(sField.Relation,"CF_DataType")>
				<cfset ArrayAppend(aSQL,"AND	(")>
				<cfset ArrayAppend(aSQL,"#sField.Relation.sql#")>
				<cfset ArrayAppend(aSQL,")")>
				<cfset ArrayAppend(aSQL,"=")>
				<cfset ArrayAppend(aSQL,queryparam(cfsqltype=sField.Relation["CF_DataType"],value=in[sField.ColumnName]))>
			</cfif>
		</cfcase>
		</cfswitch>
	<cfelse>
		<cfset ArrayAppend(aSQL,escape(sField["ColumnName"]))>
	</cfif>
	
	<cfreturn aSQL>
</cffunction>

<cffunction name="getStringTypes" access="public" returntype="string" output="no" hint="I return a list of datypes that hold strings / character values."><cfreturn ""></cffunction>

<cffunction name="getSupportedDatabases" access="public" returntype="query" output="no" hint="I return the databases supported by this installation of DataMgr.">
	
	<cfset var qComponents = 0>
	<cfset var aComps = ArrayNew(1)>
	<cfset var i = 0>
	<cfset var qDatabases = QueryNew("Database,DatabaseName,shortstring")>
	
	<cfif StructKeyExists(variables,"databases") AND isQuery(variables.databases)>
		<cfset qDatabases = variables.databases>
	<cfelse>
		<cfdirectory action="LIST" directory="#GetDirectoryFromPath(GetCurrentTemplatePath())#" name="qComponents" filter="*.cfc">
		<cfloop query="qComponents">
			<cfif name CONTAINS "DataMgr_">
				<cftry>
					<cfset ArrayAppend(aComps,CreateObject("component","#ListFirst(name,'.')#").init(""))>
					<cfset QueryAddRow(qDatabases)>
					<cfset QuerySetCell(qDatabases, "Database", ReplaceNoCase(ListFirst(name,"."),"DataMgr_","") )>
					<cfset QuerySetCell(qDatabases, "DatabaseName", aComps[ArrayLen(aComps)].getDatabase() )>
					<cfset QuerySetCell(qDatabases, "shortstring", aComps[ArrayLen(aComps)].getDatabaseShortString() )>
					<cfcatch>
					</cfcatch>
				</cftry>
			</cfif>
		</cfloop>
		<cfset variables.databases = qDatabases>
	</cfif>

	<cfreturn qDatabases>
</cffunction>

<cffunction name="getTableData" access="public" returntype="struct" output="no" hint="I return information about all of the tables currently loaded into this instance of Data Manager.">
	<cfargument name="tablename" type="string" required="no">
	
	<cfset var sResult = 0>
	
	<cfif StructKeyExists(arguments,"tablename") AND Len(arguments.tablename) AND ListFindNoCase(StructKeyList(variables.tables),arguments.tablename)>
		<cfset checkTable(arguments.tablename)><!--- Check whether table is loaded --->
		<cfset sResult = StructNew()>
		<cfset sResult[arguments.tablename] = variables.tables[arguments.tablename]>
	<cfelse>
		<cfset sResult = variables.tables>
	</cfif>
	
	<cfreturn sResult>
</cffunction>

<cffunction name="getUpdateableFields" access="public" returntype="array" output="no" hint="I return an array of fields that can be updated.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var bTable = checkTable(arguments.tablename)><!--- Check whether table is loaded --->
	<cfset var i = 0><!--- counter --->
	<cfset var arrFields = ArrayNew(1)><!--- array of udateable fields --->
	
	<cfif StructKeyExists(variables.tableprops,arguments.tablename) AND StructKeyExists(variables.tableprops[arguments.tablename],"updatefields")>
		<cfset arrFields = variables.tableprops[arguments.tablename]["updatefields"]>
	<cfelse>
		<cfloop index="i" from="1" to="#ArrayLen(variables.tables[arguments.tablename])#" step="1">
			<!--- Make sure field isn't a relation --->
			<cfif NOT StructKeyExists(variables.tables[arguments.tablename][i],"Relation")>
				<!--- Make sure field isn't a primary key --->
				<cfif NOT StructKeyExists(variables.tables[arguments.tablename][i],"PrimaryKey") OR NOT variables.tables[arguments.tablename][i].PrimaryKey>
					<cfset ArrayAppend(arrFields, variables.tables[arguments.tablename][i])>
				</cfif>
			</cfif>
		</cfloop>
		<cfset variables.tableprops[arguments.tablename]["updatefields"] = arrFields>
	</cfif>
	
	<cfreturn arrFields>
</cffunction>

<cffunction name="getVersion" access="public" returntype="string" output="no">
	<cfreturn variables.DataMgrVersion>
</cffunction>

<cffunction name="insertRecord" access="public" returntype="string" output="no" hint="I insert a record into the given table with the provided data and do my best to return the primary key of the inserted record.">
	<cfargument name="tablename" type="string" required="yes" hint="The table in which to insert data.">
	<cfargument name="data" type="struct" required="yes" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	<cfargument name="OnExists" type="string" default="insert" hint="The action to take if a record with the given values exists. Possible values: insert (inserts another record), error (throws an error), update (updates the matching record), skip (performs no action), save (updates only for matching primary key)).">
	
	<cfset var fields = getUpdateableFields(arguments.tablename)>
	<cfset var OnExistsValues = "insert,error,update,skip"><!--- possible values for OnExists argument --->
	<cfset var i = 0><!--- generic counter --->
	<cfset var fieldcount = 0><!--- count of fields --->
	<cfset var pkfields = getPKFields(arguments.tablename)>
	<cfset var in = clean(arguments.data)><!--- holder for incoming data (just for readability) --->
	<cfset var inPK = StructNew()><!--- holder for incoming pk data (just for readability) --->
	<cfset var qGetRecords = QueryNew('none')>
	<cfset var result = ""><!--- will hold primary key --->
	<cfset var qCheckKey = 0><!--- Used to get primary key --->
	<cfset var bSetGuid = false><!--- Set GUID (SQL Server specific) --->
	<cfset var GuidVar = "GUID"><!--- var to create variable name for GUID (SQL Server specific) --->
	<cfset var inf = "">
	<cfset var sqlarray = ArrayNew(1)>
	
	<cfset in = getRelationValues(arguments.tablename,in)>
	
	<!--- Create GUID for insert SQL Server where the table has on primary key field and it is a GUID --->
	<cfif ArrayLen(pkfields) eq 1 AND pkfields[1].CF_Datatype eq "CF_SQL_IDSTAMP" AND getDatabase() eq "MS SQL" AND NOT StructKeyExists(in,pkfields[1].ColumnName)>
		<cfset bSetGuid = true>
	</cfif>
	
	<!--- Create variable to hold GUID for SQL Server GUID inserts --->
	<cfif bSetGuid>
		<cflock timeout="30" throwontimeout="No" name="DataMgr_GuidNum" type="EXCLUSIVE">
			<!--- %%I cant figure out a way to safely increment the variable to make it unique for a transaction w/0 the use of request scope --->
			<cfif isDefined("request.DataMgr_GuidNum")>
				<cfset request.DataMgr_GuidNum = Val(request.DataMgr_GuidNum) + 1>
			<cfelse>
				<cfset request.DataMgr_GuidNum = 1>
			</cfif>
			<cfset GuidVar = "GUID#request.DataMgr_GuidNum#">
		</cflock>
	</cfif>
	
	<!--- Check for existing records if an action other than insert should be take if one exists --->
	<cfif arguments.OnExists neq "insert">
		<cfif ArrayLen(pkfields)>
			<!--- Load up all primary key fields in temp structure --->
			<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
				<cfif StructKeyHasLen(in,pkfields[i].ColumnName)>
					<cfset inPK[pkfields[i].ColumnName] = in[pkfields[i].ColumnName]>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif arguments.OnExists NEQ "save">
			<cfset qGetRecords = getRecords(tablename=arguments.tablename,data=in,fieldlist=StructKeyList(inPK))><!--- Try to get existing record with given data --->
		</cfif>
		
		<!--- If no matching records by all fields, Check for existing record by primary keys --->
		<cfif arguments.OnExists EQ "save" OR qGetRecords.RecordCount eq 0>
			<cfif ArrayLen(pkfields)>
				<!--- All all primary key fields exist, check for record --->
				<cfif StructCount(inPK) eq ArrayLen(pkfields)>
					<cfset qGetRecords = getRecord(tablename=arguments.tablename,data=inPK,fieldlist=StructKeyList(inPK))>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Check for existing records --->
	<cfif qGetRecords.RecordCount gt 0>
		<cfswitch expression="#arguments.OnExists#">
		<cfcase value="error">
			<cfthrow message="#arguments.tablename#: A record with these criteria already exists." type="DataMgr">
		</cfcase>
		<cfcase value="update,save">
			<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
				<cfset in[pkfields[i].ColumnName] = qGetRecords[pkfields[i].ColumnName][1]>
			</cfloop>
			<cfset result = updateRecord(arguments.tablename,in)>
			<cfreturn result>
		</cfcase>
		<cfcase value="skip">
			<cfreturn qGetRecords[pkfields[1].ColumnName][1]>
		</cfcase>
		</cfswitch>
	</cfif>
	
	<!--- Check for specials --->
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif StructKeyExists(fields[i],"Special") AND Len(fields[i].Special) AND NOT StructKeyExists(in,fields[i].ColumnName)>
			<cfswitch expression="#fields[i].Special#">
			<cfcase value="CreationDate">
				<cfset in[fields[i].ColumnName] = now()>
			</cfcase>
			<cfcase value="LastUpdatedDate">
				<cfset in[fields[i].ColumnName] = now()>
			</cfcase>
			<cfcase value="Sorter">
				<cfset in[fields[i].ColumnName] = getNewSortNum(arguments.tablename,fields[i].ColumnName)>
			</cfcase>
			</cfswitch>
		</cfif>
	</cfloop>
	
	<!--- Insert record --->
	<cfif bSetGuid>
		<cfset ArrayAppend(sqlarray,"DECLARE @#GuidVar# uniqueidentifier")>
		<cfset ArrayAppend(sqlarray,"SET @#GuidVar# = NEWID()")>
	</cfif>
	<cfset ArrayAppend(sqlarray,"INSERT INTO #escape(arguments.tablename)# (")>
	
	<!--- Loop through all updateable fields --->
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif useField(in,fields[i]) OR (StructKeyExists(fields[i],"Default") AND Len(fields[i].Default) AND getDatabase() eq "Access")><!--- Include the field in SQL if it has appropriate data --->
			<cfset fieldcount = fieldcount + 1>
			<cfif fieldcount gt 1>
				<cfset ArrayAppend(sqlarray,",")><!--- put a comma before every field after the first --->
			</cfif>
			<cfset ArrayAppend(sqlarray,escape(fields[i].ColumnName))>
		</cfif>
	</cfloop>
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfif ( useField(in,pkfields[i]) AND NOT isIdentityField(pkfields[i]) ) OR ( pkfields[i].CF_Datatype eq "CF_SQL_IDSTAMP" AND bSetGuid )><!--- Include the field in SQL if it has appropriate data --->
			<cfset fieldcount = fieldcount + 1>
			<cfif fieldcount gt 1>
				<cfset ArrayAppend(sqlarray,",")><!--- put a comma before every field after the first --->
			</cfif>
			<cfset ArrayAppend(sqlarray,"#escape(pkfields[i].ColumnName)#")>
		</cfif>
	</cfloop>
	<cfset ArrayAppend(sqlarray,")")>
	<cfset ArrayAppend(sqlarray,"VALUES (")>
	<cfset fieldcount = 0>
	<!--- Loop through all updateable fields --->
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif useField(in,fields[i])><!--- Include the field in SQL if it has appropriate data --->
			<cfset checkLength(fields[i],in[fields[i].ColumnName])>
			<cfset fieldcount = fieldcount + 1>
			<cfif fieldcount gt 1>
				<cfset ArrayAppend(sqlarray,",")><!--- put a comma before every field after the first --->
			</cfif>
			<cfset ArrayAppend(sqlarray,sval(fields[i],in))>
		<cfelseif StructKeyExists(fields[i],"Default") AND Len(fields[i].Default) AND getDatabase() eq "Access">
			<cfset fieldcount = fieldcount + 1>
			<cfset ArrayAppend(sqlarray,",")><!--- put a comma before every field after the first --->
			<cfset ArrayAppend(sqlarray,fields[i].Default)>
		</cfif>
	</cfloop>
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfif useField(in,pkfields[i]) AND NOT isIdentityField(pkfields[i])><!--- Include the field in SQL if it has appropriate data --->
			<cfset checkLength(pkfields[i],in[pkfields[i].ColumnName])>
			<cfset fieldcount = fieldcount + 1>
			<cfif fieldcount gt 1>
				<cfset ArrayAppend(sqlarray,",")><!--- put a comma before every field after the first --->
			</cfif>
			<cfset ArrayAppend(sqlarray,sval(pkfields[i],in))>
		<cfelseif pkfields[i].CF_Datatype eq "CF_SQL_IDSTAMP" AND bSetGuid>
			<cfset fieldcount = fieldcount + 1>
			<cfif fieldcount gt 1>
				<cfset ArrayAppend(sqlarray,",")><!--- put a comma before every field after the first --->
			</cfif>
			<cfset ArrayAppend(sqlarray,"@#GuidVar#")>
		</cfif>
	</cfloop><cfif fieldcount eq 0><cfsavecontent variable="inf"><cfdump var="#in#"></cfsavecontent><cfthrow message="You must pass in at least one field that can be inserted into the database. Fields: #inf#" type="DataMgr" errorcode="NeedInsertFields"></cfif>
	<cfset ArrayAppend(sqlarray,")")>
	<cfif bSetGuid>
		<cfset ArrayAppend(sqlarray,";")>
		<cfset ArrayAppend(sqlarray,"SELECT @#GuidVar# AS NewID")>
	</cfif>
	<!--- Perform insert --->
	<cflock timeout="30" throwontimeout="No" name="DataMgr_Insert_#arguments.tablename#" type="EXCLUSIVE">
		<cfset qCheckKey = runSQLArray(sqlarray)>
	</cflock>
	
	<cfif isDefined("qCheckKey") AND isQuery(qCheckKey) AND qCheckKey.RecordCount AND ListFindNoCase(qCheckKey.ColumnList,"NewID")>
		<cfset result = qCheckKey.NewID>
	</cfif>
	
	<!--- Get primary key --->
	<cfif Len(result) eq 0>
		<cfif ArrayLen(pkfields) AND StructKeyExists(pkfields[1],"Increment") AND isBoolean(pkfields[1].Increment) AND pkfields[1].Increment>
			<cfset result = getInsertedIdentity(arguments.tablename,pkfields[1].ColumnName)>
		<cfelse>
			<cftry>
				<cfset result = getPKFromData(arguments.tablename,in)>
				<cfcatch>
					<cfset result = "">
				</cfcatch>
			</cftry>
		</cfif>
	</cfif>
	
	<!--- set pkfield so that we can save relation data --->
	<cfif ArrayLen(pkfields)>
		<cfset in[pkfields[1].ColumnName] = result>
		<cfset saveRelations(arguments.tablename,in,pkfields[1],result)>
	</cfif>
	
	<!--- Log insert --->
	<cfif variables.doLogging AND NOT arguments.tablename eq variables.logtable>
		<cfinvoke method="logAction">
			<cfinvokeargument name="tablename" value="#arguments.tablename#">
			<cfif ArrayLen(pkfields) eq 1 AND StructKeyExists(in,pkfields[1].ColumnName)>
				<cfinvokeargument name="pkval" value="#in[pkfields[1].ColumnName]#">
			</cfif>
			<cfinvokeargument name="action" value="insert">
			<cfinvokeargument name="data" value="#in#">
			<cfinvokeargument name="sql" value="#sqlarray#">
		</cfinvoke>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="isLogging" access="public" returntype="boolean" output="no">
	
	<cfif NOT isDefined("doLogging")>
		<cfset variables.doLogging = false>
	</cfif>
	
	<cfreturn variables.doLogging>
</cffunction>

<cffunction name="isValidDate" access="public" returntype="boolean" output="no">
	<cfargument name="value" type="string" required="yes">
	
	<cfreturn isDate(arguments.value)>
</cffunction>

<cffunction name="loadTable" access="public" returntype="void" output="no" hint="I load a table from the database into DataMgr.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var arrTableStruct = getDBTableStruct(arguments.tablename)>
	<cfset var i = 0>
	
	<cfloop index="i" from="1" to="#ArrayLen(arrTableStruct)#" step="1">
		<cfif StructKeyExists(arrTableStruct[i],"Default") AND Len(arrTableStruct[i]["Default"])>
			<cfset arrTableStruct[i]["Default"] = makeDefaultValue(arrTableStruct[i]["Default"],arrTableStruct[i].CF_DataType)>
		</cfif>
	</cfloop>
	
	<cfset addTable(arguments.tablename,arrTableStruct)>
	
</cffunction>

<cffunction name="loadXML" access="public" returntype="void" output="false" hint="I add tables from XML and optionally create tables/columns as needed (I can also load data to a table upon its creation).">
	<cfargument name="xmldata" type="string" required="yes" hint="XML data of tables to load into DataMgr follows. Schema: http://www.bryantwebconsulting.com/cfcs/DataMgr.xsd">
	<cfargument name="docreate" type="boolean" default="false" hint="I indicate if the table should be created in the database if it doesn't already exist.">
	<cfargument name="addcolumns" type="boolean" default="false" hint="I indicate if missing columns should be be created.">
	
	<cfscript>
	var MyTables = StructNew();
	var varXML = XmlParse(arguments.xmldata,"no");
	var arrTables = varXML.XmlRoot.XmlChildren;
	var arrData = XmlSearch(varXML, "//data");
	
	var i = 0;
	var j = 0;
	var mytable = 0;
	var thisTable = 0;
	var thisTableName = 0;
	var thisField = 0;
	var tmpStruct = 0;
	
	var tables = "";
	var fields = "";
	var fieldlist = "";
	var qTest = 0;
	
	var colExists = false;
	var arrDbTable = 0;
	
	var FailedSQL = "";
	</cfscript>
	
	<cfscript>
	//  Loop over all root elements in XML
	for (i=1; i lte ArrayLen(arrTables);i=i+1) {
		//  If element is a table and has a name, add it to the data
		if ( arrTables[i].XmlName eq "table" AND StructKeyExists(arrTables[i].XmlAttributes,"name") ) {
			//temp variable to reference this table
			thisTable = arrTables[i];
			//table name
			thisTableName = thisTable.XmlAttributes["name"];
			//  Only add to struct if table doesn't exist or if cols should be altered
			if ( NOT StructKeyExists(variables.tables,thisTableName) OR arguments.addcolumns ) {
				//Add to array of tables to add/alter
				if ( NOT StructKeyExists(MyTables,thisTableName) ) {
					MyTables[thisTableName] = ArrayNew(1);
				}
				fields = "";
				//  Loop through fields in table
				for (j=1; j lte ArrayLen(thisTable.XmlChildren);j=j+1) {
					//  If this xml tag is a field
					if ( thisTable.XmlChildren[j].XmlName eq "field" OR thisTable.XmlChildren[j].XmlName eq "column" ) {
						thisField = thisTable.XmlChildren[j].XmlAttributes;
						tmpStruct = StructNew();
						//If "name" attribute exists, but "ColumnName" att doesn't use name as ColumnName
						if ( StructKeyExists(thisField,"name") AND NOT StructKeyExists(thisField,"ColumnName") ) {
							thisField["ColumnName"] = thisField["name"];
						}
						//Set ColumnName
						tmpStruct["ColumnName"] = thisField["ColumnName"];
						//If "cfsqltype" attribute exists, but "CF_DataType" att doesn't use name as CF_DataType
						if ( StructKeyExists(thisField,"cfsqltype") AND NOT StructKeyExists(thisField,"CF_DataType") ) {
							thisField["CF_DataType"] = thisField["cfsqltype"];
						}
						//Set CF_DataType
						if ( StructKeyExists(thisField,"CF_DataType") ) {
							tmpStruct["CF_DataType"] = thisField["CF_DataType"];
						}
						//Set PrimaryKey (defaults to false)
						if ( StructKeyExists(thisField,"PrimaryKey") AND isBoolean(thisField["PrimaryKey"]) AND thisField["PrimaryKey"] ) {
							tmpStruct["PrimaryKey"] = true;
						} else {
							tmpStruct["PrimaryKey"] = false;
						}
						//Set AllowNulls (defaults to true)
						if ( StructKeyExists(thisField,"AllowNulls") AND isBoolean(thisField["AllowNulls"]) AND NOT thisField["AllowNulls"] ) {
							tmpStruct["AllowNulls"] = false;
						} else {
							tmpStruct["AllowNulls"] = true;
						}
						//Set length (if it exists and isnumeric)
						if ( StructKeyExists(thisField,"Length") AND isNumeric(thisField["Length"]) AND NOT tmpStruct["CF_DataType"] eq "CF_SQL_LONGVARCHAR" ) {
							tmpStruct["Length"] = Val(thisField["Length"]);
						} else {
							tmpStruct["Length"] = 0;
						}
						//Set increment (if exists and true)
						if ( StructKeyExists(thisField,"Increment") AND isBoolean(thisField["Increment"]) AND thisField["Increment"] ) {
							tmpStruct["Increment"] = true;
						} else {
							tmpStruct["Increment"] = false;
						}
						//Set precision (if exists and true)
						if ( StructKeyExists(thisField,"Precision") AND isNumeric(thisField["Precision"]) ) {
							tmpStruct["Precision"] = Val(thisField["Precision"]);
						} else {
							tmpStruct["Precision"] = "";
						}
						//Set scale (if exists and true)
						if ( StructKeyExists(thisField,"Scale") AND isNumeric(thisField["Scale"]) ) {
							tmpStruct["Scale"] = Val(thisField["Scale"]);
						} else {
							tmpStruct["Scale"] = "";
						}
						//Set default (if exists)
						if ( StructKeyExists(thisField,"Default") AND Len(thisField["Default"]) ) {
							tmpStruct["Default"] = makeDefaultValue(thisField["Default"],tmpStruct["CF_DataType"]);
						//} else {
						//	tmpStruct["Default"] = "";
						}
						//Set Special (if exists)
						if ( StructKeyExists(thisField,"Special") ) {
							tmpStruct["Special"] = Trim(thisField["Special"]);
							//Sorter or DeletionMark should default to zero
							if (  NOT StructKeyExists(tmpStruct,"Default") ) {
								if ( tmpStruct["Special"] EQ "Sorter" OR tmpStruct["Special"] EQ "DeletionMark" ) {
									tmpStruct["Default"] = 0;
								}
							}
						} else {
							tmpStruct["Special"] = "";
						}
						//Set relation (if exists)
						if ( ArrayLen(thisTable.XmlChildren[j].XmlChildren) eq 1 AND thisTable.XmlChildren[j].XmlChildren[1].XmlName eq "relation" ) {
							tmpStruct["Relation"] = expandRelationStruct(thisTable.XmlChildren[j].XmlChildren[1].XmlAttributes);
						}
						//Copy data set in temporary structure to result storage
						if ( NOT ListFindNoCase(fields, tmpStruct["ColumnName"]) ) {
							fields = ListAppend(fields,tmpStruct["ColumnName"]);
							ArrayAppend(MyTables[thisTableName], StructNew());
							MyTables[thisTableName][ArrayLen(MyTables[thisTableName])] = Duplicate(tmpStruct);
						}
					}// /If this xml tag is a field
				}// /Loop through fields in table
			}// /Only add to struct if table doesn't exist or if cols should be altered
		}// /If element is a table and has a name, add it to the data
	}// /Loop over all root elements in XML
	
	//Add tables to DataMgr
	for ( mytable in MyTables ) {
		addTable(mytable,MyTables[mytable]);
	}
	
	//Create tables if requested to do so.
	if ( arguments.docreate ) {
		//Loop over all root elements in XML
		for (i=1; i lte ArrayLen(arrTables);i=i+1) {
			if ( arrTables[i].XmlName eq "table" AND StructKeyExists(arrTables[i].XmlAttributes,"name") ) {
				//Add table to list
				tables = ListAppend(tables,arrTables[i].XmlAttributes["name"]);
			}// /if
		}// /for
		//Try to create the tables, if that fails we'll load up the failed SQL in a variable so it can be returned in a handy lump.
		try {
			CreateTables(tables);
		} catch (DataMgr exception) {
			if ( Len(exception.Detail) ) {
				FailedSQL = ListAppend(FailedSQL,exception.Detail,";");
			} else {
				FailedSQL = ListAppend(FailedSQL,exception.Message,";");
			}
		}
		
	}// if
	</cfscript>
	<cfif Len(FailedSQL)>
		<cfthrow message="LoadXML Failed (verify datasource ""#variables.datasource#"" is correct)" type="DataMgr" detail="#FailedSQL#" errorcode="LoadFailed">
	</cfif>
	<cfscript>
	//Add columns to tables as needed if requested to do so.
	if ( arguments.addcolumns ) {
		//Loop over tables (from XML)
		for ( mytable in MyTables ) {
			//Loop over fields (from XML)
			for ( i=1; i lte ArrayLen(MyTables[mytable]); i=i+1 ) {
				colExists = false;
				// get list of fields in table
				fieldlist = getDBFieldList(mytable);
				//check for existence of this field
				if ( ListFindNoCase(fieldlist,MyTables[mytable][i].ColumnName) OR StructKeyExists(MyTables[mytable][i],"Relation") ) {
					colExists = true;
				}
				//If no match, add column
				if ( NOT colExists ) {
					try {
						if ( StructKeyExists(MyTables[mytable][i],"Default") AND Len(MyTables[mytable][i]["Default"]) ) {
							addColumn(mytable,MyTables[mytable][i].ColumnName,MyTables[mytable][i].CF_DataType,MyTables[mytable][i].Length,MyTables[mytable][i]["Default"]);
						} else {
							addColumn(mytable,MyTables[mytable][i].ColumnName,MyTables[mytable][i].CF_DataType,MyTables[mytable][i].Length);
						}
					} catch (DataMgr exception) {
						FailedSQL = ListAppend(FailedSQL,exception.Detail,";");
					}
				}
			}
		}
	}
	</cfscript>
	<cfif Len(FailedSQL)>
		<cfthrow message="LoadXML Failed" type="DataMgr" detail="#FailedSQL#" errorcode="LoadFailed">
	</cfif>
	<cfscript>
	if ( arguments.docreate ) {
		seedData(varXML,tables);
	}
	</cfscript>
	
</cffunction>

<cffunction name="queryparam" access="public" returntype="struct" output="no" hint="I run the given SQL.">
	<cfargument name="cfsqltype" type="string" required="no">
	<cfargument name="value" type="any" required="yes">
	<cfargument name="maxLength" type="string" required="no">
	<cfargument name="scale" type="string" default="0">
	<cfargument name="null" type="boolean" default="no">
	<cfargument name="list" type="boolean" default="no">
	<cfargument name="separator" type="string" default=",">
	
	<cfif StructKeyExists(arguments,"CF_DataType") AND NOT StructKeyExists(arguments,"cfsqltype")>
		<cfset arguments["cfsqltype"] = arguments["CF_DataType"]>
	</cfif>
	
	<cfif isStruct(arguments.value) AND StructKeyExists(arguments.value,"value")>
		<cfset arguments.value = arguments.value.value>
	</cfif>
	
	<cfif NOT isSimpleValue(arguments.value)>
		<cfthrow message="arguments.value must be a simple value" type="DataMgr" errorcode="ValueMustBeSimple">
	</cfif>
	
	<cfif NOT StructKeyExists(arguments,"maxLength")>
		<cfset arguments.maxLength = Len(arguments.value)>
	</cfif>
	
	<cfif StructKeyExists(arguments,"maxLength")>
		<cfset arguments.maxlength = Int(Val(arguments.maxlength))>
		<cfif NOT arguments.maxlength GT 0>
			<cfset arguments.maxlength = Len(arguments.value)>
		</cfif>
		<cfif NOT arguments.maxlength GT 0>
			<cfset arguments.maxlength = 100>
			<cfset arguments.null = "yes">
		</cfif>
	</cfif>
	
	<cfset arguments.scale = Max(int(val(arguments.scale)),2)>
	
	<cfreturn arguments>
</cffunction>

<cffunction name="runSQL" access="public" returntype="any" output="no" hint="I run the given SQL.">
	<cfargument name="sql" type="string" required="yes">
	
	<cfset var qQuery = 0>
	<cfset var thisSQL = "">
	
	<cfif StructKeyExists(variables,"username") AND StructKeyExists(variables,"password")>
		<cfquery name="qQuery" datasource="#variables.datasource#" username="#variables.username#" password="#variables.password#">#Trim(PreserveSingleQuotes(arguments.sql))#</cfquery>
	<cfelse>
		<cfquery name="qQuery" datasource="#variables.datasource#">#Trim(PreserveSingleQuotes(arguments.sql))#</cfquery>
	</cfif>
	
	<cfif IsDefined("qQuery")>
		<cfreturn qQuery>
	</cfif>
	
</cffunction>

<cffunction name="setColumn" access="public" returntype="any" output="no" hint="I set a column in the given table">
	<cfargument name="tablename" type="string" required="yes" hint="The name of the table to which a column will be added.">
	<cfargument name="columnname" type="string" required="yes" hint="The name of the column to add.">
	<cfargument name="CF_Datatype" type="string" required="no" hint="The ColdFusion SQL Datatype of the column.">
	<cfargument name="Length" type="numeric" default="0" hint="The ColdFusion SQL Datatype of the column.">
	<cfargument name="Default" type="string" required="no" hint="The default value for the column.">
	<cfargument name="Special" type="string" required="no" hint="The special behavior for the column.">
	<cfargument name="Relation" type="struct" required="no" hint="Relationship information for this column.">
	<cfargument name="PrimaryKey" type="boolean" required="no" hint="Indicates whether this column is a primary key.">
	
	<cfset var type = "">
	<cfset var sql = "">
	<cfset var FailedSQL = "">
	<cfset var dbfields = getDBFieldList(arguments.tablename)>
	<cfset var dmfields = getFieldList(arguments.tablename)>
	
	<!--- Default length to 255 (only used for text types) --->
	<cfif arguments.Length eq 0 AND StructKeyExists(arguments,"CF_Datatype")>
		<cfset arguments.Length = 255>
	</cfif>
	
	<cfif StructKeyExists(arguments,"CF_Datatype")>
		<cfset arguments.CF_Datatype = UCase(arguments.CF_Datatype)>
		<cfset type = getDBDataType(arguments.CF_Datatype)>
		
		<cfif NOT ListFindNoCase(dbfields,arguments.columnname)>
			<cfsavecontent variable="sql"><cfoutput>ALTER TABLE #escape(arguments.tablename)# ADD #escape(arguments.columnname)# #type#<cfif isStringType(type)> (#arguments.Length#)</cfif><cfif StructKeyExists(arguments,"Default")> DEFAULT #arguments.Default#</cfif></cfoutput></cfsavecontent>
		</cfif>
		
		<cftry>
			<cfset runSQL(sql)>
			<cfcatch>
				<cfset FailedSQL = ListAppend(FailedSQL,sql,";")>
			</cfcatch>
		</cftry>
	
		<cfif StructKeyExists(arguments,"Default") AND Len(Trim(arguments.Default))>
			<cfsavecontent variable="sql"><cfoutput>
			UPDATE	#escape(arguments.tablename)#	
			SET		#escape(arguments.columnname)# = #arguments.Default#
			WHERE	#escape(arguments.columnname)# IS NULL
			</cfoutput></cfsavecontent>
		
			<cftry>
				<cfset runSQL(sql)>
				<cfcatch>
					<cfset FailedSQL = ListAppend(FailedSQL,sql,";")>
				</cfcatch>
			</cftry>
		</cfif>
		
		<cfif Len(FailedSQL)>
			<cfthrow message="Failed to add Column (""#arguments.columnname#"")." type="DataMgr" detail="#FailedSQL#">
		</cfif>
		
	</cfif>
	
	
	<cfif NOT Len(FailedSQL)>
		<!--- Add the field to DataMgr if DataMgr doesn't know about the field --->
		<cfif NOT ListFindNoCase(dmfields,arguments.columnname)>
			<cfset ArrayAppend(variables.tables[arguments.tablename], Duplicate(arguments))>
		</cfif>
		<cfif StructKeyExists(arguments,"Special")>
			<!--- If the field exists but a special is passed, set the special --->
			<cfset setColumnSpecial(arguments.tablename,arguments.columnname,arguments.Special)>
		</cfif>
		<cfif StructKeyExists(arguments,"Relation")>
			<!--- If the field exists but a relation is passed, set the relation --->
			<cfset setColumnRelation(arguments.tablename,arguments.columnname,arguments.Relation)>
		</cfif>
		<cfif StructKeyExists(arguments,"PrimaryKey") AND isBoolean(arguments.PrimaryKey) AND arguments.PrimaryKey>
			<!--- If the field exists but a relation is passed, set the relation --->
			<cfset setColumnPrimaryKey(arguments.tablename,arguments.columnname)>
		</cfif>
	</cfif>
	
	<cfset variables.tableprops[arguments.tablename] = StructNew()>
	
</cffunction>

<cffunction name="runSQLArray" access="public" returntype="any" output="no" hint="I run the given array representing SQL code (structures in the array represent params).">
	<cfargument name="sqlarray" type="array" required="yes">
	
	<cfset var qQuery = 0>
	<cfset var i = 0>
	<cfset var temp = "">
	<cfset var aSQL = cleanSQLArray(arguments.sqlarray)>
	
	<cfif StructKeyExists(variables,"username") AND StructKeyExists(variables,"password")>
		<cfquery name="qQuery" datasource="#variables.datasource#" username="#variables.username#" password="#variables.password#"><cfloop index="i" from="1" to="#ArrayLen(aSQL)#" step="1"><cfif IsSimpleValue(aSQL[i])><cfset temp = aSQL[i]>#Trim(PreserveSingleQuotes(temp))#<cfelseif IsStruct(aSQL[i])><cfset aSQL[i] = queryparam(argumentCollection=aSQL[i])><cfswitch expression="#aSQL[i].cfsqltype#"><cfcase value="CF_SQL_BIT"><cfif aSQL[i].value>1<cfelse>0</cfif></cfcase><cfcase value="CF_SQL_DATE">#CreateODBCDateTime(aSQL[i].value)#</cfcase><cfdefaultcase><cfif ListFindNoCase(variables.dectypes,aSQL[i].cfsqltype)>#Val(aSQL[i].value)#<cfelse><cfqueryparam value="#aSQL[i].value#" cfsqltype="#aSQL[i].cfsqltype#" maxlength="#aSQL[i].maxlength#" scale="#aSQL[i].scale#" null="#aSQL[i].null#" list="#aSQL[i].list#" separator="#aSQL[i].separator#"></cfif></cfdefaultcase></cfswitch></cfif> </cfloop></cfquery>
	<cfelse>
		<cfquery name="qQuery" datasource="#variables.datasource#"><cfloop index="i" from="1" to="#ArrayLen(aSQL)#" step="1"><cfif IsSimpleValue(aSQL[i])><cfset temp = aSQL[i]>#Trim(PreserveSingleQuotes(temp))#<cfelseif IsStruct(aSQL[i])><cfset aSQL[i] = queryparam(argumentCollection=aSQL[i])><cfswitch expression="#aSQL[i].cfsqltype#"><cfcase value="CF_SQL_BIT"><cfif aSQL[i].value>1<cfelse>0</cfif></cfcase><cfcase value="CF_SQL_DATE">#CreateODBCDateTime(aSQL[i].value)#</cfcase><cfdefaultcase><cfif ListFindNoCase(variables.dectypes,aSQL[i].cfsqltype)>#Val(aSQL[i].value)#<cfelse><cfqueryparam value="#aSQL[i].value#" cfsqltype="#aSQL[i].cfsqltype#" maxlength="#aSQL[i].maxlength#" scale="#aSQL[i].scale#" null="#aSQL[i].null#" list="#aSQL[i].list#" separator="#aSQL[i].separator#"></cfif></cfdefaultcase></cfswitch></cfif> </cfloop></cfquery>
	</cfif>
	
	<cfif IsDefined("qQuery")>
		<cfreturn qQuery>
	</cfif>
	
</cffunction>

<cffunction name="readableSQL" access="public" returntype="string" output="no" hint="I return human-readable SQL from a SQL array (not to be sent to the database).">
	<cfargument name="sqlarray" type="array" required="yes">
	
	<cfset var aSQL = cleanSQLArray(arguments.sqlarray)>
	<cfset var i = 0>
	<cfset var result = "">
	
	<cfloop index="i" from="1" to="#ArrayLen(aSQL)#" step="1">
		<cfif IsSimpleValue(aSQL[i])>
			<cfset result = result & " " & aSQL[i]>
		<cfelseif IsStruct(aSQL[i])>
			<cfset result = result & " " & "(#aSQL[i].value#)">
		</cfif>
	</cfloop>
	
	<cfreturn result>
</cffunction>

<cffunction name="saveRecord" access="public" returntype="string" output="no" hint="I insert or update a record in the given table (update if a matching record is found) with the provided data and return the primary key of the updated record.">
	<cfargument name="tablename" type="string" required="yes" hint="The table on which to update data.">
	<cfargument name="data" type="struct" required="yes" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	
	<cfreturn insertRecord(arguments.tablename,arguments.data,"update")>
</cffunction>

<cffunction name="saveRelationList" access="public" returntype="void" output="no" hint="I save a many-to-many relationship.">
	<cfargument name="tablename" type="string" required="yes" hint="The table holding the many-to-many relationships.">
	<cfargument name="keyfield" type="string" required="yes" hint="The field holding our key value for relationships.">
	<cfargument name="keyvalue" type="string" required="yes" hint="The value of out primary field.">
	<cfargument name="multifield" type="string" required="yes" hint="The field holding our many relationships for the given key.">
	<cfargument name="multilist" type="string" required="yes" hint="The list of related values for our key.">
	<cfargument name="reverse" type="boolean" default="false" hint="Should the reverse of the relationship by run as well (for self-joins)?s.">
	
	<cfset var bTable = checkTable(arguments.tablename)><!--- Check whether table is loaded --->
	<cfset var getStruct = StructNew()>
	<cfset var setStruct = StructNew()>
	<cfset var qExistingRecords = 0>
	<cfset var item = "">
	<cfset var ExistingList = "">
	
	<!--- Make sure a value is passed in for the primary key value --->
	<cfif NOT Len(Trim(arguments.keyvalue))>
		<cfthrow message="You must pass in a value for keyvalue of saveRelationList" type="DataMgr" errorcode="NoKeyValueForSaveRelationList">
	</cfif>
	
	<cfif arguments.reverse>
		<cfinvoke method="saveRelationList">
			<cfinvokeargument name="tablename" value="#arguments.tablename#">
			<cfinvokeargument name="keyfield" value="#arguments.multifield#">
			<cfinvokeargument name="keyvalue" value="#arguments.keyvalue#">
			<cfinvokeargument name="multifield" value="#arguments.keyfield#">
			<cfinvokeargument name="multilist" value="#arguments.multilist#">
		</cfinvoke>
	</cfif>
	
	<!--- Get existing records --->
	<cfset getStruct[arguments.keyfield] = arguments.keyvalue>
	<cfset qExistingRecords = getRecords(arguments.tablename,getStruct)>
	
	<!--- Remove existing records not in list --->
	<cfoutput query="qExistingRecords">
		<cfset ExistingList = ListAppend(ExistingList,qExistingRecords[arguments.multifield][CurrentRow])>
		<cfif NOT ListFindNoCase(arguments.multilist,qExistingRecords[arguments.multifield][CurrentRow])>
			<cfset setStruct = StructNew()>
			<cfset setStruct[arguments.keyfield] = arguments.keyvalue>
			<cfset setStruct[arguments.multifield] = qExistingRecords[arguments.multifield][CurrentRow]>
			<cfset deleteRecord(arguments.tablename,setStruct)>
		</cfif>
	</cfoutput>
	
	<!--- Add records from list that don't exist --->
	<cfloop index="item" list="#arguments.multilist#">
		<cfif NOT ListFindNoCase(ExistingList,item)>
			<cfset setStruct = StructNew()>
			<cfset setStruct[arguments.keyfield] = arguments.keyvalue>
			<cfset setStruct[arguments.multifield] = item>
			<cfset insertRecord(arguments.tablename,setStruct,"skip")>
			<cfset ExistingList = ListAppend(ExistingList,item)><!--- in case list has one item more than once (4/26/06) --->
		</cfif>
	</cfloop>
	
</cffunction>

<cffunction name="saveSortOrder" access="public" returntype="void" output="no" hint="I save the sort order of records - putting them in the same order as the list of primary key values.">
	<cfargument name="tablename" type="string" required="yes" hint="The table on which to update data.">
	<cfargument name="sortfield" type="string" required="yes" hint="The field holding the sort order.">
	<cfargument name="sortlist" type="string" required="yes" hint="The list of primary key field values in sort order.">
	<cfargument name="PrecedingRecords" type="numeric" default="0" hint="The number of records preceding those being sorted.">
	
	<cfset var pkfields = getPKFields(arguments.tablename)>
	<cfset var i = 0>
	<cfset var keyval = 0>
	<cfset var sqlarray = ArrayNew(1)>
	<cfset var sqlStatements = "">
	
	<cfset arguments.PrecedingRecords = Int(arguments.PrecedingRecords)>
	<cfif arguments.PrecedingRecords lt 0>
		<cfset arguments.PrecedingRecords = 0>
	</cfif>
	
	<cfif ArrayLen(pkfields) neq 1>
		<cfthrow message="This method can only be used on tables with exactly one primary key field." type="DataMgr" errorcode="SortWithOneKey">
	</cfif>
	
	<cfloop index="i" from="1" to="#ListLen(arguments.sortlist)#" step="1">
		<cfset keyval = ListGetAt(arguments.sortlist,i)>
		<cfset sqlarray = ArrayNew(1)>
		<cfset ArrayAppend(sqlarray,"UPDATE	#escape(arguments.tablename)#")>
		<cfset ArrayAppend(sqlarray,"SET		#escape(arguments.sortfield)# = #Val(i)+arguments.PrecedingRecords#")>
		<cfset ArrayAppend(sqlarray,"WHERE	#escape(pkfields[1].ColumnName)# = ")>
		<cfset ArrayAppend(sqlarray,sval(pkfields[1],keyval))>
		<cfset runSQLArray(sqlarray)>
		<cfset sqlStatements = ListAppend(sqlStatements,readableSQL(sqlarray),";")>
	</cfloop>
	
	<cfif variables.doLogging AND ListLen(arguments.sortlist)>
		<cfinvoke method="logAction">
			<cfinvokeargument name="tablename" value="#arguments.tablename#">
			<cfinvokeargument name="action" value="sort">
			<cfinvokeargument name="data" value="#arguments#">
			<cfinvokeargument name="sql" value="#sqlStatements#">
		</cfinvoke>
	</cfif>
	
</cffunction>

<cffunction name="logAction" access="public" returntype="any" output="no" hint="I log an action in the database.">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="pkval" type="string" required="no">
	<cfargument name="action" type="string" required="yes">
	<cfargument name="data" type="struct" required="no">
	<cfargument name="sql" type="any" required="no">
	
	<cfif NOT arguments.tablename eq variables.logtable>
		
		<cfif StructKeyExists(arguments,"data")>
			<cfwddx action="CFML2WDDX" input="#arguments.data#" output="arguments.data">
		</cfif>
		
		<cfif StructKeyExists(arguments,"sql")>
			<cfif isSimpleValue(arguments.sql)>
				<cfset arguments.sql = arguments.sql>
			<cfelseif isArray(arguments.sql)>
				<cfset arguments.sql = readableSQL(arguments.sql)>
			<cfelse>
				<cfthrow message="The sql argument logAction method must be a string of SQL code or a DataMgr SQL Array." type="DataMgr" errorcode="LogActionSQLDataType">
			</cfif>
		</cfif>
		
		<cfset insertRecord(variables.logtable,arguments)>
	</cfif>
	
</cffunction>

<cffunction name="startLogging" access="public" returntype="void" output="no" hint="I turn on logging.">
	<cfargument name="logtable" type="string" default="#variables.logtable#">
	
	<cfset var dbxml = "">
	
	<cfset variables.doLogging = true>
	<cfset variables.logtable = arguments.logtable>
	
	<cfsavecontent variable="dbxml"><cfoutput>
	<tables>
		<table name="#variables.logtable#">
			<field ColumnName="LogID" CF_DataType="CF_SQL_INTEGER" PrimaryKey="true" Increment="true" />
			<field ColumnName="tablename" CF_DataType="CF_SQL_VARCHAR" Length="180" />
			<field ColumnName="pkval" CF_DataType="CF_SQL_VARCHAR" Length="250" />
			<field ColumnName="action" CF_DataType="CF_SQL_VARCHAR" Length="60" />
			<field ColumnName="DatePerformed" CF_DataType="CF_SQL_DATE" Special="CreationDate" />
			<field ColumnName="data" CF_DataType="CF_SQL_LONGVARCHAR" />
			<field ColumnName="sql" CF_DataType="CF_SQL_LONGVARCHAR" />
		</table>
	</tables>
	</cfoutput></cfsavecontent>
	
	<cfset loadXML(dbxml,true,true)>
	
</cffunction>

<cffunction name="stopLogging" access="public" returntype="void" output="no" hint="I turn off logging.">
	<cfset variables.doLogging = false>
</cffunction>

<cffunction name="truncate" access="public" returntype="struct" output="no" hint="I return the structure with the values truncated to the limit of the fields in the table.">
	<cfargument name="tablename" type="string" required="yes" hint="The table for which to truncate data.">
	<cfargument name="data" type="struct" required="yes" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	
	<cfscript>
	var sTables = getTableData();
	var aColumns = sTables[arguments.tablename];
	var i = 0;
	
	for ( i=1; i lte ArrayLen(aColumns); i=i+1 ) {
		if ( StructKeyExists(arguments.data,aColumns[i].ColumnName) ) {
			if ( StructKeyExists(aColumns[i],"Length") AND aColumns[i].Length AND aColumns[i].CF_DataType neq "CF_SQL_LONGVARCHAR" ) {
				arguments.data[aColumns[i].ColumnName] = Left(arguments.data[aColumns[i].ColumnName],aColumns[i].Length);
			}
		}
	}
	</cfscript>
	
	<cfreturn arguments.data>
</cffunction>

<cffunction name="updateRecord" access="public" returntype="string" output="no" hint="I update a record in the given table with the provided data and return the primary key of the updated record.">
	<cfargument name="tablename" type="string" required="yes" hint="The table on which to update data.">
	<cfargument name="data" type="struct" required="yes" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	
	<cfset var fields = getUpdateableFields(arguments.tablename)>
	<cfset var i = 0><!--- generic counter --->
	<cfset var fieldcount = 0><!--- number of fields --->
	<cfset var pkfields = getPKFields(arguments.tablename)>
	<cfset var in = clean(arguments.data)><!--- holds incoming data for ease of use --->
	<cfset var qGetUpdateRecord = 0><!--- used to check for existing record --->
	<cfset var temp = "">
	<cfset var result = 0>
	<cfset var sqlarray = ArrayNew(1)>
	
	<cfset in = getRelationValues(arguments.tablename,in)>
	
	<!--- This method is only to be used on fields with one pkfield --->
	<cfif NOT ArrayLen(pkfields)>
		<cfthrow message="This method can only be used on tables with at least one primary key field." type="DataMgr" errorcode="NeedPKField">
	</cfif>
	<!--- Throw exception on any attempt to update a table with no updateable fields --->
	<cfif NOT ArrayLen(fields)>
		<cfthrow errorcode="NoUpdateableFields" message="This table does not have any updateable fields." type="DataMgr">
	</cfif>
	<!--- Throw exception if any pkfields are missing from incoming data --->
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfif NOT StructKeyExists(in,pkfields[i].ColumnName)>
			<cfthrow errorcode="RequiresAllPkFields" message="All Primary Key fields must be used when updating a record." type="DataMgr">
		</cfif>
	</cfloop>
	
	<!--- Check for existing record --->
	<cfset sqlarray = ArrayNew(1)>
	<cfset ArrayAppend(sqlarray,"SELECT	#escape(pkfields[1].ColumnName)#")>
	<cfset ArrayAppend(sqlarray,"FROM	#escape(arguments.tablename)#")>
	<cfset ArrayAppend(sqlarray,"WHERE	1 = 1")>
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfset ArrayAppend(sqlarray,"AND	#escape(pkfields[i].ColumnName)# = ")>
		<cfset ArrayAppend(sqlarray,sval(pkfields[i],in))>
	</cfloop>
	<cfset qGetUpdateRecord = runSQLArray(sqlarray)>
	
	<!--- Make sure record exists to update --->
	<cfif qGetUpdateRecord.RecordCount eq 0>
		<cfset temp = "">
		<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
			<cfset temp = ListAppend(temp,"#escape(pkfields[i].ColumnName)#=#in[pkfields[i].ColumnName]#")>
		</cfloop>
		<cfthrow errorcode="NoUpdateRecord" message="No record exists for update criteria (#temp#)." type="DataMgr">
	</cfif>
	
	<!--- Check for specials --->
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif StructKeyExists(fields[i],"Special") AND Len(fields[i].Special) AND NOT StructKeyExists(in,fields[i].ColumnName)>
			<cfswitch expression="#fields[i].Special#">
			<cfcase value="LastUpdatedDate">
				<cfset in[fields[i].ColumnName] = now()>
			</cfcase>
			</cfswitch>
		</cfif>
	</cfloop>
	
	<cfset sqlarray = ArrayNew(1)>
	<cfset ArrayAppend(sqlarray,"UPDATE	#escape(arguments.tablename)#")>
	<cfset ArrayAppend(sqlarray,"SET")>
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif useField(in,fields[i])><!--- Include update if this is valid data --->
			<cfset checkLength(fields[i],in[fields[i].ColumnName])>
			<cfset fieldcount = fieldcount + 1>
			<cfif fieldcount gt 1>
				<cfset ArrayAppend(sqlarray,",")>
			</cfif>
			<cfset ArrayAppend(sqlarray,"#escape(fields[i].ColumnName)# = ")>
			<cfset ArrayAppend(sqlarray,sval(fields[i],in))>
		<cfelseif isBlankValue(in,fields[i])><!--- Or if it is passed in as empty value and null are allowed --->
			<cfset fieldcount = fieldcount + 1>
			<cfif fieldcount gt 1>
				<cfset ArrayAppend(sqlarray,",")>
			</cfif>
			<cfset ArrayAppend(sqlarray,"#escape(fields[i].ColumnName)# = NULL")>
		</cfif>
	</cfloop>
	<!--- <cfif fieldcount eq 0>
		<cfthrow message="You must include at least one field to be updated (passed fields = '#StructKeyList(in)#')." type="DataMgr">
	</cfif>
	<cfset fieldcount = 0> --->
	<cfset ArrayAppend(sqlarray,"WHERE	1 = 1")>
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfset ArrayAppend(sqlarray,"AND	#escape(pkfields[i].ColumnName)# = ")>
		<cfset ArrayAppend(sqlarray,sval(pkfields[i],in))>
	</cfloop>
	<cfif fieldcount>
		<cfset runSQLArray(sqlarray)>
		<cfset fieldcount = 0>
	</cfif>
	
	<cfset result = qGetUpdateRecord[pkfields[1].ColumnName][1]>
	
	<!--- set pkfield so that we can save relation data --->
	<cfset in[pkfields[1].ColumnName] = result>
	<!--- Save any relations --->
	<cfset saveRelations(arguments.tablename,in,pkfields[1],result)>
	
	<!--- Log update --->
	<cfif variables.doLogging AND NOT arguments.tablename eq variables.logtable>
		<cfinvoke method="logAction">
			<cfinvokeargument name="tablename" value="#arguments.tablename#">
			<cfinvokeargument name="pkval" value="#result#">
			<cfinvokeargument name="action" value="update">
			<cfinvokeargument name="data" value="#in#">
			<cfinvokeargument name="sql" value="#sqlarray#">
		</cfinvoke>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="addColumn" access="public" returntype="any" output="no" hint="I add a column to the given table (deprecated in favor of setColumn).">
	<cfargument name="tablename" type="string" required="yes" hint="The name of the table to which a column will be added.">
	<cfargument name="columnname" type="string" required="yes" hint="The name of the column to add.">
	<cfargument name="CF_Datatype" type="string" required="no" hint="The ColdFusion SQL Datatype of the column.">
	<cfargument name="Length" type="numeric" default="50" hint="The ColdFusion SQL Datatype of the column.">
	<cfargument name="Default" type="string" required="no" hint="The default value for the column.">
	
	<cfset setColumn(argumentCollection=arguments)>
	
</cffunction>

<cffunction name="addTable" access="private" returntype="boolean" output="no" hint="I add a table to the Data Manager.">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="fielddata" type="array" required="yes">
	
	<cfset var isTableAdded = false>
	<cfset var i = 0>
	<cfset var j = 0>
	<cfset var hasField = false>
	
	<cfif StructKeyExists(variables.tables,arguments.tablename)>
		<!--- If the table exists, add new columns --->
		<cfloop index="i" from="1" to="#ArrayLen(arguments.fielddata)#" step="1">
			<cfset hasField = false>
			<cfloop index="j" from="1" to="#ArrayLen(variables.tables[arguments.tablename])#" step="1">
				<cfif arguments.fielddata[i]["ColumnName"] eq variables.tables[arguments.tablename][j]["ColumnName"]>
					<cfset hasField = true>
					<cfset variables.tables[arguments.tablename][j] = arguments.fielddata[i]>
				</cfif>
			</cfloop>
			<cfif NOT hasField>
				<cfset ArrayAppend(variables.tables[arguments.tablename],arguments.fielddata[i])>
			</cfif>
		</cfloop>
	<cfelse>
		<!--- If the table doesn't exist, just add it as given --->
		<cfset variables.tables[arguments.tablename] = arguments.fielddata>
	</cfif>
	
	<cfset variables.tableprops[arguments.tablename] = StructNew()>
	
	<cfset isTableAdded = true>
	
	<cfreturn isTableAdded>
</cffunction>

<cffunction name="checkLength" access="private" returntype="void" output="no" hint="I check the length of incoming data to see if it can fit in the designated field (making for a more developer-friendly error messages).">
	<cfargument name="field" type="struct" required="yes">
	<cfargument name="data" type="string" required="yes">
	
	<cfif StructKeyExists(field,"Length") AND isNumeric(field.Length) AND field.Length gt 0 AND Len(data) gt field.Length>
		<cfthrow message="The data for '#field.ColumnName#' must be no more than #field.Length# characters in length." type="DataMgr">
	</cfif>
	
</cffunction>

<cffunction name="checkTable" access="private" returntype="boolean" output="no" hint="I check to see if the given table exists in the Datamgr.">
	<cfargument name="tablename" type="string" required="yes">
	
	<!--- Note that this method is overridden for any database for which DataMgr can introspect the database table --->
	
	<cfif NOT StructKeyExists(variables.tables,arguments.tablename)>
		<cfthrow message="The table #arguments.tablename# must be loaded into DataMgr before you can use it." type="Datamgr" errorcode="NoTableLoaded">
	</cfif>
	
	<cfset checkTablePK(arguments.tablename)>
	
	<cfreturn true>
</cffunction>

<cffunction name="checkTablePK" access="private" returntype="void" output="no" hint="I check to see if the given table has a primary key.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var i = 0><!--- counter --->
	<cfset var arrFields = ArrayNew(1)><!--- array of primarykey fields --->
	
	<!--- If pkfields data if stored --->
	<cfif StructKeyExists(variables.tableprops,arguments.tablename) AND StructKeyExists(variables.tableprops[arguments.tablename],"pkfields")>
		<cfset arrFields = variables.tableprops[arguments.tablename]["pkfields"]>
	<cfelse>
		<cfloop index="i" from="1" to="#ArrayLen(variables.tables[arguments.tablename])#" step="1">
			<cfif StructKeyExists(variables.tables[arguments.tablename][i],"PrimaryKey") AND variables.tables[arguments.tablename][i].PrimaryKey>
				<cfset ArrayAppend(arrFields, variables.tables[arguments.tablename][i])>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfif NOT ArrayLen(arrFields)>
		<cfthrow message="The table #arguments.tablename# must have at least one primary key field to be used by DataMgr." type="Datamgr" errorcode="NoPKField">
	</cfif>
		
</cffunction>

<cffunction name="cleanSQLArray" access="private" returntype="array" output="no" hint="I take a potentially nested SQL array and return a flat SQL array.">
	<cfargument name="sqlarray" type="array" required="yes">
	
	<cfset var result = ArrayNew(1)>
	<cfset var i = 0>
	<cfset var j = 0>
	<cfset var temparray = 0>
	
	<cfloop index="i" from="1" to="#ArrayLen(arguments.sqlarray)#" step="1">
		<cfif isArray(arguments.sqlarray[i])>
			<cfset temparray = cleanSQLArray(arguments.sqlarray[i])>
			<cfloop index="j" from="1" to="#ArrayLen(temparray)#" step="1">
				<cfset ArrayAppend(result,temparray[j])>
			</cfloop>
		<cfelseif isStruct(arguments.sqlarray[i])>
			<cfset ArrayAppend(result,queryparam(argumentCollection=arguments.sqlarray[i]))>
		<cfelse>
			<cfset ArrayAppend(result,arguments.sqlarray[i])>
		</cfif>
	</cfloop>
	
	<cfreturn result>
</cffunction>

<cffunction name="deleteRecords" access="private" returntype="void" output="no" hint="I delete the records with the given data.">
	<cfargument name="tablename" type="string" required="yes" hint="The name of the table from which to delete a record.">
	<cfargument name="data" type="struct" required="yes" hint="A structure indicating the record to delete. A key indicates a field. The structure should have a key for each primary key in the table.">
	
	<cfset var qRecords = getRecords(arguments.tablename,arguments.data)>
	<cfset var out = StructNew()>
	
	<cfoutput query="qRecords">
		<cfset out = QueryRowToStruct(qRecords,CurrentRow)>
		<cfset deleteRecord(arguments.tablename,out)>
	</cfoutput>
	
</cffunction>

<cffunction name="DMDuplicate" access="private" returntype="any" output="no">
	<cfargument name="var" type="any" required="yes">
	
	<cfset var result = 0>
	<cfset var key = "">
	
	<cfif isStruct(arguments.var)>
		<cfset result = StructCopy(arguments.var)>
	<cfelse>
		<cfset result = arguments.var>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="escape" access="private" returntype="string" output="no" hint="I return an escaped value for a table or field.">
	<cfargument name="name" type="string" required="yes">
	<cfreturn "#arguments.name#">
</cffunction>

<cffunction name="expandRelationStruct" access="private" returntype="struct" output="no">
	<cfargument name="Relation" type="struct" required="yes">
	
	<cfset var sResult = Duplicate(arguments.Relation)>
	
	<cfscript>
	if ( StructKeyExists(sResult,"join-table") ) {
		/*
		if ( StructKeyExists(sResult,"join-field") ) {
			sResult["join-field-local"] = sResult["join-field"];
		}
		*/
		if ( StructKeyExists(sResult,"join-field-local") AND NOT StructKeyExists(sResult,"join-table-field-local") ) {
			sResult["join-table-field-local"] = sResult["join-field-local"];
		}
		if ( StructKeyExists(sResult,"join-field-remote") AND NOT StructKeyExists(sResult,"join-table-field-remote") ) {
			sResult["join-table-field-remote"] = sResult["join-field-remote"];
		}
		if ( NOT StructKeyExists(sResult,"join-table-field-local") ) {
			sResult["join-table-field-local"] = "";
		}
		if ( NOT StructKeyExists(sResult,"join-table-field-remote") ) {
			sResult["join-table-field-remote"] = "";
		}
		if ( NOT StructKeyExists(sResult,"local-table-join-field") ) {
			sResult["local-table-join-field"] = sResult["join-table-field-local"];
		}
		if ( NOT StructKeyExists(sResult,"remote-table-join-field") ) {
			sResult["remote-table-join-field"] = sResult["join-table-field-remote"];
		}
	} else {
		if ( StructKeyExists(sResult,"field") AND NOT StructKeyExists(sResult,"join-field") ) {
			sResult["join-field"] = sResult["field"];
		}
		if ( StructKeyExists(sResult,"join-field") AND NOT StructKeyExists(sResult,"join-field-local") ) {
			sResult["join-field-local"] = sResult["join-field"];
		}
		if ( StructKeyExists(sResult,"join-field") AND NOT StructKeyExists(sResult,"join-field-remote") ) {
			sResult["join-field-remote"] = sResult["join-field"];
		}
	}
	</cfscript>
	
	<cfreturn sResult>
</cffunction>

<cffunction name="fillOutJoinTableRelations" access="private" returntype="void" output="no">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var relates = variables.tables[arguments.tablename]>
	<cfset var ii = 0>
	
	<cfif NOT ( StructKeyExists(variables.tableprops[arguments.tablename],"fillOutJoinTableRelations") )>
		<cfloop index="ii" from="1" to="#ArrayLen(relates)#" step="1">
			<cfif StructKeyExists(relates[ii],"Relation")>
				<cfif
						relates[ii].Relation.type eq "list"
					AND	StructKeyExists(relates[ii].Relation,"table")
					AND	StructKeyExists(relates[ii].Relation,"join-table")>
					<cfset checkTable(relates[ii].Relation["table"])>
					<cfset checkTable(relates[ii].Relation["join-table"])>
					<cfif NOT ( StructKeyExists(relates[ii].Relation,"join-table-field-local") AND Len(relates[ii].Relation["join-table-field-local"]) )>
						<cfset variables.tables[arguments.tablename][ii].Relation["join-table-field-local"] = getPrimaryKeyFieldName(arguments.tablename)>
					</cfif>
					<cfif NOT ( StructKeyExists(relates[ii].Relation,"join-table-field-remote") AND Len(relates[ii].Relation["join-table-field-remote"]) )>
						<cfset variables.tables[arguments.tablename][ii].Relation["join-table-field-remote"] = getPrimaryKeyFieldName(relates[ii].Relation["table"])>
					</cfif>
					<cfif NOT ( StructKeyExists(relates[ii].Relation,"local-table-join-field") AND Len(relates[ii].Relation["local-table-join-field"]) )>
						<cfset variables.tables[arguments.tablename][ii].Relation["local-table-join-field"] = getPrimaryKeyFieldName(arguments.tablename)>
					</cfif>
					<cfif NOT ( StructKeyExists(relates[ii].Relation,"remote-table-join-field") AND Len(relates[ii].Relation["remote-table-join-field"]) )>
						<cfset variables.tables[arguments.tablename][ii].Relation["remote-table-join-field"] = getPrimaryKeyFieldName(relates[ii].Relation["table"])>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfset variables.tableprops[arguments.tablename]["fillOutJoinTableRelations"] = true>
	</cfif>
	
</cffunction>

<cffunction name="getField" access="private" returntype="struct" output="no" hint="I the field of the given name.">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="fieldname" type="string" required="yes">
	
	<cfset var bTable = checkTable(arguments.tablename)>
	<cfset var i = 0>
	<cfset var result = "">
	
	<!--- Loop over the fields in the table and make a list of them --->
	<cfif StructKeyExists(variables.tables,arguments.tablename)>
		<cfloop index="i" from="1" to="#ArrayLen(variables.tables[arguments.tablename])#" step="1">
			<cfif variables.tables[arguments.tablename][i].ColumnName eq arguments.fieldname>
				<cfset result = variables.tables[arguments.tablename][i]>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfif NOT isStruct(result)>
			<cfthrow message="The field #arguments.fieldname# coult not be found in the #arguments.tablename# table." type="DataMgr" errorcode="NoSuchTable">
		</cfif>
	<cfelse>
		<cfthrow message="The #arguments.tablename# table does not exist." type="DataMgr" errorcode="NoSuchTable">
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="getInsertedIdentity" access="private" returntype="string" output="no" hint="I get the value of the identity field that was just inserted into the given table.">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="identfield" type="string" required="yes">
	
	<cfset var qCheckKey = 0>
	<cfset var result = 0>
	<cfset var sqlarray = ArrayNew(1)>
	
	<cfset ArrayAppend(sqlarray,"SELECT		Max(#escape(identfield)#) AS NewID")>
	<cfset ArrayAppend(sqlarray,"FROM		#escape(arguments.tablename)#")>
	<cfset qCheckKey = runSQLArray(sqlarray)>
	
	<cfset result = Val(qCheckKey.NewID)>
	
	<cfreturn result>
</cffunction>

<cffunction name="getRelationValues" access="private" returntype="struct" output="no">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="data" type="struct" required="yes">
	
	<cfset var in = DMDuplicate(arguments.data)>
	<cfset var rfields = getRelationFields(arguments.tablename)><!--- relation fields in table --->
	<cfset var i = 0>
	<cfset var qRecords = 0>
	<cfset var temp = 0>
	<cfset var temp2 = 0>
	<cfset var j = 0>
	
	<!--- Check for incoming label values --->
	<cfloop index="i" from="1" to="#ArrayLen(rfields)#" step="1">
		<!--- Perform action for labels where join-field isn't already being given a value --->
		<cfif StructKeyExists(in,rfields[i].ColumnName)>
			<cfif
					rfields[i].Relation.type eq "label"
				AND StructKeyExists(rfields[i].Relation,"join-field-remote")
				AND NOT useField(in,getField(rfields[i].Relation["table"],rfields[i].Relation["join-field-remote"]))>
				<cfset temp = StructNew()>
				<cfset temp[rfields[i].Relation["field"]] = in[rfields[i].ColumnName]>
				<cfset qGetRecords = getRecords(tablename=rfields[i].Relation["table"],data=temp,maxrows=1,fieldlist=rfields[i].Relation["join-field-remote"])>
				<cfif qGetRecords.RecordCount>
					<cfset in[rfields[i].Relation["join-field-local"]] = qGetRecords[rfields[i].Relation["join-field-remote"]][1]>
				<cfelseif StructKeyExists(rfields[i].Relation,"onMissing")>
					<cfswitch expression="#rfields[i].Relation.onMissing#">
					<cfcase value="insert">
						<cfset temp2 = insertRecord(rfields[i].Relation["table"],temp)>
						<cfset qGetRecords = getRecords(tablename=rfields[i].Relation["table"],data=temp,maxrows=1,fieldlist=rfields[i].Relation["join-field-remote"])>
						<cfset in[rfields[i].Relation["join-field-local"]] = qGetRecords[rfields[i].Relation["join-field-remote"]][1]>
					</cfcase>
					<cfcase value="error">
						<cfthrow message="""#in[rfields[i].ColumnName]#"" is not a valid value for ""#rfields[i].ColumnName#""" errorcode="InvalidLabelValue" type="DataMgr">
					</cfcase>
					</cfswitch>
				</cfif>
				<!--- ditch this column name from in struct (no longer needed) --->
				<cfset StructDelete(in,rfields[i].ColumnName)>
			<cfelseif
					rfields[i].Relation.type eq "concat"
				AND	StructKeyExists(rfields[i].Relation,"delimiter")
				AND	StructKeyExists(rfields[i].Relation,"fields")
			>
				<cfif ListLen(rfields[i].Relation["fields"]) EQ ListLen(in[rfields[i].ColumnName],rfields[i].Relation["delimiter"])>
					<!--- Make sure none of the component fields are being passed in. --->
					<cfset temp2 = true>
					<cfloop index="temp" list="#rfields[i].Relation.fields#">
						<cfif StructKeyExists(in, temp)>
							<cfset temp2 = false>
						</cfif>
					</cfloop>
					<!--- If none of the fields are being passed in already, set fields based on concat --->
					<cfif temp2>
						<cfloop index="j" from="1" to="#ListLen(rfields[i].Relation.fields)#" step="1">
							<cfset temp = ListGetAt(rfields[i].Relation.fields,j)>
							<cfset in[temp] = ListGetAt(in[rfields[i].ColumnName],j,rfields[i].Relation["delimiter"])>
						</cfloop>
					</cfif>
				<cfelse>
					<cfthrow message="The number of items in #rfields[i].ColumnName# don't match the number of fields." type="DataMgr" errorcode="ConcatListLenMisMatch">
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	
	<cfreturn in>
</cffunction>

<cffunction name="getPreSeedRecords" access="private" returntype="query" output="no">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfreturn getRecords(argumentCollection=arguments)>
</cffunction>

<cffunction name="getRelationFields" access="private" returntype="array" output="no" hint="I return an array of primary key fields.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var i = 0><!--- counter --->
	<cfset var arrFields = ArrayNew(1)><!--- array of primarykey fields --->
	<cfset var bTable = checkTable(arguments.tablename)><!--- Check whether table is loaded --->
	<cfset var novar = fillOutJoinTableRelations(arguments.tablename)>
	<cfset var relates = variables.tables[arguments.tablename]>
	
	<cfif StructKeyExists(variables.tableprops,arguments.tablename) AND StructKeyExists(variables.tableprops[arguments.tablename],"relatefields")>
		<cfset arrFields = variables.tableprops[arguments.tablename]["relatefields"]>
	<cfelse>
		<cfloop index="i" from="1" to="#ArrayLen(relates)#" step="1">
			<cfif StructKeyExists(relates[i],"Relation")>
				<!--- Make sure all needed attributes exist --->
				<cfif StructKeyExists(relates[i].Relation,"type")>
					<cfif
							( relates[i].Relation["type"] eq "list" AND StructKeyExists(relates[i].Relation,"table") AND StructKeyExists(relates[i].Relation,"field") )
						OR	( relates[i].Relation["type"] eq "label" AND StructKeyExists(relates[i].Relation,"table") AND StructKeyExists(relates[i].Relation,"field") AND StructKeyExists(relates[i].Relation,"join-field-local") AND StructKeyExists(relates[i].Relation,"join-field-remote") )
						OR	( relates[i].Relation["type"] eq "concat" AND StructKeyExists(relates[i].Relation,"fields") AND StructKeyExists(relates[i].Relation,"delimiter") )
						OR	( ListFindNoCase(variables.aggregates,relates[i].Relation["type"]) AND StructKeyExists(relates[i].Relation,"table") AND StructKeyExists(relates[i].Relation,"field") AND StructKeyExists(relates[i].Relation,"join-field-local") AND StructKeyExists(relates[i].Relation,"join-field-remote") )
						OR	( relates[i].Relation["type"] eq "custom" )
					>
						<!--- OR	( relates[i].Relation["type"] eq "list" AND StructKeyExists(relates[i].Relation,"join-table") ) --->
						<cfset ArrayAppend(arrFields, relates[i])>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
		<cfset variables.tableprops[arguments.tablename]["relatefields"] = arrFields>
	</cfif>
	
	<cfreturn arrFields>
</cffunction>

<cffunction name="isBlankValue" access="private" returntype="boolean" output="no" hint="I see if the given field is passed in as blank and is a nullable field.">
	<cfargument name="Struct" type="struct" required="yes">
	<cfargument name="Field" type="struct" required="yes">
	
	<cfset var Key = arguments.Field.ColumnName>
	<cfset var result = false>
	
	<cfif StructKeyExists(arguments.Struct,Key) AND Field.AllowNulls AND NOT Len(arguments.Struct[Key])>
		<cfset result = true>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="isIdentityField" access="private" returntype="boolean" output="no">
	<cfargument name="Field" type="struct" required="yes">
	
	<cfset var result = false>
	
	<cfif StructKeyExists(Field,"Increment") AND Field.Increment>
		<cfset result = true>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="isOfType" access="private" returntype="boolean" output="no" hint="I check if the given value is of the given data type.">
	<cfargument name="value" type="any" required="yes">
	<cfargument name="CF_DataType" type="string" required="yes">
	
	<cfset var datum = arguments.value>
	<cfset var isOK = false>
	
	<cfif isStruct(datum) AND StructKeyExists(datum,"value")>
		<cfset datum = datum.value>
	</cfif>
	
	<cfswitch expression="#arguments.CF_DataType#">
	<cfcase value="CF_SQL_BIT">
		<cfset isOK = isBoolean(datum)>
	</cfcase>
	<cfcase value="CF_SQL_BIGINT,CF_SQL_INTEGER,CF_SQL_DECIMAL,CF_SQL_DOUBLE,CF_SQL_FLOAT,CF_SQL_NUMERIC,CF_SQL_SMALLINT,CF_SQL_TINYINT">
		<cfset isOK = isNumeric(datum)>
	</cfcase>
	<cfcase value="CF_SQL_DATE">
		<cfset isOK = isValidDate(datum)>
	</cfcase>
	<cfdefaultcase>
		<cfset isOK = true>
	</cfdefaultcase>
	</cfswitch>
	
	<cfreturn isOK>
</cffunction>

<cffunction name="makeDefaultValue" access="private" returntype="string" output="no" hint="I return the value of the default for the given datatype and raw value.">
	<cfargument name="value" type="string" required="yes">
	<cfargument name="CF_DataType" type="string" required="yes">
	
	<cfset var result = Trim(arguments.value)>
	<cfset var type = getDBDataType(arguments.CF_DataType)>
	<cfset var isFunction = true>
	
	<!--- If default isn't a string and is in parens, remove it from parens --->
	<cfif Left(result,1) eq "(" AND Right(result,1) eq ")">
		<cfset result = Mid(result,2,Len(result)-2)>
	</cfif>
	
	<!--- If default is in single quotes, remove it from single quotes --->
	<cfif Left(result,1) eq "'" AND Right(result,1) eq "'">
		<cfset result = Mid(result,2,Len(result)-2)>
		<cfset isFunction = false><!--- Functions aren't in single quotes --->
	</cfif>
	
	<!--- Functions must have an opening paren and end with a closing paren --->
	<cfif isFunction AND NOT (FindNoCase("(", result) AND Right(result,1) eq ")")>
		<cfset isFunction = false>
	</cfif>
	<!--- Functions don't start with a paren --->
	<cfif isFunction AND Left(result,1) eq "(">
		<cfset isFunction = false>
	</cfif>
	
	<!--- boolean values should be stored as one or zero --->
	<cfif arguments.CF_DataType eq "CF_SQL_BIT">
		<cfif isBoolean(result) AND result>
			<cfset result = "1">
		<cfelse>
			<cfset result = "0">
		</cfif>
	</cfif>
	
	<!--- string values that aren't functions, should be in single quotes. --->
	<cfif isStringType(type) AND NOT isFunction>
		<cfset result = ReplaceNoCase(result, "'", "''", "ALL")>
		<cfset result = "'#result#'">
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="readyTable" access="private" returntype="void" output="no" hint="I get the internal table representation ready for use by DataMgr.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset checkTable()>
	
	<cfif NOT ( StructKeyExists(variables.tableprops,arguments.tablename) AND StructCount(variables.tableprops[arguments.tablename]) )>
		<cfset getFieldList(arguments.tablename)>
		<cfset getPKFields(arguments.tablename)>
		<cfset getUpdateableFields(arguments.tablename)>
		<cfset getRelationFields()>
		<cfset makeFieldSQLs()>
	</cfif>
</cffunction>

<cffunction name="getTableProps" access="public" returntype="struct" output="no" hint="I get the internal table representation ready for use by DataMgr.">
	<cfargument name="tablename" type="string" required="no">
	
	<cfif StructKeyExists(arguments,"tablename")>
		<cfreturn variables.tableprops[arguments.tablename]>
	<cfelse>
		<cfreturn variables.tableprops>
	</cfif>
	
</cffunction>

<cffunction name="saveRelations" access="private" returntype="void" output="no">
	<cfargument name="tablename" type="string" required="yes" hint="The table on which to update data.">
	<cfargument name="data" type="struct" required="yes" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	<cfargument name="pkfield" type="struct" required="yes" hint="The primary key field for the record.">
	<cfargument name="pkval" type="string" required="yes" hint="The primary key for the record.">
	
	<cfset var relates = getRelationFields(arguments.tablename)>
	<cfset var i = 0>
	<cfset var in = DMDuplicate(arguments.data)>
	<cfset var rtablePKeys = 0>
	<cfset var temp = "">
	<cfset var val = "">
	<cfset var list = "">
	<cfset var fieldPK = "">
	<cfset var fieldMulti = "">
	<cfset var reverse = false>
	
	<cfif ArrayLen(relates)>
		<cfloop index="i" from="1" to="#ArrayLen(relates)#" step="1">
			<!--- Make sure all needed attributes exist --->
			<cfif
					StructKeyExists(in,relates[i].ColumnName)
				AND	relates[i].Relation["type"] eq "list"
				AND	StructKeyExists(relates[i].Relation,"join-table")
			>
				<cfset rtablePKeys = getPKFields(relates[i].Relation["table"])>
				<cfif NOT ArrayLen(rtablePKeys)>
					<cfset rtablePKeys = getUpdateableFields(relates[i].Relation["table"])>
				</cfif>
				
				<cfif Len(relates[i].Relation["join-table-field-local"])>
					<cfset fieldPK = relates[i].Relation["join-table-field-local"]>
				<cfelse>
					<cfset fieldPK = getPrimaryKeyFieldName(arguments.tablename)>
				</cfif>
				
				<cfif Len(relates[i].Relation["join-table-field-remote"])>
					<cfset fieldMulti = relates[i].Relation["join-table-field-remote"]>
				<cfelse>
					<cfset fieldMulti = getPrimaryKeyFieldName(relates[i].Relation["table"])>
				</cfif>
				
				<cfif
						arguments.tablename EQ relates[i].Relation["table"]
					AND	StructKeyExists(relates[i].Relation,"bidirectional")
					AND	isBoolean(relates[i].Relation["bidirectional"])
					AND	relates[i].Relation["bidirectional"]
				>
					<cfset reverse = true>
				<cfelse>
					<cfset reverse = false>
				</cfif>
				
				<!--- If relate column is pk, use saveRelationList normally --->
				<cfif relates[i].Relation["field"] EQ rtablePKeys[1].ColumnName>
					<!--- Save this relation list --->
					<cfset saveRelationList(relates[i].Relation["join-table"],fieldPK,arguments.pkval,fieldMulti,in[relates[i].ColumnName],reverse)>
				<cfelse>
					<cfset list = "">
					<!--- Otherwise, get the values --->
					<cfloop index="val" list="#in[relates[i].ColumnName]#">
						<cfset temp = StructNew()>
						<cfset temp[relates[i].Relation["field"]] = val>
						<cfset qGetRecords = getRecords(tablename=relates[i].Relation["table"],data=temp,fieldlist=rtablePKeys[1].ColumnName)>
						<cfif qGetRecords.RecordCount>
							<cfset list = ListAppend(list,qGetRecords[rtablePKeys[1].ColumnName][1])>
						</cfif>
					</cfloop>
					<cfset saveRelationList(relates[i].Relation["join-table"],fieldPK,arguments.pkval,fieldMulti,list,reverse)>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
	
</cffunction>

<cffunction name="seedData" access="private" returntype="void" output="no">
	<cfargument name="xmldata" type="any" required="yes" hint="XML data of tables to load into DataMgr follows. Schema: http://www.bryantwebconsulting.com/cfc/DataMgr.xsd">
	<cfargument name="CreatedTables" type="string" required="yes">
	
	<cfset var varXML = arguments.xmldata>
	<cfset var arrData = XmlSearch(varXML, "//data")>
	<cfset var stcData = StructNew()>
	<cfset var tables = "">
	
	<cfset var i = 0>
	<cfset var table = "">
	<cfset var j = 0>
	<cfset var rowElement = 0>
	<cfset var rowdata = 0>
	<cfset var att = "">
	<cfset var k = 0>
	<cfset var fieldElement = 0>
	<cfset var fieldatts = 0>
	<cfset var reldata = 0>
	<cfset var m = 0>
	<cfset var relfieldElement = 0>
	
	<cfset var data = 0>
	<cfset var col = "">
	<cfset var qRecord = 0>
	<cfset var qRecords = 0>
	
	<cfif ArrayLen(arrData)>
		<cfscript>
		//  Loop through data elements
		for ( i=1; i lte ArrayLen(arrData); i=i+1 ) {
			//  Get table name
			if ( StructKeyExists(arrData[i].XmlAttributes,"table") ) {
				table = arrData[i].XmlAttributes["table"];
			} else {
				if ( arrData[i].XmlParent.XmlName eq "table" AND StructKeyExists(arrData[i].XmlParent.XmlAttributes,"name") ) {
					table = arrData[i].XmlParent.XmlAttributes["name"];
				}
			}
			if ( NOT ( StructKeyExists(arrData[i].XmlAttributes,"permanentRows") AND isBoolean(arrData[i].XmlAttributes["permanentRows"]) ) ) {
				arrData[i].XmlAttributes["permanentRows"] = false;
			}
			// /Get table name
			if ( ListFindNoCase(arguments.CreatedTables,table) OR arrData[i].XmlAttributes["permanentRows"] ) {
				//  Make sure structure exists for this table
				if ( NOT StructKeyExists(stcData,table) ) {
					stcData[table] = ArrayNew(1);
					tables = ListAppend(tables,table);
				}
				// /Make sure structure exists for this table
				//  Loop through rows
				for ( j=1; j lte ArrayLen(arrData[i].XmlChildren); j=j+1 ) {
					//  Make sure this element is a row
					if ( arrData[i].XmlChildren[j].XmlName eq "row" ) {
						rowElement = arrData[i].XmlChildren[j];
						rowdata = StructNew();
						//  Loop through fields in row tag
						for ( att in rowElement.XmlAttributes ) {
							rowdata[att] = rowElement.XmlAttributes[att];
						}
						// /Loop through fields in row tag
						//  Loop through field tags
						if ( StructKeyExists(rowElement,"XmlChildren") AND ArrayLen(rowElement.XmlChildren) ) {
							//  Loop through field tags
							for ( k=1; k lte ArrayLen(rowElement.XmlChildren); k=k+1 ) {
								fieldElement = rowElement.XmlChildren[k];
								//  Make sure this element is a field
								if ( fieldElement.XmlName eq "field" ) {
									fieldatts = "name,value,reltable,relfield";
									reldata = StructNew();
									//  If this field has a name
									if ( StructKeyExists(fieldElement.XmlAttributes,"name") ) {
										if ( StructKeyExists(fieldElement.XmlAttributes,"value") ) {
											rowdata[fieldElement.XmlAttributes["name"]] = fieldElement.XmlAttributes["value"];
										} else if ( StructKeyExists(fieldElement.XmlAttributes,"reltable") ) {
											if ( NOT StructKeyExists(fieldElement.XmlAttributes,"relfield") ) {
												fieldElement.XmlAttributes["relfield"] = fieldElement.XmlAttributes["name"];
											}
											//  Loop through attributes for related fields
											for ( att in fieldElement.XmlAttributes ) {
												if ( NOT ListFindNoCase(fieldatts,att) ) {
													reldata[att] = fieldElement.XmlAttributes[att];
												}
											}
											// /Loop through attributes for related fields
											if ( ArrayLen(fieldElement.XmlChildren) ) {
												//  Loop through relfield elements
												for ( m=1; m lte ArrayLen(fieldElement.XmlChildren); m=m+1 ) {
													relfieldElement = fieldElement.XmlChildren[m];
													if ( relfieldElement.XmlName eq "relfield" AND StructKeyExists(relfieldElement.XmlAttributes,"name") AND StructKeyExists(relfieldElement.XmlAttributes,"value") ) {
														reldata[relfieldElement.XmlAttributes["name"]] = relfieldElement.XmlAttributes["value"];
													}
												}
												// /Loop through relfield elements
											}
											rowdata[fieldElement.XmlAttributes["name"]] = StructNew();
											rowdata[fieldElement.XmlAttributes["name"]]["reltable"] = fieldElement.XmlAttributes["reltable"];
											rowdata[fieldElement.XmlAttributes["name"]]["relfield"] = fieldElement.XmlAttributes["relfield"];
											rowdata[fieldElement.XmlAttributes["name"]]["reldata"] = reldata;
										}
									}
									// /If this field has a name
								}
								// /Make sure this element is a field
							}
							// /Loop through field tags
						}
						// /Loop through field tags
						ArrayAppend(stcData[table], rowdata);
					}
					// /Make sure this element is a row
				}
				// /Loop through rows
			}
		}
		// /Loop through data elements
		if ( Len(tables) ) {
			//  Loop through tables
			for ( i=1; i lte ArrayLen(arrData); i=i+1 ) {
			//for ( i=1; i lte ListLen(tables); i=i+1 ) {
				//table = ListGetAt(tables,i);
				table = arrData[i].XmlAttributes["table"];
				qRecords = getPreSeedRecords(table);
				//  If table has seed records
				if ( ( StructKeyExists(stcData,table) AND ArrayLen(stcData[table]) ) AND ( arrData[i].XmlAttributes["permanentRows"] OR NOT qRecords.RecordCount ) ) {
					//  Loop through seed records
					for ( j=1; j lte ArrayLen(stcData[table]); j=j+1 ) {
						data = StructNew();
						//  Loop through fields in table
						for ( col in stcData[table][j] ) {
							//  Simple val?
							if ( isSimpleValue(stcData[table][j][col]) ) {
								data[col] = stcData[table][j][col];
							} else {
								//  Struct?
								if ( isStruct(stcData[table][j][col]) ) {
									//  Get record of related data
									qRecord = getRecords(stcData[table][j][col]["reltable"],stcData[table][j][col]["reldata"]);
									if ( qRecord.RecordCount eq 1 AND ListFindNoCase(qRecord.ColumnList,stcData[table][j][col]["relfield"]) ) {
										data[col] = qRecord[stcData[table][j][col]["relfield"]][1];
									}
								}
								// /Struct?
							}
							// /Simple val?
						}
						// /Loop through fields in table
						if ( StructCount(data) ) {
							seedRecord(table,data,'skip');
						}
					}
					// /Loop through seed records
				}
				//  If table has seed records
			}
			// /Loop through tables
		}
		</cfscript>
	</cfif>
	
</cffunction>

<cffunction name="seedRecord" access="private" returntype="string" output="no">
	<cfargument name="tablename" type="string" required="yes" hint="The table in which to insert data.">
	<cfargument name="data" type="struct" required="yes" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	<cfargument name="OnExists" type="string" default="insert" hint="The action to take if a record with the given values exists. Possible values: insert (inserts another record), error (throws an error), update (updates the matching record), skip (performs no action).">
	
	<cfset arguments.OnExists = "skip">
	
	<cfreturn insertRecord(argumentCollection=arguments)>
</cffunction>

<cffunction name="setColumnPrimaryKey" access="private" returntype="void" output="no">
	<cfargument name="tablename" type="string" required="yes" hint="The name of the table to which a column will be added.">
	<cfargument name="columnname" type="string" required="yes" hint="The name of the column to add.">
	
	<cfset var mytable = variables.tables[arguments.tablename]>
	<cfset var i = 0>
	
	<cfloop index="i" from="1" to="#ArrayLen(mytable)#" step="1">
		<cfif mytable[i].ColumnName EQ arguments.columnname>
			<cfset mytable[i]["PrimaryKey"] = true>
		</cfif>
	</cfloop>
	
</cffunction>

<cffunction name="setColumnRelation" access="private" returntype="void" output="no">
	<cfargument name="tablename" type="string" required="yes" hint="The name of the table to which a column will be added.">
	<cfargument name="columnname" type="string" required="yes" hint="The name of the column to add.">
	<cfargument name="Relation" type="struct" required="no" hint="Relationship information for this column.">
	
	<cfset var mytable = variables.tables[arguments.tablename]>
	<cfset var ii = 0>
	
	<cfloop index="ii" from="1" to="#ArrayLen(mytable)#" step="1">
		<cfif mytable[ii].ColumnName EQ arguments.columnname>
			<cfset mytable[ii]["Relation"] = expandRelationStruct(arguments.Relation)>
		</cfif>
	</cfloop>
	
</cffunction>

<cffunction name="setColumnSpecial" access="private" returntype="void" output="no">
	<cfargument name="tablename" type="string" required="yes" hint="The name of the table to which a column will be added.">
	<cfargument name="columnname" type="string" required="yes" hint="The name of the column to add.">
	<cfargument name="Special" type="string" required="yes" hint="The special behavior for the column.">
	
	<cfset var mytable = variables.tables[arguments.tablename]>
	<cfset var i = 0>
	
	<cfloop index="i" from="1" to="#ArrayLen(mytable)#" step="1">
		<cfif mytable[i].ColumnName EQ arguments.columnname>
			<cfset mytable[i]["Special"] = arguments.Special>
		</cfif>
	</cfloop>
	
</cffunction>

<cffunction name="skey" access="private" returntype="struct" output="no" hint="I return a structure for use in runSQLArray (I make a value key in the structure with the appropriate value).">
	<cfargument name="name" type="string" required="yes">
	<cfargument name="val" type="string" required="yes">
	
	<cfset var result = StructNew()>
	
	<cfset result[arguments.name] = arguments.val>
	
	<cfreturn result>
</cffunction>

<cffunction name="StructKeyHasLen" access="private" returntype="numeric" output="no" hint="I check to see if the given key of the given structure exists and has a value with any length.">
	<cfargument name="Struct" type="struct" required="yes">
	<cfargument name="Key" type="string" required="yes">
	
	<cfset var result = false>
	
	<cfif StructKeyExists(arguments.Struct,arguments.Key) AND isSimpleValue(arguments.Struct[arguments.Key]) AND Len(arguments.Struct[arguments.Key])>
		<cfset result = true>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="sval" access="private" returntype="struct" output="no" hint="I return a structure for use in runSQLArray (I make a value key in the structure with the appropriate value).">
	<cfargument name="struct" type="struct" required="yes">
	<cfargument name="val" type="any" required="yes">
	
	<cfset var currval = DMDuplicate(arguments.val)>
	<cfset var sResult = DMDuplicate(arguments.struct)>
	
	<cfif IsSimpleValue(val)>
		<cfset sResult.value = currval>
	<cfelseif IsStruct(currval) AND StructKeyExists(sResult,"ColumnName") AND StructKeyExists(currval,sResult.ColumnName)>
		<cfset sResult.value = val[struct.ColumnName]>
	<cfelseif IsQuery(currval) AND StructKeyExists(sResult,"ColumnName") AND ListFindNoCase(currval.ColumnList,sResult.ColumnName)>
		<cfset sResult.value = currval[sResult.ColumnName][1]>
	<cfelse>
		<cfthrow message="Unable to add data to structure for #sResult.ColumnName#" type="DataMgr">
	</cfif>
	
	<cfreturn sResult>
</cffunction>

<cffunction name="useField" access="private" returntype="boolean" output="no" hint="I check to see if the given field should be used in the SQL statement.">
	<cfargument name="Struct" type="struct" required="yes">
	<cfargument name="Field" type="struct" required="yes">
	
	<cfset var result = false>
	
	<cfif StructKeyHasLen(Struct,Field.ColumnName) AND isOfType(Struct[Field.ColumnName],Field.CF_DataType)>
		<cfset result = true>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cfscript>
/**
 * Makes a row of a query into a structure.
 * 
 * @param query 	 The query to work with. 
 * @param row 	 Row number to check. Defaults to row 1. 
 * @return Returns a structure. 
 * @author Nathan Dintenfass (nathan@changemedia.com) 
 * @version 1, December 11, 2001 
 */
function queryRowToStruct(query){
	//by default, do this to the first row of the query
	var row = 1;
	//a var for looping
	var ii = 1;
	//the cols to loop over
	var cols = listToArray(query.columnList);
	//the struct to return
	var stReturn = structnew();
	//if there is a second argument, use that for the row number
	if(arrayLen(arguments) GT 1)
		row = arguments[2];
	//loop over the cols and build the struct from the query row
	for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
		stReturn[cols[ii]] = query[cols[ii]][row];
	}		
	//return the struct
	return stReturn;
}
</cfscript>

<cffunction name="getXML" access="public" returntype="string" output="no" hint="I return the XML for the given table or for all loaded tables if none given.">
	<cfargument name="tablename" type="string" required="no">
	
	<cfset var result = "">
	
	<cfset var table = "">
	<cfset var i = 0>
	<cfset var rAtts = "table,type,field,join-table,join-field,join-field-local,join-field-remote,fields,delimiter,onDelete,onMissing">
	<cfset var rKey = "">
	<cfset var sTables = 0>
	
	<cfif StructKeyExists(arguments,"tablename")>
		<cfset checkTable(arguments.tablename)><!--- Check whether table is loaded --->
	</cfif>
	
	<cfinvoke method="getTableData" returnvariable="sTables">
		<cfif StructKeyExists(arguments,"tablename") AND Len(arguments.tablename)>
			<cfinvokeargument name="tablename" value="#arguments.tablename#">
		</cfif>
	</cfinvoke>

<cfsavecontent variable="result"><cfoutput>
<tables><cfloop collection="#sTables#" item="table">
	<table name="#table#"><cfloop index="i" from="1" to="#ArrayLen(sTables[table])#" step="1"><cfif StructKeyExists(sTables[table][i],"CF_DataType")>
		<field ColumnName="#sTables[table][i].ColumnName#" CF_DataType="#sTables[table][i].CF_DataType#"<cfif StructKeyExists(sTables[table][i],"PrimaryKey") AND isBoolean(sTables[table][i].PrimaryKey) AND sTables[table][i].PrimaryKey> PrimaryKey="true"</cfif><cfif StructKeyExists(sTables[table][i],"Increment") AND isBoolean(sTables[table][i].Increment) AND sTables[table][i].Increment> Increment="true"</cfif><cfif StructKeyExists(sTables[table][i],"Length") AND isNumeric(sTables[table][i].Length) AND sTables[table][i].Length gt 0> Length="#Int(sTables[table][i].Length)#"</cfif><cfif StructKeyExists(sTables[table][i],"Default") AND Len(sTables[table][i].Default)> Default="#sTables[table][i].Default#"</cfif><cfif StructKeyExists(sTables[table][i],"Precision") AND isNumeric(sTables[table][i]["Precision"])> Precision="#sTables[table][i]["Precision"]#"</cfif><cfif StructKeyExists(sTables[table][i],"Scale") AND isNumeric(sTables[table][i]["Scale"])> Scale="#sTables[table][i]["Scale"]#"</cfif><cfif StructKeyExists(sTables[table][i],"Special") AND Len(sTables[table][i]["Special"])> Special="#sTables[table][i]["Special"]#"</cfif> /><cfelseif StructKeyExists(sTables[table][i],"Relation")>
		<field ColumnName="#sTables[table][i].ColumnName#">
			<relation<cfloop index="rKey" list="#rAtts#"><cfif StructKeyExists(sTables[table][i].Relation,rKey)> #rKey#="#XmlFormat(sTables[table][i].Relation[rKey])#"</cfif></cfloop><cfloop collection="#sTables[table][i].Relation#" item="rKey"><cfif NOT ListFindNoCase(rAtts,rKey)> #LCase(rKey)#="#XmlFormat(sTables[table][i].Relation[rKey])#"</cfif></cfloop> />
		</field></cfif></cfloop>
	</table></cfloop>
</tables>
</cfoutput></cfsavecontent>
	
	<cfreturn result>
</cffunction>

</cfcomponent>