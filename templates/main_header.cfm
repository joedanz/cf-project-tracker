<cfsetting enablecfoutputonly="true">
<!---
	Purpose		 : Display main template header
--->

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>#attributes.title#</title>

<!-- Meta Tags -->
<meta http-equiv="content-type" content="text/html; charset=utf-8" />

<!-- Favicon -->
<link rel="shortcut icon" href="#application.settings.mapping#/images/favicon.ico" />

<!-- CSS -->
<link rel="stylesheet" href="#application.settings.mapping#/css/header/#session.style#.css" media="screen,projection" type="text/css" />
<link rel="stylesheet" href="#application.settings.mapping#/css/all_styles.css" media="screen,projection" type="text/css" />

<!-- JavaScript -->
<script type="text/javascript" src="#application.settings.mapping#/js/jquery.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/jquery.color.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/jquery.checkboxes.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/jquery.tablesorter.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/webtoolkit.scrollabletable.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/jquery.prettyPhoto.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/master.js"></script>
</head>
<body>
<div id="header">

<cfif StructKeyExists(session,"loggedin") and session.loggedin>

	<div id="loggedin">
		<cfif compareNoCase(session.user.username,'guest')>
			<img src="#application.settings.mapping#/images/<cfif session.user.avatar>avatars/#session.user.userid#_16.jpg<cfelse>user.gif</cfif>" style="vertical-align:middle;"> #session.user.firstName# #session.user.lastName#
			| <a href="#application.settings.mapping#/account.cfm" title="My Account"<cfif find('/account.cfm',cgi.script_name)> class="current"</cfif>>My Account</a>
			| <a href="#application.settings.mapping#/index.cfm?logout" title="Logout">Logout</a>
		<cfelse>
			<a href="#application.settings.mapping#/index.cfm?logout" title="Login">Login</a>
			<cfif application.settings.allowRegister>
				| <a href="#application.settings.mapping#/register.cfm" title="Logout">Register</a>
			</cfif>
		</cfif>
	</div>

	<cfif compare(attributes.project,'')>
		<cfif session.user.projects.recordCount gt 1 or session.user.admin>
		<div id="linksback">
			<a href="#application.settings.mapping#/index.cfm">Dashboard</a>
			 | <a href="##" onclick="togglemenu();">Choose a project</a>
		</div>
		</cfif>
		<h1>#attributes.project#</h1>
	<cfelse>
		<h1>#application.settings.app_title#</h1>
	</cfif>

	<cfif session.user.projects.recordCount gt 1>
	<div id="projectmenu" style="display:none;">
	<ul>
		<cfloop query="session.user.projects">
			<li onclick="window.location='#application.settings.mapping#/project.cfm?p=#projectID#';" onmouseover="$(this).addClass('menuhover')" onmouseout="$(this).removeClass('menuhover')"><a href="#application.settings.mapping#/project.cfm?p=#projectID#">#name#</a></li>
		</cfloop>
		<li onmouseover="$(this).addClass('menuhover')" onmouseout="$(this).removeClass('menuhover')" onclick="togglemenu();"><a href="##" class="cancel">Close</a></li>
	</ul>
	</div>
	</cfif>

	<div id="tabs">

		<ul id="admintabs">
			<cfif compare(attributes.projectid,'')>
				<cfset userRole = application.role.get(session.user.userid,attributes.projectid)>
				<cfif session.user.admin or userRole.admin>
					<li><a href="#application.settings.mapping#/editProject.cfm?p=#attributes.projectid#" title="Settings"<cfif find('/editProject.cfm',cgi.script_name) and StructKeyExists(url,"p")> class="current"</cfif>>Settings</a></li>
					<li><a href="#application.settings.mapping#/people.cfm?p=#attributes.projectid#" title="People"<cfif find('/people.cfm',cgi.script_name)> class="current"</cfif>>People</a></li>
				</cfif>
			</cfif>
			<li><a href="#application.settings.mapping#/search.cfm<cfif StructKeyExists(url,"p")>?p=#url.p#</cfif>" title="Search"<cfif find('/search.cfm',cgi.script_name)> class="current"</cfif>>Search</a></li>
			<cfif session.user.admin>
			<li><a href="#application.settings.mapping#/admin/users.cfm" title="Admin"<cfif find('/admin/',cgi.script_name)> class="current"</cfif>>Admin</a></li>
			</cfif>
		</ul>

		<ul id="maintabs">
			<cfif compare(attributes.projectid,'')>
				<cfset project = application.project.getDistinct(attributes.projectid)>
				<li><a href="#application.settings.mapping#/project.cfm?p=#attributes.projectid#" title="Overview"<cfif find('/project.cfm',cgi.script_name)> class="current"</cfif>>Overview</a></li>
				<cfif project.tab_msgs eq 1 and userRole.msgs gt 0>
					<li><a href="#application.settings.mapping#/messages.cfm?p=#attributes.projectid#" title="Messages"<cfif find('/messages.cfm',cgi.script_name) or find('/editMessage.cfm',cgi.script_name) or find('/message.cfm',cgi.script_name)> class="current"</cfif>>Messages</a></li>
				</cfif>
				<cfif project.tab_todos eq 1 and userRole.todos gt 0>
					<li><a href="#application.settings.mapping#/todos.cfm?p=#attributes.projectid#" title="To-Dos"<cfif find('/todos.cfm',cgi.script_name) or find('/editTodolist.cfm',cgi.script_name)> class="current"</cfif>>To-Do</a></li>
				</cfif>
				<cfif project.tab_mstones eq 1 and userRole.mstones gt 0>
					<li><a href="#application.settings.mapping#/milestones.cfm?p=#attributes.projectid#" title="Milestones"<cfif find('/milestone',cgi.script_name) or find('/editMilestone.cfm',cgi.script_name)> class="current"</cfif>>Milestones</a></li>
				</cfif>
				<cfif project.tab_issues eq 1 and userRole.issues gt 0>
					<li><a href="#application.settings.mapping#/issues.cfm?p=#attributes.projectid#" title="Issues"<cfif find('/issue',cgi.script_name) or find('/editIssue.cfm',cgi.script_name)> class="current"</cfif>>Issues</a></li>
				</cfif>
				<cfif project.tab_time eq 1 and userRole.timetrack gt 0>
					<li><a href="#application.settings.mapping#/time.cfm?p=#attributes.projectid#" title="Time"<cfif find('/time.cfm',cgi.script_name)> class="current"</cfif>>Time</a></li>
				</cfif>
				<cfif project.tab_files eq 1 and userRole.files gt 0>
					<li><a href="#application.settings.mapping#/files.cfm?p=#attributes.projectid#" title="Files"<cfif find('/files.cfm',cgi.script_name) or find('/editFile.cfm',cgi.script_name)> class="current"</cfif>>Files</a></li>
				</cfif>
				<cfif project.tab_svn eq 1 and userRole.svn gt 0 and compare(attributes.svnurl,'')>
				<li><a href="#application.settings.mapping#/svnBrowse.cfm?p=#attributes.projectid#" title="SVN"<cfif find('/svn',cgi.script_name)> class="current"</cfif>>SVN</a></li>
				</cfif>
			<cfelse>
				<li><a href="#application.settings.mapping#/index.cfm" title="Dashboard across all your projects"<cfif find('#application.settings.mapping#/index.cfm',cgi.script_name)> class="current"</cfif>>Dashboard</a></li>
				<li><a href="#application.settings.mapping#/alltodos.cfm" title="To-Dos across all your projects"<cfif find('/alltodos.cfm',cgi.script_name)> class="current"</cfif>>All To-Dos</a></li>
				<li><a href="#application.settings.mapping#/allmilestones.cfm" title="Milestones across all your projects"<cfif find('/allmilestones.cfm',cgi.script_name)> class="current"</cfif>>All Milestones</a></li>
				<li><a href="#application.settings.mapping#/allissues.cfm" title="Issues across all your projects"<cfif find('/allissues.cfm',cgi.script_name)> class="current"</cfif>>All Issues</a></li>
			</cfif>
		</ul>
		<br />
	</div>
<cfelse>
	<cfparam name="application.settings.app_title" default="Project Tracker">
	<h1 style="padding-bottom:10px;">#application.settings.app_title#</h1>
</cfif>
</div>
</cfoutput>

<cfsetting enablecfoutputonly="false">