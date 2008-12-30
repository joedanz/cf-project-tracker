<cfsetting enablecfoutputonly="true">

<cfparam name="form.display" default="0">
<cfparam name="form.fileslist" default="">
<cfif StructKeyExists(form,"issueID")> <!--- update issue --->
	<cfset application.issue.update(form.issueID,form.projectid,form.issue,form.detail,form.type,form.severity,form.componentID,form.versionID,form.dueDate,form.assignedTo,form.milestone,form.relevantURL,session.user.userid,form.fileslist)>
	<cfset application.activity.add(createUUID(),form.projectID,session.user.userid,'Issue',form.issueID,form.issue,'edited')>
	<cfset application.notify.issueUpdate(form.projectid,form.issueID)>
	<cflocation url="issue.cfm?p=#form.projectID#&i=#form.issueID#" addtoken="false">
<cfelseif StructKeyExists(form,"submit")> <!--- add issue --->
	<cfset newID = createUUID()>
	<cfset application.issue.add(newID,form.projectID,form.ticketPrefix,form.issue,form.detail,form.type,form.severity,form.componentID,form.versionID,form.dueDate,form.assignedTo,form.milestone,form.relevantURL,session.user.userid,form.fileslist)>
	<cfset application.activity.add(createUUID(),form.projectid,session.user.userid,'Issue',newID,form.issue,'created')>
	<cfset application.notify.issueNew(form.projectid,newID)>
	<cfif compare(trim(form.fileupload),'')>
		<cftry>
			<cfdirectory action="create" directory="#ExpandPath('./userfiles/')##form.projectID#">
			<cfcatch></cfcatch>
		</cftry>
		<cffile action="upload" filefield="fileupload" destination = "#ExpandPath('./userfiles/')##form.projectID#" nameConflict = "MakeUnique">
		<cfset newID2 = createUUID()>
		<cfset application.screenshot.add(newID2,newID,form.title,'',cffile.ClientFile,cffile.ServerFile,cffile.ClientFileExt,cffile.FileSize,session.user.userid)>
	</cfif>
	<cflocation url="issue.cfm?p=#form.projectID#&i=#newID#" addtoken="false">
<cfelseif StructKeyExists(url,"del") and hash(url.p) eq url.ph> <!--- delete issue --->
	<cfset application.project.delete(url.p)>
	<cflocation url="index.cfm" addtoken="false">
</cfif>

<cfparam name="url.p" default="">
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset components = application.project.component(url.p)>
<cfset versions = application.project.version(url.p)>
<cfset projectUsers = application.project.projectUsers(url.p)>
<cfset milestones = application.milestone.get(url.p,'','incomplete')>
<cfset files = application.file.get(url.p)>

<cfparam name="issue" default="">
<cfparam name="detail" default="">
<cfparam name="type" default="Bug">
<cfparam name="severity" default="Normal">
<cfparam name="componentID" default="">
<cfparam name="versionID" default="">
<cfparam name="dueDate" default="">
<cfparam name="assignedTo" default="#session.user.userID#">
<cfparam name="milestone" default="">
<cfparam name="relevantURL" default="">
<cfparam name="title_action" default="Add">
<!--- screenshot --->
<cfparam name="fileupload" default="">
<cfparam name="title" default="">

