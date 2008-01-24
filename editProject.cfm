<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(url,"p") or StructKeyExists(form,"projectid")>
	<cfif StructKeyExists(url,"p")>
		<cfset userRole = application.role.get(session.user.userid,url.p)>
	<cfelse>
		<cfset userRole = application.role.get(session.user.userid,form.projectid)>
	</cfif>
	<cfif not listFind('Owner,Admin',userRole.role) and not session.user.admin>
		<cfoutput><h2>Project Owner or Admin Access Only!!!</h2></cfoutput>
		<cfabort>
	</cfif>
</cfif>

<cfparam name="form.display" default="0">
<cfparam name="form.from" default="">

<cfif StructKeyExists(url,"from")>
	<cfset form.from = url.from>
</cfif>

<cfif StructKeyExists(form,"projectID")> <!--- update project --->
	<cfset application.project.update(form.projectid,form.ownerID,form.name,form.description,form.display,form.clientID,form.status,form.ticketPrefix,form.svnurl,form.svnuser,form.svnpass)>
	<cfset application.activity.add(createUUID(),form.projectID,session.user.userid,'Project',form.projectID,form.name,'edited')>
	<cfif not compare(form.from,'admin')>
		<cflocation url="./admin/projects.cfm" addtoken="false">
	<cfelse>
		<cflocation url="project.cfm?p=#form.projectID#" addtoken="false">
	</cfif>
<cfelseif StructKeyExists(form,"submit")> <!--- add project --->
	<cfset newID = createUUID()>
	<cfset application.project.add(newID,session.user.userid,form.name,form.description,form.display,form.clientID,form.status,form.ticketPrefix,form.svnurl,form.svnuser,form.svnpass,session.user.userid)>
	<cfset application.role.add(newID,session.user.userid,'Owner')>
	<cfset application.activity.add(createUUID(),newID,session.user.userid,'Project',newID,form.name,'added')>
	<cfset session.user.projects = application.project.get(session.user.userid)>
	<cfif not compare(form.from,'admin')>
		<cflocation url="./admin/projects.cfm" addtoken="false">
	<cfelse>
		<cflocation url="project.cfm?p=#newID#" addtoken="false">
	</cfif>
<cfelseif StructKeyExists(url,"del") and hash(url.p) eq url.ph> <!--- delete project --->
	<cfset application.project.delete(url.p)>
	<cfset session.user.projects = application.project.get(session.user.userid)>
	<cflocation url="index.cfm" addtoken="false">
</cfif>

<cfparam name="projID" default="">
<cfparam name="form.name" default="">
<cfparam name="form.description" default="">
<cfparam name="form.form.display" default="1">
<cfparam name="form.clientID" default="">
<cfparam name="form.clientName" default="&lt;none&gt;">
<cfparam name="form.status" default="">
<cfparam name="form.ticketPrefix" default="">
<cfparam name="form.svnurl" default="">
<cfparam name="form.svnuser" default="">
<cfparam name="form.svnpass" default="">
<cfparam name="title_action" default="Add">

<cfif StructKeyExists(url,"p")>
	<cfset projID = url.p>
	<cfset thisProject = application.project.getDistinct(url.p)>
	<cfset form.ownerID = thisProject.ownerID>
	<cfset form.name = thisProject.name>
	<cfset form.description = thisProject.description>
	<cfset form.display = thisProject.display>
	<cfset form.clientID = thisProject.clientID>
	<cfset form.clientName = thisProject.clientName>
	<cfset form.status = thisProject.status>
	<cfset form.ticketPrefix = thisProject.ticketPrefix>
	<cfset form.svnurl = thisProject.svnurl>
	<cfset form.svnuser = thisProject.svnuser>
	<cfset form.svnpass = thisProject.svnpass>
	<cfset title_action = "Edit">
	<cfset projectUsers = application.project.projectUsers(url.p)>
</cfif>

<cfset clients = application.client.get()>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; #title_action# Project" project="#name#" projectid="#projID#" svnurl="#svnurl#">

<cfhtmlhead text="<script type='text/javascript'>
	function confirmSubmit() {
		var errors = '';
		if (document.edit.name.value == '') {errors = errors + '   ** You must enter a name.\n';}
		if (document.edit.ticketPrefix.value == '') {errors = errors + '   ** You must enter a ticket prefix.\n';}
		if (errors != '') {
			alert('Please correct the following errors:\n\n' + errors)
			return false;
		} else return true;
	}
	function svn_toggle() {
		var targetContent = $('##svninfo');
		if (targetContent.css('display') == 'none') {
			targetContent.slideDown(300);
			$('##svnlink').removeClass('collapsed');
			$('##svnlink').addClass('expanded');
			$('##svnurl').focus();
		} else {
			targetContent.slideUp(300);
			$('##svnlink').removeClass('expanded');
			$('##svnlink').addClass('collapsed');
		}
		return false;	
	}
	$(document).ready(function(){
	  	$('##name').focus();
	});
