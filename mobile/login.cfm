<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfparam name="request.error" default="">
<cfparam name="form.username" default="">

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

	<div data-role="header" data-theme="b">
		<h1>#application.settings.app_title#</h1>
	</div><!-- /header -->

	<div data-role="content">	
		<form action="#cgi.script_name#?#cgi.query_string#" method="post" id="login" data-ajax="false">
			<p><strong>Please Login...</strong></p>
			
			<cfif compare(request.error,'')>
				<a href="##" data-role="button" data-icon="alert" data-theme="e">#request.error#</a> 
			</cfif>
		
			<div data-role="fieldcontain">
			    <label for="username">Username:</label>
			    <input type="text" name="username" id="username" value="#form.username#"  />
			</div>
			<div data-role="fieldcontain">
			    <label for="password">Password:</label>
			    <input type="password" name="password" id="password" value="" />
			</div>	
			<input type="submit" value="Click to Login" />
		
		</form> 
	</div><!-- /content -->

</div><!-- /page -->

</body>
</html>
</cfoutput>

<cfsetting enablecfoutputonly="false">