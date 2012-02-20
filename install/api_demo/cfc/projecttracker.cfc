<!---
Copyright 2008 Joe Danziger
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
--->

<cfcomponent>

<cffunction access="public" name="init" output="FALSE" returntype="any" hint="This is the pseudo constructor that allows us to play little object games." >
	<cfargument name="apiUrl" type="string" required="yes" hint="The API URL to use." />
	<cfargument name="apiKey" type="string" required="yes" hint="The Project Tracker API Key to use." />
	<cfargument name="debug" type="boolean" default="TRUE" hint="Whether or not to output debugging information." />

	<cfset variables.apiUrl = arguments.apiUrl />
	<cfset variables.apiKey = arguments.apiKey />
	<cfset variables.debug = arguments.debug />
	
	<cfreturn This />
</cffunction>

<cffunction access="public" name="getCommentsByMessage" output="false" returntype="query" hint="Gets all comments for a given message." >
	<cfargument name="projectID" type="string" required="yes" hint="The projectID for which to retrieve messages" />
	<cfargument name="messageID" type="string" required="yes" hint="The messageID for which to retrieve messages" />

	<cfset var UrlToRequest = variables.apiUrl & "?key=#variables.apiKey#&comments=1&p=" & arguments.projectID & '&m=' & arguments.messageID />
	<cfset var XMLResults = makeHTTPGetRequest(UrlToRequest) />
	<cfset var QueryResults = convertXMLToQuery(projecttrackerXML=XMLResults, collection="comment", root="comments") />

	<cfreturn QueryResults />
</cffunction>

<cffunction access="public" name="getFileCategories" output="false" returntype="query" hint="Gets the list of all file categories for a project." >
	<cfargument name="projectID" type="string" required="yes" hint="The projectID for which to get categories." />

	<cfset var UrlToRequest = variables.apiUrl & "?key=#variables.apiKey#&filecats=1&p=" & arguments.projectID/>
	<cfset var XMLResults = makeHTTPGetRequest(UrlToRequest) />
	<cfset var QueryResults = convertXMLToQuery(projecttrackerXML=XMLResults, collection="file-category", root="file-categories") />

	<cfreturn QueryResults />
</cffunction>

<cffunction access="public" name="getFiles" output="false" returntype="query" hint="Gets a specific comment." >
	<cfargument name="projectID" type="string" required="yes" hint="The projectID for which to retrieve files." />

	<cfset var UrlToRequest = variables.apiUrl & "?key=#variables.apiKey#&files=1&p=" & arguments.projectID  />
	<cfset var XMLResults = makeHTTPGetRequest(UrlToRequest) />
	<cfset var QueryResults = convertXMLToQuery(projecttrackerXML=XMLResults, collection="file", root="files") />
	
	<cfreturn QueryResults />
</cffunction>

<cffunction access="public" name="getIssues" output="false" returntype="query" hint="Gets a specific comment." >
	<cfargument name="projectID" type="string" required="yes" hint="The projectID for which to retrieve issues." />

	<cfset var UrlToRequest = variables.apiUrl & "?key=#variables.apiKey#&issues=1&p=" & arguments.projectID  />
	<cfset var XMLResults = makeHTTPGetRequest(UrlToRequest) />
	<cfset var QueryResults = convertXMLToQuery(projecttrackerXML=XMLResults, collection="issue", root="issues") />
	
	<cfreturn QueryResults />
</cffunction>

<cffunction access="public" name="getMessage" output="false" returntype="query" hint="Gets the the details of one project." >
	<cfargument name="projectID" type="string" required="yes" hint="The projectID for which to get details." />
	<cfargument name="messageID" type="string" required="yes" hint="The messageID for which to get details." />

	<cfset var messageQuery = getMessages(arguments.projectID) />

	<cfquery dbtype="query" name="messageQuery">
		SELECT 	*
		FROM 	messageQuery
		WHERE	id='#arguments.messageID#'
	</cfquery>

	<cfreturn messageQuery />
