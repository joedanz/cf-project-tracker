<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfswitch expression="#url.action#">
	<cfcase value="add">
		<cfset application.category.add(url.p,url.c,'msg')>
	</cfcase>
	<cfcase value="update">
		<cfset application.category.update(url.cid,url.c)>
	</cfcase>
	<cfcase value="delete">
		<cfset application.category.delete(url.c)>
	</cfcase>
</cfswitch>

<cfset categories = application.message.getCatMsgs(url.p)>
<cfoutput query="categories">
	<li id="msgr#currentRow#"<cfif not compareNoCase(url.c,category)> class="current"</cfif>>#currentRow#) #category# &nbsp; <a href="##" onclick="$('##msgr#currentRow#').hide();$('##edit_msgr#currentRow#').show();$('##msgcat#currentRow#').focus();return false;">Edit</a> &nbsp;<cfif numMsgs><span class="g i">(#numMsgs# msg<cfif numMsgs gt 1>s</cfif>)</span><cfelse><a href="" onclick="confirm_delete('#url.p#','#categoryID#','#category#','msg');return false;" class="delete"></a></cfif></li>
	<li id="edit_msgr#currentRow#" style="display:none;">
		<input type="text" id="msgcat#currentRow#" value="#category#" class="short" />
		<input type="button" value="Save" onclick="edit_cat('#url.p#','#categoryID#','#currentRow#','msg'); return false;" /> or <a href="##" onclick="$('##msgr#currentRow#').show();$('##edit_msgr#currentRow#').hide();return false;">Cancel</a>
	</li>
</cfoutput>
<cfoutput>
	<script type="text/javascript">
		$('.current').animate({backgroundColor:'##ff9'},200).animate({backgroundColor:'##fff'},2000);
	</script>
</cfoutput>

<cfsetting enablecfoutputonly="false">