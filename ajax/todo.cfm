<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfswitch expression="#url.action#">
	<cfcase value="add">
		<cfset application.todo.add(form.l,form.p,form.t,form.fw)>
	</cfcase>
	<cfcase value="update">
		<cfset application.todo.update(form.i,form.l,form.p,form.t,form.fw)>
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
		<cfset todos_completed = application.todo.get(url.p,url.t,'true')>
		<cfset projectUsers = application.project.projectUsers(url.p)>
		<cfoutput query="todos_completed">
		<li class="g" id="#todoID#"><input type="checkbox" name="todoID" value="#todoID#" checked="checked" onclick="mark_incomplete('#url.p#','#url.t#','#todoID#');" /> <strike>#task#</strike> - <span class="g">#DateFormat(completed,"mmm d")#</span> <span class="li_edit"><a href="##" onclick="$('###todoID#').hide();$('##edititemform#todoID#').show();$('##ta#todoID#').focus();"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" /></a> <a href="##" onclick="delete_li('#url.p#','#url.t#','#todoID#')"><img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" /></a></span></li>
		<li><div id="edititemform#todoID#" style="display:none;background-color:##ddd;padding:5px;">
		<form>
		<div style="float:left;margin-right:15px;clear:both">						
		Edit to-do item:<br />
		<textarea class="addtask" id="ta#todoID#">#task#</textarea><br />
		</div>
		Who's responsible?<br />
		<select name="forID" id="forwho#todoID#">
			<cfloop query="projectUsers">
			<option value="#userID#"<cfif not compare(todos_completed.userid[currentRow],userID)> selected="selected"</cfif>>#lastName#, #firstName#</option>
			</cfloop>
		</select><br /><br />
		<input type="button" class="button2" value="Update item" onclick="update_item('#url.p#','#url.t#','#todoID#','complete');" /> or <a href="##" onclick="$('###todoID#').show();$('##edititemform#todoID#').hide();">cancel edit</a>
		</form>
		</div>
		</li>			
		</cfoutput>
	</cfcase>
	<cfcase value="redraw_incomplete">
		<cfset todos_notcompleted = application.todo.get(url.p,url.t,'false')>
		<cfset projectUsers = application.project.projectUsers(url.p)>
		<cfoutput query="todos_notcompleted">
		<li class="li#url.t#" id="#todoID#"><input type="checkbox" name="todoID" value="#todoID#" class="cb#url.t#" onclick="mark_complete('#url.p#','#url.t#','#todoID#');" /> #task#<cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)</span></cfif> <span class="li_edit"><a href="##" onclick="$('###todoID#').hide();$('##edititemform#todoID#').show();$('##ta#todoID#').focus();"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" /></a> <a href="##" onclick="delete_li('#url.p#','#url.t#','#todoID#')"><img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" /></a></span></li>
		<li><div id="edititemform#todoID#" style="display:none;background-color:##ddd;padding:5px;">
		<form>
		<div style="float:left;margin-right:15px;clear:both">						
		Edit to-do item:<br />
		<textarea class="addtask" id="ta#todoID#">#task#</textarea><br />
		</div>
		Who's responsible?<br />
		<select name="forID" id="forwho#todoID#">
			<cfloop query="projectUsers">
			<option value="#userID#"<cfif not compare(todos_notcompleted.userid[currentRow],userID)> selected="selected"</cfif>>#lastName#, #firstName#</option>
			</cfloop>
		</select><br /><br />
		<input type="button" class="button2" value="Update item" onclick="update_item('#url.p#','#url.t#','#todoID#','incomplete');" /> or <a href="##" onclick="$('###todoID#').show();$('##edititemform#todoID#').hide();">cancel edit</a>
		</form>
		</div>
		</li>		
		</cfoutput>
		<cfswitch expression="#url.type#">
			<cfcase value="add">
				<cfoutput>
				<script type="text/javascript">
					$('###todos_notcompleted.todoID[todos_notcompleted.recordCount]#').Highlight(1500, '##ffa');
				</script>
				</cfoutput>	
			</cfcase>
			<cfcase value="update">
				<cfoutput>
				<script type="text/javascript">
					$('###url.i#').Highlight(1500, '##ffa');
				</script>
				</cfoutput>	
			</cfcase>
		</cfswitch>
	</cfcase>
</cfswitch>

<cfsetting enablecfoutputonly="false">