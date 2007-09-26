<cfsetting enablecfoutputonly="true">

<cfset svnTimeout = 60>

<cfscript>
/**
 * Convert a date in ISO 8601 format to an ODBC datetime.
 * 
 * @param ISO8601dateString 	 The ISO8601 date string. (Required)
 * @param targetZoneOffset 	 The timezone offset. (Required)
 * @return Returns a datetime. 
 * @author David Satz (david_satz@hyperion.com) 
 * @version 1, September 28, 2004 
 */
function DateConvertISO8601(ISO8601dateString, targetZoneOffset) {
	var rawDatetime = left(ISO8601dateString,10) & " " & mid(ISO8601dateString,12,8);
	
	// adjust offset based on offset given in date string
	if (uCase(mid(ISO8601dateString,20,1)) neq "Z")
		targetZoneOffset = targetZoneOffset -  val(mid(ISO8601dateString,20,3)) ;
	
	return DateAdd("h", targetZoneOffset, CreateODBCDateTime(rawDatetime));

}

/**
 * Returns the last index of an occurrence of a substring in a string from a specified starting position.
 * Big update by Shawn Seley (shawnse@aol.com) -
 * UDF was not accepting third arg for start pos 
 * and was returning results off by one.
 * Modified by RCamden, added var, fixed bug where if no match it return len of str
 * 
 * @param Substr 	 Substring to look for. 
 * @param String 	 String to search. 
 * @param SPos 	 Starting position. 
 * @return Returns the last position where a match is found, or 0 if no match is found. 
 * @author Charles Naumer (cmn@v-works.com) 
 * @version 2, February 14, 2002 
 */
function RFind(substr,str) {
  var rsubstr  = reverse(substr);
  var rstr     = "";
  var i        = len(str);
  var rcnt     = 0;

  if(arrayLen(arguments) gt 2 and arguments[3] gt 0 and arguments[3] lte len(str)) i = len(str) - arguments[3] + 1;

  rstr = reverse(Right(str, i));
  rcnt = find(rsubstr, rstr);

  if(not rcnt) return 0;
  return len(str)-rcnt-len(substr)+2;
}
</cfscript>

<cfparam name="url.act" default="browse">
<cfparam name="numrevisions" default="20">
<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; #project.name#" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

			<div class="header">
				
<span class="rightmenu"><cfif not compare(url.act,'browse')><span class="b g">Browse Repository</span><cfelse><a href="#cgi.script_name#?p=#url.p#&act=browse">Browse Repository</a></cfif>
| <cfif not compare(url.act,'lastrevs')><span class="b g">Last #numrevisions# Revisions</span><cfelse><a href="#cgi.script_name#?p=#url.p#&act=lastrevs">Last #numrevisions# Revisions</a></cfif></span>
				
				
				<h2 class="svn">Subversion source browsing</h2>
			</div>
			<div class="content">
			 	<div class="wrapper">
				 	
