<cfsetting enablecfoutputonly="true">

<cfparam name="form.display" default="0">
<cfif isDefined("form.projectID")> <!--- update project --->
	<cfset application.project.update(form.projectid,form.name,form.description,form.display,form.status,form.ticketPrefix,form.svnurl,form.svnuser,form.svnpass)>
	<cfset application.activity.add(createUUID(),form.projectID,session.user.userid,'Project',form.projectID,form.name,'edited')>
	<cflocation url="project.cfm?p=#form.projectID#" addtoken="false">
<cfelseif isDefined("form.submit")> <!--- add project --->
	<cfset newID = createUUID()>
	<cfset application.project.add(newID,form.name,form.description,form.display,form.status,form.ticketPrefix,form.svnurl,form.svnuser,form.svnpass,session.user.userid)>
	<cfset application.role.add(newID,session.user.userid,'Owner')>
	<cfset application.activity.add(createUUID(),newID,session.user.userid,'Project',newID,form.name,'added')>
	<cfset session.user.projects = application.project.get(session.user.userid)>
	<cflocation url="project.cfm?p=#newID#" addtoken="false">
<cfelseif isDefined("url.del") and hash(url.p) eq url.ph> <!--- delete project --->
	<cfset application.project.delete(url.p)>
	<cfset session.user.projects = application.project.get(session.user.userid)>
	<cflocation url="index.cfm" addtoken="false">
</cfif>

<cfparam name="projID" default="">
<cfparam name="name" default="">
<cfparam name="description" default="">
<cfparam name="variables.display" default="1">
<cfparam name="status" default="">
<cfparam name="ticketPrefix" default="">
<cfparam name="svnurl" default="">
<cfparam name="svnuser" default="">
<cfparam name="svnpass" default="">
<cfparam name="title_action" default="Add">

<cfif isDefined("url.p")>
	<cfset projID = url.p>
	<cfset thisProject = application.project.get(session.user.userid,url.p)>
	<cfset userRole = application.role.get(session.user.userid,url.p)>
	<cfset name = thisProject.name>
	<cfset description = thisProject.description>
	<cfset variables.display = thisProject.display>
	<cfset status = thisProject.status>
	<cfset ticketPrefix = thisProject.ticketPrefix>
	<cfset svnurl = thisProject.svnurl>
	<cfset svnuser = thisProject.svnuser>
	<cfset svnpass = thisProject.svnpass>
	<cfset title_action = "Edit">
</cfif>

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
					
					<h2 class="project"><cfif isDefined("url.p")>Edit<cfelse>Create a new</cfif> project</h2>
				</div>
				<div class="content">
				 	
					<form action="#cgi.script_name#" method="post" name="edit" id="edit" class="frm" onsubmit="return confirmSubmit();">
						<p>
						<label for="name" class="req">Name:</label>
						<input type="text" name="name" id="name" value="#name#" maxlength="120" />
						</p>					
						<p>
						<label for="description">Description:</label> 
						<cfscript>
							basePath = '#application.settings.mapping#/includes/fckeditor/';
							fckEditor = createObject("component", "#basePath#fckeditor");
							fckEditor.instanceName	= "description";
							fckEditor.value			= '#description#';
							fckEditor.basePath		= basePath;
							fckEditor.width			= 460;
							fckEditor.height		= 220;
							fckEditor.ToolbarSet	= "Basic";
							fckEditor.create(); // create the editor.
						</cfscript>
						</p>
						<p style="font-size:.8em;">
						<label for="display">&nbsp;</label>
						<input type="checkbox" name="display" id="display" value="1" class="checkbox"<cfif variables.display> checked="checked"</cfif> />Display description on overview page
						</p>
						<p>
						<label for="status" class="req">Status:</label>
						<select name="status" id="status">
							<option value="Active"<cfif not compare(status,'Active')> selected="selected"</cfif>>Active</option>
							<option value="On-Hold"<cfif not compare(status,'On-Hold')> selected="selected"</cfif>>On-Hold</option>
							<option value="Archived"<cfif not compare(status,'Archived')> selected="selected"</cfif>>Archived</option>
						</select>
						</p>
						<p>
						<label for="ticketPrefix" class="req">Ticket Prefix:</label>
						<input type="text" name="ticketPrefix" id="ticketPrefix" value="#ticketPrefix#" maxlength="2" style="width:50px" />
						<span style="font-size:.8em">(two-letter prefix used when generating trouble tickets)</span>
						</p>
						<fieldset style="border:0;border-top:2px solid ##d9eaf5;margin:0 0 0 50px;">
						<legend style="padding:0 3px;font-size:.9em;"><a href="##" onclick="svn_toggle();" class="<cfif not compare(svnurl,'')>collapsed<cfelse>expanded</cfif>" id="svnlink"> SVN Details</a></legend>
						<div id="svninfo"<cfif not compare(svnurl,'')> style="display:none"</cfif>>
						<p>
						<label for="svnurl">SVN URL:</label>
						<input type="text" name="svnurl" id="svnurl" value="#svnurl#" maxlength="100" class="short" />
						</p>						
						<p>
						<label for="svnuser">SVN Username:</label>
						<input type="text" name="svnuser" id="svnuser" value="#svnuser#" maxlength="20" class="short" />
						</p>						
						<p>
						<label for="svnpass">SVN Password:</label>
						<input type="text" name="svnpass" id="svnpass" value="#svnpass#" maxlength="20" class="short" />
						</p>
						</div>
						</fieldset>
						<label for="submit">&nbsp;</label>
						<cfif isDefined("url.p")>
							<input type="submit" class="button" name="submit" id="submit" value="Update Project" />
							<input type="hidden" name="projectID" value="#url.p#" />
						<cfelse>
							<input type="submit" class="button" name="submit" id="submit" value="Add Project" />
						</cfif>
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

		<cfif isDefined("url.p")>
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