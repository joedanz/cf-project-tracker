<cfsetting enablecfoutputonly="true">

<cfset applicationName = right(REReplace(getDirectoryFromPath(getCurrentTemplatePath()),'[^A-Za-z0-9]','','all'),64)>
<cfapplication name="#applicationName#" sessionManagement="true" loginstorage="session" sessiontimeout="#CreateTimeSpan(0,1,30,0)#">

<cfparam name="application.settings.showDebug" default="false">
<cfsetting showdebugoutput="#application.settings.showDebug#">

<!--- double check lock, so we don't do this twice --->
<cfif not StructKeyExists(application,"init") or StructKeyExists(url,"reinit")>
	<cflock name="init.#applicationName#" timeout="120">
		<cfif not StructKeyExists(application,"init") or StructKeyExists(url,"reinit")>

			<!--- Get application settings depending on which server --->
			<cfif not compare(cgi.server_name,'127.0.0.1')>
				<cfset serverSettings = "settings.local.cfm">
			<cfelse>
				<cfset serverSettings = "settings.ini.cfm">
			</cfif>

			<cfinvoke component="config.settings" method="getSettings" iniFile="#serverSettings#" returnVariable="settings">
			<cfset application.settings = settings>
			
			<!--- determine userfiles directory if custom from config file --->
			<cfif compare(settings.userFilesCustom,'') and len(settings.userFilesCustom)>
				<cfset application.userFilesPath = settings.userFilesCustom>
				<cfif compare(right(settings.userFilesCustom,1),'/')>
					<cfset application.userFilesPath = application.userFilesPath & '/'>
				</cfif>
			<cfelse>
				<cfset application.userFilesPath = ExpandPath('./userfiles/')>
			</cfif>
			<!--- create userfiles directory if it doesn't exist --->
			<cftry>
				<cfdirectory action="create" directory="#application.userFilesPath#">
				<cfcatch></cfcatch>
			</cftry>

			<!--- application CFCs --->
			<cfset application.activity = createObject("component","cfcs.activity").init(settings)>
			<cfset application.billing = createObject("component","cfcs.billing").init(settings)>
			<cfset application.carrier = createObject("component","cfcs.carrier").init(settings)>
			<cfset application.category = createObject("component","cfcs.category").init(settings)>
			<cfset application.client = createObject("component","cfcs.client").init(settings)>
			<cfset application.comment = createObject("component","cfcs.comment").init(settings)>
			<cfset application.config = createObject("component","cfcs.config").init(settings)>
			<cfset application.diff = createObject("component","cfcs.diff").init()>
			<cfset application.file = createObject("component","cfcs.file").init(settings)>
			<cfset application.issue = createObject("component","cfcs.issue").init(settings)>
			<cfset application.message = createObject("component","cfcs.message").init(settings)>
			<cfset application.milestone = createObject("component","cfcs.milestone").init(settings)>
			<cfset application.notify = createObject("component","cfcs.notify").init(settings)>
			<cfset application.project = createObject("component","cfcs.project").init(settings)>
			<cfset application.role = createObject("component","cfcs.role").init(settings)>
			<cfset application.screenshot = createObject("component","cfcs.screenshot").init(settings)>
			<cfset application.search = createObject("component","cfcs.search").init(settings)>
			<cfset application.svn = createObject("component","cfcs.svn").init(settings)>
			<cfset application.timetrack = createObject("component","cfcs.timetrack").init(settings)>
			<cfset application.todo = createObject("component","cfcs.todo").init(settings)>
			<cfset application.todolist = createObject("component","cfcs.todolist").init(settings)>
			<cfset application.user = createObject("component","cfcs.user").init(settings)>
			
			<!--- DataMgr --->
			<cfset application.DataMgr = createObject("component","cfcs.DataMgr.DataMgr").init(settings.dsn)>

			<!--- stored queries --->
			<cftry>
				<cfset application.carriers = application.carrier.get(activeOnly=true)>
				<cfcatch></cfcatch>
			</cftry>

			<!--- check for Blue Dragon --->
			<cfset application.isBD = StructKeyExists(server,"bluedragon")>

			<!--- check for Railo --->
			<cfset application.isRailo = not compareNoCase(server.coldfusion.productname,"railo")>

			<!--- get CF version --->
			<cfif application.isBD>
				<cfset majorVersion = listFirst(server.coldfusion.productversion,'.')>
				<cfset minorVersion = listGetAt(server.coldfusion.productversion,2,'.')>
				<cfset cfversion = server.coldfusion.productversion>
			<cfelse>
				<cfset majorVersion = listFirst(server.coldfusion.productversion)>
				<cfset minorVersion = listGetAt(server.coldfusion.productversion,2)>
				<cfset cfversion = majorVersion & "." & minorVersion>	
			</cfif>

			<!--- check for CF8 Scorpio --->
			<cfset application.isCF8 = server.coldfusion.productname is "ColdFusion Server" and cfversion gte 8>

			<!--- create all_styles.css --->
			<cffile action="read" file="#ExpandPath(settings.mapping & '/css/')#reset.css" variable="reset">
			<cffile action="read" file="#ExpandPath(settings.mapping & '/css/')#style.css" variable="style">
			<cffile action="read" file="#ExpandPath(settings.mapping & '/css/')#layout.css" variable="layout">
			<cffile action="read" file="#ExpandPath(settings.mapping & '/css/')#header.css" variable="header">
			<cffile action="read" file="#ExpandPath(settings.mapping & '/css/')#images.css" variable="images">
			<cffile action="read" file="#ExpandPath(settings.mapping & '/css/')#forms.css" variable="forms">
			<cffile action="read" file="#ExpandPath(settings.mapping & '/css/')#tables.css" variable="tables">
			<cffile action="read" file="#ExpandPath(settings.mapping & '/css/')#prettyPhoto.css" variable="prettyPhoto">
			<cffile action="write" file="#ExpandPath(settings.mapping & '/css/')#all_styles.css" output="/* THIS FILE IS GENERATED AUTOMATICALLY - EDIT INDIVIDUAL CSS FILES & REINIT TO MODIFY STYLES */#chr(10)##chr(13)#/* RESET.CSS */#chr(10)##chr(13)##reset##chr(10)##chr(13)#/* LAYOUT.CSS */#chr(10)##chr(13)##layout##chr(10)##chr(13)#/* STYLE.CSS */#chr(10)##chr(13)##style##chr(10)##chr(13)#/* HEADER.CSS */#chr(10)##chr(13)##header##chr(10)##chr(13)#/* IMAGES.CSS */#chr(10)##chr(13)##images##chr(10)##chr(13)#/* FORMS.CSS */#chr(10)##chr(13)##forms##chr(10)##chr(13)#/* TABLES.CSS */#chr(10)##chr(13)##tables#/* PRETTYPHOTO.CSS */#chr(10)##chr(13)##prettyPhoto#">

			<cfset application.init = true>

		</cfif>
	</cflock>
