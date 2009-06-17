<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(url,"df") and not compare(hash(url.df),url.dfh)>
	<cfset application.file.delete(url.p,url.df,session.user.userID)>
</cfif>

<cfif StructKeyExists(url,"o")>
	<cfset session.user.fileorder = url.o>
</cfif>

<cfparam name="url.p" default="">
<cfparam name="url.c" default="">
<cfparam name="session.user.fileorder" default="date">
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset files = application.file.get(projectID=url.p,categoryID=url.c,orderBy=session.user.fileorder)>
<cfset categories = application.category.get(url.p,'file')>

<cfif not project.file_view and not session.user.admin>
	<cfoutput><h2>You do not have permission to access files!!!</h2></cfoutput>
	<cfabort>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Files" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
</cfoutput>

<cfif project.recordCount>
	<cfoutput>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<span class="rightmenu">
						
					</span>
										
					<h2 class="files">
					<cfif compare(url.c,'')>
						<cfset category = application.category.get(url.p,'file',url.c)>
						Files in category: #category.category#
					<cfelse>
						All files
					</cfif>					
					</h2>
				</div>
				<div class="content">
				</cfoutput>
				
					<cfif files.recordCount>
					
						<cfif not compareNoCase(session.user.fileorder,'date')>
							<cfset sortField = "uploadDate">
						<cfelseif not compareNoCase(session.user.fileorder,'alpha')>
							<cfset sortField = "leftChar">
						</cfif>
						
						<cfoutput query="files" group="#sortfield#">
							<div class="stamp">
							<cfif not compareNoCase(session.user.fileorder,'date')>
								#DateFormat(uploaddate,"dddd, d mmmm")#
							<cfelseif not compareNoCase(session.user.fileorder,'alpha')>
								#leftChar#
							</cfif>
							</div>
						
							<cfoutput>
							<cfset attached = application.file.checkFile(fileID)>
							<cfif listFind(ValueList(attached.type),'msg')>
								<cfset msgAttached = true>
							</cfif>
							<cfif listFind(ValueList(attached.type),'issue')>
								<cfset issueAttached = true>
							</cfif>
							
							
							<div class="wrapper itemlist fileLrg #filetype#Lrg">
							<h3 class="padtop">#title#</h3>	
							<p>#description#</p>
							<div class="byline">
							<cfif Int(filesize/1024000) gte 1>
							#NumberFormat(filesize/1024000,"0.00")#MB,
							<cfelse>
							#Int(filesize/1024)#K,
							</cfif>
							uploaded to <a href="#cgi.script_name#?p=#url.p#&c=#categoryID#">#category#</a> by #firstName# #lastName# on #DateFormat(uploaded,"mmm d")#
							| <a href="download.cfm?p=#url.p#&f=#fileID#" class="download">Download</a>
							<cfif session.user.userID eq uploadedBy or session.user.admin>
							| <a href="editFile.cfm?p=#url.p#&f=#fileID#" class="edit">Edit</a>
							| <a href="#cgi.script_name#?p=#url.p#&df=#fileID#&dfh=#hash(fileID)#" class="delete" onclick="return confirm('<cfif attached.recordCount>This file is currently attached to <cfif isDefined("msgAttached") and isDefined("issueAttached")> a message and issue<cfelseif isDefined("msgAttached")>a message<cfelseif isDefined("issueAttached")>an issue</cfif>.\n</cfif>Are you sure you wish to delete this file?');">Delete</a>
							</cfif>
							| <a href="file.cfm?p=#url.p#&f=#fileID#" class="comment"><cfif commentCount gt 0>#commentCount# Comments<cfelse>Post the first comment</cfif></a>
							</div>
							</div>
							</cfoutput>
						</cfoutput>
					<cfelse>
						<cfoutput><div class="wrapper"><div class="warn">No files have been uploaded.</div></div></cfoutput>
					</cfif>
					
				<cfoutput>		
				</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">
		<cfif compare(project.logo_img,'')>
			<img src="#application.settings.userFilesMapping#/projects/#project.logo_img#" border="0" alt="#project.name#" class="projlogo" />
		</cfif>
	
		<cfif project.file_edit>
		<h3><a href="editFile.cfm?p=#url.p#" class="add">Upload a new file</a></h3><br />
		</cfif>	
		
		<div class="header"><h3>Sort by</h3></div>
		<div class="content">
			<ul class="nobullet">
				<li><input type="radio" name="sort" value="date"<cfif not compare(session.user.fileorder,'date')> checked="checked"</cfif> onclick="window.location='#cgi.script_name#?p=#url.p#&c=#url.c#&o=date'" /> Date and time</li>
				<li><input type="radio" name="sort" value="alpha"<cfif not compare(session.user.fileorder,'alpha')> checked="checked"</cfif> onclick="window.location='#cgi.script_name#?p=#url.p#&c=#url.c#&o=alpha'" /> A-Z</li>
			</ul>		
		</div>
		
		<div class="header"><h3>Categories</h3></div>
		<div class="content">
			<ul>
				<cfloop query="categories">
					<li><a href="#cgi.script_name#?p=#url.p#&c=#categoryID#"<cfif not compareNoCase(url.c,categoryID)> class="b"</cfif>>#category#</a></li>
				</cfloop>
			</ul>
		</div>
	</div>
	</cfoutput>
<cfelse>
	<cfoutput><div class="alert">Project Not Found.</div></cfoutput>
</cfif>

<cfoutput>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">