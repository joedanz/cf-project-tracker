<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset projectUsers = application.project.projectUsers(url.p,'0','firstName, lastName')>
<cfset timeline = application.timetrack.get(url.tt)>

<cfoutput>
<tr id="r#timeline.timetrackid#" class="input">
	<td class="first"><input type="text" name="datestamp" id="datestamp#timeline.timetrackid#" value="#dateFormat(timeline.dateStamp,"mm/dd/yyyy")#" class="shortest date-pick" /></td>
	<td>
		<select name="userID" id="userid#timeline.timetrackid#">
			<cfloop query="projectUsers">
			<option value="#userid#"<cfif not compare(timeline.userid,userid)> selected="selected"</cfif>>#firstName# #lastName#</option>
			</cfloop>
		</select>
	</td>
	<td><input type="text" name="hours" id="hrs#timeline.timetrackid#" value="#numberFormat(timeline.hours,"0.00")#" class="tiny" /></td>
	<cfif url.tb and url.b eq 2>
		<cfset rates = application.client.getRates(url.c)>
		<cfset thisRateID = timeline.rateID>
		<td>
			<select name="rateID" id="rateID#timeline.timetrackid#">
				<option value="">None</option>
				<cfloop query="rates">
					<option value="#rateID#"<cfif not compare(thisRateID,rateID)> selected="selected"</cfif>>#category# (#DollarFormat(rate)#)</option>
				</cfloop>
			</select>
		</td>
		<cfif compareNoCase(url.f,'issue')>
			<td>&nbsp;</td>
		</cfif>
	<cfelse>
		<input type="hidden" name="rateID" id="rateID" value="">
	</cfif>
	<td><input type="text" name="description" id="desc#timeline.timetrackid#" value="#timeline.description#" class="short<cfif not compareNoCase(url.type,'issue')>2</cfif>" /></td>
	<td class="tac"><input type="submit" value="Save" onclick="save_time_edit('#timeline.projectID#','#timeline.timetrackID#','#timeline.itemType#','#timeline.itemID#','#url.f#');return false;" />&nbsp;or&nbsp;<a href="##" onclick="cancel_time_edit('#timeline.projectID#','#timeline.timetrackID#','#timeline.itemType#','#timeline.itemID#','#url.f#');return false;">Cancel</a></td>
</tr>
</cfoutput>

<cfsetting enablecfoutputonly="false">