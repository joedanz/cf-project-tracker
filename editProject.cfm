<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(url,"p") or StructKeyExists(form,"projectid")>
	<cfif StructKeyExists(url,"p")>
		<cfset userRole = application.role.get(session.user.userid,url.p)>
	<cfelse>
		<cfset userRole = application.role.get(session.user.userid,form.projectid)>
	</cfif>
	<cfif not session.user.admin and (userRole.admin eq 0 or userRole.admin is '')>
		<cfoutput><h2>Admin Access Only!!!</h2></cfoutput>
		<cfabort>
	</cfif>
</cfif>

<cfparam name="form.display" default="0">
<cfparam name="form.from" default="">
<cfparam name="form.allow_reg" default="0">
<cfparam name="form.reg_active" default="0">
<cfparam name="form.reg_files" default="0">
<cfparam name="form.reg_issues" default="0">
<cfparam name="form.reg_msgs" default="0">
<cfparam name="form.reg_mstones" default="0">
<cfparam name="form.reg_todos" default="0">
<cfparam name="form.reg_svn" default="0">
<cfparam name="form.tab_files" default="0">
<cfparam name="form.tab_issues" default="0">
<cfparam name="form.tab_msgs" default="0">
<cfparam name="form.tab_mstones" default="0">
<cfparam name="form.tab_todos" default="0">
<cfparam name="form.tab_svn" default="0">

<cfif StructKeyExists(url,"from")>
	<cfset form.from = url.from>
</cfif>

<cfif StructKeyExists(form,"projectID")> <!--- update project --->
	<cfset application.project.update(form.projectid,form.ownerID,form.name,form.description,form.display,form.clientID,form.status,form.ticketPrefix,form.svnurl,form.svnuser,form.svnpass,form.allow_reg,form.reg_active,form.reg_files,form.reg_issues,form.reg_msgs,form.reg_mstones,form.reg_todos,form.reg_time,form.reg_svn,form.tab_files,form.tab_issues,form.tab_msgs,form.tab_mstones,form.tab_todos,form.tab_time,form.tab_svn)>
	<cfset application.activity.add(createUUID(),form.projectID,session.user.userid,'Project',form.projectID,form.name,'edited')>
	<cfif not compare(form.from,'admin')>
		<cflocation url="./admin/projects.cfm" addtoken="false">
	<cfelse>
		<cflocation url="project.cfm?p=#form.projectID#" addtoken="false">
	</cfif>
<cfelseif StructKeyExists(form,"submit")> <!--- add project --->
	<cfset newID = createUUID()>
	<cfset application.project.add(newID,session.user.userid,form.name,form.description,form.display,form.clientID,form.status,form.ticketPrefix,form.svnurl,form.svnuser,form.svnpass,form.allow_reg,form.reg_active,form.reg_files,form.reg_issues,form.reg_msgs,form.reg_mstones,form.reg_todos,form.reg_time,form.reg_svn,form.tab_files,form.tab_issues,form.tab_msgs,form.tab_mstones,form.tab_todos,form.tab_time,form.tab_svn,session.user.userid)>
	<cfset application.role.add(newID,session.user.userid,'1','2','2','2','2','2','1')>
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
	<cfset form.allow_reg = thisProject.allow_reg>
	<cfset form.reg_active = thisProject.reg_active>
	<cfset form.reg_files = thisProject.reg_files>
	<cfset form.reg_issues = thisProject.reg_issues>
	<cfset form.reg_msgs = thisProject.reg_msgs>
	<cfset form.reg_mstones = thisProject.reg_mstones>
	<cfset form.reg_time = thisProject.reg_time>
	<cfset form.reg_todos = thisProject.reg_todos>
	<cfset form.reg_svn = thisProject.reg_svn>
	<cfset form.tab_files = thisProject.tab_files>
	<cfset form.tab_issues = thisProject.tab_issues>
	<cfset form.tab_msgs = thisProject.tab_msgs>
	<cfset form.tab_mstones = thisProject.tab_mstones>
	<cfset form.tab_todos = thisProject.tab_todos>
	<cfset form.tab_time = thisProject.tab_time>
	<cfset form.tab_svn = thisProject.tab_svn>
	<cfset title_action = "Edit">
	<cfset projectUsers = application.project.projectUsers(url.p)>
</cfif>

<cfset clients = application.client.get()>
<cfset msgcats = application.message.getCatMsgs(url.p)>
<cfset filecats = application.file.getCatFiles(url.p)>
<cfset components = application.project.component()>
<cfset versions = application.project.version()>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; #title_action# Project" project="#name#" projectid="#projID#" svnurl="#svnurl#">

