<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfswitch expression="#url.act#">
	<cfcase value="add">
		<cfset url.tt = createUUID()>
		<cfset application.timetrack.add(timetrackID=url.tt,projectID=url.p,userID=url.u,dateStamp=url.t,hours=url.h,description=url.d,rateID=url.r)>
	</cfcase>
	<cfcase value="update">
		<cfset application.timetrack.update(url.tt,url.p,url.u,url.t,url.h,url.d,url.r)>
	</cfcase>
	<cfcase value="delete">
		<cfset application.timetrack.delete(url.tt)>
	</cfcase>
</cfswitch>

<cfset timeline = application.timetrack.get(url.tt)>
<cfset totalhours = application.timetrack.countHours(url.p)>
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>

<cfoutput>
<tr id="r#replace(timeline.timetrackid,'-','','ALL')#">
	<td class="first">#DateFormat(timeline.dateStamp,"mmm d, yyyy")#</td>
	<td>#timeline.firstName# #timeline.lastName#</td>
	<td class="b">#numberFormat(timeline.hours,"0.00")#</td>
	<cfif project.tab_billing and project.billing gt 0>
		<td>#timeline.category#</td>
	</cfif>
	<td><cfif compare(timeline.itemType,'')><span class="catbox #timeline.itemtype#">#timeline.itemtype#</span> <a href="todos.cfm?p=#timeline.projectID###id_#replace(timeline.todolistID,'-','','all')#">#timeline.task#</a><cfif compare(timeline.description,'')> - </cfif></cfif>#timeline.description#</td>
	<td class="tac"><a href="##" onclick="edit_time_row('#timeline.projectid#','#timeline.timetrackid#','#replace(timeline.timetrackid,'-','','ALL')#','#project.tab_billing#','#project.billing#','#project.clientID#')">Edit</a> &nbsp;&nbsp; <a href="##" onclick="delete_time('#timeline.projectID#','#timeline.timetrackID#','#replace(timeline.timetrackid,'-','','ALL')#');" class="delete"></a></td>
</tr>
<cfif compare(url.act,'cancel')>
	<script type="text/javascript">
		$('##totalhours').html('#numberFormat(totalhours,"0.00")#').animate({backgroundColor:'##ffffb7'},100).animate({backgroundColor:'##fff'},1500);
		$('##r#replace(timeline.timetrackid,'-','','ALL')#').animate({backgroundColor:'##ffffb7'},100).animate({backgroundColor:'##fff'},1500);
	</script>
</cfif>
</cfoutput>

<cfsetting enablecfoutputonly="false">