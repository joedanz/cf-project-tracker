<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfparam name="url.p" default="">
<cfparam name="url.f" default="">
<cfparam name="form.search" default="">

<cfif StructKeyExists(url,"s")>
	<cfset form.search = url.s>
</cfif>

<cfif compare(url.p,'')>
	<cfset project = application.project.get(projectID=url.p)>
</cfif>

<cfif compare(form.search,'')>
	<cfif not compare(url.p,'')>
		<cfset projects = application.search.projects(form.search,session.user.admin)>
		<cfquery name="distinct_projects" dbtype="query">
			select distinct projectid from projects
		</cfquery>
		<cfset dist_proj_list = quotedValueList(distinct_projects.projectID)>
	<cfelse>
		<cfset projects.recordCount = 0>
		<cfset dist_proj_list = "'#url.p#'">
	</cfif>
	<cfset messages = application.search.messages(form.search,url.p,session.user.admin)>
	<cfset comments = application.search.comments(form.search,url.p,session.user.admin)>
	<cfset files = application.search.files(form.search,url.p,session.user.admin)>
	<cfset mstones = application.search.milestones(form.search,url.p,session.user.admin)>
	<cfset todos = application.search.todos(form.search,url.p,session.user.admin)>
	<cfset issues = application.search.issues(form.search,url.p,session.user.admin)>
	<cfset screenshots = application.search.screenshots(form.search,url.p,session.user.admin)>

	<cfif not session.user.admin>
		<cfset uprojects = session.user.projects>
		<!--- messages with user permissions --->
		<cfquery name="messages_withperms" dbtype="query">
			select messageID, categoryID, milestoneID, title, message, stamp, messages.name, category, 
				messages.projectID, projName, msg_view
			from messages, uprojects
			where uprojects.projectid = messages.projectid
		</cfquery>
		<cfset messages = messages_withperms>
		<!--- comments with user permissions --->
		<cfquery name="comments_withperms" dbtype="query">
			select commentID, itemID, type, commentText, stamp, messageID, comments.title, issueID, issue,
				userID, firstName, lastName, avatar, comments.projectID, projName,
				file_comment, issue_comment, msg_comment, mstone_comment, todo_comment
			from comments, uprojects
			where uprojects.projectid = comments.projectid
		</cfquery>
		<cfset comments = comments_withperms>		
		<!--- files with user permissions --->
		<cfquery name="files_withperms" dbtype="query">
			select fileid, title, categoryID, files.description, filename, serverfilename, filetype,
				filesize, uploaded, uploadedBy, firstName,  lastName,  category, files.projectID, 
				projName, file_view
			from files, uprojects
			where uprojects.projectid = files.projectid
		</cfquery>
		<cfset files = files_withperms>
		<!--- milestones with user permissions --->
		<cfquery name="mstones_withperms" dbtype="query">
			select milestoneid, mstones.name, mstones.description, dueDate, completed, mstones.projectID, 
				projName, mstone_view
			from mstones, uprojects
			where uprojects.projectid = mstones.projectid
		</cfquery>
		<cfset mstones = mstones_withperms>
		<!--- todos with user permissions --->
		<cfquery name="todos_withperms" dbtype="query">
			select todoID, todolistID, task, todos.userID, rank, due, completed, 
					todos.title, todos.description, todos.projectID, projName, todolist_view
			from todos, uprojects
			where uprojects.projectid = todos.projectid
		</cfquery>
		<cfset todos = todos_withperms>
		<!--- issues with user permissions --->
		<cfquery name="issues_withperms" dbtype="query">
			select issueID, shortID, issue, detail, type, severity, issues.status, created, createdBy,	
				assignedTo, updated, updatedBy, issues.projectID, projName, issue_view
			from issues, uprojects
			where uprojects.projectid = issues.projectid
		</cfquery>
		<cfset issues = issues_withperms>
		<!--- screenshots with user permissions --->
		<cfquery name="screenshots_withperms" dbtype="query">
			select fileID, issueID, screenshots.title, screenshots.description, filename, serverfilename, filetype,
				screenshots.projectID, projName, issue_view
			from screenshots, uprojects
			where uprojects.projectid = screenshots.projectid
		</cfquery>
		<cfset screenshots = screenshots_withperms>
		
	</cfif>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Search" project="#IIf(compare(url.p,''),'project.name','')#" projectid="#url.p#" svnurl="#IIf(compare(url.p,''),'project.svnurl','')#">

