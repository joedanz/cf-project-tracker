<li><a href="settings.cfm"<cfif findNoCase('/admin/settings.cfm',cgi.script_name)> class="current"</cfif>>Settings</li>
<li><a href="projects.cfm"<cfif findNoCase('/admin/projects.cfm',cgi.script_name)> class="current"</cfif>>Projects</a></li>
<li><a href="users.cfm"<cfif findNoCase('/admin/users.cfm',cgi.script_name) or findNoCase('/admin/editUser.cfm',cgi.script_name)> class="current"</cfif>>Users</a></li>
<li><a href="carriers.cfm"<cfif findNoCase('/admin/carriers.cfm',cgi.script_name) or findNoCase('/admin/editCarrier.cfm',cgi.script_name)> class="current"</cfif>>Carriers</a></li>