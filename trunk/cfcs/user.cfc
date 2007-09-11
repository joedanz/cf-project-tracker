<cfcomponent displayName="pp_users" HINT="">

	<CFSET variables.dsn = "">
	<CFSET variables.tableprefix = "">
	
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
		<cfquery name="qLogin" datasource="#variables.dsn#">
			SELECT userID, firstName, lastName, username, email, phone, lastLogin, avatar, style, admin, active
			FROM #variables.tableprefix#users
			WHERE username = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.username#" MAXLENGTH="35">
				AND password = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.password#" MAXLENGTH="30">
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
			</cfscript>
		</cfif>
		<CFRETURN sLogin>
	</CFFUNCTION>		
	
	<CFFUNCTION NAME="get" ACCESS="public" RETURNTYPE="query" OUTPUT="false"
				HINT="Returns user records.">				
		<CFARGUMENT NAME="userID" TYPE="string" REQUIRED="false" DEFAULT="">
		<CFARGUMENT NAME="userIDlist" TYPE="string" REQUIRED="false" DEFAULT="">
		<CFARGUMENT NAME="akoID" TYPE="string" REQUIRED="false" DEFAULT="">
		<CFSET var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#">
			SELECT userID, firstName, lastName, akoID, email, phone, lastLogin, avatar, style, admin, active
			FROM #variables.tableprefix#users
			WHERE 0=0
			<cfif compare(ARGUMENTS.userID,'')>
				AND userID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.userID#" MAXLENGTH="35">
			</cfif>
			<cfif compare(ARGUMENTS.userIDlist,'')>
				AND userID IN ('#replace(ARGUMENTS.userIDlist,",","','","ALL")#')
			</cfif>
			<cfif compare(ARGUMENTS.akoID,'')>
				AND akoID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.akoID#" MAXLENGTH="30">
			</cfif>			
		</cfquery>		
		<CFRETURN qRecords>
	</CFFUNCTION>	
	
	<CFFUNCTION NAME="create" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Inserts a pp_users record.">
		<CFARGUMENT NAME="userID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="firstName" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="lastName" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="akoID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="email" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="lastLogin" TYPE="numeric" REQUIRED="true">
		<CFARGUMENT NAME="avatar" TYPE="numeric" REQUIRED="true">
		<CFARGUMENT NAME="admin" TYPE="numeric" REQUIRED="true">
		<CFARGUMENT NAME="active" TYPE="numeric" REQUIRED="true">
		<CFQUERY DATASOURCE="#variables.dsn#">
			INSERT INTO #variables.tableprefix#users (userID, firstName, lastName, akoID, email, lastLogin, avatar, skin, admin, active)
				VALUES(<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.userID#" MAXLENGTH="35">,
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.firstName#" MAXLENGTH="12">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.lastName#" MAXLENGTH="20">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.akoID#" MAXLENGTH="30">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.email#" MAXLENGTH="120">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_DATE" VALUE="#ARGUMENTS.lastLogin#">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_BIT" VALUE="#ARGUMENTS.avatar#">,
						'#application.settings.default_style#',
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_BIT" VALUE="#ARGUMENTS.admin#">, 
						<CFQUERYPARAM CFSQLTYPE="CF_SQL_BIT" VALUE="#ARGUMENTS.active#">		
						)
		</cfquery>		
	</CFFUNCTION>

	<CFFUNCTION NAME="update" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Updates a pp_users record.">
		<CFARGUMENT NAME="userID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="firstName" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="lastName" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="akoID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="email" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="lastLogin" TYPE="numeric" REQUIRED="true">
		<CFARGUMENT NAME="admin" TYPE="numeric" REQUIRED="true">
		<CFARGUMENT NAME="active" TYPE="numeric" REQUIRED="true">
		<CFQUERY DATASOURCE="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET
				firstName = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.firstName#" MAXLENGTH="12">, 
				lastName = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.lastName#" MAXLENGTH="20">, 
				akoID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.akoID#" MAXLENGTH="30">, 
				email = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.email#" MAXLENGTH="120">, 
				lastLogin = <CFQUERYPARAM CFSQLTYPE="CF_SQL_DATE" VALUE="#ARGUMENTS.lastLogin#">, 
				admin = <CFQUERYPARAM CFSQLTYPE="CF_SQL_BIT" VALUE="#ARGUMENTS.admin#">, 
				active = <CFQUERYPARAM CFSQLTYPE="CF_SQL_BIT" VALUE="#ARGUMENTS.active#">
			WHERE userID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.userID#">			
		</cfquery>		
	</CFFUNCTION>

	<CFFUNCTION NAME="userUpdate" ACCESS="public" RETURNTYPE="void" OUTPUT="false"
				HINT="Updates a pp_users record.">
		<CFARGUMENT NAME="userID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="firstName" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="lastName" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="akoID" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="email" TYPE="string" REQUIRED="true">
		<CFARGUMENT NAME="phone" TYPE="string" REQUIRED="true">
		<CFQUERY DATASOURCE="#variables.dsn#">
			UPDATE #variables.tableprefix#users SET
				firstName = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.firstName#" MAXLENGTH="12">, 
				lastName = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.lastName#" MAXLENGTH="20">, 
				akoID = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.akoID#" MAXLENGTH="30">, 
				email = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.email#" MAXLENGTH="120">,
				phone = <CFQUERYPARAM CFSQLTYPE="CF_SQL_VARCHAR" VALUE="#ARGUMENTS.phone#" MAXLENGTH="15">
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
