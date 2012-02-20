<!--- 2.2.0.2 (Build 151) --->
<!--- Last Updated: 2009-06-13 --->
<!--- Created by Steve Bryant 2004-12-08 --->
<cfcomponent extends="DataMgr" displayname="Data Manager for MS SQL Server" hint="I manage data interactions with the Derby database. I can be used to handle inserts/updates.">

<cffunction name="getDatabase" access="public" returntype="string" output="no" hint="I return the database platform being used (Access,MS SQL,MySQL etc).">
	<cfreturn "Derby">
</cffunction>

<cffunction name="getDatabaseShortString" access="public" returntype="string" output="no" hint="I return the string that can be found in the driver or JDBC URL for the database platform being used.">
	<cfreturn "derby">
</cffunction>

<cffunction name="getDatabaseDriver" access="public" returntype="string" output="no" hint="I return the string that can be found in the driver or JDBC URL for the database platform being used.">
	<cfreturn "Apache Derby Embedded">
</cffunction>

<cffunction name="getDatabaseProperties" access="public" returntype="struct" output="no" hint="I return some properties about this database">
	
	<cfset var sProps = StructNew()>
	
	<cfset sProps["areSubqueriesSortable"] = false>
	
	<cfreturn sProps>
</cffunction>

<cffunction name="sqlCreateColumn" access="public" returntype="any" output="false" hint="">
	<cfargument name="field" type="struct" required="yes">
	
	<cfset var sField = adjustColumnArgs(arguments.field)>
	<cfset var type = getDBDataType(sField.CF_DataType)>
	<cfset var result = "">
	
	<cfsavecontent variable="result"><cfoutput>#escape(sField.ColumnName)# #type#<cfif isStringType(type)>(#sField.Length#)<cfelseif getTypeOfCFType(sField.CF_DataType) EQ "numeric" AND StructKeyExists(sField,"scale") AND StructKeyExists(sField,"precision")>(#Val(sField.precision)#,#Val(sField.scale)#)</cfif><cfif Len(Trim(sField.Default))> DEFAULT #sField.Default#</cfif><cfif sField.PrimaryKey OR NOT sField.AllowNulls> NOT NULL</cfif><cfif sField.Increment> GENERATED ALWAYS AS IDENTITY</cfif></cfoutput></cfsavecontent>
	
	<cfreturn result>
</cffunction>

