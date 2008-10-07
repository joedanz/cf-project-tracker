<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">
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
	<cfset messages = application.search.messages(form.search)>
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
						Show <a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#">All Matches</a> or filter by 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=msgs">Messages (#messages.recordCount#)</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=comments">Comments</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=todos">To-Dos</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=files">Files</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=mstones">Milestones</a>, 
							<a href="#cgi.script_name#?s=#URLEncodedFormat(form.search)#&f=issues">Issues</a>

						</cfif>

						<p class="g">
						<cfif compare(url.p,'')>
							Enter your search term above to search the &quot;#project.name#&quot; project.<br />
							You might also want to <a href="#cgi.script_name#">search all projects</a>.
						<cfelse>
							Enter your search term above to search across all projects.
						</cfif>
						</p>

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