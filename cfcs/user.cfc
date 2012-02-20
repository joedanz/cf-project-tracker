<cfcomponent displayName="Users" hint="Methods dealing with project users.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returntype="user" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN & table prefix.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="login" access="public" returntype="struct" output="false"
				hint="Login method.">				
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="false" default="">
		<cfargument name="cookieLogin" type="boolean" required="false" default="false">
		<cfset var qLogin = "">
		<cfset var sLogin = StructNew()>
		<cfset var sAuth = StructNew()>
		<cfset var qProjects = "">
		<cfset sAuth.Authenticated = 0 />
		
		<cfif Trim(application.settings.ldapHost) NEQ "">
			<cfset oLDAP = createObject("component","cfcs.ldap").init(application.settings)>
			<cfset sAuth = oLDAP.AuthLDAP(arguments.username,arguments.password) />
		</cfif>
		<cfquery name="qLogin" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT userID, firstName, lastName, username, email, phone, lastLogin, avatar, style, locale, timezone, 
				admin, report, invoice, active
			FROM #variables.tableprefix#users
			WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="35">
			<cfif not cookieLogin AND sAuth.Authenticated EQ 0>
				AND password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.password)#" maxlength="32">
			</cfif>
		</cfquery>
		<cfif qLogin.recordCount eq 1>
			<cfscript>
				sLogin.userID = qLogin.userID;
				sLogin.firstName = qLogin.firstName;
				sLogin.lastName = qLogin.lastName;
				sLogin.username = qLogin.username;
				sLogin.email = qLogin.email;
				sLogin.phone = qLogin.phone;
				sLogin.lastLogin = qLogin.lastLogin;
				sLogin.avatar = qLogin.avatar;
				sLogin.style = qLogin.style;
				sLogin.locale = qLogin.locale;
				sLogin.timezone = qLogin.timezone;
				sLogin.admin = qLogin.admin;
				sLogin.report = qLogin.report;
				sLogin.invoice = qLogin.invoice;
				sLogin.active = qLogin.active;
				sLogin.projects = application.project.get(qLogin.userID);
				sLogin.sAuth = sAuth;
			</cfscript>
		</cfif>
		<cfreturn sLogin>
	</cffunction>		
	
	<cffunction name="get" access="public" returntype="query" output="false"
				hint="Returns user records.">				
		<cfargument name="userID" type="string" required="false" default="">
		<cfargument name="userIDlist" type="string" required="false" default="">
		<cfargument name="username" type="string" required="false" default="">
		<cfargument name="activeOnly" type="boolean" required="false" default="false">
		
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT u.userID, u.firstName, u.lastName, u.username, u.email, u.phone, u.mobile, u.carrierID, 
				u.locale, u.timezone, u.lastLogin, u.avatar, u.style, u.admin, u.report, u.invoice, u.active, 
				c.prefix, c.suffix
			FROM #variables.tableprefix#users u
				LEFT JOIN #variables.tableprefix#carriers c ON u.carrierID = c.carrierID
			WHERE 0=0
			<cfif compare(ARGUMENTS.userID,'')>
				AND u.userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
			</cfif>
			<cfif compare(ARGUMENTS.userIDlist,'')>
				AND u.userID IN (<cfqueryparam value="#arguments.userIDlist#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
			</cfif>
			<cfif compare(ARGUMENTS.username,'')>
				AND u.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">
			</cfif>
			<cfif ARGUMENTS.activeOnly>
				AND u.active = 1
			</cfif>
			ORDER BY u.lastName, u.firstName
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>
	
	<cffunction name="create" access="public" returntype="void" output="false"
				hint="Inserts a users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="firstName" type="string" required="true">
		<cfargument name="lastName" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="admin" type="numeric" required="true">
		<cfargument name="report" type="numeric" required="true">
		<cfargument name="invoice" type="numeric" required="true">
		<cfargument name="active" type="numeric" required="false" default="1">
		<cfset var newUsername = left(lcase(ARGUMENTS.firstName),1) & lcase(ARGUMENTS.lastName)>
		<cfset var validUsername = false>
		<cfset var qCheckUser = "">
		<cfset var startRec = 1>
		<cfset var emailFrom = "">
		<cfset var theMessage = "">
		<cfloop condition="validUsername is false">
			<cfset qCheckUser = application.user.get('','',newUsername)>
			<cfif not qCheckUser.recordCount>
				<cfset validUsername = true>
			<cfelse>
				<cfset newUsername = newUsername & startRec>
				<cfset startRec = startRec + 1>
			</cfif>
		</cfloop>
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#users (userID, firstName, lastName, username, password, email, 
					phone, avatar, style, admin, report, invoice, active)
				VALUES(<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstName#" maxlength="12">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#" maxlength="20">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.password)#" maxlength="32">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" maxlength="120">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone#" maxlength="15">,
						0,
						'#application.settings.default_style#',
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.admin#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.report#">, 
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.invoice#">,  
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">		
						)
		</cfquery>
		<cfif request.udf.isEmail(arguments.email)>
			<cfif request.udf.isEmail(session.user.email)>
				<cfset emailFrom = session.user.email>
			<cfelse>
				<cfset emailFrom = application.settings.adminEmail>
			</cfif>
			
			<cfsavecontent variable="theMessage">
			<cfoutput>An account has been setup for you to use the #application.settings.app_title#.

