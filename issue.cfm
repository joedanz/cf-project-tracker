<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(form,"submit")>
	<cfset application.comment.add(createUUID(),url.p,'issue',url.i,session.user.userid,form.comment)>
<cfelseif StructKeyExists(form,"resolve")>
	<cfparam name="form.closealso" default="false">
	<cfset application.issue.resolve(url.i,url.p,session.user.userid,form.closealso,form.resolution,form.res_desc)>
	<cfset issue = application.issue.get(url.p,url.i)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'resolved')>
	<cfif not form.closealso>
		<cfset application.notify.issueUpdate(url.p,url.i)>
	</cfif>
	<cfif form.closealso>
		<cfset application.issue.close(url.i,url.p,session.user.userid)>
		<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'closed')>
		<cfset application.notify.issueUpdate(url.p,url.i)>
	</cfif>
<cfelseif StructKeyExists(url,"close")>
	<cfset application.issue.close(url.i,url.p,session.user.userid)>
	<cfset issue = application.issue.get(url.p,url.i)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'closed')>
	<cfset application.notify.issueUpdate(url.p,url.i)>
<cfelseif StructKeyExists(url,"acc")>
	<cfset application.issue.accept(url.i,url.p,session.user.userid)>
	<cfset issue = application.issue.get(url.p,url.i)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'accepted')>
	<cfset application.notify.issueUpdate(url.p,url.i)>
<cfelseif StructKeyExists(url,"unacc")>
	<cfset application.issue.unaccept(url.i,url.p,session.user.userid)>
	<cfset issue = application.issue.get(url.p,url.i)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'unaccepted')>
	<cfset application.notify.issueUpdate(url.p,url.i)>
<cfelseif StructKeyExists(url,"reopen")>
	<cfset application.issue.reopen(url.i,url.p,session.user.userid)>
	<cfset issue = application.issue.get(url.p,url.i)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'re-opened')>
	<cfset application.notify.issueUpdate(url.p,url.i)>
</cfif>

<cfparam name="url.p" default="">
<cfparam name="fileupload" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
<cfset issue = application.issue.get(url.p,url.i)>
<cfset comments = application.comment.get(url.p,'issue',url.i)>
<cfset activity = application.activity.get(type='Issue',id=url.i)>

<cfif project.issues eq 0 and not session.user.admin>
	<cfoutput><h2>You do not have permission to access issues!!!</h2></cfoutput>
	<cfabort>
