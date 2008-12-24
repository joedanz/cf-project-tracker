<cfsetting enablecfoutputonly="true">
<!---
	Purpose		 : Display mobile template header
--->

<cfoutput>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN"
"http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <title>#attributes.title#</title>
	<link rel="stylesheet" href="#application.settings.mapping#/css/reset.css" media="screen" type="text/css" />
	<link rel="stylesheet" href="#application.settings.mapping#/mobile/mobile.css" media="screen" type="text/css" />
  </head>
  <body>
	<div id="header">
		<cfif compare(attributes.project,'')>
			<h1>#attributes.project#</h1>
		<cfelse>
			<h1>#application.settings.app_title#</h1>
		</cfif>
		
		<div id="loggedin">
			<cfif compare(attributes.projectid,'')>
				<a href="index.cfm" class="return">&laquo; Return to Main Menu</a>
			</cfif>
			<cfif compareNoCase(session.user.username,'guest')>
				<img src="#application.settings.mapping#/images/<cfif session.user.avatar>avatars/#session.user.userid#_16.jpg<cfelse>user.gif</cfif>" style="vertical-align:middle;"> #session.user.firstName# #session.user.lastName#
				| <a href="#application.settings.mapping#/index.cfm?logout" title="Logout">Logout</a>
			<cfelse>
				<a href="#application.settings.mapping#/index.cfm?logout" title="Login">Login</a>
			</cfif>
		</div>
	</div>
	
	<ul id="maintabs">
		<cfif compare(attributes.projectid,'')>
			<cfset project = application.project.getDistinct(attributes.projectid)>
			<cfset userRole = application.role.get(session.user.userid,attributes.projectid)>
			<li><a href="#application.settings.mapping#/mobile/project.cfm?p=#attributes.projectid#" title="Overview"<cfif find('/mobile/project.cfm',cgi.script_name)> class="current"</cfif>>Overview</a></li>
			<cfif project.tab_msgs eq 1 and userRole.msgs gt 0>
				<li><a href="#application.settings.mapping#/mobile/messages.cfm?p=#attributes.projectid#" title="Messages"<cfif find('/mobile/messages.cfm',cgi.script_name) or find('/mobile/editMessage.cfm',cgi.script_name) or find('/mobile/message.cfm',cgi.script_name)> class="current"</cfif>>Messages</a></li>
			</cfif>
			<cfif project.tab_todos eq 1 and userRole.todos gt 0>
				<li><a href="#application.settings.mapping#/mobile/todos.cfm?p=#attributes.projectid#" title="To-Dos"<cfif find('/mobile/todos.cfm',cgi.script_name) or find('/mobile/editTodolist.cfm',cgi.script_name)> class="current"</cfif>>To-Do</a></li>
			</cfif>
			<cfif project.tab_mstones eq 1 and userRole.mstones gt 0>
				<li><a href="#application.settings.mapping#/mobile/milestones.cfm?p=#attributes.projectid#" title="Milestones"<cfif find('/mobile/milestone',cgi.script_name) or find('/mobile/editMilestone.cfm',cgi.script_name)> class="current"</cfif>>Milestones</a></li>
			</cfif>
			<cfif project.tab_issues eq 1 and userRole.issues gt 0>
				<li><a href="#application.settings.mapping#/mobile/issues.cfm?p=#attributes.projectid#" title="Issues"<cfif find('/mobile/issue',cgi.script_name) or find('/mobile/editIssue.cfm',cgi.script_name)> class="current"</cfif>>Issues</a></li>
			</cfif>
			<cfif project.tab_time eq 1 and userRole.timetrack gt 0>
				<li><a href="#application.settings.mapping#/mobile/time.cfm?p=#attributes.projectid#" title="Time"<cfif find('/mobile/time.cfm',cgi.script_name)> class="current"</cfif>>Time</a></li>
			</cfif>
			<cfif project.tab_files eq 1 and userRole.files gt 0>
				<li><a href="#application.settings.mapping#/mobile/files.cfm?p=#attributes.projectid#" title="Files"<cfif find('/mobile/files.cfm',cgi.script_name) or find('/mobile/editFile.cfm',cgi.script_name)> class="current"</cfif>>Files</a></li>
			</cfif>
			<cfif project.tab_svn eq 1 and userRole.svn gt 0 and compare(attributes.svnurl,'')>
			<li><a href="#application.settings.mapping#/mobile/svnBrowse.cfm?p=#attributes.projectid#" title="SVN"<cfif find('/mobile/svn',cgi.script_name)> class="current"</cfif>>SVN</a></li>
			</cfif>
		<cfelse>
			<li><a href="#application.settings.mapping#/mobile/index.cfm" title="Dashboard across all your projects"<cfif find('#application.settings.mapping#/mobile/index.cfm',cgi.script_name)> class="current"</cfif>>Dashboard</a></li>
			<li><a href="#application.settings.mapping#/mobile/activity.cfm" title="Dashboard across all your projects"<cfif find('#application.settings.mapping#/mobile/activity.cfm',cgi.script_name)> class="current"</cfif>>Latest Activity</a></li>
			<li><a href="#application.settings.mapping#/mobile/alltodos.cfm" title="To-Dos across all your projects"<cfif find('/mobile/alltodos.cfm',cgi.script_name)> class="current"</cfif>>All To-Dos</a></li>
			<li><a href="#application.settings.mapping#/mobile/allmilestones.cfm" title="Milestones across all your projects"<cfif find('/mobile/allmilestones.cfm',cgi.script_name)> class="current"</cfif>>All Milestones</a></li>
			<li><a href="#application.settings.mapping#/mobile/allissues.cfm" title="Issues across all your projects"<cfif find('/mobile/allissues.cfm',cgi.script_name)> class="current"</cfif>>All Issues</a></li>
		</cfif>
	</ul>
	
</cfoutput>

<cfsetting enablecfoutputonly="false">