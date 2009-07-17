<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset messages = application.message.get(attributes.project)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<posts><cfloop query="messages">
	<post>
		<id>#messageid#</id>	
		<title>#xmlFormat(title)#</title>
		<category>#xmlFormat(category)#</category>
		<posted>#DateFormat(DateAdd("h",application.settings.default_offset,stamp),"yyyy-mm-dd")#T#TimeFormat(DateAdd("h",application.settings.default_offset,stamp),"HH:mm:ss")#Z</posted>
		<comments>#commentcount#</comments>
		<attachments>#attachcount#</attachments>
	</post></cfloop>
</posts>
</cfoutput>

<cfsetting enablecfoutputonly="false">