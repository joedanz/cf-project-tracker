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

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>

<cfif StructKeyExists(url,"dl") and project.recordCount>
	<cftry>
		<cfparam name="filetype" type="string" default="string">
		<cfif listFindNoCase('png,gif,jpg,doc,rtf,xls,ppt,mdb,pdf,exe',right(url.f,3))>
			<cfset filetype = 'binary'>
		</cfif>
		<cfset svn = createObject("component", "cfcs.SVNBrowser").init(project.svnurl,project.svnuser,project.svnpass)>
		<cfset fileQ = svn.FileVersion('#url.wd#/#url.f#',url.r,filetype)>	
		<cffile action="write" file="#expandpath('./')##url.f#" output="#fileQ.content#">
		<cfheader name="content-disposition" value="attachment; filename=#url.f#">
		<cfcontent file="#expandpath('./')##url.f#" deletefile="yes" type="application/unknown">
		<cfabort>
		<cfcatch>
			<div class="alert">There was a problem accessing the Subversion repository at #project.svnurl#</div>
			<div class="fs80 g" style="margin-left:20px;">If your repository requires authentication, please ensure that your username and password are correct.</div>
		</cfcatch>
	</cftry>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; #project.name#" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text='<link rel="stylesheet" href="./css/svn.css" media="screen,projection" type="text/css" />'>

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left" style="width:100%">
		<div class="main">

			<div class="header">
				<span class="rightmenu"><a href="javascript:history.back();" class="back">Back to Repository Browsing</a></span>
				
				<h2 class="svn">Subversion source browsing</h2>
			</div>
			<div class="content">
			 	<div class="wrapper">

				<cftry>
					<cfset svn = createObject("component", "cfcs.SVNBrowser").init(project.svnurl,project.svnuser,project.svnpass)>
					<cfset fileQ = svn.FileVersion('#url.wd#/#url.f#',url.r)>	
					<table class="svn">
					<caption>#project.svnurl##url.wd#</caption>
					<thead>
						<tr>
							<th>Name</th>
							<th>Size</th>
							<th>Timestamp</th>
							<th>Revision</th>
							<th>Author</th>
							<th>Download</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>#fileQ.name#</td>
							<td>#NumberFormat(fileQ.size)#</td>
							<!---<cfset dt = DateConvertISO8601(logEntries[i].date,-getTimeZoneInfo().utcHourOffset)>--->
							<td>#DateFormat(fileQ.date,"ddd mmm d 'yy")# @ #TimeFormat(fileQ.date,"h:mmtt")#</td>
							<td>#fileQ.revision#</td>
							<td>#fileQ.author#</td>
							<td><a href="#cgi.script_name#?p=#url.p#&wd=#url.wd#&f=#url.f#&r=#url.r#&dl=1">download file</a></td>
						</tr>
					</table>

					<pre name="code" class="html">
						#HTMLCodeFormat(fileQ.content)#
					</pre>
					<cfcatch>
						<div class="alert">There was a problem accessing the Subversion repository at #project.svnurl#</div>
						<div class="fs80 g" style="margin-left:20px;">If your repository requires authentication, please ensure that your username and password are correct.</div>
					</cfcatch>
				</cftry>			

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

<link type="text/css" rel="stylesheet" href="#application.settings.mapping#/includes/dp.SyntaxHighlighter/Styles/SyntaxHighlighter.css"></link>
<script language="javascript" src="#application.settings.mapping#/includes/dp.SyntaxHighlighter/Scripts/shCore.js"></script>
<script language="javascript" src="#application.settings.mapping#/includes/dp.SyntaxHighlighter/Scripts/shBrushCSharp.js"></script>
<script language="javascript" src="#application.settings.mapping#/includes/dp.SyntaxHighlighter/Scripts/shBrushXml.js"></script>
<script language="javascript">
dp.SyntaxHighlighter.ClipboardSwf = '#application.settings.mapping#/includes/dp.SyntaxHighlighter/Scripts/clipboard.swf';
dp.SyntaxHighlighter.HighlightAll('code');
</script>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">