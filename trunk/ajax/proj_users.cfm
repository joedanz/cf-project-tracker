<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfif StructKeyExists(url,"a")>
	<cfset application.role.add(url.p,url.e,url.a,url.f,url.i,url.m,url.ms,url.t,url.s)>
	<cfset thread = CreateObject("java", "java.lang.Thread")>
	<cfset thread.sleep(250)>	
<cfelseif StructKeyExists(form,"addnew")>
	<cfset newID = createUUID()>
	<cfset application.user.create(newID,form.f,form.l,form.e,form.p,form.adm)>
	<cfset application.role.add(form.p,newID,form.a,form.f,form.i,form.m,form.ms,form.t,form.s)>
	<cfset thread = CreateObject("java", "java.lang.Thread")>
	<cfset thread.sleep(250)>
	<cfset url.p = form.p>
<cfelseif StructKeyExists(url,"d")>
	<cfset application.role.remove(url.p,url.d)>
	<cfset thread = CreateObject("java", "java.lang.Thread")>
	<cfset thread.sleep(250)>	
</cfif>

<cfset project = application.project.get(session.user.userid,url.p)>
<cfset projectUsers = application.project.projectUsers(url.p)>
<cfset userRole = application.role.get(session.user.userid,url.p)>

<cfoutput>
	<cfloop query="projectUsers">
	<div class="user<cfif currentRow neq recordCount> listitem</cfif>" id="#userID#">

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
		 		<a href="##" onclick="$('##up_#replace(userid,'-','','ALL')#').slideToggle(300);return false;">edit permissions</a> /
		 		<a href="##" onclick="remove_user('#url.p#','#userID#','#lastName#','#firstName#');$('###userID#').fadeOut(500);return false;">remove from project</a>	
		 	<cfif userid neq project.ownerid> / <a href="#cgi.script_name#?p=#url.p#&mo=#userID#">make owner</a></cfif>
		 	]</div>
 		</cfif>
 		
		<table class="admin full mt5 permissions" style="display:none;" id="up_#replace(userid,'-','','ALL')#">
		<tr>
			<th class="tac">Admin</th>
			<th class="tac">Files</th>
			<th class="tac">Issues</th>
			<th class="tac">Messages</th>
			<th class="tac">Milestones</th>
			<th class="tac">To-Dos</th>
			<th class="tac">SVN</th>
			<th rowspan="2" class="tac"><input type="button" value="Save" class="button" onclick="save_permissions('#url.p#','#userid#','#replace(userid,'-','','ALL')#')" /></th>
		</tr>
		<tr>
			<td class="tac"><input type="checkbox" name="admin" id="a_#replace(userid,'-','','ALL')#" value="1" class="cb"<cfif admin> checked="checked"</cfif> /></td>
		<td class="tac">
			<select name="files" onchange="if (this.selectedIndex > 0) $('##a_#replace(url.p,'-','','ALL')#').attr('checked','');" id="f_#replace(userid,'-','','ALL')#">
				<option value="2"<cfif files eq 2> selected="selected"</cfif>>Full Access</option>
				<option value="1"<cfif files eq 1> selected="selected"</cfif>>Read-Only</option>
				<option value="0"<cfif files eq 0> selected="selected"</cfif>>None</option>
			</select>
		</td>
		<td class="tac">
			<select name="issues" onchange="if (this.selectedIndex > 0) $('##a_#replace(url.p,'-','','ALL')#').attr('checked','');" id="i_#replace(userid,'-','','ALL')#">
				<option value="2"<cfif issues eq 2> selected="selected"</cfif>>Full Access</option>
				<option value="1"<cfif issues eq 1> selected="selected"</cfif>>Read-Only</option>
				<option value="0"<cfif issues eq 0> selected="selected"</cfif>>None</option>
			</select>							
		</td>
		<td class="tac">
			<select name="msgs" onchange="if (this.selectedIndex > 0) $('##a_#replace(url.p,'-','','ALL')#').attr('checked','');" id="m_#replace(userid,'-','','ALL')#">
				<option value="2"<cfif msgs eq 2> selected="selected"</cfif>>Full Access</option>
				<option value="1"<cfif msgs eq 1> selected="selected"</cfif>>Read-Only</option>
				<option value="0"<cfif msgs eq 0> selected="selected"</cfif>>None</option>
			</select>							
		</td>
		<td class="tac">
			<select name="mstones" onchange="if (this.selectedIndex > 0) $('##a_#replace(url.p,'-','','ALL')#').attr('checked','');" id="ms_#replace(userid,'-','','ALL')#">
				<option value="2"<cfif mstones eq 2> selected="selected"</cfif>>Full Access</option>
				<option value="1"<cfif mstones eq 1> selected="selected"</cfif>>Read-Only</option>
				<option value="0"<cfif mstones eq 0> selected="selected"</cfif>>None</option>
			</select>							
		</td>
		<td class="tac">
			<select name="todos" onchange="if (this.selectedIndex > 0) $('##a_#replace(url.p,'-','','ALL')#').attr('checked','');" id="t_#replace(userid,'-','','ALL')#">
				<option value="2"<cfif todos eq 2> selected="selected"</cfif>>Full Access</option>
				<option value="1"<cfif todos eq 1> selected="selected"</cfif>>Read-Only</option>
				<option value="0"<cfif todos eq 0> selected="selected"</cfif>>None</option>
			</select>							
		</td>
		<td class="tac"><input type="checkbox" name="svn" id="s_#replace(userid,'-','','ALL')#" value="1" id="p_#replace(url.p,'-','','ALL')#" class="cb" onchange="if (this.checked == false) $('##a_#replace(url.p,'-','','ALL')#').attr('checked','');"<cfif svn> checked="checked"</cfif> /></td>
		</table>								 		
 		
 		
 	</div>
	</cfloop>
</cfoutput>

<cfif StructKeyExists(url,"a")>
	<cfoutput>
	<script type="text/javascript">
		$('###url.a#').css('backgroundColor','##ffa').animate({backgroundColor:'##f7f7f7'},2000);
	</script>
	</cfoutput>	
</cfif>


<cfsetting enablecfoutputonly="false">