You can login at #application.settings.rootURL##application.settings.mapping#

     Username: #arguments.username#
     Password: #arguments.password#			
			</cfoutput>
			</cfsavecontent>
			
			<cfset request.udf.sendEmail(emailFrom,arguments.email,'New #application.settings.app_title# Account',theMessage)>
				
		</cfif>
	</cffunction>

	<cffunction name="adminCreate" access="public" returntype="void" output="false"
				hint="Inserts a users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="firstName" type="string" required="true">
		<cfargument name="lastName" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="mobile" type="string" required="true">
		<cfargument name="carrierID" type="string" required="true">
		<cfargument name="locale" type="string" required="true">
		<cfargument name="timezone" type="string" required="true">
		<cfargument name="admin" type="numeric" required="true">
		<cfargument name="report" type="numeric" required="true">
		<cfargument name="invoice" type="numeric" required="true">
		<cfargument name="active" type="numeric" required="false" default="1">
		<cfset var emailFrom = "">
		<cfset var theMessage = "">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#users (userID, firstName, lastName, username, password, email, 
					phone, mobile, carrierID, locale, timezone, avatar, style, admin, report, invoice, active)
				VALUES(<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstName#" maxlength="12">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#" maxlength="20">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.password)#" maxlength="32">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" maxlength="120">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone#" maxlength="15">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile#" maxlength="15">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carrierID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locale#" maxlength="32">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.timezone#" maxlength="32">,
						0,
						'#application.settings.default_style#',
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.admin#">, 
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.report#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.invoice#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">		
						)
		</cfquery>
		<cfif request.udf.isEmail(arguments.email)>
			<cfif request.udf.isEmail(session.user.email)>
				<cfset emailFrom = session.user.email>
			<cfelse>
				<cfset emailFrom = application.settings.adminEmail>
			</cfif>			

			<cfsavecontent variable="theMessage">
			<cfoutput>An account has been setup for you to use the #application.settings.app_title#.
	
You can login at #application.settings.rootURL##application.settings.mapping#
	
     Username: #arguments.username#
     Password: #arguments.password#		
			</cfoutput>
			</cfsavecontent>

			<cfset request.udf.sendEmail(emailFrom,arguments.email,'New #application.settings.app_title# Account',theMessage)>
				
		</cfif>
	</cffunction>

	<cffunction name="selfRegister" access="public" returntype="void" output="false"
				hint="Inserts a users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="firstName" type="string" required="true">
		<cfargument name="lastName" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfset var theMessage = "">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#users (userID, firstName, lastName, username, password, email, avatar, style, admin, report, invoice, active)
				VALUES(<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstName#" maxlength="12">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#" maxlength="20">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.password)#" maxlength="32">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" maxlength="120">, 
						0,'#application.settings.default_style#',0,0,0,0		
						)
		</cfquery>

		<cfsavecontent variable="theMessage">
		<cfoutput>An account has been setup for you to use the #application.settings.app_title#.

