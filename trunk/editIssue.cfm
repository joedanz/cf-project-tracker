<cfsetting enablecfoutputonly="true">

<cfparam name="form.display" default="0">
<cfif isDefined("form.issueID")>
	<cfset application.issue.update(form.issueID,form.projectid,form.issue,form.detail,form.type,form.severity,form.status,form.assignedTo,form.relevantURL,session.user.userid)>
	<cfset application.activity.add(createUUID(),form.projectID,session.user.userid,'Issue',form.issueID,form.issue,'edited')>
	<cflocation url="issue.cfm?p=#form.projectID#&i=#form.issueID#" addtoken="false">
<cfelseif isDefined("form.submit")>
	<cfset newID = createUUID()>
	<cfset application.issue.add(newID,form.projectID,form.ticketPrefix,form.issue,form.detail,form.type,form.severity,form.status,form.assignedTo,form.relevantURL,session.user.userid)>
	<cfset application.activity.add(createUUID(),form.projectid,session.user.userid,'Issue',newID,form.issue,'added')>
	<cflocation url="issue.cfm?p=#form.projectID#&i=#newID#" addtoken="false">
<cfelseif isDefined("url.del") and hash(url.p) eq url.ph>
	<cfset application.project.delete(url.p)>
	<cflocation url="index.cfm" addtoken="false">
</cfif>

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
<cfset projectUsers = application.project.projectUsers(url.p)>

<cfparam name="issue" default="">
<cfparam name="detail" default="">
<cfparam name="type" default="Bug">
<cfparam name="severity" default="Normal">
<cfparam name="status" default="Open">
<cfparam name="assignedTo" default="#session.user.userID#">
<cfparam name="relevantURL" default="">
<cfparam name="title_action" default="Add">

<cfif isDefined("url.i")>
	<cfset issueID = url.i>
	<cfset thisIssue = application.issue.get(url.p,url.i)>
	<cfset issue = thisIssue.issue>
	<cfset detail = thisIssue.detail>
	<cfset type = thisIssue.type>
	<cfset severity = thisIssue.severity>
	<cfset status = thisIssue.status>
	<cfset assignedTo = thisIssue.assignedTo>
	<cfset relevantURL = thisIssue.relevantURL>
	<cfset title_action = "Edit">
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; #title_action# Issue" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text="<script type='text/javascript'>
	function confirmSubmit() {
		var errors = '';
		var oEditor = FCKeditorAPI.GetInstance('detail');
		if (document.edit.issue.value == '') {errors = errors + '   ** You must enter an issue.\n';}
		if (oEditor.GetHTML() == '') {errors = errors + '   ** You must enter the issue detail.\n';}
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
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<span class="rightmenu">
						<a href="javascript:history.back();" class="cancel">Cancel</a>
					</span>
					
					<h2 class="project"><cfif isDefined("url.i")>Edit<cfelse>Submit new</cfif> issue</h2>
				</div>
				<div class="content">
				 	
					<form action="#cgi.script_name#" method="post" name="edit" id="edit" class="frm" onsubmit="return confirmSubmit();">
						<p>
						<label for="issue" class="req">Issue:</label>
						<input type="text" name="issue" id="issue" value="#issue#" maxlength="120" />
						</p>					
						<p>
						<label for="detail" class="req">Detail:</label> 
						<cfscript>
							basePath = '#application.settings.mapping#/includes/fckeditor/';
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
						<label for="type" class="req">Type:</label>
						<select name="type" id="type">
							<option value="Bug"<cfif not compare(type,'Bug')> selected="selected"</cfif>>Bug</option>
							<option value="Enhancement"<cfif not compare(type,'Enhancement')> selected="selected"</cfif>>Enhancement</option>
						</select>
						</p>						
						<p>
						<label for="severity" class="req">Severity:</label>
						<select name="severity" id="severity">
							<option value="Critical"<cfif not compare(severity,'Critical')> selected="selected"</cfif>>Critical</option>
							<option value="Major"<cfif not compare(severity,'Major')> selected="selected"</cfif>>Major</option>
							<option value="Normal"<cfif not compare(severity,'Normal')> selected="selected"</cfif>>Normal</option>
							<option value="Minor"<cfif not compare(severity,'Minor')> selected="selected"</cfif>>Minor</option>
							<option value="Trivial"<cfif not compare(severity,'Trivial')> selected="selected"</cfif>>Trivial</option>
						</select>						
						</p>
						<p>
						<label for="status" class="req">Status:</label>
						<select name="status" id="status">
							<option value="Open"<cfif not compare(status,'Open')> selected="selected"</cfif>>Open</option>
							<option value="Closed"<cfif not compare(status,'Closed')> selected="selected"</cfif>>Closed</option>
						</select>
						</p>
						<p>
						<label for="forwho">Assign To:</label>
						<select name="assignedTo" id="forwho">
							<option value=""></option>
							<cfloop query="projectUsers">
							<option value="#userID#"<cfif not compare(assignedTo,userID)> selected="selected"</cfif>>#lastName#, #firstName#</option>
							</cfloop>
						</select>
						</p>
						<p>
						<label for="issue">Relevant URL:</label>
						<input type="text" name="relevantURL" id="relevantURL" value="#relevantURL#" maxlength="255" />
						</p>					
						<label for="submit">&nbsp;</label>
						<cfif isDefined("url.i")>
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