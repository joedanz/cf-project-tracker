<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfswitch expression="#type#">
	<cfcase value="manual">
	
		<!--- Process serialized list  --->
		<cfset counter = 0>
		<cfloop index="i" list="#FORM.li#" delimiters="|">
			<cfset counter = counter+1>
			<cfset application.todo.updateRank('#FORM.tlid#',i,counter)>
		</cfloop>
	
	</cfcase>
	<cfcase value="due">
	
		<cfset project = application.project.get(session.user.userid,url.p)>
		<cfset projectUsers = application.project.projectUsers(url.p)>
		<cfset todos_notcompleted = application.todo.get('',url.lid,'0','due,rank,added')>
		<cfset todos_reordered = QueryNew('todoID,todolistID,projectID,task,userID,rank,due,completed,svnrevision,firstname,lastname')>
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
				<cfset QuerySetCell(todos_reordered,'svnrevision',svnrevision)>
				<cfset QuerySetCell(todos_reordered,'firstname',firstname)>
				<cfset QuerySetCell(todos_reordered,'lastname',lastname)>
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
				<cfset QuerySetCell(todos_reordered,'svnrevision',svnrevision)>
				<cfset QuerySetCell(todos_reordered,'firstname',firstname)>
				<cfset QuerySetCell(todos_reordered,'lastname',lastname)>
			</cfif>
		</cfloop>
		<cfoutput query="todos_reordered">
		<cfset application.todo.updateRank(todolistID,todoID,currentRow)>
		<li class="li#todolistID#" id="#todoID#"><cfif project.todos gt 1><input type="checkbox" name="todoID" value="#todoID#" class="cb#todolistID#" onclick="mark_complete('#url.p#','#todolistID#','#todoID#');" /> </cfif>#task#<cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)<cfif isDate(due)> - due on #DateFormat(due,"mmm d, yyyy")#</cfif></span></cfif><cfif project.todos gt 1> <span class="li_edit"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" class="link" onclick="$('###todoID#').hide();$('##edititemform#todoID#').show();$('##ta#todoID#').focus();return false;" /> <img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" class="link" onclick="delete_li('#url.p#','#todolistID#','#todoID#');return false;" /></span></cfif></li>
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
		</cfoutput>		
	
	</cfcase>
</cfswitch>

<cfsetting enablecfoutputonly="false">