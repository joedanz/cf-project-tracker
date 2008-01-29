<cfsetting enablecfoutputonly="true">

<cfset project = application.project.get(session.user.userid,url.p)>
<cfif project.svn eq 0 and not session.user.admin>
	<cfoutput><h2>You do not have permission to access the repository!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfparam name="url.act" default="browse">
<cfparam name="numRevisions" default="20">
<cfparam name="url.p" default="">
<cfparam name="url.wd" default="">
<cfset numDirs = 0>
<cfset numFiles = 0>
<cfset totalFileSize = 0>
<cfset project = application.project.get(session.user.userid,url.p)>

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
		<cfset svn = createObject("component", "cfcs.SVNBrowser").init(project.svnurl,project.svnuser,project.svnpass)>
		<cfset list = svn.list('/' & url.wd)>
	
		<table class="admin full">
		<caption>#project.name#: <a href="#cgi.script_name#?p=#url.p#">root</a>&nbsp;<a href="#cgi.script_name#?p=#url.p#&wd=#url.wd#">#url.wd#</a></caption>
		<thead><tr><th>Name</th><th>Size</th><th>Date Modified</th><th class="tac">Revision</th><th>Author</th></tr></thead>
	
		<tbody>
		<cfset thisrow = 0>
		<cfif compare(url.wd,'')>
			<cfset lastdirmarker = RFind('/',url.wd)>
			<cfif lastdirmarker lte 1><cfset pd = ""><cfelse><cfset pd = left(url.wd,lastdirmarker-1)></cfif>
			<tr class="odd">
				<td>
				<img src="images/folder.gif" height="16" width="16" border="0" alt="Directory" />
				<a href="#cgi.script_name#?p=#url.p#&act=browse&wd=#URLEncodedFormat(pd)#" class="nounder">..</a></td>
				<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
			</tr>
		<cfset thisrow = thisrow + 1>			
		</cfif>
		<cfloop query="list">
	
			<cfif not compareNoCase(kind,'Dir')>
			<tr class="<cfif thisRow mod 2 eq 0>odd<cfelse>even</cfif>">
				<td>
				<a href="#cgi.script_name#?p=#url.p#&act=browse&wd=#URLEncodedFormat(url.wd & '/' & name)#" class="nounder">
				<img src="images/folder.gif" height="16" width="16" border="0" alt="Directory" />
				#name#</a></td>
				<td>-----</td>
				<!---<cfset dt = DateConvertISO8601(list.date,-getTimeZoneInfo().utcHourOffset)>--->
				<td>#DateFormat(date,"mm-dd-yyyy")# @ #TimeFormat(date,"HH:mm:ss")#</td>
				<td class="tac">#NumberFormat(revision)#</td>
				<td>#author#</td>
			</tr>
			<cfset thisrow = thisrow + 1>
			<cfset numDirs = numDirs + 1>
			</cfif>
		</cfloop>
		<cfloop query="list">
			<cfif not compareNoCase(kind,'File')>
			
			<tr class="<cfif thisRow mod 2 eq 0>odd<cfelse>even</cfif>">
				<td>
				<cfif listFindNoCase('.cfm,.cfc',right(name,4))>
					<a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#" class="nounder"><img src="images/file_cf.gif" height="16" width="16" border="0" alt="ColdFusion File" />
				<cfelseif listFindNoCase('.htm,html',right(name,4))>
					<a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#" class="nounder"><img src="images/file_htm.gif" height="16" width="16" border="0" alt="HTML File" />
				<cfelseif not compareNoCase(right(name,3),'.js')>
					<a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#" class="nounder"><img src="images/file.gif" height="16" width="16" border="0" alt="Javascript File" />
				<cfelseif not compareNoCase(right(name,4),'.css')>
					<a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#" class="nounder"><img src="images/file.gif" height="16" width="16" border="0" alt="CSS File" />
				<cfelseif listFindNoCase('png,jpg,gif,exe,pdf,doc,rtf,xls,ppt',right(name,3))>
					<a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#&dl=1" class="nounder"><img src="images/file.gif" height="16" width="16" border="0" alt="File" />
				<cfelse>
					<a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(name)#&r=#revision#" class="nounder"><img src="images/file.gif" height="16" width="16" border="0" alt="File" />
				</cfif>
				#name#</a></td>
				<td>#NumberFormat(size)# bytes</td>
				<!---<cfset dt = DateConvertISO8601(date,-getTimeZoneInfo().utcHourOffset)>--->
				<td>#DateFormat(date,"mm-dd-yyyy")# @ #TimeFormat(date,"hh:mm:ss")#</td>
				<td class="tac">#NumberFormat(revision)#</td>
				<td>#author#</td>
			</tr>
			<cfset thisrow = thisrow + 1>
			<cfset numFiles = numFiles + 1>
			<cfset totalFileSize = totalFileSize + size>
			</cfif>
		
		</cfloop>	
		</tbody>
		<tfoot><tr><td colspan="5">#NumberFormat(totalFileSize)# bytes in <cfif numFiles gt 0>#numFiles# files</cfif><cfif numFiles gt 0 and numDirs gt 0> and </cfif><cfif numDirs gt 0> #numDirs# directories</cfif>.</tr></tfoot>
		</table>
	
		<cfcatch>
			<div class="alert">There was a problem accessing the Subversion repository at #project.svnurl#</div>
			<div class="fs80 g" style="margin-left:20px;">If your repository requires authentication, please ensure that your username and password are correct.</div>
		</cfcatch>
	</cftry>
	
