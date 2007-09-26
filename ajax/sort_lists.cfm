<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<!--- Process serialized list  --->
<cfset counter = 0>
<cfloop index="i" list="#FORM.lw#" delimiters="|">
	<cfset counter = counter+1>
	<cfset application.todolist.updateRank('#FORM.pid#',i,counter)>
</cfloop>

<cfsetting enablecfoutputonly="false">