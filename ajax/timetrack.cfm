<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfparam name="url.i" default="">
<cfparam name="url.type" default="">

<cfswitch expression="#url.act#">
	<cfcase value="add">
		<cfset url.tt = createUUID()>
		<cfset application.timetrack.add(timetrackID=url.tt,projectID=url.p,userID=url.u,dateStamp=url.t,hours=url.h,description=url.d,rateID=url.r,itemID=url.i,itemType=url.type)>		
	</cfcase>
	<cfcase value="update">
		<cfset application.timetrack.update(url.tt,url.p,url.u,url.t,url.h,url.d,url.r)>
	</cfcase>
	<cfcase value="delete">
		<cfset application.timetrack.delete(url.tt)>
	</cfcase>
</cfswitch>

<cfset timeline = application.timetrack.get(url.tt)>
<cfif not compareNoCase(url.f,'issue')>
	<cfset totaltime = application.timetrack.countTime(itemID=url.i)>
<cfelse>
	<cfset totaltime = application.timetrack.countTime(projectID=url.p)>
	<cfset totalrate = application.timetrack.sumRate(projectID=url.p)>
</cfif>
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>

<cfoutput>
<cfif compareNoCase(url.act,'delete')>
	<tr id="r#timeline.timetrackid#">
		<td class="first"><cfif isDate(timeline.dateStamp)>#LSDateFormat(timeline.dateStamp,"mmm d, yyyy")#</cfif></td>
		<td>#timeline.firstName# #timeline.lastName#</td>
		<td<cfif compareNoCase(url.f,'issue')> class="b"</cfif>>#numberFormat(timeline.hours,"0.00")#</td>
		<cfif project.tab_billing and project.bill_view>
			<td><cfif compare(timeline.category,'')>#timeline.category# ($#NumberFormat(timeline.rate,"0")#/hr)</cfif></td>
			<cfif compareNoCase(url.f,'issue')>
				<td><cfif isNumeric(timeline.rate)>$#NumberFormat(timeline.rate*timeline.hours,"0")#</cfif></td>
			</cfif>
		</cfif>
		<td><cfif compare(timeline.itemType,'') and not (not compareNoCase(url.f,'issue') and not compareNoCase(timeline.itemType,'issue'))><span class="catbox #timeline.itemtype#">#timeline.itemtype#</span> <a href="todos.cfm?p=#timeline.projectID###id_#replace(timeline.todolistID,'-','','all')#">#timeline.task#</a><cfif compare(timeline.description,'')> - </cfif></cfif>#timeline.description#</td>
		<cfif project.time_edit or session.user.admin>
			<td class="tac"><a href="##" onclick="edit_time_row('#timeline.projectid#','#timeline.timetrackid#','#project.tab_billing#','#project.bill_edit#','#project.clientID#','#url.type#','#url.i#','#url.f#'); return false;">Edit</a> &nbsp;&nbsp; <a href="##" onclick="delete_time('#timeline.projectID#','#timeline.timetrackID#','#url.f#','#url.i#'); return false;" class="delete"></a></td>
		</cfif>
	</tr>
	<script type="text/javascript">
		$('##r#timeline.timetrackid# td').animate({backgroundColor:'##ffffb7'},200).animate({backgroundColor:'##fff'},2000);
	</script>
</cfif>
<cfif compare(url.act,'cancel')>
	<script type="text/javascript">
		$('##totalhours').html('#numberFormat(totaltime.numHours,"0.00")#').animate({backgroundColor:'##ffffb7'},100).animate({backgroundColor:'##fff'},1500);
		<cfif not compareNoCase(url.f,'issue')>
			$('##timerows').html('#numberFormat(totaltime.numLines)#');
		<cfelse>
			$('##totalrate').html('$#NumberFormat(totalrate.sumRate,"0")#').animate({backgroundColor:'##ffffb7'},100).animate({backgroundColor:'##fff'},1500);
		</cfif>
	</script>
</cfif>
</cfoutput>

<cfsetting enablecfoutputonly="false">