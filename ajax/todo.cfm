<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfswitch expression="#url.action#">
	<cfcase value="add">
		<cfset newID = createUUID()>
		<cfset application.todo.add(newID,form.l,form.p,form.t,form.fw,form.d)>
		<cfset application.notify.todoNew(form.p,form.l,newID)>
	</cfcase>
	<cfcase value="update">
		<cfset application.todo.update(form.i,form.l,form.p,form.t,form.fw,form.d)>
		<cfset application.notify.todoUpdate(form.p,form.l,form.i)>
	</cfcase>
	<cfcase value="delete">
		<cfset application.todo.delete(url.p,url.l,url.t)>
	</cfcase>
	<cfcase value="mark_complete">
		<cfset application.todo.markCompleted(url.t,url.i,'true')>
	</cfcase>
	<cfcase value="mark_incomplete">
		<cfset application.todo.markCompleted(url.t,url.i,'false')>
	</cfcase>		
	<cfcase value="redraw_completed">
		<cfset thread = CreateObject("java", "java.lang.Thread")>
		<cfset thread.sleep(200)>
		<cfset todos_completed = application.todo.get(url.p,url.t,'true')>
		<cfset projectUsers = application.project.projectUsers(url.p)>
		<cfoutput query="todos_completed">
		<li class="g" id="#todoID#"><input type="checkbox" name="todoID" value="#todoID#" checked="checked" onclick="mark_incomplete('#url.p#','#url.t#','#todoID#');" /> <strike>#task#</strike> - <span class="g">completed on #DateFormat(completed,"mmm d, yyyy")#</span> <span class="li_edit"><a href="##" onclick="$('###todoID#').hide();$('##edititemform#todoID#').show();$('##ta#todoID#').focus();"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" /></a> <a href="##" onclick="delete_li('#url.p#','#url.t#','#todoID#')"><img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" /></a></span></li>
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
				<input type="button" class="button2" value="Update item" onclick="update_item('#url.p#','#url.t#','#todoID#','complete');" /> or <a href="##" onclick="$('###todoID#').show();$('##edititemform#todoID#').hide();">cancel edit</a>
			</td>
		</tr>
		</table>
		</form>
		</div>
		</li>
		<script type="text/javascript">
			$('.date-pick').datepicker();
		</script>
		<cfif not compareNoCase(url.i,todoID)>
			<script type="text/javascript">
				$('###url.i#').css('backgroundColor','##ffa').animate({backgroundColor:'##f7f7f7'},1500);
			</script>
		</cfif>
		</cfoutput>
	</cfcase>
	<cfcase value="redraw_incomplete">
		<cfset thread = CreateObject("java", "java.lang.Thread")>
		<cfset thread.sleep(250)>
		<cfset todos_notcompleted = application.todo.get(url.p,url.t,'false')>
		<cfset projectUsers = application.project.projectUsers(url.p)>
		<cfoutput query="todos_notcompleted">
		<li class="li#url.t#" id="#todoID#"><input type="checkbox" name="todoID" value="#todoID#" class="cb#url.t#" onclick="mark_complete('#url.p#','#url.t#','#todoID#');" /> #task#<cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)<cfif isDate(due)> - due on #DateFormat(due,"mmm d, yyyy")#</cfif></span></cfif> <span class="li_edit"><a href="##" onclick="$('###todoID#').hide();$('##edititemform#todoID#').show();$('##ta#todoID#').focus();"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" /></a> <a href="##" onclick="delete_li('#url.p#','#url.t#','#todoID#')"><img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" /></a></span></li>
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
				<input type="button" class="button2" value="Update item" onclick="update_item('#url.p#','#url.t#','#todoID#','incomplete');" /> or <a href="##" onclick="$('###todoID#').show();$('##edititemform#todoID#').hide();">cancel edit</a>
			</td>
		</tr>
		</table>
		</form>
		</div>
		</li>
		<script type="text/javascript">
			$('.date-pick').attachDatepicker();
		</script>		
		</cfoutput>
		<cfswitch expression="#url.type#">
			<cfcase value="add">
				<cfoutput>
				<script type="text/javascript">
					$('###todos_notcompleted.todoID[todos_notcompleted.recordCount]#').css('backgroundColor','##ffa').animate({backgroundColor:'##f7f7f7'},1500);
				</script>
				</cfoutput>	
			</cfcase>
			<cfcase value="update">
				<cfoutput>
				<script type="text/javascript">
					$('###url.i#').css('backgroundColor','##ffa').animate({backgroundColor:'##f7f7f7'},1500);
				</script>
				</cfoutput>	
			</cfcase>
		</cfswitch>
	</cfcase>
</cfswitch>

<cfsetting enablecfoutputonly="false">