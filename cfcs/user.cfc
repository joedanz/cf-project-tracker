<cfcomponent displayName="Users" hint="Methods dealing with project users.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">

	<cffunction name="init" access="public" returntype="user" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN & table prefix.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="login" access="public" returntype="struct" output="false"
				hint="Login method.">				
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset var qLogin = "">
		<cfset var sLogin = StructNew()>
		<cfset var qProjects = "">
		<cfquery name="qLogin" datasource="#variables.dsn#">
			SELECT userID, firstName, lastName, username, email, phone, lastLogin, avatar, style, admin, active
			FROM #variables.tableprefix#users
			WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="35">
				AND password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" maxlength="30">
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
				sLogin.admin = qLogin.admin;
				sLogin.active = qLogin.active;
				sLogin.projects = application.project.get(qLogin.userID);
			</cfscript>
		</cfif>
		<cfreturn sLogin>
	</cffunction>		
	
	<cffunction name="get" access="public" returntype="query" output="false"
				hint="Returns user records.">				
		<cfargument name="userID" type="string" required="false" default="">
		<cfargument name="userIDlist" type="string" required="false" default="">
		<cfargument name="username" type="string" required="false" default="">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT u.userID, u.firstName, u.lastName, u.username, u.email, u.phone, u.mobile, u.carrierID, 
				u.lastLogin, u.avatar, u.style, u.email_files, u.mobile_files, u.email_issues, u.mobile_issues, 
				u.email_msgs, u.mobile_msgs, u.email_mstones, u.mobile_mstones, u.email_todos, u.mobile_todos, 
				u.admin, u.active, c.prefix, c.suffix
			FROM #variables.tableprefix#users u
				LEFT JOIN #variables.tableprefix#carriers c ON u.carrierID = c.carrierID
			WHERE 0=0
			<cfif compare(ARGUMENTS.userID,'')>
				AND u.userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
			</cfif>
			<cfif compare(ARGUMENTS.userIDlist,'')>
				AND u.userID IN ('#replace(arguments.userIDlist,",","','","ALL")#')
			</cfif>
			<cfif compare(ARGUMENTS.username,'')>
				AND u.username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">
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
		<cfargument name="active" type="numeric" required="false" default="1">
		<cfset var newUsername = left(lcase(ARGUMENTS.firstName),1) & lcase(ARGUMENTS.lastName)>
		<cfset var validUsername = false>
		<cfset var qCheckUser = "">
		<cfset var startRec = 1>
		<cfset var emailFrom = 1>
		<cfloop condition="validUsername is false">
			<cfset qCheckUser = application.user.get('','',newUsername)>
			<cfif not qCheckUser.recordCount>
				<cfset validUsername = true>
			<cfelse>
				<cfset newUsername = newUsername & startRec>
				<cfset startRec = startRec + 1>
			</cfif>
		</cfloop>
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#users (userID, firstName, lastName, username, password, email, avatar, style, email_files, mobile_files, email_issues, mobile_issues, email_msgs, mobile_msgs, email_mstones, mobile_mstones, email_todos, mobile_todos, admin, active)
				VALUES(<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstName#" maxlength="12">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#" maxlength="20">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" maxlength="20">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" maxlength="120">, 
						0,
						'#application.settings.default_style#',
						1,1,1,1,1,1,1,1,1,1,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.admin#">, 
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">		
						)
		</cfquery>
		<cfif request.udf.isEmail(arguments.email)>
			<cfif request.udf.isEmail(session.user.email)>
				<cfset emailFrom = session.user.email>
			<cfelse>
				<cfset emailFrom = application.settings.adminEmail>
			</cfif>
			<cfmail to="#arguments.email#" from="#emailFrom#" subject="New #application.settings.app_title# Account">An account has been setup for you to use the #application.settings.app_title#.

You can login at #application.settings.rootURL##application.settings.mapping#

     Username: #arguments.username#
     Password: #arguments.password#
			</cfmail>
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
		<cfargument name="email_files" type="numeric" required="true">
		<cfargument name="mobile_files" type="numeric" required="true">		
		<cfargument name="email_issues" type="numeric" required="true">
		<cfargument name="mobile_issues" type="numeric" required="true">
		<cfargument name="email_msgs" type="numeric" required="true">
		<cfargument name="mobile_msgs" type="numeric" required="true">
		<cfargument name="email_mstones" type="numeric" required="true">
		<cfargument name="mobile_mstones" type="numeric" required="true">
		<cfargument name="email_todos" type="numeric" required="true">
		<cfargument name="mobile_todos" type="numeric" required="true">
		<cfargument name="admin" type="numeric" required="true">
		<cfargument name="active" type="numeric" required="false" default="1">
		<cfset var emailFrom = "">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#users (userID, firstName, lastName, username, password, email, phone, mobile, carrierID, avatar, style, email_files, mobile_files, email_issues, mobile_issues, email_msgs, mobile_msgs, email_mstones, mobile_mstones, email_todos, mobile_todos, admin, active)
				VALUES(<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstName#" maxlength="12">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#" maxlength="20">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" maxlength="20">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" maxlength="120">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone#" maxlength="15">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile#" maxlength="15">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carrierID#" maxlength="35">,
						0,
						'#application.settings.default_style#',
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_files#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_files#">,						
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_issues#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_issues#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_msgs#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_msgs#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_mstones#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_mstones#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_todos#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_todos#">,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.admin#">, 
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">		
						)
		</cfquery>
		<cfif request.udf.isEmail(arguments.email)>
			<cfif request.udf.isEmail(session.user.email)>
				<cfset emailFrom = session.user.email>
			<cfelse>
				<cfset emailFrom = application.settings.adminEmail>
			</cfif>			
			<cfmail to="#arguments.email#" from="#emailFrom#" subject="New #application.settings.app_title# Account">An account has been setup for you to use the #application.settings.app_title#.
	
