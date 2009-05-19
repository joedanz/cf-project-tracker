<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(form,"submit")>
	<cfset application.comment.add(createUUID(),url.p,'file',url.f,session.user.userid,form.comment)>
</cfif>

<cfparam name="url.p" default="">
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset file = application.file.get(url.p,url.f)>
<cfset comments = application.comment.get(url.p,'file',url.f)>
<cfset talkList = valueList(comments.userID)>
<cfif not listLen(talkList)>
	<cfset talkList = listAppend(talkList,'000')>
</cfif>
<cfset usersTalking = application.user.get(userIDlist=talkList)>

<cfif not session.user.admin and not project.file_view>
	<cfoutput><h2>You do not have permission to access files!!!</h2></cfoutput>
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
					<a href="files.cfm?p=#url.p#" class="back">Back</a>
					<cfif file.uploadedBy eq session.user.userID or session.user.admin>
						| <a href="editFile.cfm?p=#url.p#&f=#url.f#&fh=#hash(url.f)#" class="edit">Edit</a>
						| <a href="files.cfm?p=#url.p#&df=#url.f#&dfh=#hash(url.f)#" class="delete" onclick="return confirm('Are you sure you wish to delete this file and all associated comments?')">Delete</a>
					</cfif>
				</span>
				
				<h2 class="files">#file.title#</h2>
				<h4>posted by #file.firstName# #file.lastName# in <a href="files.cfm?p=#url.p#&c=#file.categoryID#">#file.category#</a> on #DateFormat(file.uploaded,"ddd, d mmm")# at <cfif application.settings.clockHours eq 12>#TimeFormat(file.uploaded,"h:mmtt")#<cfelse>#TimeFormat(file.uploaded,"HH:mm")#</cfif></h4>
				
			</div>
			<div class="content">
				<div class="wrapper msg">
				
					<div id="fs12">
					#file.description#
					</div>
					
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
					<span class="b">#firstName# #lastName#</span> said on #DateFormat(stamp,"ddd, mmm d")# at <cfif application.settings.clockHours eq 12>#TimeFormat(stamp,"h:mmtt")#<cfelse>#TimeFormat(stamp,"HH:mm")#</cfif><br />
					#commentText#
					</div>
					</div>
					</cfloop>
					
					<cfif project.file_edit or session.user.admin>
					<form action="#cgi.script_name#?p=#url.p#&f=#url.f#" method="post" name="add" id="add" class="frm" onsubmit="return confirm_comment();">
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
			<img src="#application.settings.userFilesMapping#/projects/#project.logo_img#" border="0" alt="#project.name#" /><br />
		</cfif>

		<div class="header"><h3>Who's talking in this thread?</h3></div>
		<div class="content">
			<cfif not usersTalking.recordCount>
				<ul>
					<li>No Comments Yet</li>
				</ul>
			<cfelse>
				<ul class="people">
					<cfloop query="usersTalking">
					<li<cfif currentRow neq recordCount> class="mb10"</cfif>><div class="b">#firstName# #lastName#</div>
					#email#<br /><cfif compare(phone,'')>#phone#</cfif></li>
					</cfloop>
				</ul>			
			</cfif>
		</div>
	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">