<cfhtmlhead text="<script type='text/javascript'>
	function confirmSubmit() {
		var errors = '';
		if (document.edit.name.value == '') {errors = errors + '   ** You must enter a name.\n';}
		if (errors != '') {
			alert('Please correct the following errors:\n\n' + errors)
			return false;
		} else return true;
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
				 	
					<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="edit" id="edit" class="frm" onsubmit="return confirmSubmit();">
						<fieldset class="settings">
						<legend><a href="##" onclick="section_toggle('general');return false;" class="collapsed" id="generallink"> General Info</a></legend>
							<div id="generalinfo"<cfif StructKeyExists(url,"p")> style="display:none;"</cfif>>
							<p>
							<label for="name" class="req">Name:</label>
							<input type="text" name="name" id="name" value="#HTMLEditFormat(form.name)#" maxlength="50" />
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
								<option value="" class="i">None</option>
								<cfloop query="clients">
								<option value="#clientID#"<cfif not compare(form.clientID,clientID)> selected="selected"</cfif>>#name#</option>
								</cfloop>
							</select>
							</p>
							
							<p>
							<label for="status">Status:</label>
							<select name="status" id="status">
								<option value="Active"<cfif not compare(form.status,'Active')> selected="selected"</cfif>>Active</option>
								<option value="On-Hold"<cfif not compare(form.status,'On-Hold')> selected="selected"</cfif>>On-Hold</option>
								<option value="Archived"<cfif not compare(form.status,'Archived')> selected="selected"</cfif>>Archived</option>
							</select>
							</p>
							</div>
						</fieldset>

						<fieldset class="settings">
						<legend><a href="##" onclick="section_toggle('tab');return false;" class="collapsed" id="tablink"> Features Enabled</a></legend>
						<div id="tabinfo" style="display:none;">
						<table class="clean full mb15 permissions">
							<tr>
								<th width="20%">&nbsp;</th>
								<th width="11%">Files</th>
								<th width="11%">Issues</th>
								<th width="11%">Messages</th>
								<th width="12%">Milestones</th>
								<th width="10%">To-Dos</th>
								<th width="15%">Time Tracking</th>
								<th width="10%">SVN</th>
							</tr>
							<tr>
								<td class="b">Feature Enabled</td>
								<td><input type="checkbox" name="tab_files" value="1" class="cb"<cfif form.tab_files eq 1> checked="checked"</cfif> /></td>
								<td><input type="checkbox" name="tab_issues" value="1" class="cb"<cfif form.tab_issues eq 1> checked="checked"</cfif> /></td>
								<td><input type="checkbox" name="tab_msgs" value="1" class="cb"<cfif form.tab_msgs eq 1> checked="checked"</cfif> /></td>
								<td><input type="checkbox" name="tab_mstones" value="1" class="cb"<cfif form.tab_mstones eq 1> checked="checked"</cfif> /></td>
								<td><input type="checkbox" name="tab_todos" value="1" class="cb"<cfif form.tab_todos eq 1> checked="checked"</cfif> /></td>
								<td><input type="checkbox" name="tab_time" value="1" class="cb"<cfif form.tab_time eq 1> checked="checked"</cfif> /></td>
								<td><input type="checkbox" name="tab_svn" value="1" class="cb"<cfif form.tab_svn eq 1> checked="checked"</cfif> /></td>
							</tr>
						</table>
						</div>
						</fieldset>

						<fieldset class="settings">
						<legend><a href="##" onclick="section_toggle('cat');return false;" class="collapsed" id="catlink"> Category Lists</a></legend>
						<div id="catinfo" style="display:none;">

						<table align="center">
							<tr><td>
								<p>
								<fieldset>
								<legend>File Categories</legend>
									<ul id="filecats">
										<cfloop query="filecats">
											<li id="filer#currentRow#">#currentRow#) #category# &nbsp; <a href="##" onclick="$('##filer#currentRow#').hide();$('##edit_filer#currentRow#').show();$('##filecat#currentRow#').focus();return false;">Edit</a> &nbsp;<cfif numFiles><span class="g i">(#numFiles# file<cfif numFiles gt 1>s</cfif>)</span><cfelse><a href="" onclick="confirm_cat_delete('#url.p#','#categoryID#','#category#','file');return false;" class="delete"></a></cfif></li>
											<li id="edit_filer#currentRow#" style="display:none;">
												<input type="text" id="filecat#currentRow#" value="#category#" class="short" />
												<input type="button" value="Save" onclick="edit_cat('#url.p#','#categoryID#','#currentRow#','file'); return false;" /> or <a href="##" onclick="$('##filer#currentRow#').show();$('##edit_filer#currentRow#').hide();return false;">Cancel</a>
											</li>
										</cfloop>
									</ul>
									<ul>
										<li id="addnewfile">-- <a href="##" onclick="$('##addnewfile').hide();$('##newrowfile').show();$('##fileCat').focus();return false;">New Category...</a></li>
										<li id="newrowfile" style="display:none;">
											<input type="text" id="fileCat" class="short" />
											<input type="button" value="Add" onclick="add_cat('#url.p#','file'); return false;" /> or <a href="##" onclick="$('##addnewfile').show();$('##newrowfile').hide();return false;">Cancel</a>
										</li>
									</ul>
								</fieldset>
								</p>
							</td><td>&nbsp;&nbsp;&nbsp;</td><td>
								<p>
								<fieldset>
								<legend>Message Categories</legend>
									<ul id="msgcats">
										<cfloop query="msgcats">
											<li id="msgr#currentRow#">#currentRow#) #category# &nbsp; <a href="##" onclick="$('##msgr#currentRow#').hide();$('##edit_msgr#currentRow#').show();$('##msgcat#currentRow#').focus();return false;">Edit</a> &nbsp;<cfif numMsgs><span class="g i">(#numMsgs# msgs)</span><cfelse><a href="" onclick="confirm_cat_delete('#url.p#','#categoryID#','#category#','msg');return false;" class="delete"></a></cfif></li>
											<li id="edit_msgr#currentRow#" style="display:none;">
												<input type="text" id="msgcat#currentRow#" value="#category#" class="short" />
												<input type="button" value="Save" onclick="edit_cat('#url.p#','#categoryID#','#currentRow#','msg'); return false;" /> or <a href="##" onclick="$('##msgr#currentRow#').show();$('##edit_msgr#currentRow#').hide();return false;">Cancel</a>
											</li>
										</cfloop>
									</ul>
									<ul>
										<li id="addnewmsg">-- <a href="##" onclick="$('##addnewmsg').hide();$('##newrowmsg').show();$('##msgCat').focus();return false;">New Category...</a></li>
										<li id="newrowmsg" style="display:none;">
											<input type="text" id="msgCat" class="short" />
											<input type="button" value="Add" onclick="add_cat('#url.p#','msg'); return false;" /> or <a href="##" onclick="$('##addnewmsg').show();$('##newrowmsg').hide();return false;">Cancel</a>
										</li>
									</ul>
								</fieldset>
								</p>
							</td></tr>
						</table>
						
						</div>
						</fieldset>

						<fieldset class="settings">
						<legend><a href="##" onclick="section_toggle('issue');return false;" class="collapsed" id="issuelink"> Issue Details</a></legend>
						<div id="issueinfo" style="display:none;">
						<p>
						<label for="ticketPrefix">Ticket Prefix:</label>
						<input type="text" name="ticketPrefix" id="ticketPrefix" value="#HTMLEditFormat(form.ticketPrefix)#" maxlength="2" style="width:80px" />
						<span style="font-size:.8em">(optional two-letter prefix used when generating trouble tickets)</span>
						</p>
						
						<table align="center">
							<tr><td>
								<p>
								<fieldset>
								<legend>Project Components</legend>
									<ul id="components">
										<cfloop query="components">
											<li id="componentr#currentRow#">#currentRow#) #component# &nbsp; <a href="##" onclick="$('##componentr#currentRow#').hide();$('##edit_componentr#currentRow#').show();$('##component#currentRow#').focus();return false;">Edit</a> &nbsp;<cfif numIssues><span class="g i">(#numIssues# issue<cfif numIssues gt 1>s</cfif>)</span><cfelse><a href="" onclick="confirm_item_delete('#url.p#','#componentID#','#component#','component');return false;" class="delete"></a></cfif></li>
											<li id="edit_componentr#currentRow#" style="display:none;">
												<input type="text" id="component#currentRow#" value="#component#" class="short" />
												<input type="button" value="Save" onclick="edit_proj_item('#url.p#','#componentID#','#currentRow#','component'); return false;" /> or <a href="##" onclick="$('##componentr#currentRow#').show();$('##edit_componentr#currentRow#').hide();return false;">Cancel</a>
											</li>
										</cfloop>
									</ul>
									<ul>
										<li id="addnewcomponent">-- <a href="##" onclick="$('##addnewcomponent').hide();$('##newrowcomponent').show();$('##newcomponent').focus();return false;">New Component...</a></li>
										<li id="newrowcomponent" style="display:none;">
											<input type="text" id="newcomponent" class="short" />
											<input type="button" value="Add" onclick="add_proj_item('#url.p#','component'); return false;" /> or <a href="##" onclick="$('##addnewcomponent').show();$('##newrowcomponent').hide();return false;">Cancel</a>
										</li>
									</ul>
								</fieldset>
								</p>
							</td><td>&nbsp;&nbsp;&nbsp;</td><td>
								<p>
								<fieldset>
								<legend>Project Versions</legend>
									<ul id="versions">
										<cfloop query="versions">
											<li id="versionr#currentRow#">#currentRow#) #version# &nbsp; <a href="##" onclick="$('##versionr#currentRow#').hide();$('##edit_versionr#currentRow#').show();$('##version#currentRow#').focus();return false;">Edit</a> &nbsp;<cfif numIssues><span class="g i">(#numIssues# issue<cfif numIssues gt 1>s</cfif>)</span><cfelse><a href="" onclick="confirm_item_delete('#url.p#','#versionID#','#version#','version');return false;" class="delete"></a></cfif></li>
											<li id="edit_versionr#currentRow#" style="display:none;">
												<input type="text" id="version#currentRow#" value="#version#" class="short" />
												<input type="button" value="Save" onclick="edit_proj_item('#url.p#','#versionID#','#currentRow#','version'); return false;" /> or <a href="##" onclick="$('##versionr#currentRow#').show();$('##edit_versionr#currentRow#').hide();return false;">Cancel</a>
											</li>
										</cfloop>
									</ul>
									<ul>
										<li id="addnewversion">-- <a href="##" onclick="$('##addnewversion').hide();$('##newrowversion').show();$('##newversion').focus();return false;">New Version...</a></li>
										<li id="newrowversion" style="display:none;">
											<input type="text" id="newversion" class="short" />
											<input type="button" value="Add" onclick="add_proj_item('#url.p#','version'); return false;" /> or <a href="##" onclick="$('##addnewversion').show();$('##newrowversion').hide();return false;">Cancel</a>
										</li>
									</ul>								
								</fieldset>
								</p>
							</td></tr>
						</table>

						</div>
						</fieldset>
					
						<fieldset class="settings">
						<legend><a href="##" onclick="section_toggle('svn');return false;" class="collapsed" id="svnlink"> SVN Settings</a></legend>
						<div id="svninfo" style="display:none;">
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
						<input type="password" name="svnpass" id="svnpass" value="#HTMLEditFormat(form.svnpass)#" maxlength="20" class="short" />
						</p>
						</div>
						</fieldset>

						<fieldset class="settings">
						<legend><a href="##" onclick="section_toggle('gr');return false;" class="collapsed" id="grlink"> Self Registrations</a></legend>
						<div id="grinfo" style="display:none;">
							<p>
							<label for="allowreg" class="full">Allow users to self-register for this project?</label>
							<input type="checkbox" name="allow_reg" id="allowreg" class="checkbox" value="1"<cfif form.allow_reg eq 1> checked="checked"</cfif> />
							</p>

							<table class="clean full mb15 permissions">
							<tr>
								<th>&nbsp;</th>
								<th>Active</th>
								<th>Files</th>
								<th>Issues</th>
								<th>Messages</th>
								<th>Milestones</th>
								<th>To-Dos</th>
								<th>Time Tracking</th>
								<th>SVN</th>
							</tr>
							<tr>
								<td class="b">Default Permissions</td>
								<td><input type="checkbox" name="reg_active" value="1" class="cb"<cfif form.reg_active eq 1> checked="checked"</cfif> /></td>
								<td>
									<select name="reg_files">
										<option value="2"<cfif form.reg_files eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif form.reg_files eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif form.reg_files eq 0> selected="selected"</cfif>>None</option>
									</select>
								</td>
								<td>
									<select name="reg_issues">
										<option value="2"<cfif form.reg_issues eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif form.reg_issues eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif form.reg_issues eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td>
									<select name="reg_msgs">
										<option value="2"<cfif form.reg_msgs eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif form.reg_msgs eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif form.reg_msgs eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td>
									<select name="reg_mstones">
										<option value="2"<cfif form.reg_mstones eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif form.reg_mstones eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif form.reg_mstones eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td>
									<select name="reg_todos">
										<option value="2"<cfif form.reg_todos eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif form.reg_todos eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif form.reg_todos eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td>
									<select name="reg_time">
										<option value="2"<cfif form.reg_time eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif form.reg_time eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif form.reg_time eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td><input type="checkbox" name="reg_svn" value="1" class="cb"<cfif form.reg_svn eq 1> checked="checked"</cfif> /></td>
							</tr>
							</table>
						</div>
						</fieldset>	
						
						<label for="submit" class="none">&nbsp;</label>
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