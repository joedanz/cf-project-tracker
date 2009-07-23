<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfset file_categories = application.category.get(attributes.project,'file')>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<file-categories><cfloop query="file_categories">
	<file-category>
		<id>#categoryid#</id>	
		<category>#xmlFormat(category)#</category>
	</file-category></cfloop>
</file-categories>
</cfoutput>

<cfsetting enablecfoutputonly="false">