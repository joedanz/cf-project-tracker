<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">
<cfparam name="url.f" default="">
<cfparam name="form.search" default="">
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfparam name="form.search" default="">
<cfif StructKeyExists(url,"s")>
	<cfset form.search = url.s>
</cfif>

<cfif compare(form.search,'')>
	<cfif not compare(url.p,'')>
		<cfset projects = application.search.projects(form.search)>
	<cfelse>
		<cfset projects.recordCount = 0>
	</cfif>
	<cfset messages = application.search.messages(form.search)>
	<cfset comments = application.search.comments(form.search)>
	<cfset files = application.search.files(form.search)>
	<cfset mstones = application.search.milestones(form.search)>
	<cfset todos = application.search.todos(form.search)>
	<cfset issues = application.search.issues(form.search)>
	<cfset screenshots = application.search.screenshots(form.search)>
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

				<div class="header">
					<h2>Search <cfif compare(url.p,'')>the &quot;#project.name#&quot; project<span style="font-weight:normal;font-size:.9em;"> or <a href="#cgi.script_name#">across all projects</a></span><cfelse>across all projects</cfif></h2>
					<form action="#cgi.script_name#" method="post" id="search">
						<input type="text" name="search" value="#form.search#" id="searchbox" />
						<input type="submit" value="Search" class="button" />
					</form>
				</div>
				<div class="content">
					<div class="wrapper">

						<cfif compare(form.search,'')>
						<p>
						Show <a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#"<cfif not compare(url.f,'')> class="b"</cfif>>All (#comments.recordCount+files.recordCount+issues.recordCount+messages.recordCount+mstones.recordCount+todos.recordCount#)</a>
								 or just
							<cfif not compare(url.p,'')>
								<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=project">Projects (#projects.recordCount#)</a>,
							</cfif>
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=msgs"<cfif not compare(url.f,'msgs')> class="b"</cfif>>Msgs (#messages.recordCount#)</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=comments"<cfif not compare(url.f,'comments')> class="b"</cfif>>Comments (#comments.recordCount#)</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=todos"<cfif not compare(url.f,'todos')> class="b"</cfif>>To-Dos (#todos.recordCount#)</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=files"<cfif not compare(url.f,'files')> class="b"</cfif>>Files (#files.recordCount#)</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=mstones"<cfif not compare(url.f,'mstones')> class="b"</cfif>>Milestones (#mstones.recordCount#)</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=issues"<cfif not compare(url.f,'issues')> class="b"</cfif>>Issues (#issues.recordCount#)</a>,
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=screen"<cfif not compare(url.f,'screen')> class="b"</cfif>>Screenshots (#screenshots.recordCount#)</a>
						</p>
							
							<cfif not compare(url.p,'')>
								<cfif not compare(url.f,'') or not compare(url.f,'project')>
									<cfloop query="projects">
										<div class="catbox project">Project</div>
									</cfloop>
								</cfif>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'msgs')>
								<cfloop query="messages">
									<div class="catbox message">Message</div> #title#
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'comments')>
								<cfloop query="comments">
									<div class="catbox comment">Comment</div> on #title#
									#left(commentText,100)#
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'todos')>
								<cfloop query="todos">
									<div class="catbox todolist">To-Dos</div> #title#:#task#
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'files')>
								<cfloop query="files">
									<div class="catbox file">File</div> #title#
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'mstones')>
								<cfloop query="mstones">
									<div class="catbox milestone">Milestone</div> #name#
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'issues')>
								<cfloop query="issues">
									<div class="catbox issue">Issue</div> #issue#
								</cfloop>
							</cfif>
							<cfif not compare(url.f,'') or not compare(url.f,'screen')>
								<cfloop query="screenshots">
									<div class="catbox screen">Screenshot</div>
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
						
						<cf>

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