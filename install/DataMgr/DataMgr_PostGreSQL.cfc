<!--- 2.1 (Build 112) --->
<!--- Last Updated: 2007-07-10 --->
<!--- Created by Steve Bryant 2004-12-08 --->
<cfcomponent extends="DataMgr" displayname="Data Manager for PostGreSQL" hint="I manage data interactions with the PostGreSQL database. I can be used to handle inserts/updates.">

<cffunction name="getDatabase" access="public" returntype="string" output="no" hint="I return the database platform being used (Access,MS SQL,MySQL etc).">
	<cfreturn "PostGreSQL">
</cffunction>

<cffunction name="getDatabaseShortString" access="public" returntype="string" output="no" hint="I return the string that can be found in the driver or JDBC URL for the database platform being used.">
	<cfreturn "postgre">
</cffunction>

<cffunction name="getCreateSQL" access="public" returntype="string" output="no" hint="I return the SQL to create the given table.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var i = 0>
	<cfset var arrFields = getFields(arguments.tablename)>
	<cfset var CreateSQL = "">
	<cfset var pkfields = "">
	<cfset var thisField = "">
	
	<!--- Find Primary Key fields --->
	<cfloop index="i" from="1" to="#ArrayLen(arrFields)#" step="1">
		<cfif arrFields[i].PrimaryKey>
			<cfset pkfields = ListAppend(pkfields,arrFields[i].ColumnName)>
		</cfif>
	</cfloop>
	
	<cfsavecontent variable="CreateSQL"><cfoutput>
	CREATE TABLE #escape(arguments.tablename)# (<cfloop index="i" from="1" to="#ArrayLen(arrFields)#" step="1">
		#escape(arrFields[i].ColumnName)#<cfif StructKeyExists(arrFields[i],"Increment") AND arrFields[i].Increment> SERIAL<cfelse> #getDBDataType(arrFields[i].CF_DataType)#<cfif isStringType(getDBDataType(arrFields[i].CF_DataType))> (<cfif StructKeyExists(arrFields[i],"Length") AND isNumeric(arrFields[i].Length) AND arrFields[i].Length gt 0>#arrFields[i].Length#<cfelse>255</cfif>)</cfif></cfif><cfif StructKeyExists(arrFields[i],"Default") AND Len(Trim(arrFields[i].Default))> DEFAULT #arrFields[i].Default#</cfif> <cfif ListFindNoCase(pkfields,arrFields[i].ColumnName) OR Not arrFields[i].AllowNulls>NOT </cfif>NULL <cfif StructKeyExists(arrFields[i],"PrimaryKey") AND arrFields[i].PrimaryKey>PRIMARY KEY</cfif><cfif i lt ArrayLen(arrFields)>,</cfif></cfloop>
	)
	</cfoutput></cfsavecontent>
	
	<cfreturn CreateSQL>
</cffunction>

<cffunction name="concat" access="public" returntype="string" output="no" hint="I return the SQL to concatenate the given fields with the given delimeter.">
	<cfargument name="fields" type="string" required="yes">
	<cfargument name="delimeter" type="string" default="">
	
	<cfset var colname = "">
	<cfset var result = "">
	
	<cfloop index="colname" list="#arguments.fields#">
		<cfif Len(result)>
			<cfset result =  "#result# || '#arguments.delimeter#' || CAST(#colname# AS varchar)">
		<cfelse>
			<cfset result = "CAST(#colname# AS varchar)">
		</cfif>
	</cfloop>
	
	<cfreturn result>
</cffunction>

<cffunction name="concatFields" access="public" returntype="array" output="no" hint="I return the SQL to concatenate the given fields with the given delimeter.">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="fields" type="string" required="yes">
	<cfargument name="delimeter" type="string" default=",">
	<cfargument name="tablealias" type="string" required="no">
	
	<cfset var col = "">
	<cfset var aSQL = ArrayNew(1)>
	<cfset var fieldSQL = 0>
	
	<cfif NOT StructKeyExists(arguments,"tablealias")>
		<cfset arguments.tablealias = arguments.tablename>
	</cfif>
	
	<cfloop index="colname" list="#arguments.fields#">
		<cfset fieldSQL = getFieldSelectSQL(tablename=arguments.tablename,field=colname,tablealias=arguments.tablealias,useFieldAlias=false)>
		<cfif ArrayLen(aSQL)>
			<cfset ArrayAppend(aSQL," || '#arguments.delimeter#' || ")>
		</cfif>
		<cfif isSimpleValue(fieldSQL)>
			<cfset ArrayAppend(aSQL,"CAST(#fieldSQL# AS varchar)")>
		<cfelse>
			<cfset ArrayAppend(aSQL,"CAST(")>
			<cfset ArrayAppend(aSQL,fieldSQL)>
			<cfset ArrayAppend(aSQL," AS varchar)")>
		</cfif>
	</cfloop>
	
	<cfreturn aSQL>
