<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfoutput>
<li><a href="#application.settings.mapping#/admin/users.cfm"<cfif findNoCase('/admin/editUser.cfm',cgi.script_name) or findNoCase('/admin/user',cgi.script_name) or findNoCase('/userPermissions.cfm',cgi.script_name)> class="current"</cfif>>Users</a></li>
<li><a href="#application.settings.mapping#/admin/projects.cfm"<cfif findNoCase('/admin/projects.cfm',cgi.script_name)> class="current"</cfif>>Projects</a></li>
<li><a href="#application.settings.mapping#/admin/clients.cfm"<cfif findNoCase('/admin/client',cgi.script_name) or findNoCase('/admin/editClient.cfm',cgi.script_name)> class="current"</cfif>>Clients</a></li>
<li><a href="#application.settings.mapping#/admin/company.cfm"<cfif findNoCase('/admin/company.cfm',cgi.script_name)> class="current"</cfif>>Company</a></li>
<li><a href="#application.settings.mapping#/admin/billRates.cfm"<cfif findNoCase('/admin/billRates.cfm',cgi.script_name)> class="current"</cfif>>Rates</a></li>
<li><a href="#application.settings.mapping#/admin/settings.cfm"<cfif findNoCase('/admin/settings.cfm',cgi.script_name)> class="current"</cfif>>Settings</a></li>
<li><a href="#application.settings.mapping#/admin/notifications.cfm"<cfif findNoCase('/admin/notifications.cfm',cgi.script_name)> class="current"</cfif>>Notifications</a></li>
<li><a href="#application.settings.mapping#/admin/calendar.cfm"<cfif findNoCase('/admin/calendar.cfm',cgi.script_name)> class="current"</cfif>>Calendar</a></li>
<li><a href="#application.settings.mapping#/admin/carriers.cfm"<cfif findNoCase('/admin/carriers.cfm',cgi.script_name) or findNoCase('/admin/editCarrier.cfm',cgi.script_name)> class="current"</cfif>>SMS Carriers</a></li>
<li><a href="#application.settings.mapping#/admin/api.cfm"<cfif findNoCase('/admin/api.cfm',cgi.script_name)> class="current"</cfif>>API</a></li>
</cfoutput>

<cfsetting enablecfoutputonly="false">