<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfset files = application.file.get(attributes.project)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<files><cfloop query="files">
	<file>
		<id>#fileid#</id>
		<title>#xmlFormat(title)#</title>
		<category>#xmlFormat(category)#</category>
		<description>#xmlFormat(description)#</description>
		<filesize>#filesize#</filesize>
		<filename>#xmlFormat(filename)#</filename>
		<server-filename>#serverfilename#</server-filename>
		<uploaded>#LSDateFormat(DateAdd("h",application.settings.default_offset,uploaded),"yyyy-mm-dd")#T#LSTimeFormat(DateAdd("h",application.settings.default_offset,uploaded),"HH:mm:ss")#Z</uploaded>
	</file></cfloop>
</files>
</cfoutput>

<cfsetting enablecfoutputonly="false">