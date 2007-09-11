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
<script type="text/javascript" src="#application.settings.mapping#/js/jquery.js"></script>
<script type="text/javascript" src="#application.settings.mapping#/js/interface/interface.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$('input, textarea, select').focus(function(){ $(this).css('background-color', '##ffc'); });
	$('input, textarea, select').blur(function(){ $(this).css('background-color', '##fff'); });
});
</script>

</head>
<body>
<div id="header">

	<cfif isDefined("session.loggedin") and session.loggedin>
	<div id="loggedin">
		<img src="#application.settings.mapping#/images/user.png" style="vertical-align:middle;"> #session.user.firstName# #session.user.lastName#
		| <a href="#application.settings.mapping#/account.cfm" title="My Account"<cfif find('/account.cfm',cgi.script_name)> class="current"</cfif>>My Account</a>
		| <a href="#application.settings.mapping#/index.cfm?logout" title="Logout">Logout</a>
	</div>
	
	<cfif compare(attributes.project,'')><div id="linksback"><a href="#application.settings.mapping#/index.cfm">Dashboard</a> &raquo;</div><h1>#attributes.project#</h1><cfelse><h1>#application.settings.title#</h1></cfif>
	
	<div id="tabs">
		<ul id="maintabs">
			<cfif compare(attributes.projectid,'')>
			<li><a href="#application.settings.mapping#/project.cfm?p=#attributes.projectid#" title="Overview"<cfif find('/project.cfm',cgi.script_name)> class="current"</cfif>>Overview</a></li>
			<li><a href="#application.settings.mapping#/messages.cfm?p=#attributes.projectid#" title="Messages"<cfif find('/messages.cfm',cgi.script_name) or find('/editMessage.cfm',cgi.script_name) or find('/message.cfm',cgi.script_name)> class="current"</cfif>>Messages</a></li>
			<li><a href="#application.settings.mapping#/todos.cfm?p=#attributes.projectid#" title="To-Dos"<cfif find('/todos.cfm',cgi.script_name)> class="current"</cfif>>To-Do</a></li>
			<li><a href="#application.settings.mapping#/milestones.cfm?p=#attributes.projectid#" title="Milestones"<cfif find('/milestones.cfm',cgi.script_name)> class="current"</cfif>>Milestones</a></li>			
			<li><a href="#application.settings.mapping#/issues.cfm?p=#attributes.projectid#" title="Issues"<cfif find('/issues.cfm',cgi.script_name)> class="current"</cfif>>Issues</a></li>
			<li><a href="#application.settings.mapping#/files.cfm?p=#attributes.projectid#" title="Files"<cfif find('/files.cfm',cgi.script_name)> class="current"</cfif>>Files</a></li>
			<cfif compare(attributes.svnurl,'')>
			<li><a href="#application.settings.mapping#/svn.cfm?p=#attributes.projectid#" title="SVN"<cfif find('/svn.cfm',cgi.script_name)> class="current"</cfif>>SVN</a></li>
			</cfif>
			<cfelse>
			<li><a href="#application.settings.mapping#/index.cfm" title="Dashboard"<cfif find('/index.cfm',cgi.script_name)> class="current"</cfif>>Dashboard</a></li>
			<li><a href="#application.settings.mapping#/alltodos.cfm" title="To-Dos"<cfif find('/alltodos.cfm',cgi.script_name)> class="current"</cfif>>To-Dos</a></li>
			<li><a href="#application.settings.mapping#/allmilestones.cfm" title="Milestones"<cfif find('/allmilestones.cfm',cgi.script_name)> class="current"</cfif>>Milestones</a></li>
			</cfif>
			<cfif isDefined("session.user.admin") and session.user.admin>
			<li style="float:right; margin-right:30px;"><a href="#application.settings.mapping#/admin/" title="Admin">Admin</a></li>
			</cfif>
			<cfif compare(attributes.projectid,'')>
				<cfset userRole = application.role.get(session.user.userid,attributes.projectid)>
				<cfif listFind('Owner,Admin',userRole.role)>
					<li style="float:right;"><a href="#application.settings.mapping#/editProject.cfm?p=#attributes.projectid#" title="Settings"<cfif find('/editProject.cfm',cgi.script_name) and isDefined("url.p")> class="current"</cfif>>Settings</a></li>
				</cfif>
			<li style="float:right;<cfif not isDefined("session.user.admin") or not session.user.admin> margin-right:30px;</cfif>"><a href="#application.settings.mapping#/people.cfm?p=#attributes.projectid#" title="People"<cfif find('/people.cfm',cgi.script_name)> class="current"</cfif>>People</a></li>
			</cfif>
		</ul>
	</div>
</div>
<cfelse>
	<h1>#application.settings.title#</h1>
</cfif>
<!---
<div id="wrapper">
	<div id="header">
		<cfif isDefined("session.loggedin") and session.loggedin is true>
			<div style="float:right">
				<ul id="navbar">
					<li><a href="#application.settings.mapping#/index.cfm">Home</a></li> | 
					<li><a href="#application.settings.mapping#/index.cfm?logout">Logout</a></li>
				</ul>
			</div>
		</cfif>
		<h1><img src="/stdimages/lrc40-bev.gif" alt="LRC" height="40" width="41" border="0" style="padding:0 8px 5px 5px;vertical-align:middle;" />#application.settings.title#</h1></div>
	<div id="content">
--->
</cfoutput>

<cfsetting enablecfoutputonly="false">