You can login at #application.settings.rootURL##application.settings.mapping#
	
     Username: #arguments.username#
     Password: #arguments.password#
			</cfmail>
		</cfif>
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
		<cfquery datasource="#variables.dsn#">
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
	
	<cffunction name="notifyUpdate" access="public" returntype="void" output="false"
				hint="Updates a users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="email_files" type="numeric" required="true">
		<cfargument name="mobile_files" type="numeric" required="true">
		<cfargument name="email_issues" type="numeric" required="true">
		<cfargument name="mobile_issues" type="numeric" required="true">
		<cfargument name="email_msgs" type="numeric" required="true">
		<cfargument name="mobile_msgs" type="numeric" required="true">
		<cfargument name="email_mstones" type="numeric" required="true">
		<cfargument name="mobile_mstones" type="numeric" required="true">
		<cfargument name="email_todos" type="numeric" required="true">
		<cfargument name="mobile_todos" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET
				email_files = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_files#">, 
				mobile_files = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_files#">,
				email_issues = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_issues#">, 
				mobile_issues = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_issues#">,
				email_msgs = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_msgs#">, 
				mobile_msgs = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_msgs#">,
				email_mstones = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_mstones#">, 
				mobile_mstones = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_mstones#">,
				email_todos = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_todos#">, 
				mobile_todos = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_todos#"> 
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
		<cfargument name="email_files" type="numeric" required="true">
		<cfargument name="mobile_files" type="numeric" required="true">
		<cfargument name="email_issues" type="numeric" required="true">
		<cfargument name="mobile_issues" type="numeric" required="true">
		<cfargument name="email_msgs" type="numeric" required="true">
		<cfargument name="mobile_msgs" type="numeric" required="true">
		<cfargument name="email_mstones" type="numeric" required="true">
		<cfargument name="mobile_mstones" type="numeric" required="true">
		<cfargument name="email_todos" type="numeric" required="true">
		<cfargument name="mobile_todos" type="numeric" required="true">
		<cfargument name="admin" type="numeric" required="true">
		<cfargument name="active" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET
				firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstName#" maxlength="12">, 
				lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#" maxlength="20">,
				username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">,
				<cfif compare(arguments.password,'')>
					password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" maxlength="20">,
				</cfif>
				email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" maxlength="120">,
				phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone#" maxlength="15">,
				mobile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile#" maxlength="15">,
				carrierID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carrierID#" maxlength="35">,
				email_files = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_files#">, 
				mobile_files = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_files#">,
				email_issues = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_issues#">, 
				mobile_issues = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_issues#">,
				email_msgs = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_msgs#">, 
				mobile_msgs = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_msgs#">, 
				email_mstones = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_mstones#">, 
				mobile_mstones = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_mstones#">, 
				email_todos = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.email_todos#">, 
				mobile_todos = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.mobile_todos#">, 
				admin = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.admin#">,
				active = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">			
		</cfquery>		
	</cffunction>
	
	<cffunction name="acctUpdate" access="public" returntype="void" output="false"
				hint="Updates a users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET
				username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">
				<cfif compare(arguments.password,'')>
					, password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" maxlength="20">
				</cfif>
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">			
		</cfquery>		
	</cffunction>	
	
	<cffunction name="setImage" access="public" returnType="boolean" output="false"
				hint="Sets avatar for user.">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="imageExists" type="boolean" required="true">
		<cfquery datasource="#variables.dsn#">
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
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users 
				SET style = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.style#" maxlength="20">
				WHERE userid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
	
	<cffunction name="delete" access="public" returntype="void" output="false"
				hint="Deletes a users record.">
		<cfargument name="userID" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#users WHERE 0=0
				AND userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#">
		</cfquery>		
	</cffunction>

	<cffunction name="setLastLogin" access="public" returnType="boolean" output="false"
				hint="Sets last login stamp for user.">
		<cfargument name="userid" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET lastLogin = #Now()# 
				WHERE userid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="findUsername" access="public" returntype="query" output="false"
				hint="Returns username for an email.">				
		<cfargument name="email" type="string" required="false" default="">
		<cfset var qFindUsername = "">
		<cfquery name="qFindUsername" datasource="#variables.dsn#">
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
		<cfquery name="qFindPassword" datasource="#variables.dsn#">
			SELECT password,email,firstName
			FROM #variables.tableprefix#users
			WHERE username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
		</cfquery>		
		<cfreturn qFindPassword>
	</cffunction>
		
</cfcomponent>
