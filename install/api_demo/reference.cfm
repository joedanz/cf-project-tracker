<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title>Project Tracker API CFC Reference</title>
<link rel="stylesheet" href="screen.css" type="text/css" media="screen" />

<style>
body  {
	font-family: verdana, arial, helvetica, sans-serif;
	background-color: #FFFFFF;
	font-size: 12px;
	margin-top: 10px;
	margin-left: 10px;
}

table	{
	font-size: 11px;
	font-family: Verdana, arial, helvetica, sans-serif;
	width: 90%;
}

th {
	padding: 6px;
	font-size: 12px;
	background-color: #cccccc;
}

td {
	padding: 6px;
	background-color: #eeeeee;
	vertical-align : top;
}

code {
	color: #000099 ;
}
</style>

</head>

<body>
<div class="page_header">
  <h1>Project Tracker API Demo</h1>
	<p><a href="index.cfm">Test API</a> | <a href="reference.cfm">CFC Reference</a></p>
</div>



<font size="-2">project.install.api_demo.cfc.projecttracker</font><br>
<font size="+1"><b>Component projecttracker</b></font>

<table>


<tr><td>hierarchy:</td><td>
	
	
		<a href="/CFIDE/componentutils/cfcexplorer.cfc?method=getcfcinhtml&name=WEB-INF.cftags.component">WEB-INF.cftags.component</a><br>
		
	
	
	
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;project.install.api_demo.cfc.projecttracker<br>
		
	
	


</td></tr>


<tr><td>path:</td>
	<td>C:\ColdFusion8\wwwroot\project\install\api_demo\cfc\projecttracker.cfc</td>
</tr>



 





<tr><td>properties:</td>
	
	
	<br>
	<td></td>
</tr>

<tr><td>methods:</td>
	
	
	
	
	
	
		
	
	
	
	
	
	
		
	
	
	
	
	
	
		
	
	
	
	
	
	
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
	
	
	
	
	
	
		
	
	
	
	
	
	
		
	
	
	
	<td> <a href="#method_convertJSDateTime">convertJSDateTime</a>*, <a href="#method_convertPostRequestToXML">convertPostRequestToXML</a>*, <a href="#method_convertXMLToQuery">convertXMLToQuery</a>*, <a href="#method_debugProjectTrackerData">debugProjectTrackerData</a>*, <a href="#method_getCommentsByMessage">getCommentsByMessage</a>, <a href="#method_getFiles">getFiles</a>, <a href="#method_getIssues">getIssues</a>, <a href="#method_getMessage">getMessage</a>, <a href="#method_getMessageArchive">getMessageArchive</a>, <a href="#method_getMilestones">getMilestones</a>, <a href="#method_getProject">getProject</a>, <a href="#method_getProjectList">getProjectList</a>, <a href="#method_getToDoLists">getToDoLists</a>, <a href="#method_getToDos">getToDos</a>, <a href="#method_init">init</a>, <a href="#method_makeHTTPGetRequest">makeHTTPGetRequest</a>*, <a href="#method_makeHTTPPostRequest">makeHTTPPostRequest</a>*, <a href="#method_returnAllSubKeys">returnAllSubKeys</a>*</td>

</tr>





</table>
<font size="-2">* - private method</font>










