<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">
<cfparam name="fileupload" default="">
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>

<cfif session.user.admin or project.issue_edit eq 1>
	<cfif project.tab_svn eq 1 and compare(project.svnurl,'') and (session.user.admin eq 1 or project.svn gt 0)>
		<cfset svn = createObject("component", "cfcs.SVNBrowser").init(project.svnurl,project.svnuser,project.svnpass)>
		<cfset log = svn.getLog(numEntries=1000)>
	</cfif>
	<cfif StructKeyExists(form,"submit")>
		<cfset application.comment.add(createUUID(),url.p,'issue',url.i,session.user.userid,form.comment)>
	<cfelseif StructKeyExists(form,"resolve")>
		<cfparam name="form.closealso" default="false">
		<cfset application.issue.resolve(url.i,url.p,session.user.userid,form.closealso,form.resolution,form.res_desc)>
		<cfset issue = application.issue.get(url.p,url.i)>
		<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'resolved')>
		<cfif not form.closealso>
			<cfset application.notify.issueUpdate(url.p,url.i)>
		</cfif>
		<cfif form.closealso>
			<cfset application.issue.close(url.i,url.p,session.user.userid)>
			<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'closed')>
			<cfset application.notify.issueUpdate(url.p,url.i)>
		</cfif>
	<cfelseif StructKeyExists(url,"close")>
		<cfset application.issue.close(url.i,url.p,session.user.userid)>
		<cfset issue = application.issue.get(url.p,url.i)>
		<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'closed')>
		<cfset application.notify.issueUpdate(url.p,url.i)>
	<cfelseif StructKeyExists(url,"assign")>
		<cfset application.issue.assign(url.i,url.p,url.u)>
		<cfset issue = application.issue.get(url.p,url.i)>
		<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'assigned')>
		<cfset application.notify.issueUpdate(url.p,url.i)>
	<cfelseif StructKeyExists(url,"unaccept")>
		<cfset application.issue.unaccept(url.i,url.p,session.user.userid)>
		<cfset issue = application.issue.get(url.p,url.i)>
		<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'unaccepted')>
		<cfset application.notify.issueUpdate(url.p,url.i)>
	<cfelseif StructKeyExists(url,"reopen")>
		<cfset application.issue.reopen(url.i,url.p,session.user.userid)>
		<cfset issue = application.issue.get(url.p,url.i)>
		<cfset application.activity.add(createUUID(),url.p,session.user.userid,'Issue',url.i,issue.issue,'re-opened')>
		<cfset application.notify.issueUpdate(url.p,url.i)>
	<cfelseif StructKeyExists(form,"revid")>
		<cfset revs = application.svn.getLinks(itemID=url.i,itemType='issue')>
		<cfquery name="findRev1" dbtype="query">
			select revision from revs where revision = #form.revid#
		</cfquery>
		<cfif not findRev1.recordCount>
			<cfquery name="findRev2" dbtype="query">
				select revision from log where revision = #form.revid#
			</cfquery>
			<cfif findRev2.recordCount>	
				<cfset application.svn.addLink(createUUID(),url.p,form.revid,url.i,'issue')>
			<cfelse>
				<cfset error = "Revision number not found!">
			</cfif>
		<cfelse>
			<cfset error = "Revision number is already linked!">
		</cfif>
	<cfelseif StructKeyExists(url,"ds")>
		<cfset application.screenshot.delete(url.p,url.i,url.ds,session.user.userid)>
	</cfif>
</cfif>

<cfset issue = application.issue.get(url.p,url.i)>
<cfset revs = application.svn.getLinks(itemID=url.i,itemType='issue')>
<cfset comments = application.comment.get(url.p,'issue',url.i)>
<cfset attachments = application.file.getFileList(url.p,url.i,'issue')>
<cfset screenshots = application.screenshot.get(url.i)>
<cfset activity = application.activity.get(type='Issue',id=url.i)>
<cfset projectUsers = application.project.projectUsers(url.p,'0','firstName, lastName')>