<cfsavecontent variable="js">
<cfoutput>
<script type='text/javascript'>
$(document).ready(function(){
	$('##searchbox').focus();
});
</script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#js#">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header headernomb">
					<h2>Search <cfif compare(url.p,'')>the &quot;#project.name#&quot; project<span class="norm sm"> or <a href="#cgi.script_name#">across all projects</a></span><cfelse>across all projects</cfif></h2>
					<form action="#cgi.script_name#?#cgi.query_string#" method="post" id="search">
						<input type="text" name="search" value="#form.search#" id="searchbox" />
						<input type="submit" value="Search" class="button" />
					</form>
				</div>
				<cfif compare(form.search,'')>
					<div class="subheader">
						Show <a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#"<cfif not compare(url.f,'')> class="b"</cfif>>All (#comments.recordCount+files.recordCount+issues.recordCount+messages.recordCount+mstones.recordCount+todos.recordCount#)</a>
								 or
							<cfif not compare(url.p,'')>
								<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&amp;f=project">Projects (#projects.recordCount#)</a>,
							</cfif>
							<a href="#cgi.script_name#?p=#url.p#&amp;s=#URLEncodedFormat(form.search)#&amp;f=msgs"<cfif not compare(url.f,'msgs')> class="b"</cfif>>Messages (#messages.recordCount#)</a>, 
							<a href="#cgi.script_name#?p=#url.p#&amp;s=#URLEncodedFormat(form.search)#&amp;f=comments"<cfif not compare(url.f,'comments')> class="b"</cfif>>Comments (#comments.recordCount#)</a>, 
							<a href="#cgi.script_name#?p=#url.p#&amp;s=#URLEncodedFormat(form.search)#&amp;f=todos"<cfif not compare(url.f,'todos')> class="b"</cfif>>To-Dos (#todos.recordCount#)</a>, 
							<a href="#cgi.script_name#?p=#url.p#&amp;s=#URLEncodedFormat(form.search)#&amp;f=files"<cfif not compare(url.f,'files')> class="b"</cfif>>Files (#files.recordCount#)</a>, 
							<a href="#cgi.script_name#?p=#url.p#&amp;s=#URLEncodedFormat(form.search)#&amp;f=mstones"<cfif not compare(url.f,'mstones')> class="b"</cfif>>Milestones (#mstones.recordCount#)</a>, 
							<a href="#cgi.script_name#?p=#url.p#&amp;s=#URLEncodedFormat(form.search)#&amp;f=issues"<cfif not compare(url.f,'issues')> class="b"</cfif>>Issues (#issues.recordCount#)</a>,
							<a href="#cgi.script_name#?p=#url.p#&amp;s=#URLEncodedFormat(form.search)#&amp;f=screen"<cfif not compare(url.f,'screen')> class="b"</cfif>>Screenshots (#screenshots.recordCount#)</a>					
					</div>
				</cfif>
				<div class="content">
					<div class="wrapper">
						
						<cfset row = 1>
						<cfif compare(form.search,'')>	
							
							<cfif not compare(url.p,'')>
								<cfif not compare(url.f,'') or not compare(url.f,'project')>
									<cfset proj_list = "">
									<cfloop query="projects">
										<cfif not listFind(proj_list,projectID)>
											<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
												<div class="catbox project">Project</div> 
												<h4><a href="project.cfm?p=#projectID#">#name#</a></h4>
												<cfif compare(description,'')><p>#left(description,200)#<cfif len(description) gt 200>...</cfif></p></cfif>
											</div>
											<cfset row = row + 1>
											<cfset proj_list = listAppend(proj_list,projectID)>
										</cfif>
									</cfloop>
								</cfif>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'msgs')>
								<cfloop query="messages">
									<cfif session.user.admin or msg_view>
										<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
											<div class="catbox message">Message</div> 
											<h4>
												<cfif not compare(url.p,'')>
													<a href="project.cfm?p=#projectID#">#projName#</a> : 
												</cfif>
												<a href="message.cfm?p=#projectID#&amp;m=#messageID#">#title#</a>
											</h4>
											<cfif compare(message,'')><p>#left(message,200)#<cfif len(message) gt 200>...</cfif></p></cfif>
										</div>
										<cfset row = row + 1>
									</cfif>
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'comments')>
								<cfloop query="comments">
									<cfif session.user.admin or ( 
										(not compare(type,'file') and file_comment) or  
										(not compare(type,'issue') and issue_comment) or
										(not compare(type,'msg') and msg_comment) or
										(not compare(type,'mstone') and mstone_comment) or
										(not compare(type,'todo') and todo_comment)
									)>
										<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
											<div class="catbox comm">Comment</div> 
											<h4>on 
												<cfif not compare(url.p,'')>
													<a href="project.cfm?p=#projectID#">#projName#</a> : 
												</cfif>
												<cfif compare(messageID,'')>
													<a href="message.cfm?p=#projectID#&amp;m=#messageID#">#title#</a>
												<cfelseif compare(issueID,'')>
													<a href="issue.cfm?p=#projectID#&amp;m=#issueID#">#issue#</a>
												</cfif>
											</h4>
											<cfif compare(commentText,'')><p>#left(commentText,200)#<cfif len(commentText) gt 200>...</cfif></p></cfif>
										</div>
										<cfset row = row + 1>
									</cfif>
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'todos')>
								<cfloop query="todos">
									<cfif session.user.admin or todolist_view>
										<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
											<div class="catbox todolist">To-Dos</div> 
											<h4>
												<cfif not compare(url.p,'')>
													<a href="project.cfm?p=#projectID#">#projName#</a> : 
												</cfif>
												<a href="todos.cfm?p=#projectID#">#title#</a> : <a href="todos.cfm?p=#projectID#">#task#</a>
											</h4>
										</div>
										<cfset row = row + 1>
									</cfif>
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'files')>
								<cfloop query="files">
									<cfif session.user.admin or file_view>
										<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
											<div class="catbox file">File</div> 
											<h4>
												<cfif not compare(url.p,'')>
													<a href="project.cfm?p=#projectID#">#projName#</a> : 
												</cfif>
												<a href="files.cfm?p=#projectID#">#title#</a>
											</h4>
											<cfif compare(description,'')><p>#left(description,200)#<cfif len(description) gt 200>...</cfif></p></cfif>
										</div>
										<cfset row = row + 1>
									</cfif>
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'mstones')>
								<cfloop query="mstones">
									<cfif session.user.admin or mstone_view>
										<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
											<div class="catbox milestone">Milestone</div> 
											<h4>
												<cfif not compare(url.p,'')>
													<a href="project.cfm?p=#projectID#">#projName#</a> : 
												</cfif>
												<a href="milestone.cfm?p=#projectID#">#name#</a>
											</h4>
											<cfif compare(description,'')><p>#left(description,200)#<cfif len(description) gt 200>...</cfif></p></cfif>
										</div>
										<cfset row = row + 1>
									</cfif>
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'issues')>
								<cfloop query="issues">
									<cfif session.user.admin or issue_view>
										<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
											<div class="catbox issue">Issue</div> 
											<h4>
												<cfif not compare(url.p,'')>
													<a href="project.cfm?p=#projectID#">#projName#</a> : 
												</cfif>
												<a href="issue.cfm?p=#projectID#&amp;i=#issueID#">#issue#</a>
											</h4>
											<cfif compare(detail,'')><p>#left(detail,200)#<cfif len(detail) gt 200>...</cfif></p></cfif>
										</div>
										<cfset row = row + 1>
									</cfif>
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'screen')>
								<cfloop query="screenshots">
									<cfif session.user.admin or issue_view>
										<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
											<div class="catbox screenshot">Screenshot</div> 
											<h4>
												<cfif not compare(url.p,'')>
													<a href="project.cfm?p=#projectID#">#projName#</a> : 
												</cfif>
												<a href="issue.cfm?p=#projectID#&amp;i=#issueID#">#title#</a>
											</h4>
											<cfif compare(description,'')><p>#left(description,200)#<cfif len(description) gt 200>...</cfif></p></cfif>
										</div>
										<cfset row = row + 1>
									</cfif>
								</cfloop>
							</cfif>					
						
						<cfelse>
							<p class="g">
							<cfif compare(url.p,'')>
								Enter your search term above to search the &quot;#project.name#&quot; project.<br />
								You might also want to <a href="#cgi.script_name#">search all projects</a>.
							<cfelse>
								Enter your search term above to search across all projects.
							</cfif>
							</p>
						</cfif>

				 	</div>
				</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="#application.settings.mapping#/footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">
		<cfif not compare(url.p,'') and compare(application.settings.company_logo,'')>
			<img src="#application.settings.userFilesMapping#/company/#application.settings.company_logo#" border="0" alt="#application.settings.company_name#" /><br />
		<cfelseif compare(url.p,'') and compare(project.logo_img,'')>
			<img src="#application.settings.userFilesMapping#/projects/#project.logo_img#" border="0" alt="#project.name#" class="projlogo" />		
		</cfif>
	</div>
		
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">