<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(form,"todolistID")> <!--- update todo list --->
	<cfset application.todolist.update(form.todolistID,form.projectid,form.title,form.description,form.milestoneID)>
	<cfset application.activity.add(createUUID(),form.projectID,session.user.userid,'To-Do List',form.projectID,form.title,'edited')>
	<cflocation url="todos.cfm?p=#form.projectID#" addtoken="false">
<cfelseif StructKeyExists(form,"submit")> <!--- add todo list --->
	<cfset newID = createUUID()>
	<cfset application.todolist.add(newID,form.projectID,form.title,form.description,form.milestoneID,session.user.userid)>
	<cfset application.activity.add(createUUID(),form.projectID,session.user.userid,'To-Do List',newID,form.title,'added')>
	<cflocation url="todos.cfm?p=#form.projectID#" addtoken="false">
</cfif>

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
<cfset milestones = application.milestone.get(url.p)>

<cfparam name="title" default="">
<cfparam name="description" default="">
<cfparam name="msID" default="">
<cfparam name="title_action" default="Add">

<cfif StructKeyExists(url,"t")>
	<cfset thisTodolist = application.todolist.get(url.p,url.t)>
	<cfset title = thisTodolist.title>
	<cfset description = thisTodolist.description>
	<cfset msID = thisTodolist.milestoneID>
	<cfset title_action = "Edit">
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; #title_action# To-Do List" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text="<script type='text/javascript'>
	function confirmSubmit() {
		var errors = '';
		var oEditor = FCKeditorAPI.GetInstance('description');
		if (document.edit.title.value == '') {errors = errors + '   ** You must enter a title.\n';}
//		if (oEditor.GetHTML() == '') {errors = errors + '   ** You must enter the project description.\n';}
		if (errors != '') {
			alert('Please correct the following errors:\n\n' + errors)
			return false;
		} else return true;
	}
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
					
					<h2 class="project"><cfif StructKeyExists(url,"t")>Edit<cfelse>Add new</cfif> to-do list</h2>
				</div>
				<div class="content">
				 	
					<form action="#cgi.script_name#" method="post" name="edit" id="edit" class="frm" onsubmit="return confirmSubmit();">
						<p>
						<label for="title" class="req">Title:</label>
						<input type="text" name="title" id="title" value="#HTMLEditFormat(title)#" maxlength="100" />
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
							fckEditor.height		= 150;
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
						<label for="submit">&nbsp;</label>
						<cfif StructKeyExists(url,"t")>
							<input type="submit" class="button" name="submit" id="submit" value="Update To-Do List" />
							<input type="hidden" name="todolistID" value="#url.t#" />
						<cfelse>
							<input type="submit" class="button" name="submit" id="submit" value="Add To-Do List" />
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

	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>	
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">