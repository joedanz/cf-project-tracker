<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfswitch expression="#form.a#">
	
	<cfcase value="add">
		<cfset newID = createUUID()>
		<cfset sentinal = find('|',form.r)>
		<cfset revNum = left(form.r,sentinal-1)>
		<cfset revMsg = right(form.r,len(form.r)-sentinal)>
		<cfset application.svn.addLink(newID,form.p,revNum,form.i,form.t)>
		<cfoutput>
		<tr id="r#revNum#">
			<td>#revNum#</td>
			<td>#revMsg#</td>
			<td><a href="##" onclick="delete_svn_link('#revNum#','#newID#','#JSStringFormat(revMsg)#');return false;"><img src="./images/x.png" height="12" width="12" border="0" alt="Delete Link?" /></a></td>
		</tr>
		</cfoutput>
	</cfcase>
	
	<cfcase value="del">
		<cfset application.svn.deleteLink(form.l)>
	</cfcase>
	
</cfswitch>

<cfsetting enablecfoutputonly="false">