<cfif StructKeyExists(url,"i")>
	<cfif project.issues lt 2 and not session.user.admin>
		<cfoutput><h2>You do not have permission to edit issues!!!</h2></cfoutput>
		<cfabort>
	</cfif>
	<cfset issueID = url.i>
	<cfset thisIssue = application.issue.get(url.p,url.i)>
	<cfset issue = thisIssue.issue>
	<cfset detail = thisIssue.detail>
	<cfset type = thisIssue.type>
	<cfset severity = thisIssue.severity>
	<cfset componentID = thisIssue.componentID>
	<cfset versionID = thisIssue.versionID>
	<cfset dueDate = thisIssue.dueDate>
	<cfset assignedTo = thisIssue.assignedTo>
	<cfset milestone = thisIssue.milestoneID>
	<cfset relevantURL = thisIssue.relevantURL>
	<cfset title_action = "Edit">
	<cfset fileList = application.file.getFileList(url.p,url.i,'issue')>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; #title_action# Issue" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text="<script type='text/javascript'>
	$(document).ready(function(){
	  	$('##name').focus();
	  	$('.date-pick').datepicker();
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
					
					<h2 class="project"><cfif StructKeyExists(url,"i")>Edit<cfelse>Submit new</cfif> issue</h2>
				</div>
				<div class="content">
				 	
					<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="edit" id="edit" class="frm pb15" enctype="multipart/form-data" onsubmit="return confirmSubmitIssue();">
						<p>
						<label for="issue" class="req">Issue:</label>
						<input type="text" name="issue" id="issue" value="#HTMLEditFormat(issue)#" maxlength="120" />
						</p>					
						<p>
						<label for="detail" class="req">Detail:</label> 
						<cfscript>
							basePath = 'includes/fckeditor/';
							fckEditor = createObject("component", "#basePath#fckeditor");
							fckEditor.instanceName	= "detail";
							fckEditor.value			= '#detail#';
							fckEditor.basePath		= basePath;
							fckEditor.width			= 460;
							fckEditor.height		= 200;
							fckEditor.ToolbarSet	= "Basic";
							fckEditor.create(); // create the editor.
						</cfscript>&nbsp;
						</p>
						<p>
						<label for="type">Type:</label>
						<select name="type" id="type">
							<option value="Bug"<cfif not compare(type,'Bug')> selected="selected"</cfif>>Bug</option>
							<option value="Enhancement"<cfif not compare(type,'Enhancement')> selected="selected"</cfif>>Enhancement</option>
						</select>
						</p>						
						<p>
						<label for="severity">Severity:</label>
						<select name="severity" id="severity">
							<option value="Critical"<cfif not compare(severity,'Critical')> selected="selected"</cfif>>Critical</option>
							<option value="Major"<cfif not compare(severity,'Major')> selected="selected"</cfif>>Major</option>
							<option value="Normal"<cfif not compare(severity,'Normal')> selected="selected"</cfif>>Normal</option>
							<option value="Minor"<cfif not compare(severity,'Minor')> selected="selected"</cfif>>Minor</option>
							<option value="Trivial"<cfif not compare(severity,'Trivial')> selected="selected"</cfif>>Trivial</option>
						</select>						
						</p>
						<p>
						<label for="component">Component:</label>
						<select name="componentID" id="component" onChange="newIssueComponent(this.value);">
							<option value=""></option>
							<cfloop query="components">
								<option value="#componentID#"<cfif not compare(form.componentID,componentID)> selected="selected"</cfif>>#component#</option>
							</cfloop>
							<option value="new">--- add new component ---</option>
						</select>
						</p>
						<p>
						<label for="version">Version:</label>
						<select name="versionID" id="version" onChange="newIssueVersion(this.value);">
							<option value=""></option>
							<cfloop query="versions">
								<option value="#versionID#"<cfif not compare(form.versionID,versionID)> selected="selected"</cfif>>#version#</option>
							</cfloop>
							<option value="new">--- add new version ---</option>
						</select>
						</p>
						<p>
						<label for="dueDate">Due Date:</label>
						<input type="text" name="dueDate" id="dueDate" value="#DateFormat(dueDate,"mm/dd/yyyy")#" size="8" class="date-pick shortest" />
						</p>
						<cfif StructKeyExists(url,"i")>
						<p>
						<label for="forwho">Assign To:</label>
						<select name="assignedTo" id="forwho">
							<option value=""></option>
							<cfloop query="projectUsers">
							<option value="#userID#"<cfif not compare(assignedTo,userID)> selected="selected"</cfif>>#lastName#, #firstName#</option>
							</cfloop>
						</select>
						</p>
						<cfelse>
							<input type="hidden" name="assignedTo" value="">
						</cfif>
						<p>
						<label for="milestone">Milestone:</label>
						<select name="milestone" id="milestone">
							<option value="" class="i">None</option>
							<cfloop query="milestones">
							<option value="#milestoneID#"<cfif not compare(milestone,milestoneID)> selected="selected"</cfif>>#name#</option>
							</cfloop>
						</select>
						</p>
						
						<cfif files.recordCount>
						<p>
						<span id="fileslinkbg" class="<cfif StructKeyExists(url,"i") and fileList.recordCount gt 0>expanded<cfelse>collapsed</cfif>">
						<label for="notifylink">Files:</label>
						<a href="##" onclick="showFiles();return false;" id="fileslink"<cfif StructKeyExists(url,"i") and fileList.recordCount gt 0> class="notifybg"</cfif>> Associate project files with this issue</a>
						</span>
						<span id="files"<cfif StructKeyExists(url,"i") and fileList.recordCount gt 0> style="display:block;"</cfif>>
						<ul class="nobullet">
						<li><input type="checkbox" id="allfiles" class="checkbox filestoggle" onclick="files_all();" /><label for="allfiles" class="list b">All Files</label></li>
						<cfloop query="files">
							<li><input type="checkbox" name="fileslist" class="checkbox" id="#fileID#" value="#fileID#"<cfif StructKeyExists(url,"i") and listFind(valueList(fileList.fileid),fileID)> checked="checked"</cfif> /><label for="#fileID#" class="list">#title#</label></li>
						</cfloop>
						</ul>
						</span>
						</p>
						</cfif>						
											
						<p>
						<label for="issue">Relevant URL:</label>
						<input type="text" name="relevantURL" id="relevantURL" value="#HTMLEditFormat(relevantURL)#" maxlength="255" />
						</p>
						
						<cfif not StructKeyExists(url,"i")>
						<p>
						<label for="fileupload">Screenshot File:</label>
						<input type="file" name="fileupload" id="fileupload" value="#fileupload#" />
						</p>
						<p>
						<label for="title">Screenshot Title:</label>
						<input type="text" name="title" id="title" value="#HTMLEditFormat(title)#" maxlength="120" />
						</p>
						<br />
						</cfif>
						
						<label for="submit">&nbsp;</label>
						<cfif StructKeyExists(url,"i")>
							<input type="submit" class="button" name="submit" id="submit" value="Update Issue" />
							<input type="hidden" name="issueID" value="#url.i#" />
						<cfelse>
							<input type="submit" class="button" name="submit" id="submit" value="Add Issue" />
						</cfif>
						<input type="button" class="button" name="cancel" value="Cancel" onclick="history.back();" />
						<input type="hidden" name="projectID" value="#url.p#" />
						<input type="hidden" name="ticketPrefix" value="#project.ticketPrefix#" />
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



	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>	
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">