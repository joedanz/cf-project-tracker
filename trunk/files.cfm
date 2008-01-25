<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(url,"df")>
	<cfset thisFile = application.file.get(url.p,url.df)>
	<cftry>
	<cffile action="delete" file="#ExpandPath('./userfiles/')##url.p#/#thisFile.serverfilename#">
	<cfcatch></cfcatch>
	</cftry>
	<cfset application.file.delete(url.p,url.df,session.user.userID)>
	<cfset remainingFiles = application.file.get(url.p)>
	<cfif remainingFiles.recordCount eq 1>
		<cfdirectory action="delete" directory="#ExpandPath('./userfiles/')##url.p#">
	</cfif>
</cfif>

<cfparam name="url.p" default="">
<cfparam name="url.c" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
<cfset files = application.file.get(url.p,'',url.c)>
<cfset categories = application.file.categories(url.p)>

<cfif project.files eq 0 and not session.user.admin>
	<cfoutput><h2>You do not have permission to access files!!!</h2></cfoutput>
	<cfabort>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Files" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<cfif project.files gt 1>
					<span class="rightmenu">
						<a href="editFile.cfm?p=#url.p#" class="add">Upload a file</a>
					</span>
					</cfif>
										
					<h2 class="files">
					<cfif compare(url.c,'')>
						Files in category: #url.c#
					<cfelse>
						All files
					</cfif>					
					</h2>
				</div>
				<div class="content">
						
					<cfif files.recordCount>						
						<cfloop query="files">
						<span class="stamp">
						#DateFormat(uploaded,"dddd, d mmmm")#
						</span>
						
						<div class="wrapper itemlist">
						<img src="./images/filetypes/<cfswitch expression="#filetype#"><cfcase value="DOC,PDF,XLS">#filetype#</cfcase><cfdefaultcase>file</cfdefaultcase></cfswitch>.gif" height="48" width="48" border="0" alt="#filetype#" style="float:left;margin-right:10px;" />
						<h3 class="padtop">#title#</h3>	
						<p>#description#</p>
						<div class="byline<cfif currentRow neq recordCount> listitem</cfif>">
						<cfif Int(filesize/1024000) gte 1>
						#NumberFormat(filesize/1024000,"0.00")#MB,
						<cfelse>
						#Int(filesize/1024)#K,
						</cfif>
						uploaded to <a href="#cgi.script_name#?p=#url.p#&c=#urlEncodedFormat(category)#">#category#</a> by #firstName# #lastName# | <a href="download.cfm?p=#url.p#&f=#fileID#" class="download">Download file</a>
						<cfif session.user.userID eq uploadedBy or session.user.admin>
						| <a href="editFile.cfm?p=#url.p#&f=#fileID#" class="edit">Edit details</a>
						| <a href="#cgi.script_name#?p=#url.p#&df=#fileID#" class="delete" onclick="return confirm('Are you sure you wish to delete this file?');">Delete File</a>
						</cfif>
						</div>
						</div>
						</cfloop>
					<cfelse>
					<div class="wrapper"><div class="warn">No files have been uploaded.</div></div>
					</cfif>
						
				</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">
		<div class="header"><h3>Categories</h3></div>
		<div class="content">
			<ul>
				<cfloop query="categories">
					<li><a href="#cgi.script_name#?p=#url.p#&c=#urlEncodedFormat(category)#">#category#</a></li>
				</cfloop>
			</ul>
		</div>
	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">