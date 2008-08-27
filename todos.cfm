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
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; #project.name#" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

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
					<cfif project.todos gt 1>
					<span class="rightmenu">
						<a href="editTodolist.cfm?p=#url.p#" class="add">Add a new list</a>	| 
						<a href="##" onclick="reorder_lists();return false;" class="reorder">Reorder lists</a>
					</span>
					</cfif>
					
					<h2 class="todo">To-Do Lists</h2>
				</div>
				<div class="content">
				 	<div class="wrapper">
					
					<ul class="listWrapper" id="lw">
					<cfloop query="todolists">
					<li class="listItem todolist" id="id_#replace(todolistID,'-','','all')#" style="margin-bottom:20px;">
					<div class="top"><a href="##top"><img src="./images/top.gif" height="12" width="31" border="0" alt="Top" /></a></div>
					
					<h3 class="padtop padbottom list">#title#<cfif project.todos gt 1> <span class="itemedit">[<a href="editTodolist.cfm?p=#url.p#&t=#todolistid#">edit</a> / <a href="#cgi.script_name#?p=#url.p#&del=#todolistid#" onclick="return confirm('Are you sure you wish to delete this to-do list?');">del</a>]</span></cfif></h3>
						<div class="tododetail">
						<cfif compare(description,'')><div class="i mb10">#description#</div></cfif>
						<cfquery name="todos_notcompleted" dbtype="query">
							select * from todos where todolistID = '#todolistID#' and completed IS NULL
						</cfquery>
						<ul class="nobullet" id="todoitems#todolistID#">
						<cfloop query="todos_notcompleted">
						<li class="li#todolistID#" id="id_#replace(todoID,'-','','all')#"><cfif project.todos gt 1><input type="checkbox" name="todoID" value="#todoID#" class="cb#todolistID#" onclick="mark_complete('#url.p#','#todolistID#','#todoID#');" /> </cfif>#task#<cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)<cfif isDate(due)> - due on #DateFormat(due,"mmm d, yyyy")#</cfif></span></cfif><cfif project.todos gt 1> <span class="li_edit"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" class="link" onclick="$('###todoID#').hide();$('##edititemform#todoID#').show();$('##ta#todoID#').focus();return false;" /> <img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" class="link" onclick="delete_li('#url.p#','#todolistID#','#todoID#');return false;" /></span></cfif></li>					
						<li><div id="edititemform#todoID#" style="display:none;background-color:##ddd;padding:5px;">
						<form>
						<table class="todo">
						<tr>
							<td rowspan="2">Edit to-do item:<br />
								<textarea class="addtask" id="ta#todoID#">#task#</textarea></td>
							<td class="pad">Who's responsible?<br />
								<select name="forID" id="forwho#todoID#">
									<cfset thisUserID = userID>
									<cfloop query="projectUsers">
									<option value="#userID#"<cfif not compare(thisUserID,userID)> selected="selected"</cfif>>#lastName#, #firstName#</option>
									</cfloop>
								</select>
							</td>
							<td class="pad">Due Date:<br />
								<input type="text" name="due" id="due#todoID#" value="#DateFormat(due,"mm/dd/yyyy")#" size="8" class="date-pick" />
							</td>
						</tr>
						<tr>
							<td colspan="2" class="pad">
								<input type="button" class="button2" value="Update item" onclick="update_item('#url.p#','#todolistID#','#todoID#','incomplete');return false;" /> or <a href="##" onclick="$('###todoID#').show();$('##edititemform#todoID#').hide();return false;">cancel edit</a>
							</td>
						</tr>
						</table>
						</form>
						</div>
						</li>
						</cfloop>
						</ul>
						
						<cfif project.todos gt 1>
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
						<table class="todo">
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
							select * from todos where todolistID = '#todolistID#' and completed IS NOT NULL
						</cfquery>
						<ul class="nobullet" id="todocomplete#todolistID#">
						<cfloop query="todos_completed">
						<li class="g" id="#todoID#"><cfif project.todos gt 1><input type="checkbox" name="todoID" value="#todoID#" checked="checked" onclick="mark_incomplete('#url.p#','#todolistID#','#todoID#');" /> </cfif><strike>#task#</strike><cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)</span></cfif> - <span class="g">completed on #DateFormat(completed,"mmm d, yyyy")#</span> <cfif project.todos gt 1><span class="li_edit"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" class="link" onclick="$('###todoID#').hide();$('##edititemform#todoID#').show();$('##ta#todoID#').focus();return false;" /> <img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" class="link" onclick="delete_li('#url.p#','#todolistID#','#todoID#');return false;" /></span></cfif></li>
						
						<li><div id="edititemform#todoID#" style="display:none;background-color:##ddd;padding:5px;">	
						<form>
						<table class="todo">
						<tr>
							<td rowspan="2">Edit to-do item:<br />
								<textarea class="addtask" id="ta#todoID#">#task#</textarea></td>
							<td class="pad">Who's responsible?<br />
								<select name="forID" id="forwho#todoID#">
									<cfset thisUserID = userID>
									<cfloop query="projectUsers">
									<option value="#userID#"<cfif not compare(thisUserID,userID)> selected="selected"</cfif>>#lastName#, #firstName#</option>
									</cfloop>
								</select>
							</td>
							<td class="pad">Due Date:<br />
								<input type="text" name="due" id="due#todoID#" value="#DateFormat(due,"mm/dd/yyyy")#" size="8" class="date-pick" />
							</td>
						</tr>
						<tr>
							<td colspan="2" class="pad">
								<input type="button" class="button2" value="Update item" onclick="update_item('#url.p#','#todolistID#','#todoID#','complete');return false;" /> or <a href="##" onclick="$('###todoID#').show();$('##edititemform#todoID#').hide();return false;">cancel edit</a>
							</td>
						</tr>
						</table>
						</form>
						</div>
						</li>								
						
						</cfloop>
						</ul>
						</div>
						
						<div style="margin-top:10px;padding-top:10px;border-top:1px solid ##999;">
						<cfset daysago = DateDiff("d",added,Now())>
<cfif compare(name,'')><div class="ms mstone">Milestone: #name#</div></cfif>
<div class="posted">Posted by #firstName# #lastName# on #DateFormat(added,"dddd, mmmm d, yyyy")# (<cfif daysago eq 0>Today<cfelse>#daysago# Day<cfif daysago neq 1>s</cfif> Ago</cfif>)</div>
						</div>
						
					</li>
					</cfloop>
					</ul>
					<div id="sorting_done" style="display:none;margin-top:15px;">
					<form class="frm" style="margin:0;padding:0;">
						<input type="button" class="button" value="Done Reordering" onclick="done_reordering();return false;" />
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