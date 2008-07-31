<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset message_categories = application.category.get(attributes.project,'msg')>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<post-categories><cfloop query="message_categories">
	<post-category>
		<id>#categoryid#</id>	
		<category>#xmlFormat(category)#</category>
	</post-category></cfloop>
</post-categories>
</cfoutput>

<cfsetting enablecfoutputonly="false">