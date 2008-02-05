<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset files = application.file.get(attributes.project)>

<cfcontent type="application/xml" reset="true">
<cfoutput><?xml version="1.0" encoding="UTF-8" ?>
<files><cfloop query="files">
	<file>
		<id>#fileid#</id>
		<title>#title#</title>
		<category>#category#</category>
		<description>#description#</description>
		<filesize>#filesize#</filesize>
		<filename>#filename#</filename>
		<server-filename>#serverfilename#</server-filename>
		<uploaded>#DateFormat(uploaded,"yyyy-mm-dd")#T#TimeFormat(uploaded,"HH:mm:ss")#Z</uploaded>
	</file></cfloop>
</files>
</cfoutput>

<cfsetting enablecfoutputonly="false">