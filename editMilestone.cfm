<cfsetting enablecfoutputonly="true">

<cfparam name="form.completed" default="0">
<cfif StructKeyExists(form,"milestoneID")> <!--- update milestone --->
	<cfset application.milestone.update(form.milestoneID,form.projectid,form.name,createDate(form.y,form.m,form.d),form.description,form.forID,form.rate,form.completed)>
	<cfset application.activity.add(createUUID(),form.projectid,session.user.userid,'Milestone',form.milestoneID,form.name,'edited')>
	<cfset application.notify.milestoneUpdate(form.projectid,form.milestoneID)>
	<cfif StructKeyExists(url,"one")>
		<cflocation url="milestone.cfm?p=#form.projectID#&m=#form.milestoneid#" addtoken="false">
	<cfelse>
		<cflocation url="milestones.cfm?p=#form.projectID#" addtoken="false">
	</cfif>
<cfelseif StructKeyExists(form,"projectID")> <!--- add milestone --->
	<cfset newID = createUUID()>
	<cfset application.milestone.add(newID,form.projectID,form.name,createDate(form.y,form.m,form.d),form.description,form.forID,form.rate,form.completed,session.user.userid)>
	<cfset application.activity.add(createUUID(),form.projectid,session.user.userid,'Milestone',newID,form.name,'added')>
	<cfset application.notify.milestoneNew(form.projectid,newID)>
	<cflocation url="milestones.cfm?p=#form.projectID#" addtoken="false">
</cfif>

<cfparam name="url.p" default="">
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset projectUsers = application.project.projectUsers(url.p)>

<cfif not session.user.admin and project.mstones lt 2>
	<cfoutput><h2>You do not have permission to <cfif StructKeyExists(url,"m")>edit<cfelse>add</cfif> milestones!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfparam name="thisDay" default="#Day(Now())#">
<cfparam name="thisMonth" default="#Month(Now())#">
<cfparam name="thisYear" default="#Month(Now())#">
<cfparam name="name" default="">
<cfparam name="description" default="">
<cfparam name="rate" default="">
<cfparam name="variables.isCompleted" default="false">
<cfparam name="title_action" default="Add">

<cfif StructKeyExists(url,"m")>
	<cfset thisMilestone = application.milestone.get(url.p,url.m)>
	<cfset thisDay = datePart("d",thisMilestone.dueDate)>
	<cfset thisMonth = datePart("m",thisMilestone.dueDate)>
	<cfset thisYear = datePart("yyyy",thisMilestone.dueDate)>
	<cfset name = thisMilestone.name>
	<cfset description = thisMilestone.description>
	<cfset rate = thisMilestone.rate>
	<cfset variables.isCompleted = isDate(thisMilestone.completed)>
	<cfset title_action = "Edit">
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; #title_action# Milestone" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text="<script type='text/javascript'>
	function confirmSubmit() {
		var errors = '';
		if (document.edit.name.value == '') {errors = errors + '   ** You must enter a milestone name.\n';}
		if (errors != '') {
			alert('Please correct the following errors:\n\n' + errors)
			return false;
		} else return true;
	}
	$(document).ready(function(){
	  	$('##name').focus();
	  	$('##duedate').jcalendar();
	});
</script>
<script type='text/javascript' src='#application.settings.mapping#/js/jcalendar.js'></script>
<link rel='stylesheet' href='#application.settings.mapping#/css/jcalendar.css' media='screen,projection' type='text/css' />
">

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
					
					<h2 class="msg"><cfif StructKeyExists(url,"m")>Edit<cfelse>Add new</cfif> milestone &nbsp;<span style="font-size:.75em;font-weight:normal;color:##666;">Today is #DateFormat(Now(),"d mmm")#</h2>
				</div>
				<div class="content">
				 	
					<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="edit" id="edit" class="frm pb15" onsubmit="return confirmSubmit();">
						
		<div style="padding:0 15px;float:left;margin-bottom:50px;border-right:2px solid ##ddd;height:400px;">

		<strong>* When is it due?</strong>
		<div id="duedate">
       <div class="jcalendar-wrapper">
       <div class="jcalendar-selects">
         <select name="d" id="day" class="jcalendar-select-day">
           <option value="0"></option>
			<cfloop from="1" to="31" index="i">
				<option value="#i#"<cfif thisDay eq i> selected="selected"</cfif>>#i#</option>
			</cfloop>
         </select>
         <select name="m" id="month" class="jcalendar-select-month">
           <option value="0"></option>
			<cfloop from="1" to="12" index="i">
				<option value="#i#"<cfif thisMonth eq i> selected="selected"</cfif>>#MonthAsString(i)#</option>
			</cfloop>
         </select>
         <select name="y" id="year" class="jcalendar-select-year">
           <option value="0"></option>
			<cfloop from="#Year(Now())-1#" to="#Year(Now())+5#" index="i">
				<option value="#i#"<cfif thisYear eq i> selected="selected"</cfif>>#i#</option>
			</cfloop>
         </select>
       </div>
       </div>
		</div>
		
		</div>
		<div>
		

						
						<div style="margin:10px 0;">
						<label for="name" class="req">Name:</label>
						<input type="text" name="name" id="name" value="#HTMLEditFormat(name)#" maxlength="50" style="width:350px;padding:2px;" />
						</div>
						
						
						<div style="margin:10px 0;">
						<label for="description">Description:</label> 
						<cfscript>
							basePath = 'includes/fckeditor/';
							fckEditor = createObject("component", "#basePath#fckeditor");
							fckEditor.instanceName	= "description";
							fckEditor.value			= '#description#';
							fckEditor.basePath		= basePath;
							fckEditor.width			= 360;
							fckEditor.height		= 300;
							fckEditor.ToolbarSet	= "Basic";
							fckEditor.create(); // create the editor.
						</cfscript>
						</div>
						
						<div style="margin:10px 0;">
						<label for="forwho">Who's Responsible?</label>
						<select name="forID" id="forwho">
							<cfloop query="projectUsers">
							<option value="#userID#"<cfif StructKeyExists(url,"m")><cfif not compare(thisMilestone.forID,userID)> selected="selected"</cfif><cfelseif not compare(session.user.userid,userID)> selected="selected"</cfif>>#lastName#, #firstName#</option>
							</cfloop>
						</select>
						</div>
						
						<cfif project.tab_billing and project.billing eq 2>
						<div>
						<label for="rate">Rate:</label>
						$ <input type="text" name="rate" id="rate" value="#HTMLEditFormat(rate)#" maxlength="8" style="width:100px;padding:2px;" />
						</div>
						</cfif>
						
						<div style="margin:10px 0;">
						<label for="completed">Completed?</label>
						<input type="checkbox" name="completed" id="completed" value="1" class="checkbox"<cfif variables.isCompleted> checked="checked"</cfif> />
						</div>
						
						<div style="margin:10px 0;">
						<label for="submit">&nbsp;</label>
						<cfif StructKeyExists(url,"m")>
							<input type="submit" class="button" name="submit" id="submit" value="Update Milestone" onclick="return confirmSubmit();" />
							<input type="hidden" name="milestoneID" value="#url.m#" />
						<cfelse>
							<input type="submit" class="button" name="submit" id="submit" value="Add Milestone" />
						</cfif>
						<input type="button" class="button" name="cancel" value="Cancel" onclick="history.back();" />
						<input type="hidden" name="projectID" value="#url.p#" />
						</div>

		</div>
		<br style="clear:both" />

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