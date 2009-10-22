<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif StructKeyExists(form,"submit")>
	<cfset application.comment.add(createUUID(),url.p,'todo',url.t,session.user.userid,form.comment)>
</cfif>

<cfif not StructKeyExists(url,'p')>
	<cfoutput><h2>No Project Selected!</h2></cfoutput><cfabort>
</cfif>

<cfparam name="url.t" default="">
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset projectUsers = application.project.projectUsers(url.p)>
<cfset todo = application.todo.get(todoID=url.t)>
<cfset todolist = application.todolist.get(url.p,todo.todolistid)>
<cfset comments = application.comment.get(url.p,'todo',url.t)>
<cfset talkList = valueList(comments.userID)>
<cfif not listLen(talkList)>
	<cfset talkList = listAppend(talkList,'000')>
</cfif>
<cfset usersTalking = application.user.get(userIDlist=talkList)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; To-Do" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfhtmlhead text='<script type="text/javascript">
	$(document).ready(function(){
		$(''.date-pick'').datepicker(); 
	});
</script>
'>

<cfoutput>
<a name="top"></a>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<cfif session.user.admin or project.todolist_view eq 1>
					<span class="rightmenu">
						<a href="todos.cfm?p=#url.p#&t=#todo.todolistid#" class="back">View complete to-do list</a>
					</span>
					</cfif>
					
					<h2 class="comments">Comments on this to-do from <a href="todos.cfm?p=#url.p#&t=#todo.todolistid#">#todolist.title#</a></h2>
				</div>
				<div class="content">
				 	<div class="wrapper">
					
					<h3 class="pl30"><input type="checkbox" name="todoID" id="c#url.t#" value="1" onclick="mark_todo('#url.t#','#todo.todolistid#');"<cfif isDate(todo.completed)> checked="checked"</cfif> /> <span id="t#url.t#"><cfif isDate(todo.completed)><strike>#todo.task#</strike><cfelse>#todo.task#</cfif></span></h3>
					<h4 class="pl50"><cfif compare(todo.lastname,'')> <span class="g">#todo.firstName# #todo.lastName#</span></cfif><cfif isDate(todo.due)> - due on #LSDateFormat(todo.due,"mmm d, yyyy")#</cfif></h4>

					<a name="comments" />
					<div class="commentbar">Comments (<span id="cnum">#comments.recordCount#</span>)</div>

					<cfloop query="comments">
					<div id="#commentID#">
					<cfif userID eq session.user.userID>
					<a href="##" onclick="return delete_comment('#commentID#');"><img src="./images/delete.gif" height="16" width="16" border="0" style="float:right;padding:5px;" /></a>
					</cfif>
					<cfif application.isCF8 or application.isBD or application.isRailo>
					<img src="<cfif avatar>#application.settings.userFilesMapping#/avatars/#userID#_48.jpg<cfelse>./images/noavatar48.gif</cfif>" height="48" width="48" border="0" style="float:left;border:1px solid ##ddd;" />
					</cfif>
					<div class="commentbody">
					<span class="b">#firstName# #lastName#</span> said on #LSDateFormat(DateAdd("h",session.tzOffset,stamp),"ddd, mmm d")# at <cfif application.settings.clockHours eq 12>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"h:mmtt")#<cfelse>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"HH:mm")#</cfif><br />
					#commentText#
					</div>
					</div>
					</cfloop>						
					
					<cfif session.user.admin or project.todo_comment eq 1>
					<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="add" id="add" class="frm" onsubmit="return confirm_comment();">
					<div class="b">Leave a comment...</div>
					<cfscript>
						basePath = 'includes/fckeditor/';
						fckEditor = createObject("component", "#basePath#fckeditor");
						fckEditor.instanceName	= "comment";
						fckEditor.value			= '';
						fckEditor.basePath		= basePath;
						fckEditor.width			= "100%";
						fckEditor.height		= 150;
						fckEditor.ToolbarSet	= "Basic";
						fckEditor.create(); // create the editor.
					</cfscript>
	
					<div id="preview" class="sm" style="display:none;margin:15px 0;">
					<fieldset style="padding:10px;"><legend style="padding:0 5px;font-weight:bold;font-size:1em;">Comment Preview (<a href="##" onclick="$('##preview').hide();">X</a>)</legend>
					<div id="commentbody"></div>
					</fieldset>
					</div>
	
					<input type="button" class="button" value="Preview" onclick="comment_preview();" /> or 
					<input type="submit" class="button" name="submit" value="Post Comment" />
					</form>
					</cfif>	





				</div>
			</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">
		<cfif compare(project.logo_img,'')>
			<img src="#application.settings.userFilesMapping#/projects/#project.logo_img#" border="0" alt="#project.name#" class="projlogo" />
		</cfif>
			
		<div class="header"><h3>Who's talking in this thread?</h3></div>
		<div class="content">
			<cfif not usersTalking.recordCount>
				<ul>
					<li>No Comments Yet</li>
				</ul>
			<cfelse>
				<ul class="people">
					<cfloop query="usersTalking">
					<li<cfif currentRow neq recordCount> class="mb10"</cfif>><div class="b">#firstName# #lastName#</div>
					#email#<br /><cfif compare(phone,'')>#phone#</cfif></li>
					</cfloop>
				</ul>			
			</cfif>
		</div>
	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">