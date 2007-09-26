<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfswitch expression="#url.action#">
	<cfcase value="delete">
		<cfset application.comment.delete(session.user.userid,url.c)>
	</cfcase>
</cfswitch>

<cfsetting enablecfoutputonly="false">