<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif StructKeyExists(form,"submit")>
	<cfset application.comment.add(createUUID(),url.p,'msg',url.m,session.user.userid,form.comment)>
<cfelseif StructKeyExists(url,"rn")>
	<cfset application.message.removeNotify(url.p,url.m,url.rn)>
</cfif>

<cfif not StructKeyExists(url,'p')>
	<cfoutput><h2>No Project Selected!</h2></cfoutput><cfabort>
</cfif>

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset message = application.message.get(url.p,url.m)>
<cfset comments = application.comment.get(url.p,'msg',url.m)>
<cfset attachments = application.file.getFileList(url.p,url.m,'msg')>
<cfset notifyList = application.message.getNotifyList(url.p,url.m)>
<cfset talkList = listAppend(valueList(comments.userID),message.userID)>
<cfset usersTalking = application.user.get(userIDlist=talkList)>

<cfif not session.user.admin and not project.msg_view eq 1>
	<cfoutput><h2>You do not have permission to access messages!!!</h2></cfoutput>
	<cfabort>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; #project.name#" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

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
						| <a href="editMessage.cfm?p=#url.p#&amp;m=#url.m#&amp;mh=#hash(url.m)#" class="edit">Edit</a>
						| <a href="messages.cfm?p=#url.p#&amp;dm=#url.m#&amp;dmh=#hash(url.m)#" class="delete" onclick="return confirm('Are you sure you wish to delete this message and all associated comments?')">Delete</a>
					</cfif>
				</span>
				
				<h2 class="msg">#message.title#</h2>
				<h4>posted by #message.firstName# #message.lastName# in <a href="messages.cfm?p=#url.p#&amp;c=#message.categoryID#">#message.category#</a> on #LSDateFormat(DateAdd("h",session.tzOffset,message.stamp),"ddd, d mmm")# at <cfif application.settings.clockHours eq 12>#LSTimeFormat(DateAdd("h",session.tzOffset,message.stamp),"h:mmtt")#<cfelse>#LSTimeFormat(DateAdd("h",session.tzOffset,message.stamp),"HH:mm")#</cfif></h4>
				
			</div>
			<div class="content">
				<div class="wrapper itemlist">
				
					<div id="fs12">
					<p>#message.message#</p>
					<cfif compare(message.name,'')><div class="ms">Milestone: #message.name#</div></cfif>
					</div>
					
					<cfif attachments.recordCount>
					<a name="attach"></a>
					<div class="commentbar">#attachments.recordCount# project file<cfif attachments.recordCount neq 1>s are<cfelse> is</cfif> associated with this message</div>
					<ul class="filelist">
						<cfloop query="attachments">
						<li><a href="download.cfm?p=#url.p#&amp;f=#fileID#" class="#lcase(filetype)#">#filename#</a> in &quot;#category#&quot; <span class="g i">(#ceiling(filesize/1024)#K - #LSDateFormat(DateAdd("h",session.tzOffset,uploaded),"medium")#)</span></li>
						</cfloop>
					</ul>
					</cfif>
					
					<a name="comments"></a>
					<div class="commentbar"><span id="cnum">#comments.recordCount#</span> comment<cfif comments.recordCount neq 1>s</cfif> so far</div>

					<cfloop query="comments">
					<div id="#commentID#">
					<cfif userID eq session.user.userID or session.user.admin>
					<a href="##" onclick="return delete_comment('#commentID#');"><img src="./images/delete.gif" height="16" width="16" border="0" style="float:right;padding:5px;" /></a>
					</cfif>
					<cfif application.isCF8 or application.isBD or application.isRailo>
					<img src="<cfif avatar>#application.settings.userFilesMapping#/avatars/#userID#_48.jpg<cfelse>./images/noavatar48.gif</cfif>" height="48" width="48" border="0" style="float:left;border:1px solid ##ddd;" />
					</cfif>
					<div class="commentbody">
					<span class="b">#firstName# #lastName#</span> said on #LSDateFormat(DateAdd("h",session.tzOffset,stamp),"ddd, mmm d")# at <cfif application.settings.clockHours eq 12>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"h:mmtt")#<cfelse>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"HH:mm")#</cfif><br />
					#commentText#
					</div>
					</div>
					</cfloop>
					
					<cfif session.user.admin or project.msg_edit eq 1>
					<form action="#cgi.script_name#?p=#url.p#&amp;m=#url.m#" method="post" name="add" id="add" class="frm" onsubmit="return confirm_comment();">
					<div class="b">Post a new comment...</div>
					<cfif session.mobileBrowser>
						<textarea name="comment" id="comment"></textarea>
					<cfelse>
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
					</cfif>
	
					<div id="preview" class="sm" style="display:none;margin:15px 0;">
					<fieldset style="padding:0;"><legend style="padding:0 5px;font-weight:bold;font-size:1em;">Comment Preview (<a href="##" onclick="$('##preview').hide();">X</a>)</legend>
					<div id="commentbody"></div>
					</fieldset>
					</div>
	
					<input type="button" class="button" value="Preview" onclick="comment_preview();" /> or 
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
		<cfif compare(project.logo_img,'')>
			<img src="#application.settings.userFilesMapping#/projects/#project.logo_img#" border="0" alt="#project.name#" class="projlogo" />
		</cfif>

		<div class="header"><h3>Comment notification</h3></div>
		<div class="content">
			The following people will receive email notification when new comments are posted.
			<ul style="margin-top:5px;">
				<cfif listFind(valueList(notifyList.userID),session.user.userID)>
				<li>You (<a href="#cgi.script_name#?p=#url.p#&amp;m=#url.m#&amp;rn=#session.user.userID#">remove</a>)</li>
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