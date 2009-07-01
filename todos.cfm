<cfsetting enablecfoutputonly="true">

<cfif StructKeyExists(url,"del")>
	<cfset application.todolist.delete(url.p,url.del)>
	<cfset application.todo.delete(url.p,url.del)>
</cfif>

<cfparam name="url.p" default="">
<cfparam name="url.t" default="">
<cfparam name="form.assignedTo" default="">
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset projectUsers = application.project.projectUsers(url.p)>
<cfset todolists = application.todolist.get(url.p,url.t)>
<cfset todos = application.todo.get(url.p,url.t,'','rank,added',form.assignedTo)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; To-Dos" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text='<script type="text/javascript">
	$(document).ready(function(){
		$(''.date-pick'').datepicker(); 
	});
</script>
'>

<cfoutput>
<a name="top"></a>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<cfif project.todolist_view>
					<span class="rightmenu">
						<cfif not compare(url.t,'')>
							<cfif project.todolist_edit>
							<a href="editTodolist.cfm?p=#url.p#" class="add">Add a new list</a>	| 
							<span id="reorder_menu">
								<a href="##" onclick="reorder_lists();return false;" class="reorder">Reorder lists</a>					
							</span>
							</cfif>
						<cfelse>
							<a href="#cgi.script_name#?p=#url.p#" class="back">View all to-do lists</a>
						</cfif>
					</span>
					</cfif>
					
					<h2 class="todo">To-Do List<cfif not compare(url.t,'')>s</cfif></h2>
				</div>
				<div class="content">
				 	<div class="wrapper">
					
					<ul id="listWrapper">
					<cfloop query="todolists">
						<cfset thisTimetrack = timetrack>

						<li class="todolist" id="id_#replace(todolistID,'-','','all')#">
						<cfif not compare(url.t,'')>
							<div class="top"><a href="##top"><img src="./images/top.gif" height="12" width="31" border="0" alt="Top" /></a></div>
						</cfif>
					
						<h3 class="padtop padbottom list"><cfif not compare(url.t,'')><a href="#cgi.script_name#?p=#url.p#&t=#todolistID#" class="title">#title#</a><cfelse>#title#</cfif><cfif project.todolist_view> &nbsp;<span class="itemedit">[<a href="editTodolist.cfm?p=#url.p#&t=#todolistid#">edit</a> / <a href="#cgi.script_name#?p=#url.p#&del=#todolistid#" onclick="return confirm('Are you sure you wish to delete this to-do list?\n(to-do items will be deleted as well)');">del</a>]</span></cfif></h3>
										
						<div class="tododetail">
							<cfif compare(description,'<br />')><div class="i mb10">#description#</div></cfif>

							<cfquery name="todos_notcompleted" dbtype="query">
								select * from todos where todolistID = '#todolistID#' and completed IS NULL
							</cfquery>

							<ul class="nobullet" id="todoitems#todolistID#">
							<cfloop query="todos_notcompleted">
								<li class="li#todolistID#" id="id_#replace(todoID,'-','','ALL')#">
									<table>
										<tr id="id_#todoID#">
											<td class="cb#todolistID#"><cfif project.todolist_view><input type="checkbox" name="todoID" value="#todoID#" onclick="mark_complete('#url.p#','#todolistID#','#todoID#');" /></cfif></td>
											<td class="t#todolistID#"><cfif project.todolist_view and project.time_edit and thisTimetrack eq 1><img src="./images/time<cfif numTimeTracks gt 0>3<cfelse>2</cfif>.gif" height="16" width="16" onclick="todo_time('edit','#url.p#','#todolistID#','#todoID#','#replace(todoID,'-','','ALL')#','0');" /></cfif></td>
											<td id="edit#todoID#"<cfif numComments eq 0> onmouseover="$('##c#todoID#').show();" onmouseout="$('##c#todoID#').hide();"</cfif>>#task#<cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)<cfif isDate(due)> - due on #DateFormat(due,"mmm d, yyyy")#</cfif></span></cfif><cfif project.todo_edit> <span class="li_edit"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" class="link" onclick="edit_item('#url.p#','#todolistID#','#todoID#');return false;" /> <img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" class="link" onclick="delete_li('#url.p#','#todolistID#','#todoID#');return false;" /> <a href="todo.cfm?p=#url.p#&t=#todoID#" class="nounder" id="c#todoID#"<cfif numComments eq 0> style="display:none;"</cfif>><img src="./images/comment.png" height="11" width="14" alt="Comments" class="link" /><cfif numComments gt 0> #numComments#</cfif></a></span></cfif></td>
										</tr>
									</table>
								</li>
							</cfloop>
							</ul>
				
							<cfif project.todo_edit>
							<div style="margin:5px 5px 5px 26px;padding:5px;background-color:##ddd;">
								<div id="listmenu#todolistID#">
									<a href="##" onclick="$('##listmenu#todolistID#').hide();$('##additemform#currentRow#').show();$('##ta#todolistID#').focus();return false;" class="add">Add an item</a>
									| <a href="##" onclick="reorder_items('#todolistID#');return false;" class="reorder">Manually Reorder Items</a>
									| <a href="##" onclick="reorder_items_by_due('#url.p#','#todolistID#');return false;" class="reorder">Auto-Reorder By Due Date</a>
								</div>
								<div id="reorderdone#todolistID#" style="display:none;">
									<a href="##" onclick="done_reordering_items('#todolistID#');return false;" class="reorder">Done Reordering</a>
								</div>
								<div id="additemform#currentRow#" style="display:none;">
									<form>
									<table class="todo todoadd">
									<tr>
										<td rowspan="2">Enter a to-do item:<br />
											<textarea class="addtask" id="ta#todolistID#"></textarea></td>
										<td class="pad">Who's responsible?<br />
											<select name="forID" id="forwho#todolistID#">
												<cfloop query="projectUsers">
												<option value="#userID#"<cfif not compare(session.user.userid,userID)> selected="selected"</cfif>>#lastName#, #firstName#</option>
												</cfloop>
											</select>
										</td>
										<td class="pad">Due Date:<br />
											<input type="text" name="due" id="due#todolistID#" size="8" class="date-pick" />
										</td>
									</tr>
									<tr>
										<td colspan="2" class="pad">
											<input type="button" class="button2" value="Add this item" onclick="add_item('#url.p#','#todolistID#');return false;" /> or <a href="##" onclick="$('##listmenu#todolistID#').show();$('##additemform#currentRow#').hide();return false;">finished adding items</a>
										</td>
									</tr>
									</table>
									</form>
								</div>
							</div>
							</cfif>
						
							<cfquery name="todos_completed" dbtype="query">
								SELECT * FROM todos where todolistID = '#todolistID#' and completed IS NOT NULL
									ORDER BY completed DESC
							</cfquery>
							<ul class="nobullet" id="todocomplete#todolistID#">
							<cfloop query="todos_completed">
								<cfif compare(url.t,'') or currentRow lte 3>
								<li class="g" id="id_#replace(todoID,'-','','ALL')#">
									<table>
										<tr>
											<td class="cb#todolistID#"><cfif project.todo_edit><input type="checkbox" name="todoID" value="#todoID#" checked="checked" onclick="mark_incomplete('#url.p#','#todolistID#','#todoID#');" /></cfif></td>
											<td class="t#todolistID#"><cfif project.todo_edit and project.time_edit and thisTimetrack eq 1><img src="./images/time<cfif numTimeTracks gt 0>3<cfelse>2</cfif>.gif" height="16" width="16" onclick="todo_time('edit','#url.p#','#todolistID#','#todoID#','#replace(todoID,'-','','ALL')#','1');" /></cfif></td>
											<td id="edit#todoID#" class="sm"<cfif numComments eq 0> onmouseover="$('##c#todoID#').show();" onmouseout="$('##c#todoID#').hide();"</cfif>>#DateFormat(completed,"mmm d")# <strike>#task#</strike><cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)<cfif isDate(due)> - due on #DateFormat(due,"mmm d, yyyy")#</cfif></span></cfif><cfif project.todolist_edit> <span class="li_edit"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" class="link" onclick="edit_item('#url.p#','#todolistID#','#todoID#');return false;" /> <img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" class="link" onclick="delete_li('#url.p#','#todolistID#','#todoID#');return false;" /> <a href="todo.cfm?p=#url.p#&t=#todoID#" class="nounder" id="c#todoID#"<cfif numComments eq 0> style="display:none;"</cfif>><img src="./images/comment.png" height="11" width="14" alt="Comments" class="link" /><cfif numComments gt 0> #numComments#</cfif></a></span></cfif></td>
										</tr>
									</table>
								</li>
								</cfif>
							</cfloop>
							</ul>
							<cfif not compare(url.t,'') and todos_completed.recordCount gt 3>
								<a href="#cgi.script_name#?p=#url.p#&t=#todolistID#" class="pl30 sma">View all #todos_completed.recordCount# completed items</a>
							</cfif>

							<div class="liststamp">
								<cfset daysago = DateDiff("d",added,Now())>
								<cfif compare(name,'')><div class="ms mstone">Milestone: #name#</div></cfif>
								<div class="posted">Posted by #firstName# #lastName# on #DateFormat(added,"dddd, mmmm d, yyyy")# (<cfif daysago eq 0>Today<cfelse>#daysago# Day<cfif daysago neq 1>s</cfif> Ago</cfif>)</div>
							</div>

						</div>
				
						</li>
					</cfloop>
					</ul>
					<div id="sorting_done" class="mt15" style="display:none;">
					<form class="frm" style="margin:0;padding:0;">
						<input type="button" class="button" value="Done Reordering" onclick="done_reordering();" />
						<input type="hidden" name="listsort" id="listsort" value="" />
						<input type="hidden" name="projectID" id="projectID" value="#url.p#" />
					</form>
					</div>
					
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
			
		<form action="#cgi.script_name#?p=#url.p#" method="post">
		<div class="b">Show to-dos assigned to:</div>
		<select name="assignedTo" onchange="this.form.submit();">
			<option value="">Anyone</a>
			<option value="#session.user.userid#"<cfif not compare(form.assignedTo,session.user.userID)> selected="selected"</cfif>>Me (#session.user.firstName# #session.user.lastName#)</a>
			<cfloop query="projectUsers">
				<cfif compare(session.user.userid,userID)>
				<option value="#userID#"<cfif not compare(form.assignedTo,userID)> selected="selected"</cfif>>#lastName#, #firstName#</option>
				</cfif>
			</cfloop>
		</select>
		</form><br />
	
		<cfif not compare(url.t,'')>
		<div class="header"><h3>Current To-Do Lists</h3></div>
		<div class="content">
			<ul>
				<cfloop query="todolists">
				<li><a href="##id_#replace(todolistID,'-','','ALL')#">#title#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>
	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">