</cffunction>

<cffunction name="escape" access="public" returntype="string" output="yes" hint="I return an escaped value for a table or field.">
	<cfargument name="name" type="string" required="yes">
	
	<cfset var result = "">
	<cfset var item = "">
	
	<cfloop index="item" list="#arguments.name#" delimiters=".">
		<cfset result = ListAppend(result,"#chr(34)##item##chr(34)#",".")>
	</cfloop>
	
	<cfreturn result>
</cffunction>

<cffunction name="getDatabaseTables" access="public" returntype="string" output="yes" hint="I get a list of all tables in the current database.">

	<cfset var qTables = runSQL("SELECT tablename FROM pg_tables WHERE tableowner = current_user")>
	
	<cfreturn ValueList(qTables.tablename)>
</cffunction>

<cffunction name="getDBTableStruct" access="public" returntype="array" output="no" hint="I return the structure of the given table in the database.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfscript>
	var qTable = runSQL("SELECT tablename FROM pg_tables WHERE tableowner = current_user AND tablename = '#arguments.tablename#'");
	var qFields = 0;
	var qPrimaryKeys = 0;
	var qSequences = 0;
	var PrimaryKeys = "";
	var Sequences = "";
	var TableData = ArrayNew(1);
	var tmpStruct = StructNew();
	var sqlarray = ArrayNew(1);
	</cfscript>
	
	<cfif qTable.RecordCount eq 0>
		<cfthrow message="Data Manager: No such table ('#arguments.tablename#'). Trying to load a table that doesn't exist." type="DataMgr">
	</cfif>
	<!--- <cfquery name="qFields" datasource="#variables.datasource#">
	SELECT	attnum,attname AS Field
	FROM	pg_class, pg_attribute
	WHERE	relname = '#arguments.tablename#'
 		AND	pg_class.oid = attrelid
		AND	attnum > 0
	</cfquery> --->
	<cfset sqlarray = ArrayNew(1)>
	<cfset ArrayAppend(sqlarray,"SELECT		a.attnum, a.attname AS Field, t.typname AS Type,")>
	<cfset ArrayAppend(sqlarray,"			a.attlen AS Length, a.atttypmod, a.attnotnull AS NotNull, a.atthasdef,")>
	<cfset ArrayAppend(sqlarray,"			d.adsrc AS #escape('Default')#")>
	<cfset ArrayAppend(sqlarray,"FROM		pg_class as c")>
	<cfset ArrayAppend(sqlarray,"INNER JOIN	pg_attribute a")>
	<cfset ArrayAppend(sqlarray,"	ON		c.oid = a.attrelid")>
	<cfset ArrayAppend(sqlarray,"INNER JOIN	pg_type t")>
	<cfset ArrayAppend(sqlarray,"	ON		a.atttypid = t.oid")>
	<cfset ArrayAppend(sqlarray,"LEFT JOIN	pg_attrdef d")>
	<cfset ArrayAppend(sqlarray,"	ON		c.oid = d.adrelid")>
	<cfset ArrayAppend(sqlarray,"		AND	d.adnum = a.attnum")>
	<cfset ArrayAppend(sqlarray,"WHERE		a.attnum > 0")>
	<cfset ArrayAppend(sqlarray,"	AND		c.relname = 'cmsPages'")>
	<cfset ArrayAppend(sqlarray,"ORDER BY	a.attnum")>
	<cfset qFields = runSQLArray(sqlarray)>
	
	<cfset sqlarray = ArrayNew(1)>
	<cfset ArrayAppend(sqlarray,"SELECT	conkey")>
	<cfset ArrayAppend(sqlarray,"FROM	pg_constraint")>
	<cfset ArrayAppend(sqlarray,"JOIN	pg_class")>
	<cfset ArrayAppend(sqlarray,"	ON	pg_class.oid=conrelid")>
	<cfset ArrayAppend(sqlarray,"WHERE	contype='p'")>
	<cfset ArrayAppend(sqlarray,"	AND	relname = '#arguments.tablename#'")>
	<cfset qPrimaryKeys = runSQLArray(sqlarray)>
	
	<cfset PrimaryKeys = ValueList(qPrimaryKeys.conkey)>
	
	<cfset sqlarray = ArrayNew(1)>
	<cfset ArrayAppend(sqlarray,"SELECT	relname")>
	<cfset ArrayAppend(sqlarray,"FROM	pg_class")>
	<cfset ArrayAppend(sqlarray,"WHERE	relkind = 'S'")>
	<cfset ArrayAppend(sqlarray,"	AND	relname LIKE '#arguments.tablename#%'")>
	<cfset qSequences = runSQLArray(sqlarray)>
	
	<cfoutput query="qSequences">
		<cfset Sequences = ListAppend(Sequences,ReplaceNoCase(ReplaceNoCase(relname, "#arguments.tablename#_", ""), "_seq", "") )>
	</cfoutput>
	

	<cfoutput query="qFields">
		<cfset tmpStruct = StructNew()>
		<cfset tmpStruct["ColumnName"] = Field>
		<cfset tmpStruct["CF_DataType"] = getCFDataType(type)>
		<cfif ListFindNoCase(Sequences,Field)>
			<cfset tmpStruct["Increment"] = True>
		</cfif>
		<cfif ListFindNoCase(PrimaryKeys,Field)>
			<cfset tmpStruct["PrimaryKey"] = True>
		</cfif>
		<cfif isStringType(type) AND NOT tmpStruct["CF_DataType"] eq "CF_SQL_LONGVARCHAR">
			<cfset tmpStruct["length"] = getLength(type)>
		</cfif>
		<cfif isBoolean(NotNull)>
			<cfset tmpStruct["AllowNulls"] = NotNull>
		<cfelse>
			<cfset tmpStruct["AllowNulls"] = true>
		</cfif>
		<cfif Len(Default)>
			<cfset tmpStruct["Default"] = Default>
		</cfif>
		<cfset tmpStruct["Precision"] = "">
		<cfset tmpStruct["Scale"] = "">
		<cfset tmpStruct["Special"] = "">
		
		<cfif Len(tmpStruct.CF_DataType)>
			<cfset ArrayAppend(TableData,StructCopy(tmpStruct))>
		</cfif>
	</cfoutput>
	
	<cfreturn TableData>
