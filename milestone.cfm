<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif not StructKeyExists(url,'p')>
	<cfoutput><h2>No Project Selected!</h2></cfoutput><cfabort>
</cfif>

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>

<cfif not session.user.admin and not project.mstone_view eq 1>
	<cfoutput><h2>You do not have permission to access milestones!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfif StructKeyExists(form,"comment")>
	<cfset application.comment.add(createUUID(),url.p,'mstone',url.m,session.user.userid,form.comment)>
<cfelseif StructKeyExists(url,"c")> <!--- mark completed --->
	<cfset application.milestone.markCompleted(url.m,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.m,url.ms,'marked completed')>
	<cfif application.settings.googlecal_enable and compare(project.googlecal,'')>
		<cfset application.calendar.milestoneDelete(url.m)>
	</cfif>
<cfelseif StructKeyExists(url,"a")> <!--- mark active --->
	<cfset application.milestone.markActive(url.m,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.m,url.ms,'reactivated')>
<cfelseif StructKeyExists(url,"d")> <!--- delete --->
	<cfset application.milestone.delete(url.d,url.p)>
	<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Milestone',url.d,url.ms,'deleted')>
	<cfif application.settings.googlecal_enable and compare(project.googlecal,'')>
		<cfset application.calendar.milestoneDelete(url.d)>
	</cfif>
</cfif>

<cfset milestone = application.milestone.get(url.p,url.m)>
<cfset messages = application.message.get(url.p,'','',url.m)>
<cfset todolists = application.todolist.get(url.p,'','',url.m)>
<cfset issues = application.issue.get(projectID=url.p,milestoneID=url.m)>
<cfset comments = application.comment.get(url.p,'mstone',url.m)>
<cfset talkList = valueList(comments.userID)>
<cfif not listLen(talkList)>
	<cfset talkList = listAppend(talkList,'000')>
