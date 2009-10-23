<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfswitch expression="#action#">
	<cfcase value="add">
		<cfset newID = createUUID()>
		<cfset application.todo.add(newID,form.l,form.p,form.t,form.fw,form.d)>
		<cfset application.activity.add(createUUID(),form.p,session.user.userid,'To-Do',newID,form.t,'added')>
		<cfset application.notify.todoNew(form.p,form.l,newID)>
	</cfcase>
	<cfcase value="edit">
		<cfset projectUsers = application.project.projectUsers(url.p)>
		<cfset todo = application.todo.get(todoID=url.t)>
		<cfoutput query="todo">
		<div style="background-color:##ddd;padding:5px;">
			<table class="todo">
			<tr>
				<td rowspan="2"><textarea class="addtask" id="task#url.t#">#task#</textarea></td>
				<td class="pad">Who's responsible?<br />
					<select name="forID" id="forwho#url.t#">
						<cfset thisUserID = userID>
						<cfloop query="projectUsers">
						<option value="#userID#"<cfif not compare(thisUserID,userID)> selected="selected"</cfif>>#firstName# #lastName#</option>
						</cfloop>
					</select>
				</td>
				<td class="pad">Due Date:<br />
					<input type="text" name="due" id="due#url.t#" value="<cfif isDate(due)>#LSDateFormat(due,"mm/dd/yyyy")#</cfif>" size="8" class="date-pick" />
				</td>
			</tr>
			<tr>
				<td colspan="2" class="pad">
					<input type="button" class="button2" value="Update item" onclick="update_item('#url.p#','#url.tl#','#url.t#','incomplete');return false;" /> or <a href="##" onclick="cancel_edit('#url.p#','#url.tl#','#url.t#');return false;">cancel edit</a>
				</td>
			</tr>
			</table>
			<input type="hidden" id="completed#url.t#" value="#completed#" />
		</div>
		<script type="text/javascript">
			$('##ta#url.t#').focus();
			$('.date-pick').datepicker();
		</script>
		</cfoutput>
	</cfcase>
	<cfcase value="cancel">
		<cfif session.user.admin>
			<cfset project = application.project.get(projectID=form.p)>
		<cfelse>
			<cfset project = application.project.get(session.user.userid,form.p)>
		</cfif>
		<cfset todo = application.todo.get(todoID=form.t)>
		<cfoutput>	
		<cfif isDate(todo.completed)><strike>#todo.task#</strike><cfelse>#todo.task#</cfif><cfif compare(todo.lastName,'')> <span class="g">(#todo.firstName# #todo.lastName#)</span></cfif><cfif isDate(todo.due)> - due on #LSDateFormat(todo.due,"mmm d, yyyy")#</cfif>
		
