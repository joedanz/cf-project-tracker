<cfset failed = FALSE />


<cfif structKeyExists(form, "apiURL")>
	<cftry>

		<cfset ptObj = createObject("component", "cfc.projecttracker").init(apiUrl=form.apiUrl,apiKey=form.apiKey) />
		<cfset test.projects = ptObj.getProjectList() />
		<cfif test.projects.recordCount>
			<cfset test.project = ptObj.getProject(test.projects.id[1]) />
			<cfset test.messages = ptObj.getMessages(test.projects.id[1]) />
			<cfif test.messages.recordCount>
				<cfset test.message_categories = ptObj.getMessageCategories(test.projects.id[1])>
				<cfset test.message = ptObj.getMessage(test.projects.id[1],test.messages.id[1]) />
				<cfset test.comments = ptObj.getCommentsByMessage(test.projects.id[1],test.messages.id[1]) />
			</cfif>
			<cfset test.files = ptObj.getFiles(test.projects.id[1]) />
			<cfif test.files.recordCount>
				<cfset test.file_categories = ptObj.getFileCategories(test.projects.id[1])>
			</cfif>
			<cfset test.issues = ptObj.getIssues(test.projects.id[1]) />
			<cfset test.milestones = ptObj.getMilestones(test.projects.id[1]) />
			<cfset test.todolists = ptObj.getToDoLists(test.projects.id[1]) />
			<cfif test.todolists.recordCount>
				<cfset test.todos = ptObj.getToDos(test.projects.id[1],test.todolists.id[1]) />
			</cfif>
		</cfif>
		
		<cfcatch type="any">
			<cfif FindNoCase("401", cfcatch.Detail)>
				<cfset failed = TRUE>
			<cfelse>
				<cfrethrow>
			</cfif>
		</cfcatch>

	</cftry>
</cfif>


<cfparam name="failed" type="boolean" default="FALSE" />
<cfparam name="apiurl" type="string" default="http://127.0.0.1:8500/project/api/0.1/" />
<cfparam name="apikey" type="string" default="" />
<cfparam name="apisecret" type="string" default="" />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title>Project Tracker API Test</title>
<link rel="stylesheet" href="screen.css" type="text/css" media="screen" />

</head>

<body>
<div class="page_header">
  <h1>Project Tracker API Demo</h1>
	<p><a href="index.cfm">Test API</a> | <a href="reference.cfm">CFC Reference</a></p>
</div>

<cfform action="#cgi.script_name#" method="post" class="login">
<fieldset>
<cfif failed>
	<legend class="error">Login failed</legend>
<cfelse>
	<legend>Please Login</legend>
</cfif>
<label for="apiurl">API Url:</label><cfinput class="text" type="text" name="apiurl" value="#apiurl#" id="apiurl" required="true" validate="url" message="You must enter a valid Basecamp URL." /><br />
<label for="apikey">API Key:</label><cfinput class="text"  type="text" name="apikey" id="apikey"  value="#apikey#" required="true"  message="You must enter your API Key." /><br />
<input type="submit" name="submit" value="login" />
</fieldset>
</cfform>


<cfif structKeyExists(variables, "test")>
	<cfdump var="#test#">
</cfif>

<div class="page_footer">
	<p>Project Tracker is developed by <a href="http://www.ajaxcf.com/">Joe Danziger</a>.</p>
</div>
</body>
</html>