</script>">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<span class="rightmenu">
						<a href="javascript:history.back();" class="cancel">Cancel</a>
					</span>
					
					<h2 class="project"><cfif StructKeyExists(url,"p")>Edit<cfelse>Create a new</cfif> project</h2>
				</div>
				<div class="content">
				 	
					<form action="#cgi.script_name#" method="post" name="edit" id="edit" class="frm" onsubmit="return confirmSubmit();">
						<p>
						<label for="name" class="req">Name:</label>
						<input type="text" name="name" id="name" value="#HTMLEditFormat(form.name)#" maxlength="120" />
						</p>					
						<p>
						<label for="description">Description:</label> 
						<cfscript>
							basePath = 'includes/fckeditor/';
							fckEditor = createObject("component", "#basePath#fckeditor");
							fckEditor.instanceName	= "description";
							fckEditor.value			= '#form.description#';
							fckEditor.basePath		= basePath;
							fckEditor.width			= 460;
							fckEditor.height		= 220;
							fckEditor.ToolbarSet	= "Basic";
							fckEditor.create(); // create the editor.
						</cfscript>
						</p>
						<p style="font-size:.8em;">
						<label for="display">&nbsp;</label>
						<input type="checkbox" name="display" id="display" value="1" class="checkbox"<cfif form.display> checked="checked"</cfif> />Display description on overview page
						</p>
						
						<cfif StructKeyExists(url,"p")>
						<p>
						<label for="owner">Owner:</label>
						<select name="ownerID" id="owner">
							<cfloop query="projectUsers">
							<option value="#userID#"<cfif not compare(form.ownerID,userID)> selected="selected"</cfif>>#lastName#, #firstName#</option>
							</cfloop>
						</select>
						</p>
						</cfif>
						
						<p>
						<label for="client">Client:</label>
						<select name="clientID" id="client">
							<option value=""></option>
							<cfloop query="clients">
							<option value="#clientID#"<cfif not compare(form.clientID,clientID)> selected="selected"</cfif>>#name#</option>
							</cfloop>
						</select>
						</p>
						
						<p>
						<label for="status" class="req">Status:</label>
						<select name="status" id="status">
							<option value="Active"<cfif not compare(form.status,'Active')> selected="selected"</cfif>>Active</option>
							<option value="On-Hold"<cfif not compare(form.status,'On-Hold')> selected="selected"</cfif>>On-Hold</option>
							<option value="Archived"<cfif not compare(form.status,'Archived')> selected="selected"</cfif>>Archived</option>
						</select>
						</p>
						<p>
						<label for="ticketPrefix" class="req">Ticket Prefix:</label>
						<input type="text" name="ticketPrefix" id="ticketPrefix" value="#HTMLEditFormat(form.ticketPrefix)#" maxlength="2" style="width:50px" />
						<span style="font-size:.8em">(two-letter prefix used when generating trouble tickets)</span>
						</p>
						<fieldset style="border:0;border-top:2px solid ##d9eaf5;margin:0 0 0 50px;">
						<legend style="padding:0 3px;font-size:.9em;"><a href="##" onclick="svn_toggle();" class="<cfif not compare(form.svnurl,'')>collapsed<cfelse>expanded</cfif>" id="svnlink"> SVN Details</a></legend>
						<div id="svninfo"<cfif not compare(form.svnurl,'')> style="display:none"</cfif>>
						<p>
						<label for="svnurl">SVN URL:</label>
						<input type="text" name="svnurl" id="svnurl" value="#HTMLEditFormat(form.svnurl)#" maxlength="100" class="short" />
						</p>						
						<p>
						<label for="svnuser">SVN Username:</label>
						<input type="text" name="svnuser" id="svnuser" value="#HTMLEditFormat(form.svnuser)#" maxlength="20" class="short" />
						</p>						
						<p>
						<label for="svnpass">SVN Password:</label>
						<input type="text" name="svnpass" id="svnpass" value="#HTMLEditFormat(form.svnpass)#" maxlength="20" class="short" />
						</p>
						</div>
						</fieldset>
						<label for="submit">&nbsp;</label>
						<cfif StructKeyExists(url,"p")>
							<input type="submit" class="button" name="submit" id="submit" value="Update Project" />
							<input type="hidden" name="projectID" value="#url.p#" />
						<cfelse>
							<input type="submit" class="button" name="submit" id="submit" value="Add Project" />
						</cfif>
						<input type="hidden" name="from" value="#form.from#" />
						<input type="button" class="button" name="cancel" value="Cancel" onclick="history.back();" />
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

		<cfif StructKeyExists(url,"p")>
		<div class="header"><h3 class="delete">Delete this project?</h3></div>
		<div class="content">
			Deleting a project immediately and permanently deletes all the messages, milestones, and to-do lists associated with this project. There is no Undo so make sure you're absolutely sure you want to delete this project.<br /><br />

			<a href="#cgi.script_name#?p=#url.p#&ph=#hash(url.p)#&del" class="check" onclick="return confirm('Are you absolutely sure???\nPlease Note: there is no undo.')">Yes, I understand — delete this project</a>
		</div>
		</cfif>

	</div>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">