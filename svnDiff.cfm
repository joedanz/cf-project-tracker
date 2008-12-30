<cfsetting enablecfoutputonly="true">

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfif not session.user.admin and project.svn eq 0>
	<cfoutput><h2>You do not have permission to access the repository!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfparam name="url.act" default="browse">
<cfparam name="url.p" default="">
<cfparam name="url.wd" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
<cfset Diffable="cfc,cfm,cfml,txt,plx,php,php4,php5,asp,aspx,xml,html,htm,sql,css,js">
<cfif StructKeyExists(url,"full")>
	<cfset FullDiff=true>
<cfelse>
	<cfset FullDiff=false>
</cfif>
<!--- Keep track of line counts, and provide a quick translation for operations to class names --->
<cfset OpClasses=StructNew()>
<cfset OpClasses["+"]="ins">
<cfset OpClasses["-"]="del">
<cfset OpClasses["!"]="upd">
<cfset OpClasses[""]="">
<cfset OpCounts=StructNew()>
<cfset OpCounts["+"]=0>
<cfset OpCounts["-"]=0>
<cfset OpCounts["!"]=0>
<cfset OpCounts[""]=0>
<cfset Edge="">

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; #project.name#" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left full">
		<div class="main">

			<div class="header">
				
				<span class="rightmenu">
					<a href="svnResource.cfm?p=#url.p#&wd=#URLEncodedFormat(url.wd)#&f=#URLEncodedFormat(url.f)#" class="back">View All Revisions</a>
				</span>
				
				<h2 class="svn">Subversion source browsing</h2>
			</div>
			<div class="content">
			 	<div class="wrapper">

					<cfif listFindNoCase(Diffable,right(url.f,3))>
						
						<cftry>
							<cfset svn = createObject("component", "cfcs.SVNBrowser").init(project.svnurl,project.svnuser,project.svnpass)>
							<cfset LeftQ=svn.FileVersion('#url.wd#/#url.f#',url.r1)>
							<cfset RightQ=svn.FileVersion('#url.wd#/#url.f#',url.r2)>
							
							<cfcatch>
								<div class="alert">There was a problem accessing the Subversion repository at #project.svnurl#</div>
								<div class="fs80 g" style="margin-left:20px;">If your repository requires authentication, please ensure that your username and password are correct.</div>
							</cfcatch>
						</cftry>				

						<cfif IsQuery(LeftQ) AND IsQuery(RightQ) AND (LeftQ.RecordCount EQ 1) AND (RightQ.RecordCount EQ 1)>
							<!--- We got two files, build a diff --->
							<cfset LeftFile=ListToArray(ToString(LeftQ.Content[1]),Chr(10))>
							<cfset RightFile=ListToArray(ToString(RightQ.Content[1]),Chr(10))>
							<cfif FullDiff>
								<cfset f=application.diff.Parallelize(application.diff.DiffArrays(LeftFile,RightFile),LeftFile,RightFile)>
							<cfelse>
								<cfset f=application.diff.UnifiedDiffArrays(application.diff.DiffArrays(LeftFile,RightFile),LeftFile,RightFile)>
							</cfif>
						<cfelse>
							<!--- Yeah, we should probably show an error message or something --->
							<cfset LeftFile="">
							<cfset RightFile="">
							<cfset f=QueryNew(replace(replace(application.diff.ResultColumnList,'$','','all'),'@','','all'))>
						</cfif>
						<cfset IsDiff=true>
					
						<p>You may also view the <cfif FullDiff><a href="#CGI.SCRIPT_NAME##CGI.PATH_INFO#?p=#url.p#&wd=#url.wd#&f=#url.f#&r1=#url.r1#&r2=#url.r2#">unified diff</a><cfelse><a href="#CGI.SCRIPT_NAME##CGI.PATH_INFO#?p=#url.p#&wd=#url.wd#&f=#url.f#&r1=#url.r1#&r2=#url.r2#&full=1">full diff</a></cfif>.</p>
						<table class="diff" cellspacing="0">
							<tr>
								<th class="linenum" style="border-right:none;border-bottom:none;">&nbsp;</th>
								<th nowrap="nowrap" style="border-left:none;">Revision #NumberFormat(url.r1)#</th>
								<th class="linenum" style="border-right:none;border-bottom:none;">&nbsp;</th>
								<th nowrap="nowrap" style="border-left:none;">Revision #NumberFormat(url.r2)#</th>
							</tr>
						<cfloop query="f">
							<cfset OpCounts[Operation]=OpCounts[Operation]+1>
							<tr class="#Edge#">
								<td class="linenum"><cfif IsNumeric(AtFirst)>#NumberFormat(AtFirst)#<cfelse>&nbsp;</cfif></td>
								<td class="code<cfif Operation NEQ '+'> #OpClasses[Operation]#</cfif>"><div><cfif Len(ValueFirst) GT 0>#Replace(HTMLEditFormat(ValueFirst),Chr(9),"&nbsp;&nbsp;&nbsp;","ALL")#<cfelse>&nbsp;</cfif></div></td>
								<td class="linenum"><cfif IsNumeric(AtSecond)>#NumberFormat(AtSecond)#<cfelse>&nbsp;</cfif></td>
								<td class="code<cfif Operation NEQ '-'> #OpClasses[Operation]#</cfif>"><div><cfif Len(ValueSecond) GT 0>#Replace(HTMLEditFormat(ValueSecond),Chr(9),"&nbsp;&nbsp;&nbsp;","ALL")#<cfelse>&nbsp;</cfif></div></td>
							</tr>
						</cfloop>
						</table><br />
						
						<h3>Diff Stats</h3>
						<table class="diff" style="width: auto;">
							<tr><td class="linenum">#NumberFormat(OpCounts[""])#</td><td>Unchanged</td></tr>
							<tr><td class="linenum">#NumberFormat(OpCounts["+"])#</td><td class="ins">Added</td></tr>
							<tr><td class="linenum">#NumberFormat(OpCounts["!"])#</td><td class="upd">Updated</td></tr>
							<tr><td class="linenum">#NumberFormat(OpCounts["-"])#</td><td class="del">Removed</td></tr>
						</table>
					<cfelse>
						<div class="alert">The file type of &quot;#right(url.f,3)#&quot; is not diffable.</div>
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