</cfif>

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

				<div class="header" style="margin-bottom:0;">
				<cfif project.issues eq 2>
				<span class="rightmenu">
					<a href="editIssue.cfm?p=#url.p#&i=#url.i#" class="edit">Edit</a> 
					<cfif not compare(issue.assignedTo,'')>
						| <a href="#cgi.script_name#?p=#url.p#&i=#url.i#&acc=1" class="accept">Accept Ticket</a>
					<cfelseif compare(issue.status,'Closed')>
						| <a href="#cgi.script_name#?p=#url.p#&i=#url.i#&unacc=1" class="cancel">Unaccept Ticket</a>
					</cfif>
					<cfif not compare(issue.status,'Accepted')>
						| <a href="##" onclick="$('##resolve').slideToggle(300);;return false;" class="close">Resolve Ticket</a>
					<cfelseif not compare(issue.status,'Resolved')>
						| <a href="#cgi.script_name#?p=#url.p#&i=#url.i#&close=1" class="close">Close Ticket</a>
					<cfelseif not compare(issue.status,'Closed')>
						| <a href="#cgi.script_name#?p=#url.p#&i=#url.i#&reopen=1" class="close">Reopen Ticket</a>
					</cfif>
				</span>
				</cfif>
					
					<h2 class="issues">Ticket <cfif isNumeric(issue.shortID)>##</cfif>#issue.shortID# - #issue.issue#</h2>
				</div>
				
				<div id="resolve" style="padding:10px 20px;display:none;background-color:##f5f5f5;">
					<form action="#cgi.script_name#?#cgi.query_string#" method="post">
					<span style="float:left;margin-right:30px;">
					<label for="res" class="b">Resolution:</label><br />
					<select name="resolution" id="res">
						<option value="Fixed">Fixed</option>
						<option value="Works for me">Works for me</option>
						<option value="Postponed">Postponed</option>
						<option value="Duplicate">Duplicate</option>
						<option value="Will not fix">Will not fix</option>
						<option value="Invalid">Invalid</option>
					</select><br /><br />
					<input type="checkbox" name="closealso" value="true" id="closealso">
					<label for="closealso">Close Ticket Simultaneously</label>
					</span>
					
					<label for="res_desc" class="b">Description of Resolution:</label><br />
					<textarea name="res_desc" id="res_desc"></textarea><br />
					<input type="submit" value="Resolve Ticket" name="resolve" />
					or <a href="##" onclick="$('##resolve').slideToggle(300);;return false;">Cancel</a>
					</form>
				</div>
				
				
				<div class="content">
				 	<div class="wrapper">
					 	
					    <ul id="issueStatus">
					      <li class="<cfif not compare(issue.status,'New')>current<cfelseif not compare(issue.status,'Accepted')>lastDone<cfelse>done</cfif>"><a title=""><em>New</em></a></li>
					      <li<cfif not compare(issue.status,'Accepted') or not compare(issue.status,'Open')> class="current"<cfelseif not compare(issue.status,'Resolved')> class="lastDone"<cfelseif compare(issue.status,'New')> class="done"</cfif>><a title=""><em>Accepted</em></a></li>
					      <li<cfif not compare(issue.status,'Resolved')> class="current"<cfelseif not compare(issue.status,'Closed')> class="lastDone"</cfif>><a title=""><em>Resolved</em></a></li>
						  <li class="issueStatusNoBg<cfif not compare(issue.status,'Closed')> current</cfif>"><a title=""><em>Closed</em></a></li>
					    </ul>
					    <div class="clear mb15">&nbsp;</div>
					 	
						<div style="padding:5px;background-color:##fff6bf;border:3px solid ##ffd324;" class="mb10">
					 	<table class="bug" style="float:right;margin-right:20px;">
							<tr>
								<td class="label">Created:</td>
								<td>#DateFormat(issue.created,"mmm d")# @ #TimeFormat(issue.created,"h:mmtt")# by #issue.createdFirstName# #issue.createdLastName#</td>
							</tr>
							<tr>
								<td class="label"><cfif not compare(issue.status,'Closed')>Closed<cfelse>Updated</cfif>:</td>
								<td><cfif isDate(issue.updated)>#DateFormat(issue.updated,"mmm d")# @ #TimeFormat(issue.updated,"h:mmtt")# by #issue.updatedFirstName# #issue.updatedLastName#<cfelse><span class="g">&lt;none&gt;</span></cfif></td>
							</tr>
							
							<tr>
								<td class="label">Assigned To:</td>
								<td><cfif compare(issue.assignedLastName,'')>#issue.assignedFirstName# #issue.assignedLastName#<cfelse><span class="g">&lt;none&gt;</span></cfif></td>
							</tr>
							<tr>
								<td class="label">Resolution:</td>
								<td><cfif compare(issue.resolution,'')>#issue.resolution#<cfelse><span class="g">&lt;none&gt;</span></cfif></td>
							</tr>
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
							<tr>
								<td class="label">Milestone:</td>
								<td><cfif compare(issue.milestoneID,'')><a href="milestone.cfm?p=#url.p#&m=#issue.milestoneID#">#issue.milestone#</a><cfelse><span class="g">&lt;none&gt;</span></cfif></td>
							</tr>							
						</table>
						</div>
						
					 	<table class="bug">
							<tr>
								<td class="label"><p>Detail:</p></td>
								<td>#issue.detail#</td>
							</tr>
							<cfif compare(issue.relevantURL,'')>
							<tr>
								<td class="label">Relevant URL:</td>
								<td><a href="#issue.relevantURL#" target="_new">#issue.relevantURL#</a></td>
							</tr>
							</cfif>
						</table>	
						
					 	<table class="bug">
						 	<cfif compare(issue.resolution,'')>
							<tr>
								<td class="label">Resolution:</td>
								<td>#issue.resolution#</td>
							</tr>
							</cfif>
							<cfif compare(issue.resolutionDesc,'')>
							<tr>
								<td class="label">Description:</td>
								<td>#issue.resolutionDesc#</td>
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
						<div class="commentbar"><span id="cnum">#comments.recordCount#</span> comment<cfif comments.recordCount neq 1>s</cfif> so far</div>
	
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
						#commentText#
						</div>
						</div>
						</cfloop>						
						
						<cfif project.issues eq 2>
						<form action="#cgi.script_name#?p=#url.p#&i=#url.i#" method="post" name="add" id="add" class="frm" onsubmit="return confirm_comment();">
						<div class="b">Post a new comment...</div>
						<cfscript>
							basePath = 'includes/fckeditor/';
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
		
						<input type="button" class="button" value="Preview" onclick="comment_preview();" /> or 
						<input type="submit" class="button" name="submit" value="Post Comment" />
						</form>
						</cfif>			
						
						
						<div class="commentbar">Audit Trail</div>
						<ul class="nobullet">
						<cfloop query="activity">
							<li class="collapsed"><span class="b">Ticket #activity#</span> by #firstName# #lastName# #request.udf.relativeTime(stamp)#</li> 
						</cfloop>
						</ul>
											
						
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