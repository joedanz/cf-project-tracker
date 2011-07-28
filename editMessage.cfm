<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfparam name="form.allowComments" default="0">
<cfparam name="form.notifylist" default="">
<cfparam name="form.fileslist" default="">
<cfif StructKeyExists(form,"messageID")> <!--- update message --->
	<cfif not compare(form.message,'<br />')>
		<cfset form.message = "">
	</cfif>
	<cfset application.message.update(form.messageID,form.projectid,form.title,form.category,form.message,form.milestoneID,form.allowComments,session.user.userid,form.notifylist,form.fileslist)>
	<cfset application.activity.add(createUUID(),form.projectid,session.user.userid,'Message',form.messageID,form.title,'edited')>
	<cflocation url="messages.cfm?p=#form.projectID#" addtoken="false">
<cfelseif StructKeyExists(form,"projectID")> <!--- add message --->
	<cfset newID = createUUID()>
	<cfif not compare(form.message,'<br />')>
		<cfset form.message = "">
	</cfif>
	<cfset application.message.add(newID,form.projectID,form.title,form.category,form.message,form.milestoneID,form.allowComments,session.user.userid,form.notifylist,form.fileslist)>
	<cfset application.activity.add(createUUID(),form.projectid,session.user.userid,'Message',newID,form.title,'added')>
	<cflocation url="messages.cfm?p=#form.projectID#" addtoken="false">
</cfif>

<cfif not StructKeyExists(url,'p')>
	<cfoutput><h2>No Project Selected!</h2></cfoutput><cfabort>
</cfif>

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset projectUsers = application.project.projectUsers(url.p)>
<cfset categories = application.category.get(url.p,'msg')>
<cfset milestones = application.milestone.get(url.p)>
<cfset files = application.file.get(url.p)>

<cfif not session.user.admin and not project.msg_edit eq 1>
	<cfoutput><h2>You do not have permission to <cfif StructKeyExists(url,"m")>edit<cfelse>add</cfif> messages!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfparam name="title" default="">
<cfparam name="catID" default="">
<cfparam name="message" default="">
<cfparam name="msID" default="">
<cfparam name="variables.allowComments" default="1">
<cfparam name="title_action" default="Add">

<cfif StructKeyExists(url,"m")>
	<cfif not compare(hash(url.m),url.mh)>
		<cfset thisMessage = application.message.get(url.p,url.m)>
		<cfset title = thisMessage.title>
		<cfset catID = thisMessage.categoryID>
		<cfset message = thisMessage.message>
		<cfset msID = thisMessage.milestoneID>
		<cfset variables.allowComments = thisMessage.allowComments>
		<cfset title_action = "Edit">
		<cfset notifyList = application.message.getNotifyList(url.p,url.m)>
		<cfset fileList = application.file.getFileList(url.p,url.m,'msg')>
	<cfelse>
		<cfoutput>
			<h1>Security Alert!</h1>
			<h2>You must be the message creator or an admin to edit this message.</h2>
		</cfoutput>
		<cfabort>
	</cfif>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; #title_action# Message" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text="<script type='text/javascript'>
	$(document).ready(function(){
	  	$('##title').focus();
	});	
