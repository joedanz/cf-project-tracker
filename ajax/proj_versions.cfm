<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfswitch expression="#url.action#">
	<cfcase value="add">
		<cfset application.project.addProjectItem(url.p,url.i,'version')>
	</cfcase>
	<cfcase value="update">
		<cfset application.project.updateProjectItem(url.iid,url.i,'version')>
	</cfcase>
	<cfcase value="delete">
		<cfset application.project.deleteProjectItem(url.i,'version')>
	</cfcase>
</cfswitch>

<cfset versions = application.project.version(url.p)>
<cfoutput query="versions">
	<li id="versionr#currentRow#"<cfif not compareNoCase(url.i,version)> class="current"</cfif>>#currentRow#) #version# &nbsp; <a href="##" onclick="$('##versionr#currentRow#').hide();$('##edit_versionr#currentRow#').show();$('##version#currentRow#').focus();return false;">Edit</a> &nbsp;<cfif numIssues><span class="g i">(#numIssues# issue<cfif numIssues gt 1>s</cfif>)</span><cfelse><a href="" onclick="confirm_item_delete('#url.p#','#versionID#','#version#','version');return false;" class="delete"></a></cfif></li>
	<li id="edit_versionr#currentRow#" style="display:none;">
		<input type="text" id="version#currentRow#" value="#version#" class="short" />
		<input type="button" value="Save" onclick="edit_proj_item('#url.p#','#versionID#','#currentRow#','version'); return false;" /> or <a href="##" onclick="$('##versionr#currentRow#').show();$('##edit_versionr#currentRow#').hide();return false;">Cancel</a>
	</li>
</cfoutput>
<cfoutput>
	<script type="text/javascript">
		$('.current').animate({backgroundColor:'##ffffb7'},200).animate({backgroundColor:'##fff'},2000);
	</script>
</cfoutput>

<cfsetting enablecfoutputonly="false">