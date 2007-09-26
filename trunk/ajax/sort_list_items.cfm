<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<!--- Process serialized list  --->
<cfset counter = 0>
<cfloop index="i" list="#FORM.li#" delimiters="|">
	<cfset counter = counter+1>
	<cfset application.todo.updateRank('#FORM.tlid#',i,counter)>
</cfloop>

<cfsetting enablecfoutputonly="false">