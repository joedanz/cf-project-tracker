<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfset applicationName = right(REReplace(getDirectoryFromPath(getCurrentTemplatePath()),'[^A-Za-z0-9]','','all'),64)>
<cfapplication name="#applicationName#" sessionManagement="true" loginstorage="session" sessiontimeout="#CreateTimeSpan(0,1,30,0)#">

<cfparam name="application.settings.showDebug" default="false">
<cfsetting showdebugoutput="#application.settings.showDebug#">

<!--- G18N - everything in/out to unicode --->
<cfset setEncoding('URL','UTF-8')>
<cfset setEncoding('Form','UTF-8')>
<cfcontent type="text/html; charset=UTF-8">

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
			<cfif len(trim(settings.userFilesCustom))>
				<cfset application.userFilesPath = settings.userFilesCustom>
				<cfif compare(right(settings.userFilesCustom,1),'/')>
					<cfset application.userFilesPath = application.userFilesPath & '/'>
				</cfif>
			<cfelse>
				<cfset application.userFilesPath = ExpandPath('#settings.mapping#/userfiles/')>
			</cfif>
			<!--- create userfiles directory if it doesn't exist --->
			<cfscript>
				/**
				 * Create all non exitant directories in a path.
				 * 
				 * @param p      The path to create. (Required)
				 * @return Returns nothing. 
				 * @author Jorge Iriso (jiriso@fitquestsl.com) 
				 * @version 1, September 21, 2004 
				 */
				function makeDirs(p){
				    createObject("java", "java.io.File").init(p).mkdirs();
				}			
			</cfscript>
			<cfset makeDirs(application.userFilesPath)>

			<!--- application CFCs --->
			<cfset application.activity = createObject("component","cfcs.activity").init(settings)>
			<cfset application.billing = createObject("component","cfcs.billing").init(settings)>
			<cfset application.carrier = createObject("component","cfcs.carrier").init(settings)>
			<cfset application.calendar = createObject("component","cfcs.calendar").init(settings)>
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
			<cfset application.timezone = createObject("component","cfcs.timezone").init()>
			<cfset application.todo = createObject("component","cfcs.todo").init(settings)>
			<cfset application.todolist = createObject("component","cfcs.todolist").init(settings)>
			<cfset application.user = createObject("component","cfcs.user").init(settings)>
			<!--- Google Calendar --->
			<cftry>
				<cfset application.gCal = createObject("component", "cfcs.GoogleCalendar").init(settings.googlecal_user,settings.googlecal_pass,settings.googlecal_offset)>
				<cfcatch></cfcatch>
			</cftry>
			
			<!--- DataMgr --->
			<cftry>
				<cfset application.DataMgr = createObject("component","cfcs.DataMgr.DataMgr").init(settings.dsn)>
				<cfcatch></cfcatch>
			</cftry>

			<!--- stored queries --->
			<cftry>
				<cfset application.carriers = application.carrier.get(activeOnly=true)>
				<cfcatch></cfcatch>
			</cftry>
			<cfset application.timezones = application.timezone.getAvailableTZ()>

			<!--- geolocation stuff --->
			<cftry>
				<cfset application.settings.default_offset = application.timezone.getTZOffset(tz=application.settings.default_timezone)>
				<cfcatch>
					<cfset application.settings.default_offset = application.timezone.getTZOffset(tz='US/Eastern')>
				</cfcatch>
			</cftry>
			
			<!--- check for Blue Dragon --->
			<cfset application.isBD = StructKeyExists(server,"bluedragon")>

			<!--- check for Railo --->
			<cfset application.isRailo = not compareNoCase(server.coldfusion.productname,"railo")>

			<!--- get CF version --->
			<cfif application.isBD and find('.',server.coldfusion.productversion)>
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

<!--- include UDFs --->
<cfinclude template="#application.settings.mapping#/includes/udf.cfm">

<!--- error page --->
<cfif application.settings.errorPage>
	<cferror type="exception" template="#application.settings.mapping#/error.cfm">
</cfif>

<cftry>
	<cfparam name="session.style" default="#application.settings.default_style#">
	<cfcatch>
		<cfparam name="session.style" default="blue">
	</cfcatch>
</cftry>

<!--- check for logout --->
<cfif StructKeyExists(url,"logout") or not isDefined("session.user.userid") or StructKeyExists(url,'guest')>
	<cfset structDelete(session, "user")>
	<cfif StructKeyExists(cookie,"ptuser") and StructKeyExists(url,"logout")>
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
			<cfif findNoCase('/mobile',cgi.script_name)>
				<cfinclude template="mobile/login.cfm">
			<cfelse>
				<cfinclude template="login.cfm">
			</cfif>
			<cfabort>
		<cfelse>
			<!--- are we trying to logon? --->
			<cfif ((not StructKeyExists(cookie,"ptuser") or not len(cookie.ptuser)) and not compare(trim(form.username),'')) or ((not StructKeyExists(cookie,"ptuser") or not len(cookie.ptuser)) and not compare(trim(form.password),''))>
				<cfset request.error="Your must enter your login info to continue!">
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
					<cfset request.error="Your login was not accepted. Please try again!">
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
					<cfif compare(thisUser.locale,'')>
						<cfset session.locale = thisUser.locale>
					<cfelse>
						<cftry>
							<cfset session.locale = application.settings.default_locale>
							<cfcatch>
								<cfset session.locale = 'English (US)'>
							</cfcatch>
						</cftry>
					</cfif>
					<cfif compare(thisUser.timezone,'')>
						<cfset session.timezone = thisUser.timezone>
						<cfset session.tzOffset = application.timezone.getTZOffset(tz=thisUser.timezone)>
					<cfelse>
						<cftry>
							<cfset session.timezone = application.settings.default_timezone>
							<cfset session.tzOffset = application.timezone.getTZOffset(tz=application.settings.default_timezone)>
							<cfcatch>
								<cfset session.timezone = 'US/Eastern'>
								<cfset session.tzOffset = application.timezone.getTZOffset(tz='US/Eastern')>
							</cfcatch>
						</cftry>
					</cfif>
					<cfif reFindNoCase("android|avantgo|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0>
						<cfset session.mobileBrowser = true>
					<cfelse>
						<cfset session.mobileBrowser = false>
					</cfif>
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

<!--- set locale --->
<cfif StructKeyExists(session,"loggedin") and session.loggedin>
	<cfset setLocale(session.locale)>
<cfelse>
	<cftry>
		<cfset setLocale(application.settings.default_locale)>
		<cfcatch>
			<cfset setLocale('English (US)')>
		</cfcatch>
	</cftry>
</cfif>

<cfif StructKeyExists(form,"assignedTo")>
	<cfset session.assignedTo = form.assignedTo>
</cfif>

<cfsetting enablecfoutputonly="false">