</script>">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<span class="rightmenu">
						<a href="javascript:history.back();" class="cancel">Cancel</a>
					</span>
					
					<h2 class="msg"><cfif StructKeyExists(url,"m")>Edit<cfelse>Add new</cfif> message</h2>
				</div>
				<div class="content">
				 	
					<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="edit" id="edit" class="frm pb15" onsubmit="return confirmSubmitMsg();">
						<p>
						<label for="title" class="req">Title:</label>
						<input type="text" name="title" id="title" value="#HTMLEditFormat(title)#" maxlength="120" />
						</p>
						<p>
						<label for="category" class="req">Category:</label>
						<select name="category" id="category" onChange="newMsgCat(this.value);">
							<option value="">Select Category...</option>
							<cfloop query="categories">
							<option value="#categoryID#"<cfif not compare(catID,categoryID)> selected="selected"</cfif>>#category#</option>
							</cfloop>
							<option value="new">--- add new category ---</option>
						</select>
						</p>						
						<p>
						<label for="message" class="req">Message:</label> 
						<cfscript>
							basePath = 'includes/fckeditor/';
							fckEditor = createObject("component", "#basePath#fckeditor");
							fckEditor.instanceName	= "message";
							fckEditor.value			= '#message#';
							fckEditor.basePath		= basePath;
							fckEditor.width			= 460;
							fckEditor.height		= 300;
							fckEditor.ToolbarSet	= "Basic";
							fckEditor.create(); // create the editor.
						</cfscript>&nbsp;
						</p>
				
						<p>
						<label for="milestone">Milestone:</label>
						<select name="milestoneID" id="milestone">
							<option value="0">None</option>
							<cfloop query="milestones">
							<option value="#milestoneID#"<cfif not compare(msID,milestoneID)> selected="selected"</cfif>>#name#</option>
							</cfloop>
						</select>
						</p>				
						
						<cfif files.recordCount>
						<p>
						<span id="fileslinkbg" class="<cfif StructKeyExists(url,"m") and fileList.recordCount gt 0>expanded<cfelse>collapsed</cfif>">
						<label for="notifylink">Files:</label>
						<a href="##" onclick="showFiles();return false;" id="fileslink"<cfif StructKeyExists(url,"m") and fileList.recordCount gt 0> class="notifybg"</cfif>> Associate project files with this message</a>
						</span>
						<span id="files"<cfif StructKeyExists(url,"m") and fileList.recordCount gt 0> style="display:block;"</cfif>>
						<ul class="nobullet">
						<li><input type="checkbox" id="allfiles" class="checkbox filestoggle" onclick="files_all();" /><label for="allfiles" class="list b">All Files</label></li>
						<cfloop query="files">
							<li><input type="checkbox" name="fileslist" class="checkbox" id="#fileID#" value="#fileID#"<cfif StructKeyExists(url,"m") and listFind(valueList(fileList.fileid),fileID)> checked="checked"</cfif> /><label for="#fileID#" class="list">#title#</label></li>
						</cfloop>
						</ul>
						</span>
						</p>
						</cfif>
						
						<cfif projectUsers.recordCount gt 1>
						<p>
						<span id="notifylinkbg" class="collapsed">
						<label for="notifylink">Notify People:</label>
						<a href="##" onclick="showNotify();return false;" id="notifylink"> Send a copy of message comments &amp; updates to...</a>
						</span>
						<span id="notify" style="display:none;">
						<ul class="nobullet">
						<li><input type="checkbox" id="everyone" class="checkbox notoggle" onclick="notify_all();"<cfif not StructKeyExists(url,"m")> checked="checked"</cfif> /><label for="everyone" class="list b">Everyone</label></li>
						<li><input type="checkbox" name="notifylist" class="checkbox" id="#session.user.userID#" value="#session.user.userID#" onchange="if (!$('###session.user.userid#').is(':checked')) $('##everyone').attr('checked','');"<cfif (StructKeyExists(url,"m") and (listFind(valueList(notifyList.userid),session.user.userID))) or not StructKeyExists(url,"m")> checked="checked"</cfif> /><label for="#session.user.userID#" class="list">Myself</label>
						<cfloop query="projectUsers">
						<cfif compare(userID,session.user.userID)><li><input type="checkbox" name="notifylist" class="checkbox" id="#userID#" value="#userID#" onchange="if (!$('###userid#').is(':checked')) $('##everyone').attr('checked','');"<cfif not StructKeyExists(url,"m") or (listFind(valueList(notifyList.userid),userID))> checked="checked"</cfif> /><label for="#userID#" class="list">#firstName# #lastName#</label></li></cfif>
						</cfloop>
						</ul>
						</span>
						</p>
						</cfif>

						<p>
						<label for="comments">Allow Comments?</label>
						<input type="checkbox" name="allowComments" id="comments" value="1" class="checkbox notoggle"<cfif variables.allowComments> checked="checked"</cfif> />
						</p>
						
						<label for="submit">&nbsp;</label>
						<cfif StructKeyExists(url,"m")>
							<input type="submit" class="button" name="submit" id="submit" value="Update Message" />
							<input type="hidden" name="messageID" value="#url.m#" />
						<cfelse>
							<input type="submit" class="button" name="submit" id="submit" value="Add Message" />
						</cfif>
						<input type="button" class="button" name="cancel" value="Cancel" onclick="history.back();" />
						<input type="hidden" name="projectID" value="#url.p#" />
					</form>				 	

				</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">
	<!---
		<div class="textheader"><h3>Categories</h3></div>
		<div class="content">
			<ul>
			</ul>
		</div>
	--->	
	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">