</cffunction>

<cffunction name="getCFDataType" access="public" returntype="string" output="no" hint="I return the cfqueryparam datatype from the database datatype.">
	<cfargument name="type" type="string" required="yes" hint="The database data type.">
	
	<cfset var result = "">
	<cfif FindNoCase(arguments.type,"(")>
		<cfset arguments.type = Left(arguments.type,FindNoCase(arguments.type,"("))>
	</cfif>
	
	<cfswitch expression="#arguments.type#">
		<cfcase value="bigint"><cfset result = "CF_SQL_BIGINT"></cfcase>
		<cfcase value="binary,image,sql_variant,sysname,varbinary"><cfset result = ""></cfcase>
		<cfcase value="bit,boolean"><cfset result = "CF_SQL_BIT"></cfcase>
		<cfcase value="char"><cfset result = "CF_SQL_CHAR"></cfcase>
		<cfcase value="date"><cfset result = "CF_SQL_DATE"></cfcase>
		<cfcase value="decimal"><cfset result = "CF_SQL_DECIMAL"></cfcase>
		<cfcase value="double"><cfset result = "CF_SQL_DOUBLE"></cfcase>
		<cfcase value="float"><cfset result = "CF_SQL_FLOAT"></cfcase>
		<cfcase value="int"><cfset result = "CF_SQL_INTEGER"></cfcase>
		<cfcase value="money"><cfset result = "CF_SQL_MONEY"></cfcase>
		<cfcase value="nchar"><cfset result = "CF_SQL_CHAR"></cfcase>
		<cfcase value="ntext"><cfset result = "CF_SQL_LONGVARCHAR"></cfcase>
		<cfcase value="numeric"><cfset result = "CF_SQL_NUMERIC"></cfcase>
		<cfcase value="nvarchar"><cfset result = "CF_SQL_VARCHAR"></cfcase>
		<cfcase value="real"><cfset result = "CF_SQL_REAL"></cfcase>
		<cfcase value="smalldatetime"><cfset result = "CF_SQL_DATE"></cfcase>
		<cfcase value="smallint"><cfset result = "CF_SQL_SMALLINT"></cfcase>
		<cfcase value="smallmoney"><cfset result = "CF_SQL_MONEY4"></cfcase>
		<cfcase value="text"><cfset result = "CF_SQL_LONGVARCHAR"></cfcase>
		<cfcase value="timestamp"><cfset result = "CF_SQL_TIMESTAMP"></cfcase>
		<cfcase value="tinyint"><cfset result = "CF_SQL_TINYINT"></cfcase>
		<cfcase value="uniqueidentifier"><cfset result = "CF_SQL_IDSTAMP"></cfcase>
		<cfcase value="varchar"><cfset result = "CF_SQL_VARCHAR"></cfcase>
		<cfdefaultcase><cfset result = ""></cfdefaultcase>
	</cfswitch>
	
	<cfreturn result>
</cffunction>