<cfif not session.user.admin and not project.issue_view eq 1>
	<cfoutput><h2>You do not have permission to access issues!!!</h2></cfoutput>
	<cfabort>
</cfif>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Issue Detail" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text='<script type="text/javascript" src="./js/jquery-select.js"></script>
<script type="text/javascript" src="./js/comments.js"></script>
<script type="text/javascript" charset="utf-8">
	$(document).ready(function(){
		$(".date-pick").datepicker();
		$("a[rel^=''prettyPhoto'']").prettyPhoto();
	});
</script>'>

<cfoutput>
<div id="container">
<cfif issue.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header" style="margin-bottom:0;">
				<cfif session.user.admin or project.issue_edit eq 1>
				<span class="rightmenu">
					<a href="editIssue.cfm?p=#url.p#&i=#url.i#" class="edit">Edit</a> 
					<cfif session.user.admin or project.issue_assign eq 1>
						<cfif not compare(issue.assignedTo,'')>
							| <span style="position:relative;"><a href="##" onclick="$('##assignmenu').slideToggle();return false;" class="assign">Assign Ticket To...</a>
								<ul id="assignmenu">
									<li><a href="#cgi.script_name#?p=#url.p#&i=#url.i#&u=#session.user.userID#&assign=1" class="b">Myself</a></li>
									<cfloop query="projectUsers">
									<cfif compare(userID,session.user.userID)>
										<li><a href="#cgi.script_name#?p=#url.p#&i=#url.i#&u=#userID#&assign=1">#firstName# #lastName#</a></li>
									</cfif>
									</cfloop>
								</ul>
							  </span>
						<cfelseif not listFind('Closed,Resolved',issue.status) and not compare(issue.assignedTo,session.user.userid)>
							| <a href="#cgi.script_name#?p=#url.p#&i=#url.i#&unaccept=1" class="cancel">Unaccept Ticket</a>
						</cfif>
					</cfif>
					<cfif listFind('Accepted,Assigned',issue.status) and (session.user.admin or project.issue_resolve eq 1)>
						| <a href="##" onclick="$('##resolve').slideToggle(300);return false;" class="close">Resolve Ticket</a>
					<cfelseif not compare(issue.status,'Resolved') and (session.user.admin or project.issue_close eq 1)>
						| <a href="#cgi.script_name#?p=#url.p#&i=#url.i#&close=1" class="close">Close Ticket</a>
					<cfelseif not compare(issue.status,'Closed')>
						| <a href="#cgi.script_name#?p=#url.p#&i=#url.i#&reopen=1" class="close">Reopen Ticket</a>
					</cfif>
				</span>
				</cfif>
					
					<h2 class="issues">Ticket <cfif isNumeric(issue.shortID)>##</cfif>#issue.shortID# - #issue.issue#</h2>
				</div>
				
				<div id="resolve" style="padding:10px 20px;display:none;background-color:##f5f5f5;">
					<form action="#cgi.script_name#?#cgi.query_string#" method="post">
					<span style="float:left;margin-right:30px;width:180px;">
					<label for="res" class="b">Resolution:</label><br />
					<select name="resolution" id="res">
						<option value="Fixed">Fixed</option>
						<option value="Works for me">Works for me</option>
						<option value="Postponed">Postponed</option>
						<option value="Duplicate">Duplicate</option>
						<option value="Will not fix">Will not fix</option>
						<option value="Invalid">Invalid</option>
					</select>
					<cfif session.user.admin or project.issue_close eq 1><br /><br />
					<input type="checkbox" name="closealso" value="true" id="closealso">
					<label for="closealso">Close Ticket Simultaneously</label>
					</cfif>
					</span>
					
					<label for="res_desc" class="b">Description of Resolution:</label><br />
					<textarea name="res_desc" id="res_desc"></textarea><br />
					<input type="submit" value="Resolve Ticket" name="resolve" />
					or <a href="##" onclick="$('##resolve').slideToggle(300);;return false;">Cancel</a>
					</form>
				</div>
				
				
				<div class="content">
				 	<div class="wrapper">
					 	
					    <ul id="issueStatus">
					      <li class="<cfif not compare(issue.status,'New')>current<cfelseif listFind('Accepted,Assigned',issue.status)>lastDone<cfelse>done</cfif>"><a title=""><em>New</em></a></li>
					      <li<cfif listFind('Accepted,Assigned',issue.status) or not compare(issue.status,'Open')> class="current"<cfelseif not compare(issue.status,'Resolved')> class="lastDone"<cfelseif compare(issue.status,'New')> class="done"</cfif>><a title=""><em>Assigned</em></a></li>
					      <li<cfif not compare(issue.status,'Resolved')> class="current"<cfelseif not compare(issue.status,'Closed')> class="lastDone"</cfif>><a title=""><em>Resolved</em></a></li>
						  <li class="issueStatusNoBg<cfif not compare(issue.status,'Closed')> current</cfif>"><a title=""><em>Closed</em></a></li>
					    </ul>
					    <div class="clear mb15">&nbsp;</div>
					 	
						<div style="padding:5px;background-color:##fff6bf;border:3px solid ##ffd324;" class="mb10">
					 	<table class="bug" style="float:right;margin-right:20px;">
							<tr>
								<td class="label">Created:</td>
								<td>#LSDateFormat(DateAdd("h",session.tzOffset,issue.created),"mmm d, yyyy")# @ <cfif application.settings.clockHours eq 12>#LSTimeFormat(DateAdd("h",session.tzOffset,issue.created),"h:mmtt")#<cfelse>#LSTimeFormat(DateAdd("h",session.tzOffset,issue.created),"HH:mm")#</cfif> by #issue.createdFirstName# #issue.createdLastName#</td>
							</tr>
							<tr>
								<td class="label"><cfif not compare(issue.status,'Closed')>Closed<cfelse>Updated</cfif>:</td>
								<td><cfif isDate(issue.updated)>#LSDateFormat(DateAdd("h",session.tzOffset,issue.updated),"mmm d, yyyy")# @ <cfif application.settings.clockHours eq 12>#LSTimeFormat(DateAdd("h",session.tzOffset,issue.updated),"h:mmtt")#<cfelse>#LSTimeFormat(DateAdd("h",session.tzOffset,issue.updated),"HH:mm")#</cfif> by #issue.updatedFirstName# #issue.updatedLastName#<cfelse><span class="g">&lt;none&gt;</span></cfif></td>
							</tr>
							<tr>
								<td class="label">Assigned To:</td>
								<td><cfif compare(issue.assignedLastName,'')>#issue.assignedFirstName# #issue.assignedLastName#<cfelse><span class="g">&lt;none&gt;</span></cfif></td>
							</tr>
							<tr>
								<td class="label">Due Date:</td>
								<td><cfif isDate(issue.dueDate)>#LSDateFormat(issue.dueDate,"mmmm d, yyyy")#<cfelse><span class="g">&lt;none&gt;</span></cfif></td>
							</tr>
							<tr>
								<td class="label">Milestone:</td>
								<td><cfif compare(issue.milestone,'')><a href="milestone.cfm?p=#url.p#&m=#issue.milestoneID#">#issue.milestone#</a><cfelse><span class="g">&lt;none&gt;</span></cfif></td>
							</tr>			
						</table>
					
					 	<table class="bug">
							<tr>
								<td class="label">Type:</td>
								<td>#issue.type#</td>
							</tr>
							<tr>
								<td class="label">Status:</td>
								<td>#issue.status#</td>
							</tr>
							<tr>
								<td class="label">Severity:</td>
								<td>#issue.severity#</td>
							</tr>
							<tr>
								<td class="label">Component:</td>
								<td><cfif compare(issue.componentID,'')>#issue.component#<cfelse><span class="g">&lt;none&gt;</span></cfif></td>
							</tr>
							<tr>
								<td class="label">Version:</td>
								<td><cfif compare(issue.versionID,'')>#issue.version#<cfelse><span class="g">&lt;none&gt;</span></cfif></td>
							</tr>
							<tr>
								<td class="label">Resolution:</td>
								<td><cfif compare(issue.resolution,'')>#issue.resolution#<cfif compare(issue.resolutionDesc,'')> (#issue.resolutionDesc#)</cfif><cfelse><span class="g">&lt;none&gt;</span></cfif></td>
							</tr>
						</table>
						</div>
						
					 	<table class="bug">
							<tr>
								<td class="label"><p>Detail:</p></td>
								<td>#issue.detail#</td>
							</tr>
							<cfif compare(issue.relevantURL,'')>
							<tr>
								<td class="label">Relevant URL:</td>
								<td><a href="#issue.relevantURL#" target="_new">#issue.relevantURL#</a></td>
							</tr>
							</cfif>
						</table>	
						
					 	<table class="bug">
						 	<cfif compare(issue.resolution,'')>
							<tr>
								<td class="label">Resolution:</td>
								<td>#issue.resolution#</td>
							</tr>
							</cfif>
							<cfif compare(issue.resolutionDesc,'')>
							<tr>
								<td class="label">Description:</td>
								<td>#issue.resolutionDesc#</td>
							</tr>
							</cfif>
						</table>	

						<div class="attachbar">
							<cfif session.user.admin or project.issue_edit eq 1><span style="float:right;margin-top:2px;"><a href="editScreen.cfm?p=#url.p#&i=#url.i#" class="button2 nounder">Upload Screenshot</a></span></cfif>
							Screenshots (#screenshots.recordCount#)
						</div>						
						<cfif screenshots.recordCount>
						<a name="screen"></a>
						<table class="svn full" id="issues">
							<thead>
								<tr>
									<th>Title</th>
									<th>Name</th>
									<th>Size</th>
									<th>Uploaded</th>
									<th>Edit</th>
									<th>Delete</th>
								</tr>
							</thead>
							<tbody>
								<cfloop query="screenshots">
									<tr>
										<td>#title#</td>
										<td><a href="#application.settings.userFilesMapping#/#url.p#/#filename#" class="#lcase(filetype)#" rel="prettyPhoto" title="#title#">#filename#</a></td>
										<td>#ceiling(filesize/1024)#K</td>
										<td>#LSDateFormat(DateAdd("h",session.tzOffset,uploaded),"medium")#</td>
										<cfif not compareNoCase(session.user.userID,uploadedBy) or session.user.admin>
											<td><a href="editScreen.cfm?p=#url.p#&i=#url.i#&f=#fileID#" class="edit">Edit</a></td>
											<td><a href="#cgi.script_name#?p=#url.p#&i=#url.i#&ds=#fileID#" class="delete" onclick="return confirm('Are you sure you wish to delete this screenshot?');">Delete</a></td>										
										</cfif>
									</tr>
								</cfloop>
							</tbody>
						</table>
						</cfif>

						<cfif project.tab_time eq 1 and (session.user.admin or (project.time_view eq 1 and project.issue_timetrack eq 1))>
							<cfset timelines = application.timetrack.get(itemID=url.i)>
							<cfif project.tab_billing and (session.user.admin or project.bill_edit eq 1)>
								<cfset rates = application.client.getRates(project.clientID)>
							</cfif>
							<cfset totalHours = 0>						
							<div class="attachbar">
								Time Tracking (<span id="timerows">#timelines.recordCount#</span>)
							</div>						
							<a name="time"></a>
							<table class="clean full" id="time">
								<thead>
									<tr>
										<th>Date</th>
										<th>Person</th>
										<th>Hours</th>
										<cfif project.tab_billing and (session.user.admin or project.bill_view eq 1)>
											<th>Billing Category</th>
										</cfif>
										<th>Description</th>
										<cfif session.user.admin or project.time_edit eq 1>
											<th></th>
										</cfif>
									</tr>
									<cfif session.user.admin or project.time_edit eq 1>
									<tr class="input">
										<td class="first"><input type="text" name="datestamp" id="datestamp" class="shortest date-pick" /></td>
										<td>
											<select name="userID" id="userid">
												<cfloop query="projectUsers">
												<option value="#userid#"<cfif not compare(session.user.userid,userid)> selected="selected"</cfif>>#firstName# #lastName#</option>
												</cfloop>
											</select>
										</td>
										<td><input type="text" name="hours" id="hrs" class="tiny" /></td>
										<cfif project.tab_billing and (session.user.admin or project.bill_edit eq 1)>
											<td>
												<select name="rateID" id="rateID">
													<option value="">None</option>
													<cfloop query="rates">
														<option value="#rateID#">#category# ($#NumberFormat(rate,"0")#/hr)</option>
													</cfloop>
												</select>
											</td>
										<cfelse>
											<td><input type="hidden" name="rateID" value="" /></td>
										</cfif>
										<td><input type="text" name="description" id="desc" class="short2" /></td>
										<td class="tac"><input type="submit" value="Add" onclick="add_time_row('#url.p#','issue','#url.i#','issue');" class="sm" /></td>
									</tr>
									</cfif>
								</thead>
								<tbody>
									<cfloop query="timelines">
										<tr id="r#timetrackid#">
											<td class="first">#LSDateFormat(dateStamp,"mmm d, yyyy")#</td>
											<td>#firstName# #lastName#</td>
											<td>#numberFormat(hours,"0.00")#</td>
											<cfif project.tab_billing and (session.user.admin or project.bill_view eq 1)>
												<td>#category#<cfif compare(category,'')> ($#NumberFormat(rate,"0")#/hr)</cfif></td>
											</cfif>
											<td>#description#</td>
											<cfif session.user.admin or project.time_edit eq 1>
												<td class="tac"><a href="##" onclick="edit_time_row('#projectid#','#timetrackid#','#project.tab_billing#','#project.bill_edit#','#project.clientID#','issue','#url.i#','issue'); return false;">Edit</a>&nbsp;&nbsp;<a href="##" onclick="delete_time('#projectID#','#timetrackID#','issue','#url.i#'); return false;" class="delete"></a></td>
											</cfif>
										</tr>
										<cfset totalHours = totalHours + hours>
									</cfloop>
								</tbody>
								<tfoot>
									<tr class="last">
										<td colspan="2" class="tar b">TOTAL:&nbsp;&nbsp;&nbsp;</td>
										<td class="b"><span id="totalhours">#NumberFormat(totalHours,"0.00")#</span></td>
										<td colspan="<cfif project.tab_billing and (session.user.admin or project.bill_view eq 1)>3<cfelse>2</cfif>">&nbsp;</td>
									</tr>
								</tfoot>
							</table>
						</cfif>

						<cfif project.tab_svn eq 1 and compare(project.svnurl,'') and (session.user.admin or (project.svn gt 0 and project.issue_svn_link eq 1))>
							<div class="attachbar">
								SVN Revisions (<span id="revcount">#revs.recordCount#</span>)
							</div>
							<form action="#cgi.script_name#?#cgi.query_string###revcount" class="frm" method="post">
							<table>
								<tr>
									<td>
									<cfif session.user.admin or project.issue_edit eq 1>
										<cfquery name="reverselog" dbtype="query">
											select * from log order by revision asc
										</cfquery>
										<cfquery name="svnfull" dbtype="query">
											select * from log, revs
												where log.revision = revs.revision
										</cfquery>				
										<p>
										<select name="revision" id="rev" class="rev sm">
											<option value="">Recent SVN Revisions</option>
											<cfloop from="#reverselog.recordCount#" to="#Max(reverselog.recordCount-50,1)#" step="-1" index="i">
												<cfif not listFind(valueList(svnfull.revision),reverselog.revision[i])>
												<option value="#reverselog.revision[i]#|#reverselog.message[i]#">#reverselog.revision[i]# - #left(reverselog.message[i],50)#</option>
												</cfif>
											</cfloop>
										</select>
										<input type="button" class="button2 shortest" value="Add Link" onclick="add_svn_link('#url.p#','#url.i#','issue');" />
										</p> 
									</cfif>
									</td>
									<td>
										<p>
										<label for="revid" class="none">Rev ##:</label>
										<input type="text" name="revid" id="revid" class="shortest" />
										<input type="submit" class="button2 shortest" value="Add Link" />
										</p>
									</td>
								</tr>
							</table>
							</form>
							<cfif StructKeyExists(form,"revid") and isDefined("error")>
								<div class="alertbox">#error#</div>
							</cfif>
							<cfif svnfull.recordCount>
							<table class="clean full sm">
								<thead>
									<tr>
										<th>Rev</th>
										<th>Comment</th>
									</tr>
								</thead>
								<tbody id="revrows">
									<cfloop query="svnfull">
										<tr id="r#revision#">
											<td>#revision#</td>
											<td>#message#</td>
											<td><a href="##" onclick="delete_svn_link('#revision#','#linkID#','#JSStringFormat(message)#');return false;"><img src="./images/x.png" height="12" width="12" border="0" alt="Delete Link?" /></a></td>
										</tr>
									</cfloop>
								</tbody>
							</table>
							</cfif>
						</cfif>
										
						<cfif attachments.recordCount>
						<a name="attach"></a>
						<div class="attachbar">Files (#attachments.recordCount#)</div>
						<table class="svn full" id="issues">
							<thead>
								<tr>
									<th>Title</th>
									<th>Name</th>
									<th>Category</th>
									<th>Size</th>
									<th>Uploaded</th>
								</tr>
							</thead>
							<tbody>
								<cfloop query="attachments">
									<tr>
										<td>#title#</td>
										<td><a href="download.cfm?p=#url.p#&f=#fileID#" class="#lcase(filetype)#">#filename#</a></td>
										<td>#category#</td>
										<td>#ceiling(filesize/1024)#K</td>
										<td>#LSDateFormat(uploaded,"medium")#</td>
									</tr>
								</cfloop>
							</tbody>
						</table>									
						</cfif>
						
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
						
						<cfif session.user.admin or project.issue_comment eq 1>
						<form action="#cgi.script_name#?p=#url.p#&i=#url.i#" method="post" name="add" id="add" class="frm" onsubmit="return confirm_comment();">
						<div class="b">Post a new comment...</div>
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
		
						<div id="preview" class="sm" style="display:none;margin:15px 0;">
						<fieldset style="padding:0;"><legend style="padding:0 5px;font-weight:bold;font-size:1em;">Comment Preview (<a href="##" onclick="$('##preview').hide();">X</a>)</legend>
						<div id="commentbody"></div>
						</fieldset>
						</div>
		
						<input type="button" class="button" value="Preview" onclick="comment_preview();" /> or 
						<input type="submit" class="button" name="submit" value="Post Comment" />
						</form>
						</cfif>			
						
						
						<div class="commentbar">Audit Trail (#activity.recordCount#)</div>
						<ul class="nobullet">
						<cfloop query="activity">
							<li class="collapsed"><span class="b">Ticket #activity#</span> by #firstName# #lastName# #request.udf.relativeTime(DateAdd("h",session.tzOffset,stamp))#</li> 
						</cfloop>
						</ul>
											
						
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
	</div>
<cfelse>
	<div class="alert">Issue Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">