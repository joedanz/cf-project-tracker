<cfsetting enablecfoutputonly="true" showdebugoutput="false">
<cfprocessingdirective pageencoding="utf-8">

<cfswitch expression="#url.action#">
	<cfcase value="add">
		<cfset application.category.add(url.p,url.c,'file')>
	</cfcase>
	<cfcase value="update">
		<cfset application.category.update(url.cid,url.c)>
	</cfcase>
	<cfcase value="delete">
		<cfset application.category.delete(url.c)>
	</cfcase>
</cfswitch>

<cfset categories = application.file.getCatFiles(url.p)>
<cfoutput query="categories">
	<li id="filer#currentRow#"<cfif not compareNoCase(url.c,category)> class="current"</cfif>>#currentRow#) #category# &nbsp; <a href="##" onclick="$('##filer#currentRow#').hide();$('##edit_filer#currentRow#').show();$('##filecat#currentRow#').focus();return false;">Edit</a> &nbsp;<cfif numFiles><span class="g i">(#numFiles# file<cfif numFiles gt 1>s</cfif>)</span><cfelse><a href="" onclick="confirm_delete('#url.p#','#categoryID#','#category#','file');return false;" class="delete"></a></cfif></li>
	<li id="edit_filer#currentRow#" style="display:none;">
		<input type="text" id="filecat#currentRow#" value="#category#" class="short" />
		<input type="button" value="Save" onclick="edit_cat('#url.p#','#categoryID#','#currentRow#','file'); return false;" /> or <a href="##" onclick="$('##filer#currentRow#').show();$('##edit_filer#currentRow#').hide();return false;">Cancel</a>
	</li>
</cfoutput>
<cfoutput>
	<script type="text/javascript">
		$('.current').animate({backgroundColor:'##ffffb7'},200).animate({backgroundColor:'##fff'},2000);
	</script>
</cfoutput>

<cfsetting enablecfoutputonly="false">