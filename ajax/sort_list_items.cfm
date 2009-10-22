<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfswitch expression="#type#">
	<cfcase value="manual">
	
		<!--- Process serialized list  --->
		<cfset counter = 0>
		<cfloop index="i" list="#FORM.li#" delimiters="|">
			<cfset counter = counter+1>
			<cfset application.todo.updateRank(FORM.tlid,left(i,8)&'-'&mid(i,9,4)&'-'&mid(i,13,4)&'-'&right(i,16),counter)>
		</cfloop>
	
	</cfcase>
	<cfcase value="due">
	
		<cfif session.user.admin>
			<cfset project = application.project.get(projectID=url.p)>
		<cfelse>
			<cfset project = application.project.get(session.user.userid,url.p)>
		</cfif>
		<cfset projectUsers = application.project.projectUsers(url.p)>
		<cfset todolist = application.todolist.get(url.p,url.lid)>
		<cfset todos_notcompleted = application.todo.get('',url.lid,'0','due,rank,added')>
		<cfset todos_reordered = QueryNew('todoID,todolistID,projectID,task,userID,rank,due,completed,firstname,lastname,numTimeTracks,numComments')>
		<cfloop query="todos_notcompleted">
			<cfif isDate(due)> <!--- add items with due dates --->
				<cfset QueryAddRow(todos_reordered)>
				<cfset QuerySetCell(todos_reordered,'todoID',todoID)>
				<cfset QuerySetCell(todos_reordered,'todolistID',todolistID)>
				<cfset QuerySetCell(todos_reordered,'projectID',projectID)>
				<cfset QuerySetCell(todos_reordered,'task',task)>
				<cfset QuerySetCell(todos_reordered,'userID',userID)>
				<cfset QuerySetCell(todos_reordered,'rank',rank)>
				<cfset QuerySetCell(todos_reordered,'due',due)>
				<cfset QuerySetCell(todos_reordered,'completed',completed)>
				<cfset QuerySetCell(todos_reordered,'firstname',firstname)>
				<cfset QuerySetCell(todos_reordered,'lastname',lastname)>
				<cfset QuerySetCell(todos_reordered,'numTimeTracks',numTimeTracks)>
				<cfset QuerySetCell(todos_reordered,'numComments',numComments)>
			</cfif>
		</cfloop>
		<cfloop query="todos_notcompleted">
			<cfif not isDate(due)> <!--- add items without due dates --->
				<cfset QueryAddRow(todos_reordered)>
				<cfset QuerySetCell(todos_reordered,'todoID',todoID)>
				<cfset QuerySetCell(todos_reordered,'todolistID',todolistID)>
				<cfset QuerySetCell(todos_reordered,'projectID',projectID)>
				<cfset QuerySetCell(todos_reordered,'task',task)>
				<cfset QuerySetCell(todos_reordered,'userID',userID)>
				<cfset QuerySetCell(todos_reordered,'rank',rank)>
				<cfset QuerySetCell(todos_reordered,'due',due)>
				<cfset QuerySetCell(todos_reordered,'completed',completed)>
				<cfset QuerySetCell(todos_reordered,'firstname',firstname)>
				<cfset QuerySetCell(todos_reordered,'lastname',lastname)>
				<cfset QuerySetCell(todos_reordered,'numTimeTracks',numTimeTracks)>
				<cfset QuerySetCell(todos_reordered,'numComments',numComments)>
			</cfif>
		</cfloop>
		<cfoutput query="todos_reordered">
		<cfset application.todo.updateRank(todolistID,todoID,currentRow)>
		<li class="li#todolistID#" id="id_#replace(todoID,'-','','ALL')#">
			<table>
				<tr>
					<td class="cb#todolistID#"><cfif project.todo_edit><input type="checkbox" name="todoID" value="#todoID#" class="cb#todolistID#" onclick="mark_complete('#url.p#','#todolistID#','#todoID#');" /></cfif></td>
					<td class="t#todolistID#"><cfif project.todo_edit and project.time_edit and todolist.timetrack eq 1><img src="./images/time<cfif numTimeTracks gt 0>3<cfelse>2</cfif>.gif" height="16" width="16" onclick="todo_time('edit','#url.p#','#todolistID#','#todoID#','#replace(todoID,'-','','ALL')#','0');" /></cfif></td>
					<td id="edit#todoID#"<cfif numComments eq 0> onmouseover="$('##c#todoID#').show();" onmouseout="$('##c#todoID#').hide();"</cfif>>#task#<cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)</span></cfif><cfif isDate(due)> - due on #LSDateFormat(due,"mmm d, yyyy")#</cfif><cfif project.todo_edit> <span class="li_edit"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" class="link" onclick="$('###todoID#').hide();$('##edititemform#todoID#').show();$('##ta#todoID#').focus();return false;" /> <img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" class="link" onclick="delete_li('#url.p#','#todolistID#','#todoID#');return false;" /> <a href="todo.cfm?p=#url.p#&tl=#todolistID#&t=#todoID#" class="nounder" id="c#todoID#"<cfif numComments eq 0> style="display:none;"</cfif>><img src="./images/comment.png" height="11" width="14" alt="Comments" class="link" /><cfif numComments gt 0> #numComments#</cfif></a></span></cfif></td>
					</tr>
				</table>
		</li>
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
				<input type="text" name="due" id="due#todoID#" value="<cfif isDate(due)>#LSDateFormat(due,"mm/dd/yyyy")#</cfif>" size="8" class="date-pick" />
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
		</cfoutput>		
	
	</cfcase>
</cfswitch>

<cfsetting enablecfoutputonly="false">