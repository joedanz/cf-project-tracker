<cfsetting enablecfoutputonly="true">

<cfif isDefined("form.submit")>
	<cfset application.comment.add(createUUID(),url.p,'',url.i,session.user.userid,form.comment)>
<cfelseif isDefined("url.close")>
	<cfset application.issue.markClosed(url.i,url.p)>
</cfif>

<cfparam name="url.p" default="">
<cfparam name="fileupload" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
<cfset issue = application.issue.get(url.p,url.i)>
<cfset comments = application.comment.get(url.p,'',url.i)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Issue Detail" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text='<script type="text/javascript" src="./js/comments.js"></script>
'>

<cfoutput>
<div id="container">
<cfif issue.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
				<span class="rightmenu">
					<a href="editIssue.cfm?p=#url.p#&i=#url.i#" class="edit">Edit</a>
					<cfif compare(issue.status,'Closed')>
					| <a href="#cgi.script_name#?p=#url.p#&i=#url.i#&close=1" class="close">Close Ticket</a>
					</cfif>
				</span>
					
					
					<h2 class="issues">#issue.shortID# - #issue.issue#</h2>
				</div>
				<div class="content">
				 	<div class="wrapper">
					 	
					 	
						<div style="padding:5px;background-color:##fff6bf;border:3px solid ##ffd324;">
					 	<table class="bug" style="float:right;margin-right:20px;">
							<tr>
								<td class="label">Created:</td>
								<td>#DateFormat(issue.created,"d mmm")# @ #TimeFormat(issue.created,"h:mmtt")# by #issue.createdFirstName# #issue.createdLastName#</td>
							</tr>
							<tr>
								<td class="label">Updated:</td>
								<td><cfif isDate(issue.updated)>#DateFormat(issue.updated,"d mmm")# @ #TimeFormat(issue.updated,"h:mmtt")# by #issue.updatedFirstName# #issue.updatedLastName#<cfelse>N/A</cfif></td>
							</tr>
							<cfif compare(issue.assignedLastName,'')>
							<tr>
								<td class="label">Assigned To:</td>
								<td>#issue.assignedFirstName# #issue.assignedLastName#</td>
							</tr>
							</cfif>
						</table>
					
					 	<table class="bug">
							<tr>
								<td class="label">Type:</td>
								<td>#issue.type#</td>
							</tr>
							<tr>
								<td class="label">Status:</td>
								<td>#issue.status#</td>
							</tr>
							<tr>
								<td class="label">Severity:</td>
								<td>#issue.severity#</td>
							</tr>
						</table>
						</div>
						
					 	<table class="bug">
							<tr>
								<td class="label">Detail:</td>
								<td>#issue.detail#</td>
							</tr>
							<cfif compare(issue.relevantURL,'')>
							<tr>
								<td class="label">Relevant URL:</td>
								<td><a href="#issue.relevantURL#" target="_new">#issue.relevantURL#</a></td>
							</tr>
							</cfif>
						</table>	
						
						<!---
						<table class="svn mb10" id="issues">
							<caption class="plain">Attachments</caption>
							<thead>
								<tr>
									<th>Name</th>
									<th>Size</th>
									<th>Type</th>
									<th>Uploaded</th>
								</tr>
							</thead>
							<tbody>

							</tbody>
						</table>	
						<form action="#cgi.script_name#" method="post" name="edit" id="edit" class="frm" enctype="multipart/form-data" onsubmit="return confirmSubmit();">
						<p>
						<label for="fileupload" class="req">File:</label>
						<input type="file" name="fileupload" id="fileupload" value="#fileupload#" />
						</p>
						</form>		
						--->			
						
						<a name="comments" />
						<div id="commentbar"><span id="cnum">#comments.recordCount#</span> comment<cfif comments.recordCount neq 1>s</cfif> so far</div>
	
						<cfloop query="comments">
						<div id="#commentID#">
						<cfif userID eq session.user.userID>
						<a href="##" onclick="return delete_comment('#commentID#');"><img src="./images/delete.gif" height="16" width="16" border="0" style="float:right;padding:5px;" /></a>
						</cfif>
						<cfif application.isCF8 or application.isBD>
						<img src="./images/<cfif avatar>avatars/#userID#_48.jpg<cfelse>noavatar48.gif</cfif>" height="48" width="48" border="0" style="float:left;border:1px solid ##ddd;" />
						</cfif>
						<div class="commentbody">
						<span class="b">#firstName# #lastName#</span> said on #DateFormat(stamp,"ddd, mmm d")# at #TimeFormat(stamp,"h:mmtt")#<br />
						#comment#
						</div>
						</div>
						</cfloop>						
						
						<form action="#cgi.script_name#?p=#url.p#&i=#url.i#" method="post" name="add" id="add" class="frm" onsubmit="return confirmSubmit();">
						<div class="b">Post a new comment...</div>
						<cfscript>
							basePath = '#application.settings.mapping#/includes/fckeditor/';
							fckEditor = createObject("component", "#basePath#fckeditor");
							fckEditor.instanceName	= "comment";
							fckEditor.value			= '';
							fckEditor.basePath		= basePath;
							fckEditor.width			= "100%";
							fckEditor.height		= 150;
							fckEditor.ToolbarSet	= "Basic";
							fckEditor.create(); // create the editor.
						</cfscript>
		
						<div id="preview" style="display:none;margin:15px 0;font-size:.9em;">
						<fieldset style="padding:0;"><legend style="padding:0 5px;font-weight:bold;font-size:1em;">Comment Preview (<a href="##" onclick="$('##preview').hide();">X</a>)</legend>
						<div id="commentbody"></div>
						</fieldset>
						</div>
		
						<input type="button" class="button" value="Preview" onclick="show_preview();" /> or 
						<input type="submit" class="button" name="submit" value="Post Comment" />
						</form>												
						
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
	<div class="alert">Issue Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">