</cffunction>

<cffunction access="public" name="getMessageCategories" output="false" returntype="query" hint="Gets the list of all message categories for a project." >
	<cfargument name="projectID" type="string" required="yes" hint="The projectID for which to get categories." />

	<cfset var UrlToRequest = variables.apiUrl & "?key=#variables.apiKey#&messagecats=1&p=" & arguments.projectID/>
	<cfset var XMLResults = makeHTTPGetRequest(UrlToRequest) />
	<cfset var QueryResults = convertXMLToQuery(projecttrackerXML=XMLResults, collection="post-category", root="post-categories") />

	<cfreturn QueryResults />
</cffunction>

<cffunction access="public" name="getMessages" output="false" returntype="query" hint="Gets the list of all messages for a project." >
	<cfargument name="projectID" type="string" required="yes" hint="The projectID for which to get messages." />

	<cfset var UrlToRequest = variables.apiUrl & "?key=#variables.apiKey#&messages=1&p=" & arguments.projectID/>
	<cfset var XMLResults = makeHTTPGetRequest(UrlToRequest) />
	<cfset var QueryResults = convertXMLToQuery(projecttrackerXML=XMLResults, collection="post", root="posts") />

	<cfreturn QueryResults />
</cffunction>

<cffunction access="public" name="getMilestones" output="false" returntype="query" hint="Gets all of the milestones for a project." >
	<cfargument name="projectID" type="string" required="yes" hint="The projectID for which to get details." />

	<cfset var UrlToRequest = variables.apiUrl & "?key=#variables.apiKey#&mstones=1&p="& arguments.projectID  />
	<cfset var XMLResults = makeHTTPGetRequest(UrlToRequest) />
	<cfset var QueryResults = convertXMLToQuery(projecttrackerXML=XMLResults, collection="milestone", root="milestones") />

	<cfreturn QueryResults />
</cffunction>

<cffunction access="public" name="getProject" output="false" returntype="query" hint="Gets the the details of one project." >
	<cfargument name="projectID" type="string" required="yes" hint="The projectID for which to get details." />

	<cfset var projectQuery = getProjectList() />

	<cfquery dbtype="query" name="projectQuery">
		SELECT 	*
		FROM 	projectQuery
		WHERE	id='#arguments.projectID#'
	</cfquery>

	<cfreturn projectQuery />
</cffunction>

<cffunction access="public" name="getProjectList" output="false" returntype="query" hint="Get list of all projects in Project Tracker." >

	<cfset var UrlToRequest = variables.apiUrl & "?key=#variables.apiKey#&projects"  />
	<cfset var XMLResults = makeHTTPGetRequest(UrlToRequest) />
	<cfset var QueryResults = convertXMLToQuery(projecttrackerXML=XMLResults, collection="project", root="projects") />

	<cfreturn QueryResults />
</cffunction>

<cffunction access="public" name="getToDos" output="false" returntype="query" hint="Gets a todo list." >
	<cfargument name="projectID" type="string" required="yes" hint="The projectID for this todo list." />
	<cfargument name="todoListID" type="string" required="yes" hint="The todo list for which to get items." />

	<cfset var UrlToRequest = variables.apiUrl & "?key=#variables.apiKey#&todos=1&p="& arguments.projectID &"&t="& arguments.todoListID />
	<cfset var XMLResults = makeHTTPGetRequest(UrlToRequest) />
	<cfset var QueryResults = convertXMLToQuery(projecttrackerXML=XMLResults, collection="todo", root="todos") />

	<cfreturn QueryResults />
</cffunction>

<cffunction access="public" name="getToDoLists" output="false" returntype="query" hint="Gets all of the todo lists for a project." >
	<cfargument name="projectID" type="string" required="yes" hint="The projectID for which to get details." />

	<cfset var UrlToRequest = variables.apiUrl & "?key=#variables.apiKey#&todolists=1&p="& arguments.projectID  />
	<cfset var XMLResults = makeHTTPGetRequest(UrlToRequest) />
	<cfset var QueryResults = convertXMLToQuery(projecttrackerXML=XMLResults, collection="todo-list", root="todo-lists") />

	<cfreturn QueryResults />
