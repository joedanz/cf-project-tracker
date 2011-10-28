<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfset project = application.project.getDistinct(url.p)>
<cfset userRole = application.role.get(session.user.userid,url.p)>

<cfoutput>
<!DOCTYPE html>
<html> 
	<head> 
	<title>#application.settings.app_title#</title> 
	<link rel="stylesheet" href="http://code.jquery.com/mobile/1.0b2/jquery.mobile-1.0b2.min.css" />
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.6.2.min.js"></script>
	<script type="text/javascript" src="http://code.jquery.com/mobile/1.0b2/jquery.mobile-1.0b2.min.js"></script>
</head> 
<body> 

<div data-role="page" data-theme="b">

	<div data-role="header" data-theme="b" data-position="fixed">
		<h1>#project.name#</h1>
	</div><!-- /header -->

	<div data-role="content">	
		
		<ul data-role="listview">
			<cfif project.tab_msgs eq 1 and (session.user.admin or userRole.admin or userRole.msg_view)>
				<li><a href="#application.settings.mapping#/messages.cfm?p=#url.p#" title="Messages"<cfif find('/messages.cfm',cgi.script_name) or find('/editMessage.cfm',cgi.script_name) or find('/message.cfm',cgi.script_name)> class="current"</cfif>>Messages<span class="ui-li-count">0</span></a></li>
			</cfif>
			<cfif project.tab_todos eq 1 and (session.user.admin or userRole.admin or userRole.todolist_view)>
				<li><a href="#application.settings.mapping#/todos.cfm?p=#url.p#" title="To-Dos"<cfif find('/todo',cgi.script_name) or find('/editTodolist.cfm',cgi.script_name)> class="current"</cfif>>To-Do<span class="ui-li-count">0</span></a></li>
			</cfif>
			<cfif project.tab_mstones eq 1 and (session.user.admin or userRole.admin or userRole.mstone_view)>
				<li><a href="#application.settings.mapping#/milestones.cfm?p=#url.p#" title="Milestones"<cfif find('/milestone',cgi.script_name) or find('/editMilestone.cfm',cgi.script_name)> class="current"</cfif>>Milestones<span class="ui-li-count">0</span></a></li>
			</cfif>
			<cfif project.tab_issues eq 1 and (session.user.admin or userRole.admin or userRole.issue_view)>
				<li><a href="#application.settings.mapping#/issues.cfm?p=#url.p#" title="Issues"<cfif find('/issue',cgi.script_name) or find('/editIssue.cfm',cgi.script_name)> class="current"</cfif>>Issues<span class="ui-li-count">0</span></a></li>
			</cfif>
			<cfif project.tab_time eq 1 and (session.user.admin or userRole.admin or userRole.time_view)>
				<li><a href="#application.settings.mapping#/time.cfm?p=#url.p#" title="Time"<cfif find('/time.cfm',cgi.script_name)> class="current"</cfif>>Time<span class="ui-li-count">0</span></a></li>
			</cfif>
			<cfif project.tab_billing eq 1 and (session.user.admin or userRole.admin or userRole.bill_view)>
				<li><a href="#application.settings.mapping#/billing.cfm?p=#url.p#" title="Billing"<cfif find('/billing.cfm',cgi.script_name)> class="current"</cfif>>Billing<span class="ui-li-count">0</span></a></li>
			</cfif>
			<cfif project.tab_files eq 1 and (session.user.admin or userRole.admin or userRole.file_view)>
				<li><a href="#application.settings.mapping#/files.cfm?p=#url.p#" title="Files"<cfif find('/file',cgi.script_name) or find('/editFile.cfm',cgi.script_name)> class="current"</cfif>>Files<span class="ui-li-count">0</span></a></li>
			</cfif>
			<cfif project.tab_svn eq 1 and compare(project.svnurl,'') and (session.user.admin or userRole.admin or userRole.svn)>
			<li><a href="#application.settings.mapping#/svnBrowse.cfm?p=#url.p#" title="SVN"<cfif find('/svn',cgi.script_name)> class="current"</cfif>>SVN<span class="ui-li-count">0</span></a></li>
			</cfif>
		</ul>

	</div><!-- /content -->

	<div data-role="footer" data-theme="a" data-position="fixed" data-id="fixedfooter">
		<div data-role="navbar">
			<ul>
				<li><a href="index.cfm">Home</a></li>
				<li><a href="projects.cfm">Projects</a></li>
			</ul>
		</div><!-- /navbar -->
	</div><!-- /footer -->

</div><!-- /page -->

</body>
</html>
</cfoutput>

<cfsetting enablecfoutputonly="false">