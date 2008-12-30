<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfif StructKeyExists(url,"d")>
	<cfset application.timetrack.add(createUUID(),url.p,url.u,url.d,url.h,url.note,url.t,'to-do')>
</cfif>

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset todolist = application.todolist.get(url.p,url.tl)>
<cfset todo = application.todo.get(todoid=url.t)>

<cfif StructKeyExists(url,"edit")>

	<cfset projectUsers = application.project.projectUsers(url.p)>
	
	<cfoutput query="todo">
	<table>
		<tr>
			<td><cfif project.todos gt 1><input type="checkbox" name="todoID" value="#todoID#" class="cb#todolistID#" onclick="mark_complete('#url.p#','#todolistID#','#todoID#','#replace(todoID,'-','','all')#');" /></cfif></td>
			<td><cfif project.todos gt 1 and project.timetrack gt 1 and todolist.timetrack eq 1><a href="##" onclick="todo_time('edit','#url.p#','#url.tl#','#url.t#','#replace(url.t,'-','','all')#');return false;" class="time<cfif numTimeTracks gt 0>full</cfif>"></a></cfif></td>
			<td style="border:2px solid #session.style#;padding:0;">
				
				<div>#task#</div>
				<cfif numHours gt 0>
				<div style="background-color:##ddd;">
					<span class="b" style="background-color:#session.style#;color:##fff;padding:0 3px;margin-left:5px;">#numberFormat(numHours,"0.0")#</span> hour<cfif numHours neq 1>s</cfif> total &nbsp;&nbsp;
					<small><a href="timeReport.cfm?p=#url.p#&t=#url.t#">View the time log</a> for this to-do item</small>
				</div>
				</cfif>

				<form>
					<p>
						<label for="datestamp#replace(url.t,'-','','all')#">Date:</label>
						<input type="text" name="datestamp" id="datestamp#replace(url.t,'-','','all')#" class="date-pick shortest" />
					</p>
					<p>
						<label for="person#replace(url.t,'-','','all')#">Person:</label>
						<select name="userid" id="person#replace(url.t,'-','','all')#">
							<cfloop query="projectUsers">
								<option value="#userID#"<cfif not compare(userid,session.user.userid)> selected="selected"</cfif>>#firstName# #lastName#</option>
							</cfloop>
						</select>
					</p>
					<p>
						<label for="hours#replace(url.t,'-','','all')#">Hours:</label>
						<input type="text" name="hours" id="hours#replace(url.t,'-','','all')#" class="tiny" />
						<span class="g">(eg. 2.5 or 2:30)</span>
					</p>
					<p>
						<label for="note#replace(url.t,'-','','all')#">Notes:</label>
						<textarea name="note" id="note#replace(url.t,'-','','all')#"></textarea>
					</p>
					<p>
						<label for="add">&nbsp;</label>
						<input type="button" value="Add to log" id="add" onclick="todo_time('save','#url.p#','#url.tl#','#url.t#','#replace(url.t,'-','','all')#');return false;" /> or <a href="##" onclick="todo_time('cancel','#url.p#','#url.tl#','#url.t#','#replace(url.t,'-','','all')#');return false;">Cancel</a>
					</p>
				</form>
			</td>
		</tr>
	</table>
	<script type='text/javascript'>
		$('.date-pick').datepicker();
	</script>
	</cfoutput>
	
<cfelse>

	<cfoutput query="todo">
	<table>
		<tr>
			<td class="cb#todolistID#"><cfif project.todos gt 1><input type="checkbox" name="todoID" value="#todoID#" onclick="mark_complete('#url.p#','#todolistID#','#todoID#','#replace(todoID,'-','','all')#');" /></cfif></td>
			<td class="t#todolistID#"><cfif project.todos gt 1 and project.timetrack gt 1 and todolist.timetrack eq 1><a href="##" onclick="todo_time('edit','#url.p#','#todolistID#','#todoID#','#replace(todoID,'-','','all')#');return false;" class="time<cfif numTimeTracks gt 0>full</cfif>"></a></cfif></td>
			<td id="edit#todoID#"><cfif isDate(completed)><strike>#task#</strike><cfelse>#task#</cfif><cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)<cfif isDate(due)> - due on #DateFormat(due,"mmm d, yyyy")#</cfif></span></cfif><cfif project.todos gt 1> <span class="li_edit"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" class="link" onclick="edit_item('#url.p#','#todolistID#','#todoID#');return false;" /> <img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" class="link" onclick="delete_li('#url.p#','#todolistID#','#todoID#');return false;" /></span></cfif></td>
		</tr>
	</table>
	</cfoutput>

</cfif>

<cfsetting enablecfoutputonly="false">