</cffunction>

<cffunction access="private" name="convertJSDateTime" output="false" returntype="date" hint="Converts BaseCamp time to a ColdFusion date time variable. " >
	<cfargument name="jsTime" type="string" required="yes" default="" hint="The basecamp formatted date time." />

	<cfset var date = "" />
	<cfset var time = ""/>
	<cfset var ZuluTime = "" />
	<cfset var outputDateTime = "">

	<cftry>
	<cfset date = GetToken(jsTime,1,"T") />
	<cfset time = Replace(GetToken(jsTime,2,"T"), "Z", "", "ALL") />
	<cfset ZuluTime = ParseDateTime(date & " " & time) />
	<cfset outputDateTime = DateConvert("utc2Local",ZuluTime)>

	<cfcatch type="any">
		<cfdump var="#arguments#">
		<cfdump var="#cfcatch#">
		<cfabort>
	</cfcatch>

	</cftry>

	<cfreturn outputDateTime />
</cffunction>

<cffunction access="private" name="convertXMLToQuery" output="false" returntype="query" hint="Converts the results from Basecamp into an ColdFusion query variable." >
	<cfargument name="projecttrackerXML" type="XML" required="yes" hint="The Project Tracker XML content." />
	<cfargument name="collection" type="string" required="yes" hint="The name of the collection to loop over. If the xml structure is 'projecttrackerXML.comments.comment',we are looking for 'comment'." />
	<cfargument name="root" type="string" default ="" hint="The root of the XML file, needed if collection is not the root." />getMessageComments

	<cfset var keyArray= arrayNew(1) />
	<cfset var QueryResults = QueryNew('') />
	<cfset var i= 0 />
	<cfset var j= 0 />
	<cfset var r= arguments.root />
	<cfset var c= arguments.collection>

	<cfset debugProjectTrackerData(arguments.projecttrackerXML) />

	<cfif len(r) gt 0>
		<cfif StructKeyExists(arguments.projecttrackerXML, r) and StructKeyExists(arguments.projecttrackerXML[r], c)>
			<cfset keyArray= returnAllSubKeys(arguments.projecttrackerXML[r][c], c) />
			<cfset QueryResults = QueryNew(Replace(ArrayToList(keyArray), "-", "_", "ALL")) />

			<cfloop index="j" from="1" to="#ArrayLen(arguments.projecttrackerXML[r][c])#">
				<cfset QueryAddRow(QueryResults) />
				<cfloop index="i" from="1" to="#ArrayLen(keyArray)#">
					<!--- Make sure the item exists. --->
					<cfif structKeyExists(arguments.projecttrackerXML[r][c][j], keyArray[i])>
						<!--- If it is marked as a datatime, convert it.  --->
						<cfif structKeyExists(arguments.projecttrackerXML[r][c][j][keyArray[i]], "XMLAttributes") AND
								structKeyExists(arguments.projecttrackerXML[r][c][j][keyArray[i]].XMLAttributes, "type") AND
									Len(arguments.projecttrackerXML[r][c][j][keyArray[i]].XMLText) gt 0 AND
									CompareNoCAse(arguments.projecttrackerXML[r][c][j][keyArray[i]].XMLAttributes.type,"datetime") eq 0>
							<cfset QuerySetCell(QueryResults, Replace(keyArray[i], "-", "_", "ALL"), convertBaseCampDateTime(arguments.projecttrackerXML[r][c][j][keyArray[i]].XMlText)) />
						<cfelse>
							<cfset QuerySetCell(QueryResults, Replace(keyArray[i], "-", "_", "ALL"), arguments.projecttrackerXML[r][c][j][keyArray[i]].XMlText) />
						</cfif>

					</cfif>
				</cfloop>
			</cfloop>
		</cfif>
	<cfelse>
		<cfif StructKeyExists(arguments.projecttrackerXML, c)>

			<cfset keyArray= returnAllSubKeys(arguments.projecttrackerXML[c], c) />
			<cfset QueryResults = QueryNew(Replace(ArrayToList(keyArray), "-", "_", "ALL")) />

			<cfset QueryAddRow(QueryResults) />
			<cfloop index="i" from="1" to="#ArrayLen(keyArray)#">
				<!--- Make sure the item exists. --->
				<cfif structKeyExists(arguments.projecttrackerXML[c], keyArray[i])>
					<!--- If it is marked as a datatime, convert it.  --->
					<cfif structKeyExists(arguments.projecttrackerXML[c][keyArray[i]], "XMLAttributes") AND
							structKeyExists(arguments.projecttrackerXML[c][keyArray[i]].XMLAttributes, "type") AND
								Len(arguments.projecttrackerXML[c][keyArray[i]].XMLText) gt 0 AND
								CompareNoCAse(arguments.projecttrackerXML[c][keyArray[i]].XMLAttributes.type,"datetime") eq 0>
						<cfset QuerySetCell(QueryResults, Replace(keyArray[i], "-", "_", "ALL"), convertJSDateTime(arguments.projecttrackerXML[c][keyArray[i]].XMlText)) />
					<cfelse>
						<cfset QuerySetCell(QueryResults, Replace(keyArray[i], "-", "_", "ALL"), arguments.projecttrackerXML[c][keyArray[i]].XMlText) />
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>

	<cfreturn QueryResults />