<cfif project.todo_edit> <span class="li_edit"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" class="link" onclick="edit_item('#form.p#','#form.tl#','#form.t#');return false;" /> <img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" class="link" onclick="delete_li('#form.p#','#form.tl#','#form.t#');return false;" /> <a href="todo.cfm?p=#form.p#&amp;tl=#form.tl#&amp;t=#form.t#" class="nounder" id="c#form.t#"<cfif todo.numComments eq 0> style="display:none;"</cfif>><img src="./images/comment.png" height="11" width="14" alt="Comments" class="link" /><cfif todo.numComments gt 0> #todo.numComments#</cfif></a></span></cfif>
		</cfoutput>	
	</cfcase>
	<cfcase value="update">
		<cfset application.todo.update(form.t,form.tl,form.p,form.task,form.fw,form.d)>
		<cfset application.activity.add(createUUID(),form.p,session.user.userid,'To-Do',form.t,form.task,'edited')>
		<cfset application.notify.todoUpdate(form.p,form.tl,form.t)>
		<cfif session.user.admin>
			<cfset project = application.project.get(projectID=form.p)>
		<cfelse>
			<cfset project = application.project.get(session.user.userid,form.p)>
		</cfif>
		<cfset todo = application.todo.get(todoID=form.t)>
		<cfoutput>	
		<cfif isDate(form.c)><strike>#form.task#</strike><cfelse>#form.task#</cfif><cfif compare(form.fw,'')> <span class="g">(#form.fwfull#)</span></cfif><cfif isDate(form.d)> - due on #LSDateFormat(form.d,"mmm d, yyyy")#</cfif><cfif project.todo_edit> <span class="li_edit"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" class="link" onclick="edit_item('#form.p#','#form.tl#','#form.t#');return false;" /> <img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" class="link" onclick="delete_li('#form.p#','#form.tl#','#form.t#');return false;" /> <a href="todo.cfm?p=#form.p#&amp;tl=#form.tl#&amp;t=#form.t#" class="nounder" id="c#form.t#"<cfif todo.numComments eq 0> style="display:none;"</cfif>><img src="./images/comment.png" height="11" width="14" alt="Comments" class="link" /><cfif todo.numComments gt 0> #todo.numComments#</cfif></a></span></cfif>
		<script type="text/javascript">
			$('##id_#form.t#').animate({backgroundColor:'##ffffb7'},200).animate({backgroundColor:'##f7f7f7'},1500);
		</script>
		</cfoutput>
	</cfcase>
	<cfcase value="delete">
		<cfset application.todo.delete(url.p,url.tl,url.t)>
	</cfcase>
	<cfcase value="mark_complete">
		<cfset application.todo.markCompleted(url.tl,url.t,'true')>
	</cfcase>
	<cfcase value="mark_incomplete">
		<cfset application.todo.markCompleted(url.tl,url.t,'false')>
	</cfcase>		
	<cfcase value="mark_todo">
		<cfset todo = application.todo.get(todoID=url.t)>
		<cfset application.todo.markCompleted(url.tl,url.t,url.v)>
		<cfoutput><cfif url.v><strike>#todo.task#</strike><cfelse>#todo.task#</cfif></cfoutput>
	</cfcase>		
	<cfcase value="redraw_completed">
		<cfset thread = CreateObject("java", "java.lang.Thread")>
		<cfset thread.sleep(200)>
		<cfif session.user.admin>
			<cfset project = application.project.get(projectID=url.p)>
		<cfelse>
			<cfset project = application.project.get(session.user.userid,url.p)>
		</cfif>
		<cfset todos_completed = application.todo.get(url.p,url.tl,'true','completed desc')>
		<cfset projectUsers = application.project.projectUsers(url.p)>
		<cfset todolist = application.todolist.get(url.p,url.tl)>
		<cfoutput query="todos_completed">
		<li class="g" id="id_#replace(todoID,'-','','ALL')#">
			<table>
				<tr>
					<td class="cb#todolistID#"><cfif project.todo_edit><input type="checkbox" name="todoID" value="#todoID#" checked="checked" onclick="mark_incomplete('#url.p#','#todolistID#','#todoID#');" /></cfif></td>
					<td class="t#todolistID#"><cfif project.todo_edit and project.time_edit and todolist.timetrack eq 1><img src="./images/time<cfif numTimeTracks gt 0>3<cfelse>2</cfif>.gif" height="16" width="16" onclick="todo_time('edit','#url.p#','#todolistID#','#todoID#','1');" /></cfif></td>
					<td id="edit#todoID#" class="sm"<cfif numComments eq 0> onmouseover="$('##c#todoID#').show();" onmouseout="$('##c#todoID#').hide();"</cfif>><cfif isDate(completed)>#LSDateFormat(DateAdd("h",session.tzOffset,completed),"mmm d")# </cfif><strike>#task#</strike><cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)<cfif isDate(due)> - due on #LSDateFormat(due,"mmm d, yyyy")#</cfif></span></cfif><cfif project.todo_edit> <span class="li_edit"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" class="link" onclick="edit_item('#url.p#','#todolistID#','#todoID#');return false;" /> <img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" class="link" onclick="delete_li('#url.p#','#todolistID#','#todoID#');return false;" /> <a href="todo.cfm?p=#url.p#&amp;tl=#todolistID#&amp;t=#todoID#" class="nounder" id="c#todoID#"<cfif numComments eq 0> style="display:none;"</cfif>><img src="./images/comment.png" height="11" width="14" alt="Comments" class="link" /><cfif numComments gt 0> #numComments#</cfif></a></span></cfif></td>
				</tr>
			</table>
		</li>
	
		<script type="text/javascript">
			$('.date-pick').datepicker();
		</script>
		<cfif not compareNoCase(url.t,todoID)>
			<script type="text/javascript">
				$('##id_#url.t#').animate({backgroundColor:'##ffffb7'},200).animate({backgroundColor:'##f7f7f7'},1500);
			</script>
		</cfif>
		</cfoutput>
	</cfcase>
	<cfcase value="redraw_incomplete">
		<cfset thread = CreateObject("java", "java.lang.Thread")>
		<cfset thread.sleep(250)>
		<cfif session.user.admin>
			<cfset project = application.project.get(projectID=url.p)>
		<cfelse>
			<cfset project = application.project.get(session.user.userid,url.p)>
		</cfif>
		<cfset todos_notcompleted = application.todo.get(url.p,url.tl,'false')>
		<cfset projectUsers = application.project.projectUsers(url.p)>
		<cfset todolist = application.todolist.get(url.p,url.tl)>
		<cfoutput query="todos_notcompleted">
		<li class="li#todolistID#" id="id_#replace(todoID,'-','','ALL')#">
			<table>
				<tr id="id_#todoid#">
					<td class="cb#todolistID#"><cfif project.todo_edit><input type="checkbox" name="todoID" value="#todoID#" onclick="mark_complete('#url.p#','#todolistID#','#todoID#');" /></cfif></td>
					<td class="t#todolistID#"><cfif project.todo_edit and project.time_edit and todolist.timetrack eq 1><img src="./images/time<cfif numTimeTracks gt 0>3<cfelse>2</cfif>.gif" height="16" width="16" onclick="todo_time('edit','#url.p#','#todolistID#','#todoID#','0');" /></cfif></td>
					<td id="edit#todoID#"<cfif numComments eq 0> onmouseover="$('##c#todoID#').show();" onmouseout="$('##c#todoID#').hide();"</cfif>>#task#<cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)<cfif isDate(due)> - due on #LSDateFormat(due,"mmm d, yyyy")#</cfif></span></cfif><cfif project.todo_edit> <span class="li_edit"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" class="link" onclick="edit_item('#url.p#','#todolistID#','#todoID#');return false;" /> <img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" class="link" onclick="delete_li('#url.p#','#todolistID#','#todoID#');return false;" /> <a href="todo.cfm?p=#url.p#&amp;tl=#todolistID#&amp;t=#todoID#" class="nounder" id="c#todoID#"<cfif numComments eq 0> style="display:none;"</cfif>><img src="./images/comment.png" height="11" width="14" alt="Comments" class="link" /><cfif numComments gt 0> #numComments#</cfif></a></span></cfif></td>
				</tr>
			</table>
		</li>

		<script type="text/javascript">
			$('.date-pick').datepicker();
		</script>		
		</cfoutput>
		<cfswitch expression="#url.type#">
			<cfcase value="add">
				<cfoutput>
				<script type="text/javascript">
					$('##id_#todos_notcompleted.todoID[todos_notcompleted.recordCount]#').css('backgroundColor','##ffa').animate({backgroundColor:'##f7f7f7'},1500);
				</script>
				</cfoutput>	
			</cfcase>
			<cfcase value="update">
				<cfoutput>
				<script type="text/javascript">
					$('##id_#url.t#').css('backgroundColor','##ffffb7').animate({backgroundColor:'##f7f7f7'},1500);
				</script>
				</cfoutput>	
			</cfcase>
		</cfswitch>
	</cfcase>
</cfswitch>

<cfsetting enablecfoutputonly="false">