<cfinclude template="../Application.cfm">

<cfif not session.user.admin>
	<cfoutput><h2>Admin Access Only!!!</h2></cfoutput>
	<cfabort>
</cfif>