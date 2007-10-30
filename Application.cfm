<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfset applicationName = "project_tracker">
<cfapplication name="#applicationName#" sessionManagement="true" loginstorage="session">

<cfif not StructKeyExists(application,"init") or StructKeyExists(url,"reinit")>

	<!--- Get application settings depending on which server --->
	<cfif not compare(cgi.server_name,'127.0.0.1')>
		<cfset serverSettings = "settings.local.cfm">
	<cfelse>
		<cfset serverSettings = "settings.ini.cfm">
	</cfif>

	<cfinvoke component="config.settings" method="getSettings" iniFile="#serverSettings#" returnVariable="settings">
	<cfset application.settings = settings>
	
	<cfset application.userFilesPath = ExpandPath('./userfiles/')>
	
	<!--- application CFCs --->	
	<cfset application.activity = createObject("component","cfcs.activity").init(settings)>
	<cfset application.comment = createObject("component","cfcs.comment").init(settings)>
	<cfset application.file = createObject("component","cfcs.file").init(settings)>
	<cfset application.issue = createObject("component","cfcs.issue").init(settings)>
	<cfset application.message = createObject("component","cfcs.message").init(settings)>
	<cfset application.milestone = createObject("component","cfcs.milestone").init(settings)>
	<cfset application.project = createObject("component","cfcs.project").init(settings)>
	<cfset application.role = createObject("component","cfcs.role").init(settings)>
	<cfset application.todo = createObject("component","cfcs.todo").init(settings)>
	<cfset application.todolist = createObject("component","cfcs.todolist").init(settings)>	
	<cfset application.user = createObject("component","cfcs.user").init(settings)>

	<!--- check for CF8 Scorpio --->
	<cfset majorVersion = listFirst(server.coldfusion.productversion)>
	<cfset minorVersion = listGetAt(server.coldfusion.productversion,2)>
	<cfset cfversion = majorVersion & "." & minorVersion>
	<cfset application.isCF8 = server.coldfusion.productname is "ColdFusion Server" and cfversion gte 8>
	<!--- check for Blue Dragon --->
	<cfset application.isBD = StructKeyExists(server,"bluedragon")>
	
	<cfset application.init = true>
	
</cfif>

<cfparam name="session.style" default="#application.settings.default_style#">

<!--- check for logout --->
<cfif StructKeyExists(url,"logout")>
	<cfset structDelete(session, "user")>
	<cfset session.loggedin = false>
	<cflogout>
</cfif>

<!--- handle security --->
<cfif not findNoCase('/rss.cfm',cgi.script_name)>
<cflogin>

	<cfif NOT StructKeyExists(form,"username")>
		<cfinclude template="login.cfm">
		<cfabort>
	<cfelse>	
		<!--- are we trying to logon? --->
		<cfif not compare(trim(form.username),'') or not compare(trim(form.password),'')>
			<cfset variables.error="Your must enter your login info to continue!">
			<cfinclude template="login.cfm">
			<cfabort>
		<cfelse>
			<!--- check user account against database table --->
			<cfset thisUser = application.user.login(trim(form.username),trim(form.password))>
			<cfif not structKeyExists(thisUser,"userid") or not compare(thisUser.userid,'')>
				<cfset variables.error="Your login was not accepted. Please try again!">
				<cfinclude template="login.cfm">
				<cfabort>
			<cfelse>
				<!--- log user into application --->
				<cfloginuser name="#trim(form.username)#" password="#trim(form.password)#" roles="user">
				<cfset session.user = thisUser>
				<cfset session.style = thisUser.style>
				<cfset session.loggedin = true>
				<!--- set last login stamp --->
				<cfset application.user.setLastLogin(session.user.userid)>
			</cfif>
		</cfif>			
	</cfif>
	
</cflogin>
</cfif>

<cfsetting enablecfoutputonly="false">