</cffunction>

<cffunction access="private" name="convertPostRequestToXML" output="false" returntype="string" hint="Takes a post request structure and converts it to the XML form that Basecamp needs." >
	<cfargument name="request" type="struct" required="yes" default="" hint="The request structure to transform. " />

	<cfset var i = 0 />
	<cfset var attribute = "" />
	<cfset var postVar = "" />
	<cfset var XMLNode = "" />

	<cfset postVar = postVar.concat("<request>") & chr(10) />
	<cfset postVar = postVar.concat("	<#arguments.request.type#>") & chr(10) />

	<cfloop collection="#arguments.request.item#" item="attribute">
		<cfif isSimpleValue(arguments.request.item[attribute])>
			<cfset XMLNode = Lcase(Replace(attribute, "_", "-", "ALL")) />
			<cfset postVar = postVar.concat("		<#XMLNode#>#arguments.request.item[attribute]#</#XMLNode#>") & chr(10) />
		</cfif>
	</cfloop>

	<cfset postVar = postVar.concat("	</#arguments.request.type#>") & chr(10) />

	<cfloop collection="#arguments.request#" item="attribute">
		<cfif CompareNoCase("item", attribute) neq 0 and CompareNoCase("type", attribute) neq 0>
			<cfset XMLNode = Lcase(Replace(attribute, "_", "-", "ALL")) />
			<cfif isSimpleValue(arguments.request[attribute])>
				<cfset postVar = postVar.concat("		<#XMLNode#>#arguments.request[attribute]#</#XMLNode#>") & chr(10) />
			<cfelseif isArray(arguments.request[attribute])>
				<cfloop index="i" from="1" to="#ArrayLen(arguments.request[attribute])#">
					<cfset postVar = postVar.concat("	<#XMLNode#>#arguments.request[attribute][i]#</#XMLNode#>") & chr(10) />
				</cfloop>
			</cfif>
		</cfif>

	</cfloop>

	<cfset postVar = postVar.concat("</request>") & chr(10) />

	<cfreturn postVar />
</cffunction>

