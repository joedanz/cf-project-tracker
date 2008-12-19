<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset projectUsers = application.project.projectUsers(url.p,'0','firstName, lastName')>
<cfset timeline = application.timetrack.get(url.tt)>

<cfoutput>
<tr id="r#replace(timeline.timetrackid,'-','','ALL')#" class="input">
	<td class="first"><input type="text" name="datestamp" id="datestamp#replace(timeline.timetrackid,'-','','ALL')#" value="#dateFormat(timeline.dateStamp,"mm/dd/yyyy")#" class="shortest date-pick" /></td>
	<td>
		<select name="userID" id="userid#replace(timeline.timetrackid,'-','','ALL')#">
			<cfloop query="projectUsers">
			<option value="#userid#"<cfif not compare(timeline.userid,userid)> selected="selected"</cfif>>#firstName# #lastName#</option>
			</cfloop>
		</select>
	</td>
	<td><input type="text" name="hours" id="hrs#replace(timeline.timetrackid,'-','','ALL')#" value="#numberFormat(timeline.hours,"0.00")#" class="tiny" /></td>
	<td><input type="text" name="description" id="desc#replace(timeline.timetrackid,'-','','ALL')#" value="#timeline.description#" class="short" /></td>
	<td class="tac"><input type="submit" value="Save" onclick="save_time_edit('#timeline.projectID#','#timeline.timetrackID#','#replace(timeline.timetrackid,'-','','ALL')#');" /> or <a href="##" onclick="cancel_time_edit('#timeline.projectID#','#timeline.timetrackID#','#replace(timeline.timetrackid,'-','','ALL')#');return false;">Cancel</a></td>
</tr>
</cfoutput>

<cfsetting enablecfoutputonly="false">