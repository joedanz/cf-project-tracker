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
<link rel="stylesheet" href="#application.settings.mapping#/css/master.css" media="screen,projection" type="text/css" />

<!-- JavaScript -->
<script type="text/javascript" src="#application.settings.mapping#/js/jquery/jquery.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/jquery/interface.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/jquery/jquery.tablesorter.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/jquery/webtoolkit.jscrollable.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/jquery/webtoolkit.scrollabletable.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/master.js"></script>
</head>
<body>
<div id="header">

	<cfif StructKeyExists(session,"loggedin") and session.loggedin>
	<div id="loggedin">
		<img src="#application.settings.mapping#/images/avatars/<cfif session.user.avatar>#session.user.userid#_16.jpg<cfelse>user.gif</cfif>" style="vertical-align:middle;"> #session.user.firstName# #session.user.lastName#
		| <a href="#application.settings.mapping#/account.cfm" title="My Account"<cfif find('/account.cfm',cgi.script_name)> class="current"</cfif>>My Account</a>
		| <a href="#application.settings.mapping#/index.cfm?logout" title="Logout">Logout</a>
	</div>

	<cfif compare(attributes.project,'')>
		<div id="linksback">
			<a href="#application.settings.mapping#/index.cfm">Dashboard</a>
			<cfif session.user.projects.recordCount gt 1> | <a href="##" onclick="togglemenu();">Choose a project</a></cfif>
		</div>
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
		<ul id="maintabs">
			<cfif compare(attributes.projectid,'')>
			<li><a href="#application.settings.mapping#/project.cfm?p=#attributes.projectid#" title="Overview"<cfif find('/project.cfm',cgi.script_name)> class="current"</cfif>>Overview</a></li>
			<li><a href="#application.settings.mapping#/messages.cfm?p=#attributes.projectid#" title="Messages"<cfif find('/messages.cfm',cgi.script_name) or find('/editMessage.cfm',cgi.script_name) or find('/message.cfm',cgi.script_name)> class="current"</cfif>>Messages</a></li>
			<li><a href="#application.settings.mapping#/todos.cfm?p=#attributes.projectid#" title="To-Dos"<cfif find('/todos.cfm',cgi.script_name)> class="current"</cfif>>To-Do</a></li>
			<li><a href="#application.settings.mapping#/milestones.cfm?p=#attributes.projectid#" title="Milestones"<cfif find('/milestones.cfm',cgi.script_name)> class="current"</cfif>>Milestones</a></li>			
			<li><a href="#application.settings.mapping#/issues.cfm?p=#attributes.projectid#" title="Issues"<cfif find('/issue',cgi.script_name)> class="current"</cfif>>Issues</a></li>
			<li><a href="#application.settings.mapping#/files.cfm?p=#attributes.projectid#" title="Files"<cfif find('/files.cfm',cgi.script_name)> class="current"</cfif>>Files</a></li>
			<cfif compare(attributes.svnurl,'') and compare(application.settings.svnBinary,'')>
			<li><a href="#application.settings.mapping#/svn.cfm?p=#attributes.projectid#" title="SVN"<cfif find('/svn.cfm',cgi.script_name)> class="current"</cfif>>SVN</a></li>
			</cfif>
			<cfelse>
			<li><a href="#application.settings.mapping#/index.cfm" title="Dashboard"<cfif find('#application.settings.mapping#/index.cfm',cgi.script_name)> class="current"</cfif>>Dashboard</a></li>
			<li><a href="#application.settings.mapping#/alltodos.cfm" title="To-Dos"<cfif find('/alltodos.cfm',cgi.script_name)> class="current"</cfif>>To-Dos</a></li>
			<li><a href="#application.settings.mapping#/allmilestones.cfm" title="Milestones"<cfif find('/allmilestones.cfm',cgi.script_name)> class="current"</cfif>>Milestones</a></li>
			<li><a href="#application.settings.mapping#/allissues.cfm" title="Issues"<cfif find('/allissues.cfm',cgi.script_name)> class="current"</cfif>>Issues</a></li>
			</cfif>
			<cfif StructKeyExists(session.user,"admin") and session.user.admin>
			<li style="float:right; margin-right:30px;"><a href="#application.settings.mapping#/admin.cfm" title="Admin"<cfif find('/admin.cfm',cgi.script_name)> class="current"</cfif>>Admin</a></li>
			</cfif>
			<cfif compare(attributes.projectid,'')>
				<cfset userRole = application.role.get(session.user.userid,attributes.projectid)>
				<cfif listFind('Owner,Admin',userRole.role)>
					<li style="float:right;"><a href="#application.settings.mapping#/editProject.cfm?p=#attributes.projectid#" title="Settings"<cfif find('/editProject.cfm',cgi.script_name) and StructKeyExists(url,"p")> class="current"</cfif>>Settings</a></li>
				</cfif>
			<li style="float:right;<cfif not StructKeyExists(session.user,"admin") or not session.user.admin> margin-right:30px;</cfif>"><a href="#application.settings.mapping#/people.cfm?p=#attributes.projectid#" title="People"<cfif find('/people.cfm',cgi.script_name)> class="current"</cfif>>People</a></li>
			</cfif>
		</ul>
	</div>
<cfelse>
	<h1 style="padding-bottom:10px;">#application.settings.app_title#</h1>
</cfif>
</div>
</cfoutput>

<cfsetting enablecfoutputonly="false">