<cfif not compareNoCase(url.act,'browse')>
	<!--- browse repository --->
	<cftry>
	<!--- process subversion action --->
	<cfparam name="url.wd" default="">
	<cfset svnargs = "list #project.svnurl#/#url.wd# --xml">
	<cfif compare(project.svnuser,'')>
		<cfset svnargs = svnargs & ' --username #project.svnuser# --password #project.svnpass#'>
	</cfif>
	<cfexecute name="#application.settings.svnBinary#" arguments="#svnargs#" timeout="#svnTimeout#" variable="result"></cfexecute>
	<!--- parse to xml --->
	<cfset data = xmlparse(result)>
	<!--- get entries --->
	<cfset entries = xmlSearch(data, "//entry")>
	<cfset dirEntries = arrayNew(1)>
	<cfloop index="x" from="1" to="#arrayLen(entries)#">
		<cfset entry = entries[x]>
		<cfset dirEntry = structNew()>
		<cfset dirEntry.type = entry.xmlAttributes.kind>
		<cfset dirEntry.name = entry.name.xmlText>
		<cfif not compareNoCase(dirEntry.type,'File')><cfset dirEntry.size = entry.size.xmlText></cfif>
		<cfset dirEntry.commitRevision = entry.commit.xmlAttributes.revision>
		<cfset dirEntry.commitAuthor = entry.commit.author.xmlText>
		<cfset dirEntry.commitDate = entry.commit.date.xmlText>
		<cfset arrayAppend(dirEntries,dirEntry)>
	</cfloop>
	
	<!--- display subversion output --->
	<cfoutput>
	<table class="svn">
	<caption>#project.svnurl##url.wd#</caption>
	<thead><tr><th>Name</th><th>Size</th><th>Date Modified</th><th>Commit Revision</th><th>Author</th></tr></thead>
	<tbody>
	<cfset thisrow = 0>
	<cfif compare(url.wd,'')>
		<cfset lastdirmarker = RFind('/',url.wd)>
		<cfif lastdirmarker lte 1><cfset pd = ""><cfelse><cfset pd = left(url.wd,lastdirmarker-1)></cfif>
		<tr class="even">
			<td>
			<img src="images/folder.gif" height="16" width="16" border="0" alt="Directory" />
			<a href="#cgi.script_name#?p=#url.p#&act=browse&wd=#URLEncodedFormat(pd)#">..</a></td>
			<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
		</tr>
	<cfset thisrow = thisrow + 1>			
	</cfif>
	<cfloop from="1" to="#arrayLen(dirEntries)#" index="i">
		<cfif not compareNoCase(dirEntries[i].type,'Dir')>
		<tr class="<cfif thisRow mod 2 eq 1>odd<cfelse>even</cfif>">
			<td>
			<a href="#cgi.script_name#?p=#url.p#&browse&wd=#URLEncodedFormat(url.wd & '/' & dirEntries[i].name)#">
			<img src="images/folder.gif" height="16" width="16" border="0" alt="Directory" />
			#dirEntries[i].name#</a></td>
			<td>-----</td>
			<cfset dt = DateConvertISO8601(dirEntries[i].commitDate,-getTimeZoneInfo().utcHourOffset)>
			<td>#DateFormat(dt,"ddd mmm d 'yy")# @ #TimeFormat(dt,"h:mmtt")#</td>
			<td>#dirEntries[i].commitRevision#</td>
			<td>#dirEntries[i].commitAuthor#</td>
		</tr>
		<cfset thisrow = thisrow + 1>
		</cfif>
	</cfloop>
	<cfloop from="1" to="#arrayLen(dirEntries)#" index="i">
		<cfif not compareNoCase(dirEntries[i].type,'File')>
		<tr class="<cfif thisRow mod 2 eq 1>odd<cfelse>even</cfif>">
			<td>
			<cfif listFindNoCase('.cfm,.cfc',right(dirEntries[i].name,4))>
				<a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(dirEntries[i].name)#"><img src="images/file_cf.gif" height="16" width="16" border="0" alt="ColdFusion File" />
			<cfelseif listFindNoCase('.htm,html',right(dirEntries[i].name,4))>
				<a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(dirEntries[i].name)#"><img src="images/file_htm.gif" height="16" width="16" border="0" alt="HTML File" />
			<cfelseif not compareNoCase(right(dirEntries[i].name,3),'.js')>
				<a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(dirEntries[i].name)#"><img src="images/file.gif" height="16" width="16" border="0" alt="Javascript File" />
			<cfelseif not compareNoCase(right(dirEntries[i].name,4),'.css')>
				<a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(dirEntries[i].name)#"><img src="images/file.gif" height="16" width="16" border="0" alt="CSS File" />
			<cfelse>
				<a href="#cgi.script_name#?p=#url.p#&br=&f=#URLEncodedFormat(dirEntries[i].name)#"><img src="images/file.gif" height="16" width="16" border="0" alt="File" />
			</cfif>
			#dirEntries[i].name#</a></td>
			<td>#dirEntries[i].size#</td>
			<cfset dt = DateConvertISO8601(dirEntries[i].commitDate,-getTimeZoneInfo().utcHourOffset)>
			<td>#DateFormat(dt,"ddd mmm d 'yy")# @ #TimeFormat(dt,"h:mmtt")#</td>
			<td>#dirEntries[i].commitRevision#</td>
			<td>#dirEntries[i].commitAuthor#</td>
		</tr>
		<cfset thisrow = thisrow + 1>
		</cfif>
	</cfloop>	
	</tbody>
	</table>
	</cfoutput>
	<cfcatch><cfoutput><div class="alert">There was a problem accessing the Subversion repository at #project.svnurl#</div><div class="fs80 g" style="margin-left:20px;">If your repository requires authentication, please ensure that your username and password are correct.</div></cfoutput></cfcatch>
	</cftry>
