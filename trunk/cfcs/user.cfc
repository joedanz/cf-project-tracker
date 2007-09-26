<cfcomponent displayName="pp_users" HINT="">

	<CFSET variables.dsn = "">
	<CFSET variables.tableprefix = "">
	
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
	
	<CFFUNCTION NAME="init" ACCESS="public" RETURNTYPE="user" OUTPUT="false"
				HINT="Returns an instance of the CFC initialized with the correct DSN & table prefix.">
		<CFARGUMENT NAME="settings" TYPE="struct" REQUIRED="true" HINT="Settings">

		<CFSET variables.dsn = arguments.settings.dsn>
		<CFSET variables.tableprefix = arguments.settings.tableprefix>
		
		<CFRETURN this>
	</CFFUNCTION>
	
	<CFFUNCTION NAME="login" ACCESS="public" RETURNTYPE="struct" OUTPUT="false"
				HINT="Login method.">				
		<CFARGUMENT NAME="username" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="password" TYPE="string" REQUIRED="true">
		<CFSET var qLogin = "">
		<CFSET var sLogin = StructNew()>
		<CFSET var qProjects = "">
		<cfquery name="qLogin" datasource="#variables.dsn#">
			SELECT userID, firstName, lastName, username, email, phone, lastLogin, avatar, style, admin, active
			FROM #variables.tableprefix#users
			WHERE username = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.username#" MAXLENGTH="35">
		<!---		AND password = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.password#" MAXLENGTH="30">--->
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
		<CFRETURN sLogin>
	</CFFUNCTION>		
	
	<CFFUNCTION NAME="get" ACCESS="public" RETURNTYPE="query" OUTPUT="false"
				HINT="Returns user records.">				
		<CFARGUMENT NAME="userID" TYPE="string" REQUIRED="false" DEFAULT="">
		<CFARGUMENT NAME="userIDlist" TYPE="string" REQUIRED="false" DEFAULT="">
		<CFARGUMENT NAME="username" TYPE="string" REQUIRED="false" DEFAULT="">
		<CFSET var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT userID, firstName, lastName, username, email, phone, lastLogin, avatar, style, admin, active
			FROM #variables.tableprefix#users
			WHERE 0=0
			<cfif compare(ARGUMENTS.userID,'')>
				AND userID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.userID#" MAXLENGTH="35">
			</cfif>
			<cfif compare(ARGUMENTS.userIDlist,'')>
				AND userID IN ('#replace(ARGUMENTS.userIDlist,",","','","ALL")#')
			</cfif>
			<cfif compare(ARGUMENTS.username,'')>
				AND username = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.username#" MAXLENGTH="30">
			</cfif>			
		</cfquery>		
		<CFRETURN qRecords>
	</CFFUNCTION>	
	
	<CFFUNCTION NAME="create" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Inserts a pp_users record.">
		<CFARGUMENT NAME="userID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="firstName" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="lastName" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="email" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="admin" TYPE="numeric" REQUIRED="true">
		<CFARGUMENT NAME="active" TYPE="numeric" REQUIRED="false" default="1">
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
		<CFQUERY DATASOURCE="#variables.dsn#">
			INSERT INTO #variables.tableprefix#users (userID, firstName, lastName, username, password, email, style, admin, active)
				VALUES(<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.userID#" MAXLENGTH="35">,
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.firstName#" MAXLENGTH="12">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.lastName#" MAXLENGTH="20">, 
						'#newUsername#', '#newPass#',
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.email#" MAXLENGTH="120">, 
						'#application.settings.default_style#',
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_BIT" VALUE="#ARGUMENTS.admin#">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_BIT" VALUE="#ARGUMENTS.active#">		
						)
		</cfquery>
		<cfmail to="#arguments.email#" from="#session.user.email#" subject="New #application.settings.app_title# Account">An account has been setup for you to use the #application.settings.app_title#.

You can login at #application.settings.rootURL##application.settings.mapping#

     Username: #newUsername#
     Password: #newPass#
		</cfmail>
	</CFFUNCTION>

	<CFFUNCTION NAME="userUpdate" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Updates a pp_users record.">
		<CFARGUMENT NAME="userID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="firstName" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="lastName" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="email" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="phone" TYPE="string" REQUIRED="true">
		<CFQUERY DATASOURCE="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET
				firstName = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.firstName#" MAXLENGTH="12">, 
				lastName = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.lastName#" MAXLENGTH="20">, 
				email = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.email#" MAXLENGTH="120">,
				phone = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.phone#" MAXLENGTH="15">
			WHERE userID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.userID#">			
		</cfquery>		
	</CFFUNCTION>
	
	<CFFUNCTION NAME="acctUpdate" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Updates a pp_users record.">
		<CFARGUMENT NAME="userID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="username" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="password" TYPE="string" REQUIRED="true">
		<CFQUERY DATASOURCE="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET
				username = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.username#" MAXLENGTH="30">
				<cfif compare(arguments.password,'')>
					, password = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.password#" MAXLENGTH="20">
				</cfif>
			WHERE userID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.userID#">			
		</cfquery>		
	</CFFUNCTION>	
	
	<CFFUNCTION NAME="setImage" ACCESS="public" returnType="boolean" output="false"
				HINT="Sets avatar for user.">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="imageExists" type="boolean" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users 
				SET avatar = <CFQUERYPARAM CFSQLTYPE="CF_SQL_BIT" VALUE="#ARGUMENTS.imageExists#">
				WHERE userid = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
	
	<CFFUNCTION NAME="setStyle" ACCESS="public" returnType="boolean" output="false"
				HINT="Sets style for user.">
		<cfargument name="userid" type="uuid" required="true">
		<cfargument name="style" type="string" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users 
				SET style = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.style#" maxlength="20">
				WHERE userid = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
	
	<CFFUNCTION NAME="delete" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Deletes a pp_users record.">
		<CFARGUMENT NAME="userID" TYPE="string" REQUIRED="true">
		<CFQUERY DATASOURCE="#variables.dsn#">
			DELETE FROM #variables.tableprefix#users WHERE 0=0
				AND userID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.userID#">
		</cfquery>		
	</CFFUNCTION>

	<CFFUNCTION NAME="setLastLogin" ACCESS="public" returnType="boolean" output="false"
				HINT="Sets last login stamp for user.">
		<cfargument name="userid" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET lastLogin = #Now()# 
				WHERE userid = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<CFFUNCTION NAME="makeOwner" ACCESS="public" returnType="boolean" output="false"
				HINT="Makes user owner of a project.">
		<cfargument name="projectid" type="uuid" required="true">
		<cfargument name="userid" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#project_users SET role = 'Admin'
				WHERE projectid = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.projectID#" maxlength="35">
					AND role = 'Owner'
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#project_users SET role = 'Owner'
				WHERE projectid = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.projectID#" maxlength="35">
					AND userid = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<CFFUNCTION NAME="makeAdmin" ACCESS="public" returnType="boolean" output="false"
				HINT="Makes user owner of a project.">
		<cfargument name="projectid" type="uuid" required="true">
		<cfargument name="userid" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#">
			UPDATE #variables.tableprefix#project_users SET role = 'Admin'
				WHERE projectid = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.projectID#" maxlength="35">
					AND userid = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.userID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>		
	
</CFCOMPONENT>