</cfif>
<cfset usersTalking = application.user.get(userIDlist=talkList)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Milestone Detail" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<span class="rightmenu">
						<a href="milestones.cfm?p=#url.p#" class="back">Back to Milestones</a>
						<cfif session.user.admin or project.mstone_edit eq 1>
							| <a href="editMilestone.cfm?p=#url.p#&amp;m=#url.m#" class="edit">Edit Milestone</a>
							| <a href="milestones.cfm?p=#url.p#&amp;d=#url.m#" class="delete" onclick="return confirm('Are you sure you wish to delete this milestone?');">Delete Milestone</a>
						</cfif>
					</span>
					
					<h2 class="milestone">Milestone Detail</h2>
				</div>
				<div class="content">
					<div class="wrapper">

						<cfset daysago = DateDiff("d",milestone.dueDate,CreateDate(year(Now()),month(Now()),day(Now())))>
						<div class="milestones <cfif isDate(milestone.completed)>completed<cfelseif daysago gte 1>late<cfelse>upcoming</cfif>">
						<div class="header <cfif isDate(milestone.completed)>completed">Completed<cfelseif daysago gte 1>late">Late<cfelse>upcoming">Upcoming</cfif></div>
						<cfloop query="milestone">
						
							<div class="milestone">
							<div class="date <cfif isDate(milestone.completed)>completed<cfelseif daysago gte 1>late<cfelse>upcoming</cfif>"><span class="b"><cfif daysago eq 0>Today<cfelseif daysago eq 1>Yesterday<cfelseif daysAgo gt 1>#daysago# days ago<cfelseif daysAgo eq -1>Tomorrow<cfelse>#Abs(daysago)# days away</cfif></span><cfif isDate(dueDate)> (#LSDateFormat(dueDate,"dddd, d mmmm, yyyy")#)</cfif><cfif userid neq 0><span style="color:##666;"> - For #firstName# #lastName#</span></cfif></div>
							<div id="m#milestoneid#" style="display:none;" class="markcomplete">Moving to <cfif not isDate(milestone.completed)>Completed<cfelseif DateDiff("d",dueDate,DateConvert("local2Utc",Now()))>Late<cfelse>Upcoming</cfif> - just a second...</div>
							<h3><cfif session.user.admin or project.mstone_edit eq 1><input type="checkbox" name="milestoneid" value="#milestoneid#" onclick="$('##m#milestoneid#').show();window.location='#cgi.script_name#?p=#url.p#&amp;<cfif isDate(milestone.completed)>a<cfelse>c</cfif>=1&amp;m=#milestoneid#&amp;ms=#URLEncodedFormat(name)#';" style="vertical-align:middle;"<cfif isDate(milestone.completed)> checked="checked"</cfif> /> </cfif>#name#</h3>
							<cfif compare(description,'')><div class="desc">#description#</div></cfif>
							
							<cfquery name="msgs" dbtype="query">
								select messageid,title,stamp,firstName,lastName,commentcount from messages where milestoneid = '#milestoneid#'
							</cfquery>
							<cfif msgs.recordCount>
							<h5 class="sub">Messages:</h5>
							<ul class="sub">
							<cfloop query="msgs">
							<li class="sub"><a href="message.cfm?p=#url.p#&amp;m=#messageid#">#title#</a> - Posted #LSDateFormat(DateAdd("h",session.tzOffset,stamp),"d mmm, yyyy")# by #firstName# #lastName#<cfif commentcount gt 0> <span class="i">(#commentcount# comments)</span></cfif></li>
							</cfloop>
							</ul>
							</cfif>
							
							<cfquery name="tl" dbtype="query">
								select todolistid,title,added,firstName,lastName from todolists where milestoneid = '#milestoneid#'
							</cfquery>
							<cfif tl.recordCount>
							<h5 class="sub">To-Do Lists:</h5>
							<ul class="sub">
							<cfloop query="tl">
							<li class="sub"><a href="todos.cfm?p=#url.p#&amp;tlid=#todolistid#">#title#</a> - Added #LSDateFormat(DateAdd("h",session.tzOffset,added),"d mmm, yyyy")#<cfif compare(firstName,'') or compare(lastName,'')> for #firstName# #lastName#</cfif></li>
							</cfloop>
							</ul>	
							</cfif>

							<cfquery name="iss1" dbtype="query">
								select issueID, shortID, issue, status, type, severity, created, assignedFirstName, assignedLastName
								from issues where milestoneid = '#milestoneid#' and status in ('New','Open','Accepted','Assigned')
							</cfquery>
							<cfquery name="iss2" dbtype="query">
								select issueID, shortID, issue, status, type, severity, created, assignedFirstName, assignedLastName
								from issues where milestoneid = '#milestoneid#' and status in ('Resolved','Closed')
							</cfquery>
							<cfif iss1.recordCount>
							<h5 class="sub">New/Open Issues:</h5>
							<ul class="sub">
							<cfloop query="iss1">
							<li class="sub"><a href="issue.cfm?p=#url.p#&amp;i=#issueid#">#shortid# - #issue#</a> (#status# #type# / #severity#) - Added #LSDateFormat(DateAdd("h",session.tzOffset,created),"d mmm, yyyy")#<cfif compare(assignedFirstName,'') or compare(assignedLastName,'')> for #assignedFirstName# #assignedLastName#</cfif></li>
							</cfloop>
							</ul>	
							</cfif>						
							<cfif iss2.recordCount>
							<h5 class="sub">Resolved/Closed Issues:</h5>
							<ul class="sub">
							<cfloop query="iss2">
							<li class="sub"><a href="issue.cfm?p=#url.p#&amp;i=#issueid#">#shortid# - #issue#</a> (#status# #type# / #severity#) - Added #LSDateFormat(DateAdd("h",session.tzOffset,created),"d mmm, yyyy")#<cfif compare(assignedFirstName,'') or compare(assignedLastName,'')> for #assignedFirstName# #assignedLastName#</cfif></li>
							</cfloop>
							</ul>	
							</cfif>
							
							</div>
						</cfloop>
						</div>	
													
						<a name="comments" />
						<div class="commentbar">Comments (<span id="cnum">#comments.recordCount#</span>)</div>
	
						<cfloop query="comments">
						<div id="#commentID#">
						<cfif userID eq session.user.userID>
						<a href="##" onclick="return delete_comment('#commentID#');"><img src="./images/delete.gif" height="16" width="16" border="0" style="float:right;padding:5px;" /></a>
						</cfif>
						<cfif application.isCF8 or application.isBD or application.isRailo>
						<img src="<cfif avatar>#application.settings.userFilesMapping#/avatars/#userID#_48.jpg<cfelse>./images/noavatar48.gif</cfif>" height="48" width="48" border="0" style="float:left;border:1px solid ##ddd;" />
						</cfif>
						<div class="commentbody">
						<span class="b">#firstName# #lastName#</span> said on #LSDateFormat(DateAdd("h",session.tzOffset,stamp),"ddd, mmm d")# at <cfif application.settings.clockHours eq 12>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"h:mmtt")#<cfelse>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"HH:mm")#</cfif><br />
						#commentText#
						</div>
						</div>
						</cfloop>						
						
						<cfif session.user.admin or project.mstone_comment eq 1>
						<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="add" id="add" class="frm" onsubmit="return confirm_comment();">
						<div class="b">Post a new comment...</div>
						<cfif session.mobileBrowser>
							<textarea name="comment" id="comment"></textarea>
						<cfelse>
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
						</cfif>
		
						<div id="preview" class="sm" style="display:none;margin:15px 0;">
						<fieldset style="padding:10px;"><legend style="padding:0 5px;font-weight:bold;font-size:1em;">Comment Preview (<a href="##" onclick="$('##preview').hide();">X</a>)</legend>
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
			<img src="#application.settings.userFilesMapping#/projects/#project.logo_img#" border="0" alt="#project.name#" class="projlogo" />
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