<cffunction access="private" name="makeHTTPGetRequest" output="false" returntype="XML" hint="Encapsulates getting the requesting and parsing the Basecamp results into an XML variable." >
	<cfargument name="urlToRequest" type="string" required="yes" default="" hint="The url to request the data from. " />

	<cfset var XMLResults = "" />
	<cfset var myresult = structNew() />

	<cfhttp url="#arguments.urlToRequest#"
		method="get" result="myresult">
		<cfhttpparam type="header" name="Accept" value="application/xml" />
		<cfhttpparam type="header" name="Content-Type" value="application/xml" />
	</cfhttp>

	<cfif not FindNoCase("200", myresult.statusCode)>
		<cfif FindNoCase("404", myresult.statusCode)>
			<cfthrow type="projecttrackercfc" message="Targeted item or items do not exist." detail="#myresult.statuscode#" />
		<cfelse>
			<cfthrow type="projecttrackercfc" message="Error in Underlying Web Call" detail="#myresult.statuscode#" />
		</cfif>
	</cfif>

	<cfset XMLResults = XMLParse(myresult.fileContent) />

	<cfreturn XMLResults />
</cffunction>

<cffunction access="private" name="makeHTTPPostRequest" output="false" returntype="XML" hint="Encapsulates getting the requesting and parsing the Basecamp results into an XML variable." >
	<cfargument name="urlToRequest" type="string" required="yes" hint="The url to request the data from. " />
	<cfargument name="request" type="struct" required="no" hint="A structured post to send to Basecamp API.  Usually for creating items." />

	<cfset var XMLResults = "" />
	<cfset var myresult = structNew() />
	<cfset var postvar = "" />

	<cfif structKeyExists(arguments, "request")>
			<cfset postVar = convertPostRequestToXML(arguments.request) />
	</cfif>


	<cfhttp result="myresult" method="post" url="#urlToRequest#">
	    <cfhttpparam type="header" name="Accept" value="application/xml" />
	    <cfhttpparam type="header" name="Content-Type" value="application/xml" />
	    <cfif structKeyExists(arguments, "request")>
		    <cfhttpparam type="body" name="post" encoded="no" value="#PostVar#" />
		</cfif>
	</cfhttp>

	<cfif not FindNoCase("200", myresult.statusCode)>
		<cfthrow type="projecttrackercfc" message="Error in Underlying Web Call" detail="#myresult.statuscode#" />
	</cfif>

	<cfset XMLResults = XMLParse(myresult.fileContent) />

	<cfreturn XMLResults />
</cffunction>

<cffunction access="private" name="returnAllSubKeys" output="false" returntype="array" hint="Takes an Array of structures, and returns a list of all keys. " >
	<cfargument name="array" type="any" required="yes" hint="The array of structures to parse." />
	<cfargument name="collection" type="string" default="" hint="The collection type to parse." />

	<cfset var i=0 />
	<cfset var j=0 />
	<cfset var keyHolder = structNew() />
	<cfset var keyArray = ArrayNEw(1) />
	<cfset var returnArray  =ArrayNew(1) />

	<cfloop index="i" from="1" to="#ArrayLen(arguments.array)#">
		<cfset keyArray = StructKeyArray(arguments.array[i]) />

		<cfloop index="j" from="1" to="#ArrayLen(keyArray)#">
			<cfset keyHolder[keyArray[j]]="" />
		</cfloop>

	</cfloop>

	<cfset returnArray  = StructKeyArray(keyholder) />

	<cfreturn returnArray />
</cffunction>

<cffunction access="private" name="debugProjectTrackerData" output="false" returntype="void" hint="Handles processing Project Tracker API XML for Debugging." >
	<cfargument name="projecttrackerXML" type="string" required="yes" default="" hint="The Project Tracker XML to display." />

	<cfset var dumpResults = "" />

	<cfif variables.debug>
		<cfsavecontent variable="dumpResults">
			<cfdump var="#arguments.projecttrackerXML#">
		</cfsavecontent>

		<cftrace var="#dumpResults#" category="Project Tracker Debugging" >
	</cfif>

</cffunction>

</cfcomponent>