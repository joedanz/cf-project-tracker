<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfswitch expression="#url.action#">
	<cfcase value="add">
		<cfset application.project.addProjectItem(url.p,url.i,'component')>
	</cfcase>
	<cfcase value="update">
		<cfset application.project.updateProjectItem(url.iid,url.i,'component')>
	</cfcase>
	<cfcase value="delete">
		<cfset application.project.deleteProjectItem(url.i,'component')>
	</cfcase>
</cfswitch>

<cfset components = application.project.component(url.p)>
<cfoutput query="components">
	<li id="componentr#currentRow#"<cfif not compareNoCase(url.i,component)> class="current"</cfif>>#currentRow#) #component# &nbsp; <a href="##" onclick="$('##componentr#currentRow#').hide();$('##edit_componentr#currentRow#').show();$('##component#currentRow#').focus();return false;">Edit</a> &nbsp;<cfif numIssues><span class="g i">(#numIssues# issue<cfif numIssues gt 1>s</cfif>)</span><cfelse><a href="" onclick="confirm_item_delete('#url.p#','#componentID#','#component#','component');return false;" class="delete"></a></cfif></li>
	<li id="edit_componentr#currentRow#" style="display:none;">
		<input type="text" id="component#currentRow#" value="#component#" class="short" />
		<input type="button" value="Save" onclick="edit_proj_item('#url.p#','#componentID#','#currentRow#','component'); return false;" /> or <a href="##" onclick="$('##componentr#currentRow#').show();$('##edit_componentr#currentRow#').hide();return false;">Cancel</a>
	</li>
</cfoutput>
<cfoutput>
	<script type="text/javascript">
		$('.current').animate({backgroundColor:'##ffffb7'},200).animate({backgroundColor:'##fff'},2000);
	</script>
</cfoutput>

<cfsetting enablecfoutputonly="false">