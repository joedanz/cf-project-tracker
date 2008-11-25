<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">
<cfparam name="url.f" default="">
<cfparam name="form.search" default="">
<!---<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>--->
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
	<cfset messages = application.search.messages(form.search,session.user.admin)>
	<cfset comments = application.search.comments(form.search,session.user.admin)>
	<cfset files = application.search.files(form.search,session.user.admin)>
	<cfset mstones = application.search.milestones(form.search,session.user.admin)>
	<cfset todos = application.search.todos(form.search,session.user.admin)>
	<cfset issues = application.search.issues(form.search,session.user.admin)>
	<cfset screenshots = application.search.screenshots(form.search,session.user.admin)>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Search">

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
					<h2>Search <cfif compare(url.p,'')>the &quot;#project.name#&quot; project<span style="font-weight:normal;font-size:.9em;"> or <a href="#cgi.script_name#">across all projects</a></span><cfelse>across all projects</cfif></h2>
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
								<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=project">Projects (#projects.recordCount#)</a>,
							</cfif>
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=msgs"<cfif not compare(url.f,'msgs')> class="b"</cfif>>Messages (#messages.recordCount#)</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=comments"<cfif not compare(url.f,'comments')> class="b"</cfif>>Comments (#comments.recordCount#)</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=todos"<cfif not compare(url.f,'todos')> class="b"</cfif>>To-Dos (#todos.recordCount#)</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=files"<cfif not compare(url.f,'files')> class="b"</cfif>>Files (#files.recordCount#)</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=mstones"<cfif not compare(url.f,'mstones')> class="b"</cfif>>Milestones (#mstones.recordCount#)</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=issues"<cfif not compare(url.f,'issues')> class="b"</cfif>>Issues (#issues.recordCount#)</a>,
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=screen"<cfif not compare(url.f,'screen')> class="b"</cfif>>Screenshots (#screenshots.recordCount#)</a>					
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
									<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
										<div class="catbox message">Message</div> 
										<h4>
											<cfif not compare(url.p,'')>
												<a href="project.cfm?p=#projectID#">#projName#</a> : 
											</cfif>
											<a href="message.cfm?p=#projectID#&m=#messageID#">#title#</a>
										</h4>
										<cfif compare(message,'')><p>#left(message,200)#<cfif len(message) gt 200>...</cfif></p></cfif>
									</div>
									<cfset row = row + 1>
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'comments')>
								<cfloop query="comments">
									<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
										<div class="catbox comm">Comment</div> 
										<h4>on 
											<cfif not compare(url.p,'')>
												<a href="project.cfm?p=#projectID#">#projName#</a> : 
											</cfif>
											<a href="message.cfm?p=#projectID#">#title#</a>
										</h4>
										<cfif compare(commentText,'')><p>#left(commentText,200)#<cfif len(commentText) gt 200>...</cfif></p></cfif>
									</div>
									<cfset row = row + 1>
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'todos')>
								<cfloop query="todos">
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
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'files')>
								<cfloop query="files">
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
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'mstones')>
								<cfloop query="mstones">
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
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'issues')>
								<cfloop query="issues">
									<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
										<div class="catbox issue">Issue</div> 
										<h4>
											<cfif not compare(url.p,'')>
												<a href="project.cfm?p=#projectID#">#projName#</a> : 
											</cfif>
											<a href="issue.cfm?p=#projectID#&i=#issueID#">#issue#</a>
										</h4>
										<cfif compare(detail,'')><p>#left(detail,200)#<cfif len(detail) gt 200>...</cfif></p></cfif>
									</div>
									<cfset row = row + 1>
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'screen')>
								<cfloop query="screenshots">
									<div class="searchresult<cfif row mod 2 eq 0> odd</cfif>">
										<div class="catbox screenshot">Screenshot</div> 
										<h4>
											<cfif not compare(url.p,'')>
												<a href="project.cfm?p=#projectID#">#projName#</a> : 
											</cfif>
											<a href="issue.cfm?p=#projectID#&i=#issueID#">#title#</a>
										</h4>
										<cfif compare(description,'')><p>#left(description,200)#<cfif len(description) gt 200>...</cfif></p></cfif>
									</div>
									<cfset row = row + 1>
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

	</div>
		
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">