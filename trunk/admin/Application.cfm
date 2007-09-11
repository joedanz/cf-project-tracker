<cfinclude template="../Application.cfm">
<cfif not session.user.admin>
	<h2>Admin Only!!!</h2>
	<cfabort>
</cfif>
