<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<!--- Process serialized list  --->
<cfset counter = 0>
<cfloop index="i" list="#FORM.lw#" delimiters="|">
	<cfset counter = counter+1>
	<cfset application.todolist.updateRank('#FORM.pid#',left(i,8)&'-'&mid(i,9,4)&'-'&mid(i,13,4)&'-'&right(i,16),counter)>
</cfloop>

<cfsetting enablecfoutputonly="false">