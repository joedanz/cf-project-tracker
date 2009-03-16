<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset site_url = application.settings.rootURL & application.settings.mapping>
<cfset meta = structNew()>

<cfswitch expression="#url.type#">
	<cfcase value="act">
		<cfset project = application.project.get(url.u,url.p)>
		<cfif project.recordCount>
			<cfset meta.title = "#project.name# - Recent Activity">
			<cfset meta.link = "#site_url#/project.cfm?p=#url.p#">
			<cfset meta.description = "#project.name# project activity">
			<cfset activity = application.activity.get(url.p,'','true')>
	
			<cfset data = queryNew("title,body,link,subject,date")>
			<cfoutput query="activity">
				<cfset queryAddRow(data,1)>
				<cfset querySetCell(data,"title","#type# #activity#: #name#")>
				<cfif application.settings.clockHours eq 12>
					<cfset formattedTime = timeFormat(stamp,"h:mmtt")>
				<cfelse>
					<cfset formattedTime = timeFormat(stamp,"HH:mm")>
				</cfif>
				<cfset querySetCell(data,"body","#activity# by #firstName# #lastName# on #DateFormat(stamp,"d mmm")# @ #formattedTime#")>
				
				<cfswitch expression="#type#">
					<cfcase value="Issue"><cfset querySetCell(data,"link","#site_url#/issues.cfm?p=#url.p#&i=#id#")></cfcase>		
					<cfcase value="Message"><cfset querySetCell(data,"link","#site_url#/messages.cfm?p=#url.p#&mid=#id#")></cfcase>
					<cfcase value="Milestone"><cfset querySetCell(data,"link","#site_url#/milestones.cfm?p=#url.p#&m=#id#")></cfcase>
					<cfcase value="To-Do List"><cfset querySetCell(data,"link","#site_url#/todos.cfm?p=#url.p#&t=#id#")></cfcase>
					<cfcase value="File"><cfset querySetCell(data,"link","#site_url#/files.cfm?p=#url.p#&f=#id#")></cfcase>
					<cfcase value="Project"><cfset querySetCell(data,"link","#site_url#/project.cfm?p=#url.p#")></cfcase>
					<cfdefaultcase>#site_url#</cfdefaultcase>
				</cfswitch>			
				
				<cfset querySetCell(data,"subject","Recent Activity")>
				<cfset querySetCell(data,"date",stamp)>
			</cfoutput>
		</cfif>
	</cfcase>
	<cfcase value="allact">
		<cfset meta.title = "#application.settings.app_title# - Recent Activity">
		<cfset meta.link = "#site_url#">
		<cfset meta.description = "#application.settings.app_title# activity">
		<cfset projects = application.project.get(url.u)>
		<cfset activity = application.activity.get('',valueList(projects.projectID),'true')>

		<cfset data = queryNew("title,body,link,subject,date")>
		<cfoutput query="activity">
			<cfset queryAddRow(data,1)>
			<cfset querySetCell(data,"title","#projectName#: #type# #activity#: #name#")>
			<cfif application.settings.clockHours eq 12>
				<cfset formattedTime = timeFormat(stamp,"h:mmtt")>
			<cfelse>
				<cfset formattedTime = timeFormat(stamp,"HH:mm")>
			</cfif>			
			<cfset querySetCell(data,"body","#activity# by #firstName# #lastName# on #DateFormat(stamp,"d mmm")# @ #formattedTime#")>
			
			<cfswitch expression="#type#">
				<cfcase value="Issue"><cfset querySetCell(data,"link","#site_url#/issues.cfm?p=#projectID#&i=#id#")></cfcase>		
				<cfcase value="Message"><cfset querySetCell(data,"link","#site_url#/messages.cfm?p=#projectID#&mid=#id#")></cfcase>
				<cfcase value="Milestone"><cfset querySetCell(data,"link","#site_url#/milestones.cfm?p=#projectID#&m=#id#")></cfcase>
				<cfcase value="To-Do List"><cfset querySetCell(data,"link","#site_url#/todos.cfm?p=#projectID#&t=#id#")></cfcase>
				<cfcase value="File"><cfset querySetCell(data,"link","#site_url#/files.cfm?p=#projectID#&f=#id#")></cfcase>
				<cfcase value="Project"><cfset querySetCell(data,"link","#site_url#/project.cfm?p=#projectID#")></cfcase>
				<cfdefaultcase>#site_url#</cfdefaultcase>
			</cfswitch>			
			
			<cfset querySetCell(data,"subject","Recent Activity")>
			<cfset querySetCell(data,"date",stamp)>
		</cfoutput>
	</cfcase>	
</cfswitch>

<cfset meta.image = structNew()>
<cfset meta.image.url = "#site_url#/images/activity.gif">
<cfset meta.image.title = "#application.settings.app_title#">
<cfset meta.image.link = "#application.settings.rootURL#">

<cfset rss = createObject("component","cfcs.rss")>

<cfset rssXML = rss.generateRSS("rss1",data,meta)>
<!---
<cffile action="write" file="#expandPath('./foo.xml')#" output="#rssXML#">
--->
<cfcontent type="text/xml" reset="true"><cfoutput>#rssxml#</cfoutput>