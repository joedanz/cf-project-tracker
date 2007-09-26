<cfsetting enablecfoutputonly=true>
<!---
	Purpose		 : Loads up templates. Will look in a subdirectory for templates, 
				   and will load #attributes.template#_header.cfm and 
				   #attributes.template#_footer.cfm
--->

<!--- Because "template" is a reserved attribute for cfmodule, we allow templatename as well. --->
<cfif isDefined("attributes.templatename")>
	<cfset attributes.template = attributes.templatename>
</cfif>
<cfparam name="attributes.template">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.project" default="">
<cfparam name="attributes.projectid" default="">
<cfparam name="attributes.svnurl" default="">

<cfset base = attributes.template>

<cfif thisTag.executionMode is "start">
	<cfset myFile = base & "_header.cfm">
<cfelse>
	<cfset myFile = base & "_footer.cfm">
</cfif>

<cfinclude template="../templates/#myFile#">

<cfsetting enablecfoutputonly=false>