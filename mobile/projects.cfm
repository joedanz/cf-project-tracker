<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif session.user.admin>
	<cfset projects = application.project.get()>
<cfelse>
	<cfset projects = application.project.get(session.user.userid)>
</cfif>

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
		<h1>#application.settings.app_title# - Projects</h1>
	</div><!-- /header -->

	<div data-role="content">	
		
		<ul data-role="listview" data-filter="true">
			<cfloop query="projects">
				<li><a href="project.cfm?p=#projectID#" data-transition="slideup" rel="external">#name#</a></li>
			</cfloop>
		</ul>

	</div><!-- /content -->

	<div data-role="footer" data-theme="a" data-position="fixed" data-id="fixedfooter">
		<div data-role="navbar">
			<ul>
				<li><a href="index.cfm">Home</a></li>
				<li><a href="projects.cfm" class="ui-btn-active">Projects</a></li>
			</ul>
		</div><!-- /navbar -->
	</div><!-- /footer -->

</div><!-- /page -->

</body>
</html>
</cfoutput>

<cfsetting enablecfoutputonly="false">