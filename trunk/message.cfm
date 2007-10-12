<cfsetting enablecfoutputonly="true">

<cfif isDefined("form.submit")>
	<cfset application.comment.add(createUUID(),url.p,url.m,'',session.user.userid,form.comment)>
<cfelseif isDefined("url.rn")>	
	<cfset application.message.removeNotify(url.p,url.m,url.rn)>
</cfif>

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
<cfset message = application.message.get(url.p,url.m)>
<cfset comments = application.comment.get(url.p,url.m)>
<cfset notifyList = application.message.getNotifyList(url.p,url.m)>
<cfset talkList = listAppend(valueList(comments.userID),message.userID)>
<cfset usersTalking = application.user.get('',talkList)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; #project.name#" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text='<script type="text/javascript" src="./js/comments.js"></script>
'>

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

			<div class="header">
				<span class="rightmenu">
					<a href="messages.cfm?p=#url.p#" class="back">Back</a>
					<cfif message.userID eq session.user.userID or session.user.admin>
						| <a href="editMessage.cfm?p=#url.p#&m=#url.m#&mh=#hash(url.m)#" class="edit">Edit</a>
						| <a href="messages.cfm?p=#url.p#&dm=#url.m#&dmh=#hash(url.m)#" class="delete" onclick="return confirm('Are you sure you wish to delete this message and all associated comments?')">Delete</a>
					</cfif>
				</span>
				
				<h2 class="msg">#message.title#</h2>
				<h4>posted by #message.firstName# #message.lastName# in <a href="messages.cfm?p=#url.p#&c=#URLEncodedFormat(message.category)#">#message.category#</a> on #DateFormat(message.stamp,"ddd, d mmm")# at #TimeFormat(message.stamp,"h:mmtt")#</h4>
				
			</div>
			<div class="content">
				<div class="wrapper msg">
				
					<div id="fs12">
					#message.message#
					<cfif compare(message.name,'')><div class="ms">Milestone: #message.name#</div></cfif>
					</div>
					
					<a name="comments" />
					<div id="commentbar"><span id="cnum">#comments.recordCount#</span> comment<cfif comments.recordCount neq 1>s</cfif> so far</div>

					<cfloop query="comments">
					<div id="#commentID#">
					<cfif userID eq session.user.userID or session.user.admin>
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
					
					<cfif compare(project.role,'Read-Only')>
					<form action="#cgi.script_name#?p=#url.p#&m=#url.m#" method="post" name="add" id="add" class="frm" onsubmit="return confirmSubmit();">
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
		<div class="header"><h3>Comment notification</h3></div>
		<div class="content">
			The following people will receive email notification when new comments are posted.
			<ul style="margin-top:5px;">
				<cfif listFind(valueList(notifyList.userID),session.user.userID)>
				<li>You (<a href="#cgi.script_name#?p=#url.p#&m=#url.m#&rn=#session.user.userID#">remove</a>)</li>
				</cfif>
				<cfloop query="notifyList">
					<cfif userID neq session.user.userID>
						<li>#firstName# #lastName#</li>
					</cfif>
				</cfloop>
			</ul>
		</div>

		<div class="header"><h3>Who's talking in this thread?</h3></div>
		<div class="content">
			<ul class="people">
				<cfloop query="usersTalking">
				<li<cfif currentRow neq recordCount> class="mb10"</cfif>><div class="b">#firstName# #lastName#</div>
				#email#<br /><cfif compare(phone,'')>#phone#</cfif></li>
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