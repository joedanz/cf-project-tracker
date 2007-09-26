<cfif right(listlast(cgi.script_name, "/"),4) is ".cfm">
	<cfabort>
</cfif>