<cfcomponent displayName="Users" hint="Methods dealing with project users.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">
	
	<cfscript>
	/**
	 * Generates an 8-character random password free of annoying similar-looking characters such as 1 or l.
	 * 
	 * @return Returns a string. 
	 * @author Alan McCollough (amccollough@anmc.org) 
	 * @version 1, December 18, 2001 
	 */
	function MakePassword()
	{      
	  var valid_password = 0;
	  var loopindex = 0;
	  var this_char = "";
	  var seed = "";
	  var new_password = "";
	  var new_password_seed = "";
	  while (valid_password eq 0){
	    new_password = "";
	    new_password_seed = CreateUUID();
	    for(loopindex=20; loopindex LT 35; loopindex = loopindex + 2){
	      this_char = inputbasen(mid(new_password_seed, loopindex,2),16);
	      seed = int(inputbasen(mid(new_password_seed,loopindex/2-9,1),16) mod 3)+1;
	      switch(seed){
	        case "1": {
	          new_password = new_password & chr(int((this_char mod 9) + 48));
	          break;
	        }
		case "2": {
	          new_password = new_password & chr(int((this_char mod 26) + 65));
	          break;
	        }
	        case "3": {
	          new_password = new_password & chr(int((this_char mod 26) + 97));
	          break;
	        }
	      } //end switch
	    }
	    valid_password = iif(refind("(O|o|0|i|l|1|I|5|S)",new_password) gt 0,0,1);	
	  }
	  return new_password;
	}
	</cfscript>
	
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
			SELECT userID, firstName, lastName, username, email, phone, mobile, lastLogin, avatar, style, 
				email_todos, mobile_todos, email_mstones, mobile_mstones, email_issues, mobile_issues,
				admin, active
			FROM #variables.tableprefix#users
			WHERE 0=0
			<cfif compare(ARGUMENTS.userID,'')>
				AND userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">
			</cfif>
			<cfif compare(ARGUMENTS.userIDlist,'')>
				AND userID IN ('#replace(arguments.userIDlist,",","','","ALL")#')
			</cfif>
			<cfif compare(ARGUMENTS.username,'')>
				AND username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">
			</cfif>
			ORDER BY lastName, firstName
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>
	
	<cffunction name="create" access="public" returntype="void" output="false"
				hint="Inserts a pt_users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="firstName" type="string" required="true">
		<cfargument name="lastName" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="admin" type="numeric" required="true">
		<cfargument name="active" type="numeric" required="false" default="1">
		<cfset var newUsername = left(lcase(ARGUMENTS.firstName),1) & lcase(ARGUMENTS.lastName)>
		<cfset var validUsername = false>
		<cfset var qCheckUser = "">
		<cfset var startRec = 1>
		<cfset var newPass = left(MakePassword(),4)>
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
			INSERT INTO #variables.tableprefix#users (userID, firstName, lastName, username, password, email, avatar, style, email_todos, mobile_todos, email_mstones, mobile_mstones, email_issues, mobile_issues, admin, active)
				VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstName#" maxlength="12">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#" maxlength="20">, 
						'#newUsername#', '#newPass#',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" maxlength="120">, 
						0,
						'#application.settings.default_style#',
						0,0,0,0,0,0,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.admin#">, 
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">		
						)
		</cfquery>
		<cfmail to="#arguments.email#" from="#session.user.email#" subject="New #application.settings.app_title# Account">An account has been setup for you to use the #application.settings.app_title#.

You can login at #application.settings.rootURL##application.settings.mapping#

     Username: #newUsername#
     Password: #newPass#
		</cfmail>
	</cffunction>

	<cffunction name="adminCreate" access="public" returntype="void" output="false"
				hint="Inserts a pt_users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="firstName" type="string" required="true">
		<cfargument name="lastName" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="admin" type="numeric" required="true">
		<cfargument name="active" type="numeric" required="false" default="1">
		<cfquery datasource="#variables.dsn#">
			INSERT INTO #variables.tableprefix#users (userID, firstName, lastName, username, password, email, avatar, style, email_todos, mobile_todos, email_mstones, mobile_mstones, email_issues, mobile_issues, admin, active)
				VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstName#" maxlength="12">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#" maxlength="20">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userame#" maxlength="30">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" maxlength="20">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" maxlength="120">, 
						0,
						'#application.settings.default_style#',
						0,0,0,0,0,0,
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.admin#">, 
						<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">		
						)
		</cfquery>
		<cfmail to="#arguments.email#" from="#session.user.email#" subject="New #application.settings.app_title# Account">An account has been setup for you to use the #application.settings.app_title#.

You can login at #application.settings.rootURL##application.settings.mapping#

     Username: #arguments.username#
     Password: #arguments.password#
		</cfmail>
	</cffunction>

	<cffunction name="userUpdate" access="public" returntype="void" output="false"
				hint="Updates a pt_users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="firstName" type="string" required="true">
		<cfargument name="lastName" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="mobile" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET
				firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.firstName#" maxlength="12">, 
				lastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.lastName#" maxlength="20">, 
				email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#" maxlength="120">,
				phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phone#" maxlength="15">,
				mobile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mobile#" maxlength="15">
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">			
		</cfquery>		
	</cffunction>
	
	<cffunction name="adminUpdate" access="public" returntype="void" output="false"
				hint="Updates a pt_users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="firstName" type="string" required="true">
		<cfargument name="lastName" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
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
				admin = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.admin#">,
				active = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.active#">
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">			
		</cfquery>		
	</cffunction>
	
	<cffunction name="acctUpdate" access="public" returntype="void" output="false"
				hint="Updates a pt_users record.">
		<cfargument name="userID" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET
				username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="30">
				<cfif compare(arguments.password,'')>
					, password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#" maxlength="20">
				</cfif>
			WHERE userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">			
		</cfquery>		
	</cffunction>	
	
	<cffunction name="setImage" access="public" returnType="boolean" output="false"
				hint="Sets avatar for user.">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="imageExists" type="boolean" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users 
				SET avatar = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.imageExists#">
				WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">
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
				WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
	
	<cffunction name="delete" access="public" returntype="void" output="false"
				hint="Deletes a pt_users record.">
		<cfargument name="userID" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			DELETE FROM #variables.tableprefix#users WHERE 0=0
				AND userID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
		</cfquery>		
	</cffunction>

	<cffunction name="setLastLogin" access="public" returnType="boolean" output="false"
				hint="Sets last login stamp for user.">
		<cfargument name="userid" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET lastLogin = #Now()# 
				WHERE userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="makeOwner" access="public" returnType="boolean" output="false"
				hint="Makes user owner of a project.">
		<cfargument name="projectid" type="uuid" required="true">
		<cfargument name="userid" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#project_users SET role = 'Admin'
				WHERE projectid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
					AND role = 'Owner'
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#project_users SET role = 'Owner'
				WHERE projectid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
					AND userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="changeRole" access="public" returnType="boolean" output="false"
				hint="Makes user owner of a project.">
		<cfargument name="projectid" type="uuid" required="true">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="role" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#project_users 
			SET role = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.role#" maxlength="9">
				WHERE projectid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectID#" maxlength="35">
					AND userid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#" maxlength="35">
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
