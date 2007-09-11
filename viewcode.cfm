<cfsetting enablecfoutputonly="true">

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

<cfif isDefined("url.dl") and project.recordCount>
	<cfset svnargs = "cat #project.svnurl##url.wd#/#url.f#">
	<cfif compare(project.svnuser,'')>
		<cfset svnargs = svnargs & ' --username #project.svnuser# --password #srssion.project.svnpass#'>
	</cfif>		
	<cfexecute name="#application.settings.svnexe#" arguments="#svnargs#" timeout="10" variable="result"></cfexecute>
	<cffile action="write" file="#expandpath('./')##url.f#" output="#result#">
	<cfheader name="content-disposition" value="attachment; filename=#url.f#">
	<cfcontent file="#expandpath('./')##url.f#" deletefile="yes" type="application/unknown">
	<cfabort>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.title# &raquo; #project.name#" project="#project.name#" projectid="#url.p#">

<cfhtmlhead text='<link rel="stylesheet" href="./css/svn.css" media="screen,projection" type="text/css" />'>

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left" style="width:100%">
		<div class="main">

			<div class="header">
				<span class="rightmenu"><a href="javascript:history.back();" class="back">Back to source browser</a></span>
				
				<h2 class="svn">Subversion source browsing</h2>
			</div>
			<div class="content">
			 	<div class="wrapper">
			
<!--- process subversion actions --->
<cfset svnargs = "log -v #project.svnurl##url.wd#/#url.f# --xml">
<cfif compare(project.svnuser,'')>
	<cfset svnargs = svnargs & ' --username #project.svnuser# --password #project.svnpass#'>
</cfif>
<cfexecute name="#application.settings.svnexe#" arguments="#svnargs#" timeout="10" variable="history"></cfexecute>	
<!--- parse to xml --->
<cfset data = xmlparse(history)>
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
      <cfset logEntry[xmlChild.xmlName] = xmlChild.xmlText>
   </cfloop>
   <cfset arrayAppend(logEntries, logEntry)>   
</cfloop>
	
<cfset svnargs = "cat #project.svnurl##url.wd#/#url.f#">
<cfif compare(project.svnuser,'')>
	<cfset svnargs = svnargs & ' --username #project.svnuser# --password #project.svnpass#'>
</cfif>
<cfexecute name="#application.settings.svnexe#" arguments="#svnargs#" timeout="10" variable="result"></cfexecute>

<pre name="code" class="html">
#HTMLCodeFormat(result)#
</pre>

<!---
<div style="margin-top:4px;margin-left:50px;" class="fr main"><a href="##" onclick="history.back();">&laquo; back to last page</a></div>

<h2>View Code</h2>
<div class="fs80 fr main">[<a href="##" onclick="Effect.toggle('rhist');">Show Resource History</a>]</div>
<div style="margin:4px 0 0 2px;" class="main g i fs85">#project.svnurl##url.wd#/#url.f#</div>

<div style="display:none;" id="rhist">
	<table class="mt10" style="width:100%;">
	<thead><tr><th>Rev</th><th>Message</th><th>Timestamp</th><th>Author</th></tr></thead>
	<tbody>
	<cfloop from="1" to="#arrayLen(logEntries)#" index="i">
		<tr class="tac <cfif i mod 2 eq 1>odd<cfelse>even</cfif>">
			<td<cfif i eq 1> class="b"</cfif>>#logEntries[i].revision#<cfif i eq 1> *</cfif><br /></td>
			<td>#logEntries[i].msg#</td>
			<cfset dt = DateConvertISO8601(logEntries[i].date,-getTimeZoneInfo().utcHourOffset)>
			<td>#DateFormat(dt,"ddd mmm d 'yy")# @ #TimeFormat(dt,"h:mmtt")#</td>
			<td>#logEntries[i].author#</td>
		</tr>
	</cfloop>
	</tbody>
	</table>
</div>

<!---<div style="background-color:##ffc;margin:10px 0;padding:10px;font-size:80%;">#replace(colored,chr(13),"<br />","all")#</div>--->

<div style="margin-bottom:4px;margin-left:50px;" class="fr main"><a href="##" onclick="history.back();">&laquo; back to last page</a></div>
<div style="margin-bottom:4px;font-size:85%;" class="fr main g i">#project.svnurl##url.wd#/#url.f#</div>
<div class="main"><a href="#cgi.script_name#?wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(url.f)#&dl"><img src="images/disk.png" height="16" width="16" border="0" alt="Download" /> Download File</a></div>
--->
			
			
			
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