<br><br><table>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_convertJSDateTime">convertJSDateTime</a>*
		
		</th></tr>
	<tr><td>
	
	
	
	<code>
	
		<i>private</i>

	
	
		<i>date</i>
	
	<b>convertJSDateTime</b>
	
	(
 	
		
		<i>
		required
		string
		</i>
		jsTime=""
		
	)
	</i>
	</code>

	<br><br>	
	
	
	Converts BaseCamp time to a ColdFusion date time variable. <br><br>
	
	Output: suppressed<br>
	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>jsTime:</b>
			string,
			required,
			jsTime
			- The basecamp formatted date time.
			<br>

		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_convertPostRequestToXML">convertPostRequestToXML</a>*
		
		</th></tr>
	<tr><td>
	
	
	
	<code>
	
		<i>private</i>

	
	
		<i>string</i>
	
	<b>convertPostRequestToXML</b>
	
	(
 	
		
		<i>
		required
		struct
		</i>
		request=""
		
	)
	</i>
	</code>

	<br><br>	
	
	
	Takes a post request structure and converts it to the XML form that Basecamp needs.<br><br>
	
	Output: suppressed<br>
	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>request:</b>
			struct,
			required,
			request
			- The request structure to transform. 
			<br>

		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_convertXMLToQuery">convertXMLToQuery</a>*
		
		</th></tr>
	<tr><td>
	
	
	
	<code>
	
		<i>private</i>

	
	
		<i>query</i>
	
	<b>convertXMLToQuery</b>
	
	(
 	
		
		<i>
		required
		<a href="/CFIDE/componentutils/cfcexplorer.cfc?method=getcfcinhtml&name=project.install.api_demo.cfc.XML">XML</a>
		</i>
		projecttrackerXML,
	
		
		<i>

		required
		string
		</i>
		collection,
	
		
		<i>
		
		string
		</i>
		root=""
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Converts the results from Basecamp into an ColdFusion query variable.<br><br>

	
	Output: suppressed<br>
	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>projecttrackerXML:</b>
			<a href="/CFIDE/componentutils/cfcexplorer.cfc?method=getcfcinhtml&name=project.install.api_demo.cfc.XML">XML</a>,
			required,
			projecttrackerXML
			- The Project Tracker XML content.
			<br>
		
			
			&nbsp;&nbsp; <b>collection:</b>

			string,
			required,
			collection
			- The name of the collection to loop over. If the xml structure is 'projecttrackerXML.comments.comment',we are looking for 'comment'.
			<br>
		
			
			&nbsp;&nbsp; <b>root:</b>
			string,
			optional,
			root
			- The root of the XML file, needed if collection is not the root.
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">

		<a name="method_debugProjectTrackerData">debugProjectTrackerData</a>*
		
		</th></tr>
	<tr><td>
	
	
	
	<code>
	
		<i>private</i>
	
	
		<i>void</i>
	
	<b>debugProjectTrackerData</b>

	
	(
 	
		
		<i>
		required
		string
		</i>
		projecttrackerXML=""
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Handles processing Project Tracker API XML for Debugging.<br><br>
	
	Output: suppressed<br>

	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>projecttrackerXML:</b>
			string,
			required,
			projecttrackerXML
			- The Project Tracker XML to display.
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">

		<a name="method_getCommentsByMessage">getCommentsByMessage</a>
		
		</th></tr>
	<tr><td>
	
	
	
	<code>
	
		<i>public</i>
	
	
		<i>query</i>
	
	<b>getCommentsByMessage</b>

	
	(
 	
		
		<i>
		required
		string
		</i>
		projectID,
	
		
		<i>
		required
		string
		</i>
		messageID
		
	)
	</i>
	</code>

	<br><br>	
	
	
	Gets all comments for a given message.<br><br>
	
	Output: suppressed<br>
	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>projectID:</b>
			string,
			required,
			projectID
			- The projectID for which to retrieve messages
			<br>

		
			
			&nbsp;&nbsp; <b>messageID:</b>
			string,
			required,
			messageID
			- The messageID for which to retrieve messages
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_getFiles">getFiles</a>

		
		</th></tr>
	<tr><td>
	
	
	
	<code>
	
		<i>public</i>
	
	
		<i>query</i>
	
	<b>getFiles</b>
	
	(
 	
		
		<i>

		required
		string
		</i>
		projectID
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Gets a specific comment.<br><br>
	
	Output: suppressed<br>
	
	
	
		Parameters:<br>

		
			
			&nbsp;&nbsp; <b>projectID:</b>
			string,
			required,
			projectID
			- The projectID for which to retrieve files.
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_getIssues">getIssues</a>

		
		</th></tr>
	<tr><td>
	
	
	
	<code>
	
		<i>public</i>
	
	
		<i>query</i>
	
	<b>getIssues</b>
	
	(
 	
		
		<i>

		required
		string
		</i>
		projectID
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Gets a specific comment.<br><br>
	
	Output: suppressed<br>
	
	
	
		Parameters:<br>

		
			
			&nbsp;&nbsp; <b>projectID:</b>
			string,
			required,
			projectID
			- The projectID for which to retrieve issues.
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_getMessage">getMessage</a>

		
		</th></tr>
	<tr><td>
	
	
	
	<code>
	
		<i>public</i>
	
	
		<i>query</i>
	
	<b>getMessage</b>
	
	(
 	
		
		<i>

		required
		string
		</i>
		projectID,
	
		
		<i>
		required
		string
		</i>
		messageID
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Gets the the details of one project.<br><br>

	
	Output: suppressed<br>
	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>projectID:</b>
			string,
			required,
			projectID
			- The projectID for which to get details.
			<br>
		
			
			&nbsp;&nbsp; <b>messageID:</b>

			string,
			required,
			messageID
			- The messageID for which to get details.
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_getMessageArchive">getMessageArchive</a>
		
		</th></tr>
	<tr><td>

	
	
	
	<code>
	
		<i>public</i>
	
	
		<i>query</i>
	
	<b>getMessageArchive</b>
	
	(
 	
		
		<i>
		required
		string
		</i>

		projectID
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Gets the list of all messages for a project.<br><br>
	
	Output: suppressed<br>
	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>projectID:</b>

			string,
			required,
			projectID
			- The projectID for which to get messages.
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_getMilestones">getMilestones</a>
		
		</th></tr>
	<tr><td>

	
	
	
	<code>
	
		<i>public</i>
	
	
		<i>query</i>
	
	<b>getMilestones</b>
	
	(
 	
		
		<i>
		required
		string
		</i>

		projectID
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Gets all of the milestones for a project.<br><br>
	
	Output: suppressed<br>
	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>projectID:</b>

			string,
			required,
			projectID
			- The projectID for which to get details.
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_getProject">getProject</a>
		
		</th></tr>
	<tr><td>

	
	
	
	<code>
	
		<i>public</i>
	
	
		<i>query</i>
	
	<b>getProject</b>
	
	(
 	
		
		<i>
		required
		string
		</i>

		projectID
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Gets the the details of one project.<br><br>
	
	Output: suppressed<br>
	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>projectID:</b>

			string,
			required,
			projectID
			- The projectID for which to get details.
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_getProjectList">getProjectList</a>
		
		</th></tr>
	<tr><td>

	
	
	
	<code>
	
		<i>public</i>
	
	
		<i>query</i>
	
	<b>getProjectList</b>
	
	(
 		
	)
	</i>
	</code>
	<br><br>	
	
	
	Get list of all projects in Project Tracker.<br><br>

	
	Output: suppressed<br>
	
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_getToDoLists">getToDoLists</a>
		
		</th></tr>
	<tr><td>

	
	
	
	<code>
	
		<i>public</i>
	
	
		<i>query</i>
	
	<b>getToDoLists</b>
	
	(
 	
		
		<i>
		required
		string
		</i>

		projectID
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Gets all of the todo lists for a project.<br><br>
	
	Output: suppressed<br>
	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>projectID:</b>

			string,
			required,
			projectID
			- The projectID for which to get details.
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_getToDos">getToDos</a>
		
		</th></tr>
	<tr><td>

	
	
	
	<code>
	
		<i>public</i>
	
	
		<i>query</i>
	
	<b>getToDos</b>
	
	(
 	
		
		<i>
		required
		string
		</i>

		projectID,
	
		
		<i>
		required
		string
		</i>
		todoListID
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Gets a todo list.<br><br>
	
	Output: suppressed<br>

	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>projectID:</b>
			string,
			required,
			projectID
			- The projectID for this todo list.
			<br>
		
			
			&nbsp;&nbsp; <b>todoListID:</b>
			string,
			required,
			todoListID
			- The todo list for which to get items.
			<br>

		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_init">init</a>
		
		</th></tr>
	<tr><td>
	
	
	
	<code>

	
		<i>public</i>
	
	
		<i>any</i>
	
	<b>init</b>
	
	(
 	
		
		<i>
		required
		string
		</i>
		apiUrl,
	
		
		<i>

		required
		string
		</i>
		apiKey,
	
		
		<i>
		
		boolean
		</i>
		debug="TRUE"
		
	)
	</i>
	</code>
	<br><br>	
	
	
	This is the pseudo constructor that allows us to play little object games.<br><br>

	
	Output: suppressed<br>
	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>apiUrl:</b>
			string,
			required,
			apiUrl
			- The API URL to use.
			<br>
		
			
			&nbsp;&nbsp; <b>apiKey:</b>

			string,
			required,
			apiKey
			- The Project Tracker API Key to use.
			<br>
		
			
			&nbsp;&nbsp; <b>debug:</b>
			boolean,
			optional,
			debug
			- Whether or not to output debugging information.
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">

		<a name="method_makeHTTPGetRequest">makeHTTPGetRequest</a>*
		
		</th></tr>
	<tr><td>
	
	
	
	<code>
	
		<i>private</i>
	
	
		<i><a href="/CFIDE/componentutils/cfcexplorer.cfc?method=getcfcinhtml&name=project.install.api_demo.cfc.XML">XML</a></i>
	
	<b>makeHTTPGetRequest</b>

	
	(
 	
		
		<i>
		required
		string
		</i>
		urlToRequest=""
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Encapsulates getting the requesting and parsing the Basecamp results into an XML variable.<br><br>
	
	Output: suppressed<br>

	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>urlToRequest:</b>
			string,
			required,
			urlToRequest
			- The url to request the data from. 
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">

		<a name="method_makeHTTPPostRequest">makeHTTPPostRequest</a>*
		
		</th></tr>
	<tr><td>
	
	
	
	<code>
	
		<i>private</i>
	
	
		<i><a href="/CFIDE/componentutils/cfcexplorer.cfc?method=getcfcinhtml&name=project.install.api_demo.cfc.XML">XML</a></i>
	
	<b>makeHTTPPostRequest</b>

	
	(
 	
		
		<i>
		required
		string
		</i>
		urlToRequest,
	
		
		<i>
		
		struct
		</i>
		request
		
	)
	</i>
	</code>

	<br><br>	
	
	
	Encapsulates getting the requesting and parsing the Basecamp results into an XML variable.<br><br>
	
	Output: suppressed<br>
	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>urlToRequest:</b>
			string,
			required,
			urlToRequest
			- The url to request the data from. 
			<br>

		
			
			&nbsp;&nbsp; <b>request:</b>
			struct,
			optional,
			request
			- A structured post to send to Basecamp API.  Usually for creating items.
			<br>
		
	
	
	<br>
	</td></tr>


	
	
	
	
	
	<tr><th align="left" colspan="1">
		<a name="method_returnAllSubKeys">returnAllSubKeys</a>*
		
		</th></tr>

	<tr><td>
	
	
	
	<code>
	
		<i>private</i>
	
	
		<i>array</i>
	
	<b>returnAllSubKeys</b>
	
	(
 	
		
		<i>
		required
		any
		</i>

		array,
	
		
		<i>
		
		string
		</i>
		collection=""
		
	)
	</i>
	</code>
	<br><br>	
	
	
	Takes an Array of structures, and returns a list of all keys. <br><br>
	
	Output: suppressed<br>

	
	
	
		Parameters:<br>
		
			
			&nbsp;&nbsp; <b>array:</b>
			any,
			required,
			array
			- The array of structures to parse.
			<br>
		
			
			&nbsp;&nbsp; <b>collection:</b>
			string,
			optional,
			collection
			- The collection type to parse.
			<br>

		
	
	
	<br>
	</td></tr>

	

</table>

<div class="page_footer">
	<p>Project Tracker is developed by <a href="http://www.ajaxcf.com/">Joe Danziger</a>.</p>
</div>
</body>
</html>

		

		
		
	