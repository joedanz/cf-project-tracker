<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

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
		<h1>#application.settings.app_title#</h1>
	</div><!-- /header -->

	<div data-role="content">	
		<p>Welcome, #session.user.firstName#!</p>


	</div><!-- /content -->

	<div data-role="footer" data-theme="a" data-position="fixed" data-id="fixedfooter">
		<div data-role="navbar">
			<ul>
				<li><a href="index.cfm" class="ui-btn-active">Home</a></li>
				<li><a href="projects.cfm" data-transition="slidedown">Projects</a></li>
			</ul>
		</div><!-- /navbar -->
	</div><!-- /footer -->

</div><!-- /page -->

</body>
</html>
</cfoutput>

<cfsetting enablecfoutputonly="false">