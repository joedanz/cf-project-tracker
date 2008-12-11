<cfsetting enablecfoutputonly="true">

<cfset userRole = application.role.get(session.user.userid,url.p)>
<cfif not session.user.admin and not userRole.admin>
	<cfoutput><h2>Admin Access Only!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfif StructKeyExists(url,"mo")>
	<cfset application.project.makeOwner(url.p,url.mo)>
<cfelseif StructKeyExists(url,"r")>
	<cfset application.user.changeRole(url.p,url.u,url.r)>
</cfif>

<cfparam name="url.p" default="">
<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>
<cfset projectUsers = application.project.projectUsers(url.p)>
<cfset userRole = application.role.get(session.user.userid,url.p)>
<cfset people = application.project.nonProjectUsers(url.p)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; People" project="#project.name#" projectid="#url.p#">

<cfhtmlhead text='<script type="text/javascript" src="./js/jquery-select.js"></script>'>

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<span class="rightmenu">
						<a href="##" onclick="$('##slidediv').slideToggle(1000);" class="add">Add person to project</a>
					</span>					
					
					<h2 class="people">People associated with this project</h2>
				</div>
				<div class="content">
	
				<div id="slidediv" style="display:none;">
				<form class="frm">

				<div id="existing"<cfif not people.recordCount> style="display:none;"</cfif>>
				<fieldset>
					<legend class="b">Add an existing person to this project:</legend>
				<select name="userID" id="userID">
				<cfloop query="people">
					<option value="#userID#"><cfif compare(lastName,'')>#lastName#, </cfif>#firstName#</option>
				</cfloop>
				</select>
				with the following permissions:
				<table class="full mt5 permissions">
				<tr>
					<th>Admin</th>
					<th>Files</th>
					<th>Issues</th>
					<th>Messages</th>
					<th>Milestones</th>
					<th>To-Dos</th>
					<th>SVN</th>
					<th rowspan="2"><input type="button" value="Add" class="button" onclick="add_existing('#url.p#');return false;" /> or <a href="##" onclick="$('##slidediv').slideUp(1000);return false;">cancel</a></th>
				</tr>
				<tr>
					<td><input type="checkbox" name="admin" id="a_existing" value="1" class="cb" /></td>
					<td>
						<select name="files" onchange="if (this.selectedIndex > 0) $('##a_existing').attr('checked','');" id="f_existing">
							<option value="2">Full Access</option>
							<option value="1">Read-Only</option>
							<option value="0">None</option>
						</select>
					</td>
					<td>
						<select name="issues" onchange="if (this.selectedIndex > 0) $('##a_existing').attr('checked','');" id="i_existing">
							<option value="2">Full Access</option>
							<option value="1">Read-Only</option>
							<option value="0">None</option>
						</select>							
					</td>
					<td>
						<select name="msgs" onchange="if (this.selectedIndex > 0) $('##a_existing').attr('checked','');" id="m_existing">
							<option value="2">Full Access</option>
							<option value="1">Read-Only</option>
							<option value="0">None</option>
						</select>							
					</td>
					<td>
						<select name="mstones" onchange="if (this.selectedIndex > 0) $('##a_existing').attr('checked','');" id="ms_existing">
							<option value="2">Full Access</option>
							<option value="1">Read-Only</option>
							<option value="0">None</option>
						</select>							
					</td>
					<td>
						<select name="todos" onchange="if (this.selectedIndex > 0) $('##a_existing').attr('checked','');" id="t_existing">
							<option value="2">Full Access</option>
							<option value="1">Read-Only</option>
							<option value="0">None</option>
						</select>							
					</td>
					<td><input type="checkbox" name="svn" id="s_existing" value="1" class="cb" onchange="if (this.checked == false) $('##a_existing').attr('checked','');" checked="checked" /></td>
				</tr>
				</table>
				</fieldset>
				</div>
				
				<cfif session.user.admin>
				<br /><div>
				<fieldset class="addnew">
					<legend class="b">Add a new person to this project:</legend>

					<label for="fname">First
						<input type="text" name="firstName" id="fname" size="5" />
					</label>
					
					<label for="lname">Last
						<input type="text" name="lastName" id="lname" size="8" />
					</label>
					
					<label for="email">Email
						<input type="text" name="email" id="email" size="20" />
					</label>
										
					<label for="phone">Phone
						<input type="text" name="phone" id="phone" size="6" />
					</label>

					<label for="username">Username
						<input type="text" name="username" id="username" size="7" />
					</label>
					
					<label for="password">Password
						<input type="text" name="password" id="password" value="#lcase(left(request.udf.MakePassword(),4))#" size="4" />
					</label>
					
					<cfif session.user.admin>
						<label for="globaladmin">SysAdmin?
							<select name="admin" id="admin" class="block">
								<option value="0">No
								<option value="1">Yes
							</select>
						</label>
					<cfelse>
						<input type="hidden" name="admin" id="admin" value="0" />
					</cfif>
					
					<br style="clear:both;" />
					
					with the following permissions:
					<table class="full mt5 permissions">
					<tr>
						<th>Admin</th>
						<th>Files</th>
						<th>Issues</th>
						<th>Messages</th>
						<th>Milestones</th>
						<th>To-Dos</th>
						<th>SVN</th>
						<th rowspan="2"><input type="button" value="Add" class="button" onclick="add_new('#url.p#');return false;" /> or <a href="##" onclick="$('##slidediv').slideUp(1000);return false;">cancel</a></th>
					</tr>
					<tr>
						<td><input type="checkbox" name="admin" id="a_new" value="1" class="cb" /></td>
						<td>
							<select name="files" onchange="if (this.selectedIndex > 0) $('##a_new').attr('checked','');" id="f_new">
								<option value="2">Full Access</option>
								<option value="1">Read-Only</option>
								<option value="0">None</option>
							</select>
						</td>
						<td>
							<select name="issues" onchange="if (this.selectedIndex > 0) $('##a_new').attr('checked','');" id="i_new">
								<option value="2">Full Access</option>
								<option value="1">Read-Only</option>
								<option value="0">None</option>
							</select>							
						</td>
						<td>
							<select name="msgs" onchange="if (this.selectedIndex > 0) $('##a_new').attr('checked','');" id="m_new">
								<option value="2">Full Access</option>
								<option value="1">Read-Only</option>
								<option value="0">None</option>
							</select>							
						</td>
						<td>
							<select name="mstones" onchange="if (this.selectedIndex > 0) $('##a_new').attr('checked','');" id="ms_new">
								<option value="2">Full Access</option>
								<option value="1">Read-Only</option>
								<option value="0">None</option>
							</select>							
						</td>
						<td>
							<select name="todos" onchange="if (this.selectedIndex > 0) $('##a_new').attr('checked','');" id="t_new">
								<option value="2">Full Access</option>
								<option value="1">Read-Only</option>
								<option value="0">None</option>
							</select>							
						</td>
						<td><input type="checkbox" name="svn" id="s_new" value="1" class="cb" onchange="if (this.checked == false) $('##a_new').attr('checked','');" checked="checked" /></td>
					</tr>
					</table>

				</fieldset>
				</div>
				</cfif>
				</form>
				</div>
				
					<div class="wrapper" id="replace">

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
							 		<cfif userid neq project.ownerid><a href="##" onclick="remove_user('#url.p#','#userID#','#lastName#','#firstName#');$('###userID#').fadeOut(500);return false;">remove from project</a><cfelse><span class="b">project owner</span></cfif>	
							 	<cfif userid neq project.ownerid> / <a href="#cgi.script_name#?p=#url.p#&mo=#userID#">make owner</a></cfif>
							 	]</div>
					 		</cfif>
					 		
							<table class="full mt5 permissions" style="display:none;" id="up_#replace(userid,'-','','ALL')#">
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
									<select name="files" onchange="if (this.selectedIndex > 0) $('##a_#replace(userid,'-','','ALL')#').attr('checked','');" id="f_#replace(userid,'-','','ALL')#">
										<option value="2"<cfif files eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif files eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif files eq 0> selected="selected"</cfif>>None</option>
									</select>
								</td>
								<td class="tac">
									<select name="issues" onchange="if (this.selectedIndex > 0) $('##a_#replace(userid,'-','','ALL')#').attr('checked','');" id="i_#replace(userid,'-','','ALL')#">
										<option value="2"<cfif issues eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif issues eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif issues eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td class="tac">
									<select name="msgs" onchange="if (this.selectedIndex > 0) $('##a_#replace(userid,'-','','ALL')#').attr('checked','');" id="m_#replace(userid,'-','','ALL')#">
										<option value="2"<cfif msgs eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif msgs eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif msgs eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td class="tac">
									<select name="mstones" onchange="if (this.selectedIndex > 0) $('##a_#replace(userid,'-','','ALL')#').attr('checked','');" id="ms_#replace(userid,'-','','ALL')#">
										<option value="2"<cfif mstones eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif mstones eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif mstones eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td class="tac">
									<select name="todos" onchange="if (this.selectedIndex > 0) $('##a_#replace(userid,'-','','ALL')#').attr('checked','');" id="t_#replace(userid,'-','','ALL')#">
										<option value="2"<cfif todos eq 2> selected="selected"</cfif>>Full Access</option>
										<option value="1"<cfif todos eq 1> selected="selected"</cfif>>Read-Only</option>
										<option value="0"<cfif todos eq 0> selected="selected"</cfif>>None</option>
									</select>							
								</td>
								<td class="tac"><input type="checkbox" name="svn" id="s_#replace(userid,'-','','ALL')#" value="1" class="cb" onchange="if (this.checked == false) $('##a_#replace(url.p,'-','','ALL')#').attr('checked','');"<cfif svn> checked="checked"</cfif> /></td>
							</tr>
							</table>								 		
					 		
					 		
					 	</div>
				 		</cfloop>
				 		
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

		<div class="header"><h3>Project Owner</h3></div>
		<div class="content">
			<ul>
				<li>#project.ownerFirstName# #project.ownerLastName#</li>
			</ul>
		</div>

		<cfset proj_admins = application.project.projectUsers(url.p,'1')>
		<div id="proj_admins">
		<cfif proj_admins.recordCount>
		<div class="header"><h3>Project Admin<cfif proj_admins.recordCount gt 1>s</cfif></h3></div>
		<div class="content">
			<ul>
				<cfloop query="proj_admins">
					<li>#firstName# #lastName#<cfif (admin or session.user.admin) and userid neq project.ownerid> <span style="font-size:.8em;">(<a href="#cgi.script_name#?p=#url.p#&mo=#userID#">make owner</a>)</span></cfif></li>
				</cfloop>
			</ul>
		</div>
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