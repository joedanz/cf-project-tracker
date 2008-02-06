<!---
	THIS SCRIPT SHOULD BE RUN AFTER THE OTHER UPGRADE SCRIPT FOR YOUR DATABASE PLATFORM.
	TAKES CARE OF CREATING MESSAGE CATEGORIES IN NEW TABLE THAT DIDN'T EXIST IN VERSION 1.
--->

<cfsetting showdebugoutput="true">

<cfquery name="getMissingCats" datasource="#application.settings.dsn#">
	select distinct category,projectid from #application.settings.tableprefix#messages
	where categoryID is NULL
</cfquery>

<cfloop query="getMissingCats">
	<cfset newCatID = createUUID()>
	<cfquery datasource="#application.settings.dsn#">
		insert into #application.settings.tableprefix#message_categories (projectID,categoryID,category)
		values ('#projectID#','#newCatID#','#category#')
	</cfquery>
	<cfquery datasource="#application.settings.dsn#">
		update #application.settings.tableprefix#messages 
		set categoryID = '#newCatID#'
		where projectID = '#projectID#' and category = '#category#'
	</cfquery>
</cfloop>

<cfquery datasource="#application.settings.dsn#">
	alter table #application.settings.tableprefix#messages
	drop column category
</cfquery>