<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset file_categories = application.file.categories(attributes.project,'file')>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<file-categories><cfloop query="file_categories">
	<file-category>
		<id>#categoryid#</id>	
		<category>#category#</category>
	</file-category></cfloop>
</file-categories>
</cfoutput>

<cfsetting enablecfoutputonly="false">