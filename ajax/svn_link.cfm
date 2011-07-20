<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfswitch expression="#form.a#">
	
	<cfcase value="add">
		<cfif not compare(form.r,'')>
			<cfoutput>
				<script type="text/javascript">
					alert('You must select a revision to link.');
				</script>
			</cfoutput>
		<cfelse>
			<cfset newID = createUUID()>
			<cfset sentinal = find('|',form.r)>
			<cfset revNum = left(form.r,sentinal-1)>
			<cfset revMsg = right(form.r,len(form.r)-sentinal)>
			<cfset application.svn.addLink(newID,form.p,revNum,form.i,form.t)>
			<cfoutput>
			<tr id="r#revNum#">
				<td>#revNum#</td>
				<td>#revMsg#</td>
				<td class="tac"><a href="##" onclick="delete_svn_link('#form.i#','#revNum#','#newID#','#JSStringFormat(revMsg)#');return false;"><img src="./images/x.png" height="12" width="12" border="0" alt="Delete Link?" /></a></td>
			</tr>
			<script type="text/javascript">
				$('tr##r#revNum#').animate({backgroundColor:'##ffffb7'},100).animate({backgroundColor:'##fff'},1500);
			</script>
			</cfoutput>
		</cfif>
	</cfcase>

	<cfcase value="addopen">
		<cfset newID = createUUID()>
		<cfset revs = application.svn.getLinks(itemID=form.i,itemType='issue')>
		<cfquery name="findRev1" dbtype="query">
			select revision from revs where revision = #form.r#
		</cfquery>
		<cfif not findRev1.recordCount>
			<cfif session.user.admin>
				<cfset project = application.project.get(projectID=form.p)>
			<cfelse>
				<cfset project = application.project.get(session.user.userid,form.p)>
			</cfif>
			<cfset svn = createObject("component", "#replace(right(application.settings.mapping,len(application.settings.mapping)-1),'/','.','ALL')#.cfcs.SVNBrowser").init(project.svnurl,project.svnuser,project.svnpass)>
			<cfset log = svn.getLog(numEntries=1000)>
			<cfquery name="findRev2" dbtype="query">
				select revision,message from log where revision = #form.r#
			</cfquery>
			<cfif findRev2.recordCount>	
				<cfset application.svn.addLink(newID,form.p,form.r,form.i,'issue')>
			<cfelse>
				<cfset error = "Revision number not found!">
			</cfif>
		<cfelse>
			<cfset error = "Revision number is already linked!">
		</cfif>
		<cfoutput>
		<tr id="r#findRev2.revision#">
			<td>#findRev2.revision#</td>
			<td>#findRev2.message#</td>
			<td class="tac"><a href="##" onclick="delete_svn_link('#form.i#','#findRev2.revision#','#newID#','#JSStringFormat(findRev2.message)#');return false;"><img src="./images/x.png" height="12" width="12" border="0" alt="Delete Link?" /></a></td>
		</tr>
		<script type="text/javascript">
			$('tr##r#findRev2.revision#').animate({backgroundColor:'##ffffb7'},100).animate({backgroundColor:'##fff'},1500);
		</script>
		</cfoutput>
	</cfcase>

	<cfcase value="del">
		<cfset application.svn.deleteLink(form.l)>
	</cfcase>
	
</cfswitch>

<cfsetting enablecfoutputonly="false">