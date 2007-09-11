<cfsetting enablecfoutputonly="true">

<cfparam name="form.allowComments" default="0">
<cfparam name="form.notifylist" default="">
<cfif isDefined("form.messageID")>
	<cfset application.message.update(form.messageID,form.projectid,form.title,form.category,form.message,form.milestoneID,form.allowComments)>
	<cfset application.activity.add(createUUID(),form.projectid,session.user.userid,'Message',form.messageID,form.title,'edited')>
	<cflocation url="messages.cfm?p=#form.projectID#" addtoken="false">
<cfelseif isDefined("form.projectID")>
	<cfset newID = createUUID()>
	<cfset application.message.add(newID,form.projectID,form.title,form.category,form.message,form.milestoneID,form.allowComments,session.user.userid,form.notifylist)>
	<cfset application.activity.add(createUUID(),form.projectid,session.user.userid,'Message',newID,form.title,'added')>
	<cflocation url="messages.cfm?p=#form.projectID#" addtoken="false">
</cfif>

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
<cfset projectUsers = application.project.projectUsers(url.p)>
<cfset categories = application.message.categories(url.p)>
<cfset milestones = application.milestone.get(url.p)>

<cfparam name="title" default="">
<cfparam name="cat" default="">
<cfparam name="message" default="">
<cfparam name="msID" default="">
<cfparam name="variables.allowComments" default="1">
<cfparam name="title_action" default="Add">

<cfif isDefined("url.m")>
	<cfset thisMessage = application.message.get(url.p,url.m)>
	<cfset title = thisMessage.title>
	<cfset cat = thisMessage.category>
	<cfset message = thisMessage.message>
	<cfset msID = thisMessage.milestoneID>
	<cfset variables.allowComments = thisMessage.allowComments>
	<cfset title_action = "Edit">
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; #title_action# Message" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text="<script type='text/javascript'>
	function newMsgCat() {
		var newcat = prompt('Enter the new category name:','');
		var opt = new Option(newcat, newcat);
  		var sel = document.edit.category;
  		sel.options[sel.options.length] = opt;
		sel.selectedIndex = sel.options.length-1;		
	}
	function showNotify() {
		var targetContent = $('##notify');
		if (targetContent.css('display') == 'none') {
			targetContent.slideDown(300);
			$('##notifylinkbg').removeClass('collapsed');
			$('##notifylinkbg').addClass('expanded');
			$('##notifylink').addClass('notifybg');
		} else {
			targetContent.slideUp(300);
			$('##notifylinkbg').removeClass('expanded');
			$('##notifylink').removeClass('notifybg');
			$('##notifylinkbg').addClass('collapsed');
		}
		return false;	
	}
	function notify_all() {
		if ($('##everyone').attr('checked')==true) {
			$('##edit').checkCheckboxes(':not(.notoggle)');		
		} else $('##edit').unCheckCheckboxes(':not(.notoggle)');
	}
	function confirmSubmit() {
		var errors = '';
		var oEditor = FCKeditorAPI.GetInstance('message');
		if (document.edit.title.value == '') {errors = errors + '   ** You must enter a title.\n';}
		if (document.edit.category.value == '') {errors = errors + '   ** You must enter a category.\n';}
		if (oEditor.GetHTML() == '') {errors = errors + '   ** You must enter the message body.\n';}
		if (errors != '') {
			alert('Please correct the following errors:\n\n' + errors)
			return false;
		} else return true;
	}
	$(document).ready(function(){
	  	$('##title').focus();
	});	
</script>
<script type='text/javascript' src='./js/jquery.checkboxes.js'></script>">

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
					
					<h2 class="msg"><cfif isDefined("url.m")>Edit<cfelse>Add new</cfif> message</h2>
				</div>
				<div class="content">
				 	
					<form action="#cgi.script_name#" method="post" name="edit" id="edit" class="frm" onsubmit="return confirmSubmit();">
						<p>
						<label for="title" class="req">Title:</label>
						<input type="text" name="title" id="title" value="#title#" maxlength="120" />
						</p>
						<p>
						<label for="category" class="req">Category:</label>
						<select name="category" id="category">
							<option value="">Select Category...</option>
							<cfloop query="categories">
							<option value="#category#"<cfif not compare(cat,category)> selected="selected"</cfif>>#category#</option>
							</cfloop>
							<option value="" onclick="newMsgCat();">--- add new category ---</option>
						</select>
						</p>						
						<p>
						<label for="message" class="req">Message:</label> 
						<cfscript>
							basePath = '#application.settings.mapping#/includes/fckeditor/';
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
						
						<cfif projectUsers.recordCount gt 1>
						<p>
						<span id="notifylinkbg" class="collapsed">
						<label for="notifylink">Notify People:</label>
						<a href="##" onclick="showNotify();" id="notifylink"> Send copies of this message via email</a>
						</span>
						<span id="notify" style="display:none;">
						<ul class="nobullet">
						<li><input type="checkbox" id="everyone" class="checkbox notoggle" onclick="notify_all();" /><label for="everyone" class="list b">Everyone</label></li>
						<li><input type="checkbox" name="notifylist" class="checkbox" id="#session.user.userID#" value="#session.user.userID#" checked="checked" /><label for="#session.user.userID#" class="list">Myself</label>
						<cfloop query="projectUsers">
						<cfif compare(userID,session.user.userID)><li><input type="checkbox" name="notifylist" class="checkbox" id="#userID#" value="#userID#" /><label for="#userID#" class="list">#firstName# #lastName#</label></li></cfif>
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
						<cfif isDefined("url.m")>
							<input type="submit" class="button" name="submit" id="submit" value="Update Message" onclick="return confirmSubmit();" />
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