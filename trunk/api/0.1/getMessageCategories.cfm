<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset message_categories = application.message.categories(attributes.project)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<post-categories><cfloop query="message_categories">
	<post-category>
		<id>#categoryid#</id>	
		<category>#category#</category>
	</post-category></cfloop>
</post-categories>
</cfoutput>

<cfsetting enablecfoutputonly="false">