<cfelseif not compareNoCase(url.act,'lastrevs')>
	<!--- show last N revisions --->
	<cftry>
	<!--- process subversion action --->
	<cfset svnargs = "log -v #project.svnurl# --xml">
	<cfif not compareNoCase(url.act,'lastrevs')>
		<cfset svnargs = svnargs & ' --limit #numrevisions#'>
	</cfif>
	<cfif compare(project.svnuser,'')>
		<cfset svnargs = svnargs & ' --username #project.svnuser# --password #project.svnpass#'>
	</cfif>	
	<cfexecute name="#application.settings.svnBinary#" arguments="#svnargs#" timeout="#svnTimeout#" variable="result"></cfexecute>
	<!--- parse to xml --->
	<cfset data = xmlparse(result)>
	<!--- get entries --->
	<cfset entries = xmlSearch(data, "//logentry")>
	<cfset logEntries = arrayNew(1)>
	<cfloop index="x" from="1" to="#arrayLen(entries)#">
	   <cfset entry = entries[x]>
	   <cfset logEntry = structNew()>
	   <cfset logEntry.revision = entry.xmlAttributes.revision>
	   <cfset logEntry.files = arrayNew(1)>
	   <cfloop index="y" from="1" to="#arrayLen(entry.xmlChildren)#">
	      <cfset xmlChild = entry.xmlChildren[y]>
	      <cfswitch expression="#xmlChild.xmlName#">
	         <cfcase value="author,msg,date">
	            <cfset logEntry[xmlChild.xmlName] = xmlChild.xmlText>
	         </cfcase>
	         <cfcase value="paths">
	            <cfloop index="z" from="1" to="#arrayLen(xmlChild.xmlChildren)#">
	               <cfset thisFile = xmlChild.xmlChildren[z].xmlText>
	               <cfset arrayAppend(logEntry.files, thisFile)>
	            </cfloop>
	         </cfcase>
	      </cfswitch>
	   </cfloop>
	   <cfset arrayAppend(logEntries, logEntry)>   
	</cfloop>

	<!--- display subversion output --->
	<cfoutput>
	<table class="svn">
	<caption>#project.svnurl# - Last 20 Revisions</caption>
	<thead><tr><th>Rev</th><th>Message</th><th>Timestamp</th><th>Author</th><th>Files</th></tr></thead>
	<tbody>
	<cfloop from="1" to="#arrayLen(logEntries)#" index="i">
		<tr class="<cfif i mod 2 eq 1>odd<cfelse>even</cfif>"<cfif isDefined("url.r") and url.r eq logEntries[i].revision> style="background-color:##ffc;"</cfif>>
			<td>#logEntries[i].revision#<br /></td>
			<td><div id="r#logEntries[i].revision#view">&nbsp;#logEntries[i].msg#</div></td>
			<cfset dt = DateConvertISO8601(logEntries[i].date,-getTimeZoneInfo().utcHourOffset)>
			<td>#DateFormat(dt,"ddd mmm d 'yy")# @ #TimeFormat(dt,"h:mmtt")#</td>
			<td>#logEntries[i].author#</td>
			<td><a href="##" onclick="$('##files#i#').toggle();">#arrayLen(logEntries[i].files)#</a></td>
		</tr>
		<tr class="files" style="display:none;" id="files#i#"><td colspan="5" style="padding-left:50px;background-color:##ffc;">
			<cfloop from="1" to="#arrayLen(logEntries[i].files)#" index="j">
			<cfset filebreaker = RFind('/',logEntries[i].files[j])>
			#j#: <cfif filebreaker gt 1 and find('.',logEntries[i].files[j])><a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(left(logEntries[i].files[j],filebreaker-1))#&f=#right(logEntries[i].files[j],len(logEntries[i].files[j])-filebreaker)#">#logEntries[i].files[j]#</a><cfelse>#logEntries[i].files[j]#</cfif><br />
			</cfloop>
		</td></tr>
	</cfloop>
	</tbody>
	</table>
	</cfoutput>
	<cfcatch><cfoutput><div class="alert">There was a problem accessing the Subversion repository at #project.svnurl#</div></cfoutput></cfcatch>
	</cftry>	
</cfif>				 	
				 	
			 	</div>
			</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">

	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">