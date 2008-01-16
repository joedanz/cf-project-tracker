<cfsetting enablecfoutputonly="true">

<cfset userRole = application.role.get(session.user.userid,url.p)>
<cfif not listFind('Owner,Admin',userRole.role) and not session.user.admin>
	<cfoutput><h2>Project Owner or Admin Access Only!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfif StructKeyExists(url,"makeOwner")>
	<cfset application.user.makeOwner(url.p,url.makeOwner)>
<cfelseif StructKeyExists(url,"r")>
	<cfset application.user.changeRole(url.p,url.u,url.r)>
</cfif>

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>
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
					<legend class="b">Add an existing person:</legend>
				<select name="userID" id="userID">
				<cfloop query="people">
					<option value="#userID#"><cfif compare(lastName,'')>#lastName#, </cfif>#firstName#</option>
				</cfloop>
				</select>
				with a project role of
				<select name="role" id="role">
					<option value="User">User</option>
					<option value="Admin">Admin</option>
					<option value="Read-Only">Read-Only</option>
				</select>
				<input type="button" class="button2" name="add" value="Add Person" onclick="add_existing('#url.p#');return false;" /> or 
				<a href="##" onclick="$('##slidediv').slideUp(1000);return false;">cancel</a><br />
				</fieldset>
				</div>
				
				<cfif session.user.admin>
				<br /><div>
				<fieldset class="addnew">
					<legend class="b">Add a new person:</legend>
					
					<div>
					<label for="fname">First Name
						<input type="text" name="firstName" id="fname" size="7" />
					</label>
					</div>
					<div>
					<label for="lname">Last Name
						<input type="text" name="lastName" id="lname" size="10" />
					</label>
					</div>
					<div>
					<label for="email">Email
						<input type="text" name="email" id="email" size="22" />
					</label>
					</div>
					<div>
					<label>Project Role
						<select name="newrole" id="newrole">
							<option value="User">User</option>
							<option value="Admin">Admin</option>
							<option value="Read-Only">Read-Only</option>
						</select>
					</label>
					</div>
					<cfif session.user.admin>
					<div>
					<label>System Admin?
						<select name="admin" id="admin">
							<option value="0">No</option>
							<option value="1">Yes</option>
						</select>
					</label>
					</div>
					<cfelse>
						<input type="hidden" name="admin" id="admin" value="0" />
					</cfif>
					<div style="float:left;">
					<input type="button" class="button2" name="add" value="Add" onclick="add_new('#url.p#');return false;" /> 
					</div>
					<div>
					or <a href="##" onclick="$('##slidediv').slideUp(1000);return false;">cancel</a>
					</div>
				</fieldset>
				</div>
				</cfif>
				</form>
				</div>
				
					<div class="wrapper" id="replace">

				 		<cfloop query="projectUsers">
						<div class="user<cfif currentRow neq recordCount> listitem</cfif>" id="#userID#">
		 		
					 		<h4 class="b">#firstName# #lastName#&nbsp;
								<span style="font-weight:normal;font-size:.9em;">(<cfif compare(role,'')>#role#<cfelse>User</cfif>)</span>
							</h4>
					 		<cfif compare(email,'')><a href="mailto:#email#">#email#</a><br /></cfif>
					 		<cfif compare(phone,'')>#request.udf.phoneFormat(phone,"(xxx) xxx-xxxx")#
						 		<cfif compare(mobile,'')>
							 		<cfif compare(phone,'') and compare(mobile,'')>	/ mobile: </cfif>
							 		#request.udf.phoneFormat(mobile,"(xxx) xxx-xxxx")#
							 	</cfif>
						 		<br /></cfif>
					 		
					 		
					 		<cfif (listFind('Admin,Owner',userRole.role) and compare('Owner',role)) or session.user.userID eq userID>						<div style="font-weight:bold;font-size:.9em;margin-top:3px;">[ 
						 	
						 	<cfif session.user.userID eq userID><a href="account.cfm">edit</a></cfif>

							<cfif session.user.userID eq userID and listFind('User,Admin,Read-Only',role)> / </cfif>

					 		<cfif listFind('User,Admin,Read-Only',role)>
					 		<a href="##" onclick="remove_user('#url.p#','#userID#','#lastName#','#firstName#');$('###userID#').fadeOut(500);return false;">remove from project</a></cfif>
		<cfif compareNoCase('Owner',role)>
	 		<cfif compareNoCase('User',role)> / <a href="people.cfm?p=#url.p#&u=#userID#&r=User">make user</a></cfif>
	 		<cfif compareNoCase('Admin',role)> / <a href="people.cfm?p=#url.p#&u=#userID#&r=Admin">make admin</a></cfif>
			<cfif compareNoCase('Read-Only',role)> / <a href="people.cfm?p=#url.p#&u=#userID#&r=Read-Only">make read-only</a></cfif>
		</cfif>
					 		
					 		]</div>
					 		</cfif>						 		
					 		
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

		<cfquery name="proj_owner" dbtype="query">
			select * from projectUsers where role = 'Owner'
		</cfquery>
		<div class="header"><h3>Project Owner</h3></div>
		<div class="content">
			<ul>
				<li>#proj_owner.firstName# #proj_owner.lastName#</li>
			</ul>
		</div>

		<cfset proj_admins = application.project.projectUsers(url.p,'Admin')>
		<div id="proj_admins">
		<cfif proj_admins.recordCount>
		<div class="header"><h3>Project Admin<cfif proj_admins.recordCount gt 1>s</cfif></h3></div>
		<div class="content">
			<ul>
				<cfloop query="proj_admins">
					<li>#firstName# #lastName#<cfif listFind('Owner,Admin',userRole.role)> <span style="font-size:.8em;">(<a href="#cgi.script_name#?p=#url.p#&makeOwner=#userID#">make owner</a>)</span></cfif></li>
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