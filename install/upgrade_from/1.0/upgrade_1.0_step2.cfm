<!---
	THIS SCRIPT SHOULD BE RUN AFTER THE OTHER UPGRADE SCRIPT FOR YOUR DATABASE PLATFORM.
	TAKES CARE OF CREATING MESSAGE CATEGORIES IN NEW TABLE THAT DIDN'T EXIST IN VERSION 1.
--->

<cfsetting showdebugoutput="true">

<!--- comment stuff --->
<cfquery name="getComments" datasource="#application.settings.dsn#">
	select commentid,messageID,issueID from #application.settings.tableprefix#comments
</cfquery>
<cfloop query="getComments">
	<cfquery datasource="#application.settings.dsn#">
		update #application.settings.tableprefix#comments set
	<cfif compare(messageID,'')>
		type = 'msg', itemID = '#messageID#'
	<cfelseif compare(issueID,'')>
		type = 'issue', itemID = '#issueID#'
	</cfif>
		where commentid = '#commentid#'
	</cfquery>
</cfloop>
<cftry>
<cfquery datasource="#application.settings.dsn#">
	alter table #application.settings.tableprefix#comments
	drop column issueID
</cfquery>
<cfcatch><h2>You should manually remove the column: <b>&quot;issueID&quot;</b> from table: <b>&quot;<cfoutput>#application.settings.tableprefix#</cfoutput>comments&quot;</b></h2><br /><br /></cfcatch>
</cftry>
<cftry>
<cfquery datasource="#application.settings.dsn#">
	alter table #application.settings.tableprefix#comments
	drop column messageID
</cfquery>
<cfcatch><h2>You should manually remove the column: <b>&quot;messageID&quot;</b> from table: <b>&quot;<cfoutput>#application.settings.tableprefix#</cfoutput>comments&quot;</b></h2><br /><br /></cfcatch>
</cftry>

<!--- file categories --->
<cfquery name="getMissingCats" datasource="#application.settings.dsn#">
	select distinct category,projectid from #application.settings.tableprefix#files
	where categoryID is NULL
</cfquery>
<cfloop query="getMissingCats">
	<cfset newCatID = createUUID()>
	<cfquery datasource="#application.settings.dsn#">
		insert into #application.settings.tableprefix#categories (projectID,categoryID,type,category)
		values ('#projectID#','#newCatID#','file','#category#')
	</cfquery>
	<cfquery datasource="#application.settings.dsn#">
		update #application.settings.tableprefix#files 
		set categoryID = '#newCatID#'
		where projectID = '#projectID#' and category = '#category#'
	</cfquery>
</cfloop>
<cftry>
<cfquery datasource="#application.settings.dsn#">
	alter table #application.settings.tableprefix#files
	drop column category
</cfquery>
<cfcatch><h2>You should manually remove the column: <b>&quot;category&quot;</b> from table: <b>&quot;<cfoutput>#application.settings.tableprefix#</cfoutput>files&quot;</b></h2><br /><br /></cfcatch>
</cftry>

<!--- issue stuff --->
<cfquery datasource="#application.settings.dsn#">
	update pt_issues set status = 'New' where status = 'open'
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	update pt_issues set ownerID = addedBy
</cfquery>

<!--- message categories --->
<cfquery name="getMissingCats" datasource="#application.settings.dsn#">
	select distinct category,projectid from #application.settings.tableprefix#messages
	where categoryID is NULL
</cfquery>
<cfloop query="getMissingCats">
	<cfset newCatID = createUUID()>
	<cfquery datasource="#application.settings.dsn#">
		insert into #application.settings.tableprefix#categories (projectID,categoryID,type,category)
		values ('#projectID#','#newCatID#','msg','#category#')
	</cfquery>
	<cfquery datasource="#application.settings.dsn#">
		update #application.settings.tableprefix#messages 
		set categoryID = '#newCatID#'
		where projectID = '#projectID#' and category = '#category#'
	</cfquery>
</cfloop>
<cftry>
<cfquery datasource="#application.settings.dsn#">
	alter table #application.settings.tableprefix#messages
	drop column category
</cfquery>
<cfcatch><h2>You should manually remove the column: <b>&quot;category&quot;</b> from table: <b>&quot;<cfoutput>#application.settings.tableprefix#</cfoutput>messages&quot;</b></h2></cfcatch>
</cftry>