<cfelseif not compareNoCase(url.act,'lastrevs')>
	<!--- show last N revisions --->
	<cftry>
		<cfset svn = createObject("component", "cfcs.SVNBrowser").init(project.svnurl,project.svnuser,project.svnpass)>
		<cfset log = svn.getLog(numEntries=numRevisions)>
		
		<table class="svn">
		<caption>#project.svnurl# - Last 20 Revisions</caption>
		<thead><tr><th>Rev</th><th>Message</th><th>Timestamp</th><th>Author</th><th>Changed</th></tr></thead>
		<tbody>
		<cfloop query="log">
			<tr class="<cfif currentRow mod 2 eq 1>odd<cfelse>even</cfif>"<!---<cfif StructKeyExists(url,"r") and url.r is revision> style="background-color:##ffc;"</cfif>--->>
				
				<td>#revision#</td>
				<td><div id="r#revision#view">&nbsp;#message#</div></td>
				<!---<cfset dt = DateConvertISO8601(logEntries[i].date,-getTimeZoneInfo().utcHourOffset)>--->
				<td>#DateFormat(date,"ddd mmm d 'yy")# @ #TimeFormat(date,"h:mmtt")#</td>
				<td>#author#</td>
				
				<td><a href="##" onclick="$('##files#currentRow#').toggle();return false;">#StructCount(path)# files</a></td>
			</tr>
			
			<tr class="files" style="display:none;" id="files#currentRow#"><td colspan="5" style="padding-left:50px;background-color:##ffc;">
			<cfset thisRow = 1>
			<cfloop collection="#path#" item="resource">
			<cfset filebreaker = RFind('/',resource)>
				#thisRow#: <cfif filebreaker gt 1 and find('.',resource)><a href="viewcode.cfm?p=#url.p#&wd=#URLEncodedFormat(left(resource,filebreaker-1))#&f=#right(resource,len(resource)-filebreaker)#">#resource#</a><cfelse>#resource#</cfif><br />
				<cfset thisRow = thisRow + 1>
			</cfloop>
			</td></tr>
		</cfloop>
		</tbody>
		</table>	

		<cfcatch>
			<div class="alert">There was a problem accessing the Subversion repository at #project.svnurl#</div>
			<div class="fs80 g" style="margin-left:20px;">If your repository requires authentication, please ensure that your username and password are correct.</div>
		</cfcatch>
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