</cfif>

<!--- error page --->
<cfif application.settings.errorPage>
	<cferror type="exception" template="#application.settings.mapping#/error.cfm">
</cfif>

<!--- include UDFs --->
<cfinclude template="#application.settings.mapping#/includes/udf.cfm">

<cftry>
	<cfparam name="session.style" default="#application.settings.default_style#">
	<cfcatch>
		<cfparam name="session.style" default="blue">
	</cfcatch>
</cftry>

<!--- check for logout --->
<cfif StructKeyExists(url,"logout") or not isDefined("session.user.userid")>
	<cfset structDelete(session, "user")>
	<cfif StructKeyExists(cookie,"ptuser")>
		<cfif compare(application.settings.mapping,'')>
			<cfcookie name="ptuser" expires="now" domain="#replaceNoCase(replaceNoCase(application.settings.rootURL,'http://',''),'https://','')#" path="#application.settings.mapping#">
		<cfelse>
			<cfcookie name="ptuser" expires="now" domain="#replaceNoCase(replaceNoCase(application.settings.rootURL,'http://',''),'https://','')#">
		</cfif>
	</cfif>
	<cfset session.loggedin = false>
	<cflogout>
</cfif>

<!--- handle security --->
<cfif not findNoCase('/rss.cfm',cgi.script_name) and not findNoCase('/register.cfm',cgi.script_name) and not findNoCase('/confirm.cfm',cgi.script_name) and not findNoCase('/forgot.cfm',cgi.script_name) and not findNoCase('/reset.cfm',cgi.script_name) and not findNoCase('/api/',cgi.script_name) and not findNoCase('/install/',cgi.script_name)>

	<!--- check for auto login --->
	<cfif application.settings.guestUserAutoLogin AND NOT StructKeyExists(url,'logout') and not find('edit',cgi.script_name)>
		<cfset url.guest = 1>
	</cfif>
	
	<cflogin>
	
		<cfif StructKeyExists(url,'guest') and application.settings.guestUserAutoLogin>
			<cfset form.username = "guest">
			<cfset form.password = "guest">
		</cfif>
	
		<cfif NOT StructKeyExists(form,"username") AND (not StructKeyExists(cookie,"ptuser") or not len(cookie.ptuser))>
			<cfinclude template="login.cfm">
			<cfabort>
		<cfelse>
			<!--- are we trying to logon? --->
			<cfif ((not StructKeyExists(cookie,"ptuser") or not len(cookie.ptuser)) and not compare(trim(form.username),'')) or ((not StructKeyExists(cookie,"ptuser") or not len(cookie.ptuser)) and not compare(trim(form.password),''))>
				<cfset variables.error="Your must enter your login info to continue!">
				<cfif findNoCase('/mobile',cgi.script_name)>
					<cfinclude template="mobile/login.cfm">
				<cfelse>
					<cfinclude template="login.cfm">
				</cfif>
				<cfabort>
			<cfelse>
				<!--- check user account against database table --->
				<cfif StructKeyExists(cookie,"ptuser") and len(cookie.ptuser)>
					<cfset thisUser = application.user.login(username=decrypt(cookie.ptuser,'ajaxcf.com'),cookieLogin=true)>
				<cfelse>	
					<cfset thisUser = application.user.login(trim(form.username),trim(form.password))>
				</cfif>
				<cfif not structKeyExists(thisUser,"userid") or not compare(thisUser.userid,'')>
					<cfset variables.error="Your login was not accepted. Please try again!">
					<cfif findNoCase('/mobile',cgi.script_name)>
						<cfinclude template="mobile/login.cfm">
					<cfelse>
						<cfinclude template="login.cfm">
					</cfif>
					<cfabort>
				<cfelse>
					<!--- log user into application --->
					<cfif StructKeyExists(cookie,"ptuser") and len(cookie.ptuser)>
						<cfloginuser name="#decrypt(cookie.ptuser,'ajaxcf.com')#" password="cookielogin" roles="user">
					<cfelse>
						<cfloginuser name="#trim(form.username)#" password="#trim(hash(form.password))#" roles="user">
					</cfif>
					<cfset session.user = thisUser>
					<cfset session.style = thisUser.style>
					<cfset session.loggedin = true>
					<cfset session.assignedTo = "">
					<!--- set last login stamp --->
					<cfset application.user.setLastLogin(session.user.userid)>
					<!--- set persistant login if user chose it --->
					<cfif StructKeyExists(form,"remain")>
						<cfif compare(application.settings.mapping,'')>
							<cfcookie name="ptuser" expires="14" value="#encrypt(trim(form.username),'ajaxcf.com')#" domain="#replaceNoCase(replaceNoCase(application.settings.rootURL,'http://',''),'https://','')#" path="#application.settings.mapping#">
						<cfelse>
							<cfcookie name="ptuser" expires="14" value="#encrypt(trim(form.username),'ajaxcf.com')#" domain="#replaceNoCase(replaceNoCase(application.settings.rootURL,'http://',''),'https://','')#">
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	
	</cflogin>
</cfif>

<cfif StructKeyExists(form,"assignedTo")>
	<cfset session.assignedTo = form.assignedTo>
</cfif>

<cfsetting enablecfoutputonly="false">
