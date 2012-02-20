<cfset sRailoQuery = StructNew()>
<cfset sRailoQuery["name"] = "qQuery">
<cfset sRailoQuery["datasource"] = variables.datasource>
<cfset sRailoQuery["psq"] = "false">
<cfif StructKeyExists(variables,"username") AND StructKeyExists(variables,"password")>
	<cfset sRailoQuery["username"] = variables.username>
	<cfset sRailoQuery["password"] = variables.password>
</cfif>
<cfif variables.SmartCache>
	<cfset sRailoQuery["cachedafter"] = "#variables.CacheDate#">
</cfif>
<cfif isDefined("aSQL")>
	<cfquery attributeCollection="#sRailoQuery#"><cfloop index="i" from="1" to="#ArrayLen(aSQL)#" step="1"><cfif IsSimpleValue(aSQL[i])><cfset temp = aSQL[i]>#Trim(temp)#<cfelseif IsStruct(aSQL[i])><cfset aSQL[i] = queryparam(argumentCollection=aSQL[i])><cfswitch expression="#aSQL[i].cfsqltype#"><cfcase value="CF_SQL_BIT">#getBooleanSqlValue(aSQL[i].value)#</cfcase><cfcase value="CF_SQL_DATE,CF_SQL_DATETIME">#CreateODBCDateTime(aSQL[i].value)#</cfcase><cfdefaultcase><!--- <cfif ListFindNoCase(variables.dectypes,aSQL[i].cfsqltype)>#Val(aSQL[i].value)#<cfelse> ---><cfqueryparam value="#aSQL[i].value#" cfsqltype="#aSQL[i].cfsqltype#" maxlength="#aSQL[i].maxlength#" scale="#aSQL[i].scale#" null="#aSQL[i].null#" list="#aSQL[i].list#" separator="#aSQL[i].separator#"><!--- </cfif> ---></cfdefaultcase></cfswitch></cfif> </cfloop></cfquery>
<cfelse>
	<cfquery attributeCollection="#sRailoQuery#">#Trim(arguments.sql)#</cfquery>
</cfif>