<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfif StructKeyExists(url,"a")>
	<cfset def = application.project.getDistinct(url.p)>
	<cfset application.role.add(url.p,url.u,'0',def.reg_file_view,def.reg_file_edit,def.reg_file_comment,def.reg_issue_view,def.reg_issue_edit,def.reg_issue_assign,def.reg_issue_resolve,def.reg_issue_close,def.reg_issue_comment,def.reg_msg_view,def.reg_msg_edit,def.reg_msg_comment,def.reg_mstone_view,def.reg_mstone_edit,def.reg_mstone_comment,def.reg_todolist_view,def.reg_todolist_edit,def.reg_todo_edit,def.reg_todo_comment,def.reg_time_view,def.reg_time_edit,def.reg_bill_view,def.reg_bill_edit,def.reg_bill_rates,def.reg_bill_invoices,def.reg_bill_markpaid,def.reg_svn)>
	<cfset application.notify.add(url.u,url.p)>
	<cfset thread = CreateObject("java", "java.lang.Thread")>
	<cfset thread.sleep(250)>	
<cfelseif StructKeyExists(form,"addnew")>
	<cfset userExists = application.user.get('','',form.un)>
	<cfif userExists.recordCount>
		<cfset error = "Username already exists!">
	<cfelse>
		<cfset newID = createUUID()>
		<cfset def = application.project.getDistinct(form.p)>
		<cfset application.user.create(newID,form.fn,form.ln,form.e,form.ph,form.un,form.pw,form.adm)>
		<cfset application.role.add(form.p,newID,'0',def.reg_file_view,def.reg_file_edit,def.reg_file_comment,def.reg_issue_view,def.reg_issue_edit,def.reg_issue_assign,def.reg_issue_resolve,def.reg_issue_close,def.reg_issue_comment,def.reg_msg_view,def.reg_msg_edit,def.reg_msg_comment,def.reg_mstone_view,def.reg_mstone_edit,def.reg_mstone_comment,def.reg_todolist_view,def.reg_todolist_edit,def.reg_todo_edit,def.reg_todo_comment,def.reg_time_view,def.reg_time_edit,def.reg_bill_view,def.reg_bill_edit,def.reg_bill_rates,def.reg_bill_invoices,def.reg_bill_markpaid,def.reg_svn)>
		<cfset application.notify.add(newID,form.p)>
		<cfset thread = CreateObject("java", "java.lang.Thread")>
		<cfset thread.sleep(250)>
	</cfif>
	<cfset url.p = form.p>
<cfelseif StructKeyExists(url,"d")>
	<cfset application.role.remove(url.p,url.d)>
	<cfset thread = CreateObject("java", "java.lang.Thread")>
	<cfset thread.sleep(250)>	
</cfif>

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset projectUsers = application.project.projectUsers(url.p)>
<cfset userRole = application.role.get(session.user.userid,url.p)>

<cfoutput>
	<cfif StructKeyExists(variables,"error")>
		<script type="text/javascript">
			alert('Username already exists - please try another!');
		</script>
	</cfif>
	<cfloop query="projectUsers">
	<div class="user" id="#userID#">

 		<h4 class="b">#firstName# #lastName#&nbsp;
			<span style="font-weight:normal;font-size:.9em;">(<span id="ut_#replace(userid,'-','','ALL')#"><cfif admin>Admin<cfelse>User</cfif></span>)<cfif session.user.admin>&nbsp; [<a href="./admin/editUser.cfm?from=people&p=#url.p#&u=#userid#">edit</a>]</cfif></span>
		</h4>
 		<cfif compare(email,'')><a href="mailto:#email#">#email#</a><br /></cfif>
 		<cfif compare(phone,'')>#request.udf.phoneFormat(phone,"(xxx) xxx-xxxx")#
	 		<cfif compare(mobile,'')>
		 		<cfif compare(phone,'') and compare(mobile,'')>	/ mobile: </cfif>
		 		#request.udf.phoneFormat(mobile,"(xxx) xxx-xxxx")#
		 	</cfif>
	 		<br /></cfif>
 		
 		<cfif admin or session.user.admin>
	 		<div style="font-size:.9em;margin-top:3px;">[
		 		<a href="userPermissions.cfm?u=#userID#&p=#url.p#">edit permissions</a> /
		 		<a href="##" onclick="remove_user('#url.p#','#userID#','#lastName#','#firstName#');$('###userID#').fadeOut(500);return false;">remove from project</a>	
		 	<cfif userid neq project.ownerid> / <a href="people.cfm?p=#url.p#&mo=#userID#">make owner</a></cfif>
		 	]</div>
 		</cfif>
 	</div>
	</cfloop>
</cfoutput>

<cfsetting enablecfoutputonly="false">