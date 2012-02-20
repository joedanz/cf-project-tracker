<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfset comments = application.comment.get(attributes.project,attributes.message)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<comments><cfloop query="comments">
	<comment>
		<id>#commentid#</id>	
		<author_id>#userid#</author_id>
		<body>#xmlFormat(comment)#</body>
		<posted>#LSDateFormat(DateAdd("h",application.settings.default_offset,stamp),"yyyy-mm-dd")#T#LSTimeFormat(DateAdd("h",application.settings.default_offset,stamp),"HH:mm:ss")#Z</posted>
	</comment></cfloop>
</comments>
</cfoutput>

<cfsetting enablecfoutputonly="false">