You must confirm this account before using it by clicking here:
#application.settings.rootURL##application.settings.mapping#/confirm.cfm?u=#arguments.userID#
		</cfoutput>
		</cfsavecontent>

		<cfset request.udf.sendEmail(application.settings.adminEmail,arguments.email,'New #application.settings.app_title# Account',theMessage)>

	</cffunction>

	<cffunction name="confirm" access="public" returntype="boolean" output="false"
				hint="Inserts a users record.">
		<cfargument name="userID" type="string" required="true">
		<cfset var checkUserID = "">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#users
			SET active = 1
			WHERE userID = 
				<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfquery name="checkUserID" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT userID FROM #variables.tableprefix#users
			WHERE userID = 
				<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
			AND active = 1
		</cfquery>
		<cfreturn checkUserID.recordCount>
	</cffunction>

	<cffunction name="userUpdate" access="public" returntype="void" output="false"
				hint="Updates a users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="firstName" type="string" required="true">
		<cfargument name="lastName" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="mobile" type="string" required="true">
		<cfargument name="carrierID" type="string" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#users SET
				firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstName#" maxlength="12">, 
				lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#" maxlength="20">, 
				email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" maxlength="120">,
				phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone#" maxlength="15">,
				mobile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile#" maxlength="15">,
				carrierID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carrierID#" maxlength="35">
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">			
		</cfquery>		
	</cffunction>
	
	<cffunction name="adminUpdate" access="public" returntype="void" output="false"
				hint="Updates a users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="firstName" type="string" required="true">
		<cfargument name="lastName" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="mobile" type="string" required="true">
		<cfargument name="carrierID" type="string" required="true">
		<cfargument name="locale" type="string" required="true">
		<cfargument name="timezone" type="string" required="true">
		<cfargument name="admin" type="numeric" required="true">
		<cfargument name="report" type="numeric" required="true">
		<cfargument name="invoice" type="numeric" required="true">
		<cfargument name="active" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#users SET
				firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstName#" maxlength="12">, 
				lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#" maxlength="20">,
				username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">,
				<cfif compare(arguments.password,'')>
					password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.password)#" maxlength="32">,
				</cfif>
				email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" maxlength="120">,
				phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone#" maxlength="15">,
				mobile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile#" maxlength="15">,
				carrierID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carrierID#" maxlength="35">,
				locale = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locale#" maxlength="32">,
				timezone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.timezone#" maxlength="32">,
				admin = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.admin#">,
				report = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.report#">,
				invoice = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.invoice#">,
				active = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">			
		</cfquery>		
	</cffunction>
	
	<cffunction name="acctUpdate" access="public" returntype="void" output="false"
				hint="Updates a users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#users SET
				username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">
				<cfif compare(arguments.password,'')>
					, password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.password)#" maxlength="32">
				</cfif>
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">			
		</cfquery>		
	</cffunction>	
	
	<cffunction name="setImage" access="public" returnType="boolean" output="false"
				hint="Sets avatar for user.">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="imageExists" type="boolean" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#users 
				SET avatar = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.imageExists#">
				WHERE userid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
	
	<cffunction name="setStyle" access="public" returnType="boolean" output="false"
				hint="Sets style for user.">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="style" type="string" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#users 
				SET style = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.style#" maxlength="20">
				WHERE userid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="setLocaleTimezone" access="public" returnType="boolean" output="false"
				hint="Sets timezone for user.">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="locale" type="string" required="true">
		<cfargument name="timezone" type="string" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#users 
				SET locale = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locale#" maxlength="32">,
					timezone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.timezone#" maxlength="32">
				WHERE userid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="delete" access="public" returntype="void" output="false"
				hint="Deletes a users record.">
		<cfargument name="userID" type="string" required="true">
		<cftransaction>
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#users WHERE 0=0
				AND userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">
		</cfquery>
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#project_users WHERE 0=0
				AND userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">
		</cfquery>
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#user_notify WHERE 0=0
				AND userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">
		</cfquery>
		</cftransaction>
	</cffunction>

	<cffunction name="setLastLogin" access="public" returnType="boolean" output="false"
				hint="Sets last login stamp for user.">
		<cfargument name="userid" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#users 
			SET lastLogin = #DateConvert("local2Utc",Now())#
			WHERE userid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="findUsername" access="public" returntype="query" output="false"
				hint="Returns username for an email.">				
		<cfargument name="email" type="string" required="false" default="">
		<cfset var qFindUsername = "">
		<cfquery name="qFindUsername" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT username,firstName,lastName
			FROM #variables.tableprefix#users
			WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">
		</cfquery>		
		<cfreturn qFindUsername>
	</cffunction>

	<cffunction name="findPassword" access="public" returntype="query" output="false"
				hint="Returns password for a username.">				
		<cfargument name="username" type="string" required="false" default="">
		<cfset var qFindPassword = "">
		<cfquery name="qFindPassword" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT userid,email,firstName
			FROM #variables.tableprefix#users
			WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
		</cfquery>		
		<cfreturn qFindPassword>
	</cffunction>
	
	<cffunction name="setPassword" access="public" returntype="void" output="false"
				hint="Sets password for a username.">				
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset var qFindPassword = "">
		<cfquery name="qFindPassword" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#users
			SET password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.password)#" maxlength="32">
			WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#" maxlength="35">
		</cfquery>		
	</cffunction>	
		
</cfcomponent>