<cffunction name="getDBDataType" access="public" returntype="string" output="no" hint="I return the database datatype from the cfqueryparam datatype.">
	<cfargument name="CF_Datatype" type="string" required="yes">
	
	<cfset var result = "">
	
	<cfswitch expression="#arguments.CF_Datatype#">
		<cfcase value="CF_SQL_BIGINT"><cfset result = "bigint"></cfcase>
		<cfcase value="CF_SQL_BIT"><cfset result = "boolean"></cfcase>
		<cfcase value="CF_SQL_CHAR"><cfset result = "char"></cfcase>
		<cfcase value="CF_SQL_DATE"><cfset result = "date"></cfcase>
		<cfcase value="CF_SQL_DECIMAL"><cfset result = "decimal"></cfcase>
		<cfcase value="CF_SQL_DOUBLE"><cfset result = "double"></cfcase>
		<cfcase value="CF_SQL_FLOAT"><cfset result = "float"></cfcase>
		<cfcase value="CF_SQL_IDSTAMP"><cfset result = "uniqueidentifier"></cfcase>
		<cfcase value="CF_SQL_INTEGER"><cfset result = "int"></cfcase>
		<cfcase value="CF_SQL_LONGVARCHAR"><cfset result = "text"></cfcase>
		<cfcase value="CF_SQL_MONEY"><cfset result = "money"></cfcase>
		<cfcase value="CF_SQL_MONEY4"><cfset result = "smallmoney"></cfcase>
		<cfcase value="CF_SQL_NUMERIC"><cfset result = "numeric"></cfcase>
		<cfcase value="CF_SQL_REAL"><cfset result = "real"></cfcase>
		<cfcase value="CF_SQL_SMALLINT"><cfset result = "smallint"></cfcase>
		<cfcase value="CF_SQL_TIMESTAMP"><cfset result = "timestamp"></cfcase>
		<cfcase value="CF_SQL_TINYINT"><cfset result = "tinyint"></cfcase>
		<cfcase value="CF_SQL_VARCHAR"><cfset result = "varchar"></cfcase>
		<cfdefaultcase><cfthrow message="DataMgr object cannot handle this data type." type="DataMgr" detail="DataMgr cannot handle data type '#arguments.CF_Datatype#'" errorcode="InvalidDataType"></cfdefaultcase>
	</cfswitch>
	
	<cfreturn result>
</cffunction>

<cffunction name="checkTable" access="private" returntype="boolean" output="no" hint="I check to see if the given table exists in the Datamgr.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfif NOT StructKeyExists(variables.tables,arguments.tablename)>
		<cfset loadTable(arguments.tablename)>
	</cfif>
	
	<cfreturn true>
</cffunction>

<cffunction name="getInsertedIdentity" access="private" returntype="string" output="no" hint="I get the value of the identity field that was just inserted into the given table.">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="identfield" type="string" required="yes">
	
	<cfset var qCheckKey = runSQL("SELECT TOP 1 #identfield# AS NewID FROM #arguments.tablename# ORDER BY #identfield# DESC")>
	<cfset var result = 0>
	
	<cfset result = qCheckKey.NewID>
	
	<cfreturn result>
</cffunction>

<cffunction name="getLength" access="private" returntype="string" output="no">
	<cfargument name="type" type="string" required="yes">
	
	<cfset var result = "">
	<cfset var parens1 = "(">
	<cfset var parens2 = ")">
	<cfset var fparens1 = FindNoCase(parens1,arguments.type)>
	<cfset var fparens2 = FindNoCase(parens2,arguments.type)>
	
	<cfif fparens1 AND fparens2>
		<cfset result = Mid(arguments.type,fparens1+1,fparens2-(fparens1+1))>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="isStringType" access="private" returntype="boolean" output="no" hint="I indicate if the given datatype is valid for string data.">
	<cfargument name="type" type="string">

	<cfset var strtypes = "char,nchar,nvarchar,varchar">
	<cfset var result = false>
	<cfif ListFindNoCase(strtypes,arguments.type)>
		<cfset result = true>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="makeDefaultValue" access="private" returntype="string" output="no" hint="I return the value of the default for the given datatype and raw value.">
	<cfargument name="value" type="string" required="yes">
	<cfargument name="CF_DataType" type="string" required="yes">
	
	<cfset var result = super.makeDefaultValue(arguments.value,arguments.CF_DataType)>
	<cfset var type = getDBDataType(arguments.CF_DataType)>
	
	<cfif type eq "boolean">
		<cfif isBoolean(result) AND result>
			<cfset result = "true">
		<cfelse>
			<cfset result = "false">
		</cfif>
	</cfif>
	
	<cfreturn result>
</cffunction>

</cfcomponent>