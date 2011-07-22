<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfswitch expression="#url.type#">

	<cfcase value="upcoming">
		<cfset todos_upcoming = application.todo.get('','','','t.due','',url.p,'',1,'upcoming',url.l)>
		<cfoutput query="todos_upcoming">
			<cfset daysDiff = DateDiff("d",CreateDate(year(Now()),month(Now()),day(Now())),due)>
			<li class="item"><span class="b"><cfif daysDiff eq 0>Today<cfelseif daysDiff eq 1>Tomorrow<cfelse>#daysDiff# days away</cfif>:</span> 
				<a href="todo.cfm?p=#projectID#&t=#todoid#">#task#</a>
				<cfif compare(lastName,'')><span style="font-size:.9em;">(#firstName# #lastName# is responsible)</span></cfif>
			</li>
		</cfoutput>
	</cfcase>
	
	<cfcase value="allupcoming">
		<cfset projects = application.project.get(session.user.userid)>
		<cfset todos_upcoming = application.todo.get('','','','t.due','',valueList(projects.projectID),'',1,'upcoming',url.l)>
		<cfoutput query="todos_upcoming">
			<cfset daysDiff = DateDiff("d",CreateDate(year(Now()),month(Now()),day(Now())),due)>
			<li class="item"><span class="b"><cfif daysDiff eq 0>Today<cfelseif daysDiff eq 1>Tomorrow<cfelse>#daysDiff# days away</cfif>:</span> 
				<a href="todo.cfm?p=#projectID#&t=#todoid#">#task#</a>
				<span style="font-size:.9em;">(<a href="project.cfm?p=#projectID#" class="b">#name#</a><cfif compare(lastName,'')> | #firstName# #lastName# is responsible</cfif>)</span>
			</li>
		</cfoutput>
	</cfcase>

</cfswitch>

<cfoutput>
<script type="text/javascript">
	$(document).ready(function(){
		$('##upcoming_todos').animate({backgroundColor:'##ffffb7'},200).animate({backgroundColor:'##fff'},1500);
	});
</script>
</cfoutput>

<cfsetting enablecfoutputonly="false">