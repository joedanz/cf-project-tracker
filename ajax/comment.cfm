<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfswitch expression="#url.action#">
	<cfcase value="delete">
		<cfset application.comment.delete(userID=session.user.userid,commentID=url.c)>
	</cfcase>
</cfswitch>

<cfsetting enablecfoutputonly="false">