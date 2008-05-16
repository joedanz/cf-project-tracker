<!---
	THIS SCRIPT SHOULD BE RUN AFTER THE OTHER UPGRADE SCRIPT FOR YOUR DATABASE PLATFORM.
	TAKES CARE OF CREATING MESSAGE CATEGORIES IN NEW TABLE THAT DIDN'T EXIST IN VERSION 1.
--->

<cfsetting showdebugoutput="true">

<!--- passwords to hashes --->
<cfquery name="getUsers" datasource="#application.settings.dsn#">
	select userid,password from #application.settings.tableprefix#users
</cfquery>
<cfloop query="getUsers">
	<cfquery datasource="#application.settings.dsn#">
		update #application.settings.tableprefix#users 
		set password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(password)#" maxlength="32">
		where userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#userID#" maxlength="35">
	</cfquery>
</cfloop>