<cffunction name="getCreateSQL" access="public" returntype="string" output="no" hint="I return the SQL to create the given table.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var ii = 0><!--- generic counter --->
	<cfset var arrFields = getFields(arguments.tablename)><!--- table structure --->
	<cfset var CreateSQL = ""><!--- holds sql to create table --->
	<cfset var pkfields = "">
	<cfset var thisField = "">
	
	<!--- Find Primary Key fields --->
	<cfloop index="ii" from="1" to="#ArrayLen(arrFields)#" step="1">
		<cfif arrFields[ii].PrimaryKey>
			<cfset pkfields = ListAppend(pkfields,escape(arrFields[ii].ColumnName))>
		</cfif>
	</cfloop>
	
	<!--- create sql to create table --->
	<cfsavecontent variable="CreateSQL"><cfoutput>
	CREATE TABLE #escape(arguments.tablename)# (<cfloop index="ii" from="1" to="#ArrayLen(arrFields)#" step="1">
		#sqlCreateColumn(arrFields[ii])#,</cfloop>
		<cfif Len(pkfields)>
		PRIMARY KEY (#pkfields#)
		</cfif>
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
			<cfset result =  "#result# || '#arguments.delimeter#' || CAST(#colname# AS char(50))">
		<cfelse>
			<cfset result = "CAST(#colname# AS char(50))">
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
	
	<cfloop index="col" list="#arguments.fields#">
		<cfset fieldSQL = getFieldSelectSQL(tablename=arguments.tablename,field=col,tablealias=arguments.tablealias,useFieldAlias=false)>
		<cfif ArrayLen(aSQL)>
			<cfset ArrayAppend(aSQL," || '#arguments.delimeter#' || ")>
		</cfif>
		<cfif isSimpleValue(fieldSQL)>
			<cfset ArrayAppend(aSQL,"CAST(#fieldSQL# AS char(50))")>
		<cfelse>
			<cfset ArrayAppend(aSQL,"CAST(")>
			<cfset ArrayAppend(aSQL,fieldSQL)>
			<cfset ArrayAppend(aSQL," AS char(50))")>
		</cfif>
	</cfloop>
	
	<cfreturn aSQL>
</cffunction>

<cffunction name="escape" access="public" returntype="string" output="no" hint="I return an escaped value for a table or field.">
	<cfargument name="name" type="string" required="yes">
	
	<cfset var result = "">
	<cfset var item = "">
	
	<cfloop index="item" list="#arguments.name#" delimiters=".">
		<cfset result = ListAppend(result,"#chr(34)##UCase(item)##chr(34)#",".")>
	</cfloop>
	
	<cfreturn result>
</cffunction>

<cffunction name="getDatabaseTables" access="public" returntype="string" output="no" hint="I get a list of all tables in the current database.">

	<cfset var qTables = 0>
	
	<cfdbinfo datasource="#variables.datasource#" name="qTables" type="tables" />
	
	<cfreturn ValueList(qTables.Table_Name)>
</cffunction>

<cffunction name="getDBFieldList" access="public" returntype="string" output="no" hint="I return a list of fields in the database for the given table.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var qColumns = 0>
	
	<cfdbinfo datasource="#variables.datasource#" name="qColumns" type="columns" table="#arguments.tablename#">
	
	<cfreturn ValueList(qColumns.Column_Name)>
</cffunction>

<cffunction name="getDBTableStruct" access="public" returntype="array" output="no" hint="I return the structure of the given table in the database.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var qColumns = 0>
	<cfset var TableData = ArrayNew(1)>
	<cfset var sTemp = StructNew()>
	
	<cftry>
		<cfdbinfo datasource="#variables.datasource#" name="qColumns" type="columns" table="#arguments.tablename#">
	<cfcatch>
		<cfif CFCATCH.Detail EQ "Table #arguments.tablename# does not exist.">
			<cfthrow message="Data Manager: No such table (#arguments.tablename#). Trying to load a table that doesn't exist." type="DataMgr">
		<cfelse>
			<cfrethrow>
		</cfif>
	</cfcatch>
	</cftry>
	<cfoutput query="qColumns">
		<cfset sTemp = StructNew()>
		<cfset sTemp["ColumnName"] = Column_Name>
		<cfset sTemp["CF_DataType"] = getCFDataType(Type_Name)>
		<cfset sTemp["PrimaryKey"] = Is_PrimaryKey>
		
		<!--- Determine increment/default --->
		<cfif ListFirst(Column_Default_Value,":") EQ "AUTOINCREMENT">
			<cfset sTemp["Increment"] = true>
		<cfelseif Len(Column_Default_Value)>
			<cfset sTemp["Default"] = Column_Default_Value>
		</cfif>
		
		<cfif Len(Column_Size) AND isNumeric(Column_Size) AND NOT sTemp["CF_DataType"] EQ "CF_SQL_LONGVARCHAR">
			<cfset sTemp["length"] = Column_Size>
		</cfif>
		<cfset sTemp["AllowNulls"] = Is_Nullable>
		<!--- <cfset sTemp["Precision"] = Decimal_Digits>
		<cfset sTemp["Scale"] = Decimal_Digits> --->
		<cfset sTemp["Special"] = "">
		
		<cfif Len(sTemp.CF_DataType)>
			<cfset ArrayAppend(TableData,StructCopy(sTemp))>
		</cfif>
	</cfoutput>
	
	<cfreturn TableData>
</cffunction>

<!--- %%TODO: --->
<cffunction name="getCFDataType" access="public" returntype="string" output="no" hint="I return the cfqueryparam datatype from the database datatype.">
	<cfargument name="type" type="string" required="yes" hint="The database data type.">
	
	<cfset var result = "">
	
	<cfswitch expression="#arguments.type#">
		<cfcase value="bigint"><cfset result = "CF_SQL_BIGINT"></cfcase>
		<cfcase value="binary,image,sql_variant,sysname,varbinary"><cfset result = ""></cfcase>
		<cfcase value="bit"><cfset result = "CF_SQL_BIT"></cfcase>
		<cfcase value="char"><cfset result = "CF_SQL_CHAR"></cfcase>
		<cfcase value="datetime"><cfset result = "CF_SQL_DATE"></cfcase>
		<cfcase value="decimal"><cfset result = "CF_SQL_DECIMAL"></cfcase>
		<cfcase value="float"><cfset result = "CF_SQL_FLOAT"></cfcase>
		<cfcase value="int,integer"><cfset result = "CF_SQL_INTEGER"></cfcase>
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

<!--- %%TODO: --->
<cffunction name="getDBDataType" access="public" returntype="string" output="no" hint="I return the database datatype from the cfqueryparam datatype.">
	<cfargument name="CF_Datatype" type="string" required="yes">
	
	<cfset var result = "">
	
	<cfswitch expression="#arguments.CF_Datatype#">
		<cfcase value="CF_SQL_BIGINT"><cfset result = "bigint"></cfcase>
		<cfcase value="CF_SQL_BIT"><cfset result = "smallint"></cfcase>
		<cfcase value="CF_SQL_CHAR"><cfset result = "char"></cfcase>
		<cfcase value="CF_SQL_DATE"><cfset result = "timestamp"></cfcase>
		<cfcase value="CF_SQL_DECIMAL"><cfset result = "decimal"></cfcase>
		<cfcase value="CF_SQL_DOUBLE"><cfset result = "float"></cfcase>
		<cfcase value="CF_SQL_FLOAT"><cfset result = "float"></cfcase>
		<cfcase value="CF_SQL_IDSTAMP"><cfset result = "uniqueidentifier"></cfcase>
		<cfcase value="CF_SQL_INTEGER"><cfset result = "int"></cfcase>
		<cfcase value="CF_SQL_LONGVARCHAR"><cfset result = "CLOB"></cfcase>
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

<cffunction name="getNowSQL" access="public" returntype="string" output="no" hint="I return the SQL for the current date/time.">
	<cfreturn "CURRENT_TIMESTAMP">
</cffunction>

<cffunction name="getMaxRowsPrefix" access="public" returntype="string" output="no" hint="I get the SQL before the field list in the select statement to limit the number of rows.">
	<cfargument name="maxrows" type="numeric" required="yes">
	
	<cfreturn "">
</cffunction>

<cffunction name="isValidDate" access="public" returntype="boolean" output="no">
	<cfargument name="value" type="string" required="yes">
	
	<cfreturn isDate(arguments.value)><!---  AND Year(arguments.value) GTE 1753 AND arguments.value LT CreateDate(2079,6,7) --->
</cffunction>

<cffunction name="checkTable" access="private" returntype="boolean" output="no" hint="I check to see if the given table exists in the Datamgr.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfif NOT StructKeyExists(variables.tables,arguments.tablename)>
		<cfset loadTable(arguments.tablename)>
	</cfif>
	
	<cfreturn true>
</cffunction>

<cffunction name="getFieldSQL_Has" access="private" returntype="any" output="no">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="field" type="string" required="yes">
	<cfargument name="tablealias" type="string" required="no">
	
	<cfset var sField = getField(arguments.tablename,arguments.field)>
	<cfset var dtype = getEffectiveDataType(arguments.tablename,sField.Relation.field)>
	<cfset var aSQL = ArrayNew(1)>
	<cfset var sAdvSQL = StructNew()>
	<cfset var sJoin = StructNew()>
	<cfset var sArgs = StructNew()>
	<cfset var temp = "">
	
	<cfswitch expression="#dtype#">
	<cfcase value="numeric">
		<cfset ArrayAppend(aSQL,"CASE WHEN (")>
		<cfset ArrayAppend(aSQL, getFieldSelectSQL(tablename=arguments.tablename,field=sField.Relation['field'],tablealias=arguments.tablealias,useFieldAlias=false) )>
		<cfset ArrayAppend(aSQL,") > 0 THEN 1 ELSE 0 END")>
	</cfcase>
	<cfcase value="string">
		<cfset ArrayAppend(aSQL,"CASE WHEN LENGTH(")>
		<cfset ArrayAppend(aSQL, getFieldSelectSQL(tablename=arguments.tablename,field=sField.Relation['field'],tablealias=arguments.tablealias,useFieldAlias=false) )>
		<cfset ArrayAppend(aSQL,") > 0 THEN 1 ELSE 0 END")>
	</cfcase>
	<cfcase value="date">
		<cfset ArrayAppend(aSQL,"CASE WHEN (")>
		<cfset ArrayAppend(aSQL, getFieldSelectSQL(tablename=arguments.tablename,field=sField.Relation['field'],tablealias=arguments.tablealias,useFieldAlias=false) )>
		<cfset ArrayAppend(aSQL,") IS NULL THEN 0 ELSE 1 END")>
	</cfcase>
	<cfcase value="boolean">
		<cfset ArrayAppend(aSQL,"CASE WHEN (")>
		<cfset ArrayAppend(aSQL, getFieldSelectSQL(tablename=arguments.tablename,field=sField.Relation['field'],tablealias=arguments.tablealias,useFieldAlias=false) )>
		<cfset ArrayAppend(aSQL,") = 1 THEN 1 ELSE 0 END")>
	</cfcase>
	</cfswitch>
	
	<cfreturn aSQL>	
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

</cfcomponent>