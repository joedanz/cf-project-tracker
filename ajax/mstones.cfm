<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfswitch expression="#url.type#">

<cfcase value="upcoming">
<cfset milestones_upcoming = application.milestone.get(url.p,'','upcoming',url.l)>
<cfoutput query="milestones_upcoming">
<cfset daysDiff = DateDiff("d",CreateDate(year(Now()),month(Now()),day(Now())),dueDate)>
<li class="item"><span class="b"><cfif daysDiff eq 0>Today<cfelseif daysDiff eq 1>Tomorrow<cfelse>#daysDiff# days away</cfif>:</span> 
	<a href="milestones.cfm?p=#projectID#">#name#</a>
	<cfif compare(lastName,'')><span style="font-size:.9em;">(#firstName# #lastName# is responsible)</span></cfif>
</li>
</cfoutput>
</cfcase>

<cfcase value="allupcoming">
<cfset projects = application.project.get(session.user.userid)>
<cfset milestones_upcoming = application.milestone.get('','','upcoming',url.l,valueList(projects.projectID))>
<cfoutput query="milestones_upcoming">
<cfset daysDiff = DateDiff("d",CreateDate(year(Now()),month(Now()),day(Now())),dueDate)>
<li class="item"><span class="b"><cfif daysDiff eq 0>Today<cfelseif daysDiff eq 1>Tomorrow<cfelse>#daysDiff# days away</cfif>:</span> 
	<a href="milestones.cfm?p=#projectID#">#name#</a>
	<span style="font-size:.9em;">(<a href="project.cfm?p=#projectID#" class="b">#projName#</a><cfif compare(lastName,'')> | #firstName# #lastName# is responsible</cfif>)</span>
</li>
</cfoutput>
</cfcase>

</cfswitch>

<cfoutput>
<script type="text/javascript">
$(document).ready(function(){
	$('##upcoming_milestones').css('backgroundColor','##ffa').animate({backgroundColor:'##fff'},1500);
});
</script>
</cfoutput>

<cfsetting enablecfoutputonly="false">