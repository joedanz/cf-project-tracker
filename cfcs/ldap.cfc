<cfcomponent>
	<cffunction name="init" access="public" returntype="ldap" output="false"
				hint="Returns an instance of the CFC initialized with the ldap info.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.ldapHost = arguments.settings.ldapHost />
		<cfset variables.ldapPort = arguments.settings.ldapPort />
		<cfset variables.ldapUid = arguments.settings.ldapUid />
		<cfset variables.ldapBindDN = arguments.settings.ldapBindDN />
		<cfset variables.ldapBindPw = arguments.settings.ldapBindPw />
		<cfset variables.ldapBaseDN = arguments.settings.ldapBaseDN />
		<cfset variables.returnAttributes = "dn,uid,#variables.ldapUid#,ou,displayName,givenname,sn,mail,employeeNumber,department,memberOf" />
		
		<cfreturn this>
	</cffunction>
	<cffunction access="remote" name="AuthLDAP" output="no" returntype="struct" hint="Authenticate against AD">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfscript>
			this.myResult=StructNew();
			this.myResult.dn="";
			this.myResult.uid="";
			this.myResult.euid="";
			this.myResult.cn="";
			this.myResult.ou="";
			this.myResult.fullname="";
			this.myResult.givenname="";
			this.myResult.sn="";
			this.myResult.mail="";
			this.myResult.groupmembership="";
			this.myResult.workforceID="";
			this.myResult.authenticated=0;
			this.myResult.error="";
			
			this.UserSearchFailed=0;
			//jparker changed filter to the below OR statement from (uid=#username#)
			this.filter = "(|(uid=#username#)(#variables.ldapUid#=#username#))";
		
			LOCAL.LDAPAttemptLimit = 3;
			if (Trim(arguments.password) EQ ''){  //ensure that if an empty password is supplied, the login fails.
				arguments.password = ' ';
			}
		</cfscript>
		
		<cfset LOCAL.LDAPAttempts = 0 />
		<cfset LOCAL.LDAPValidResponse = 0 />
		<cftry>
		<cfloop from="1" to="#LOCAL.LDAPAttemptLimit#" index="ind">
		<cfldap action="QUERY" secure="CFSSL_BASIC"
			name="userSearch"
			attributes="dn,uid,#variables.ldapUid#"
			start="#variables.ldapBaseDN#"
			scope="SUBTREE"
			server="#variables.ldapHost#"
			port="#variables.ldapPort#"
			filter="#this.filter#"
			username="#variables.ldapBindDN#" password="#variables.ldapBindPw#" >
		<cfif CompareNoCase(userSearch.uid, username) EQ 0 OR CompareNoCase(Evaluate('userSearch.#variables.ldapUid#'), username) EQ 0>
			<cfset LOCAL.LDAPValidResponse = 1 />
			<cfbreak />
		</cfif>
		</cfloop>
		<cfcatch type="any"><cfdump var="#cfcatch#" ><cfabort></cfcatch>
		</cftry>
		
		<cfif isDefined("usersearch") AND userSearch.recordcount EQ 0>
			<cfset this.myResult.error="UID for #username# not found after #ind# attempts.">
			<cfreturn this.myResult>
		</cfif>
		
		<!--- pass the user's DN and password to see if the user authenticates and get the user’s roles --->
		<cfif isDefined("usersearch") AND userSearch.recordcount GT 0>
		<cfset LOCAL.LDAPAttempts = 0 />
		<cfset LOCAL.LDAPValidResponse = 0 />
		<cfloop from="1" to="#LOCAL.LDAPAttemptLimit#" index="ind">
		
			<cftry>
				<cfldap action="QUERY" secure="CFSSL_BASIC"
					name="auth"
					attributes="#variables.returnAttributes#"
					start="#variables.ldapBaseDN#"
					scope="SUBTREE"
					server="#variables.ldapHost#"
					port="#variables.ldapPort#"
					filter="#this.filter#"
					username="#userSearch.dn#"
					password="#password#">
				<cfif CompareNoCase(auth.uid, username) EQ 0 OR CompareNoCase(Evaluate('auth.#variables.ldapUid#'), username) EQ 0>
				<cfscript>
					this.myResult.dn=auth.dn;
					if (not len(trim(auth.uid)))
						this.myResult.uid=Evaluate('auth.#variables.ldapUid#');
					else
						this.myResult.uid=auth.uid;
						this.myResult.euid=Evaluate('auth.#variables.ldapUid#');
					this.myResult.cn=Evaluate('auth.#variables.ldapUid#');
					this.myResult.ou=auth.department;
					this.myResult.fullname=auth.displayName;
					this.myResult.givenname=auth.givenname;
					this.myResult.sn=auth.sn;
					this.myResult.mail=auth.mail;
					this.myResult.groupmembership=auth.memberOf;
					this.myResult.workforceID=auth.employeeNumber;
					this.myResult.authenticated=1;
					this.myResult.error="";
				</cfscript>
					<cfset LOCAL.LDAPValidResponse = 1 />
					<cfbreak />
				</cfif>

				<cfcatch type="any">
					<cfif FindNoCase("Inappropriate authentication", cfcatch.message) OR FindNoCase("failed authentication", cfcatch.message)>
						<cfset this.myResult.error="User ID or Password invalid for user: #username#">
					<cfelse>
						<cfset this.myResult.error="Unknown error for user: #username# #cfcatch.detail#">
						<cfreturn this.myResult>
					</cfif>
				</cfcatch>
			</cftry>
		</cfloop>
		</cfif>
			
		<cfreturn this.myResult>
	</cffunction>

	<cffunction access="remote" name="checkUser" output="no" returntype="array" hint="Check to see if user exists">
		<cfargument name="username" type="string" required="true">
		
		<cfscript>
			this.myResult=ArrayNew(1);
			//this.filter = "(uid=#username#)";
			this.filter = "(|(uid=#username#)(#variables.ldapUid#=#username#))";
		</cfscript>
		
		<cfldap action="QUERY" secure="CFSSL_BASIC"
			name="userSearch"
			attributes="#this.returnAttributes#"
			start="#variables.ldapBaseDN#"
			scope="SUBTREE"
			server="#variables.ldapHost#"
			port="#variables.ldapPort#"
			filter="#this.filter#"
			username="#variables.ldapBindDN#" password="#variables.ldapBindPw#" >
			
		<cfoutput query="userSearch">
				<cfscript>
					this.myResult[userSearch.currentrow]=StructNew();
					this.myResult[userSearch.currentrow].dn=userSearch.dn;
					if (not len(trim(userSearch.uid)))
						this.myResult[userSearch.currentrow].uid=Evaluate('userSearch.#variables.ldapUid#');
					else
						this.myResult[userSearch.currentrow].uid=userSearch.uid;
						this.myResult[userSearch.currentrow].euid=Evaluate('userSearch.#variables.ldapUid#');
					this.myResult[userSearch.currentrow].cn=Evaluate('userSearch.#variables.ldapUid#');
					this.myResult[userSearch.currentrow].ou=userSearch.department;
					this.myResult[userSearch.currentrow].fullname=userSearch.displayName;
					this.myResult[userSearch.currentrow].givenname=userSearch.givenname;
					this.myResult[userSearch.currentrow].sn=userSearch.sn;
					this.myResult[userSearch.currentrow].mail=userSearch.mail;
					this.myResult[userSearch.currentrow].groupmembership=userSearch.memberOf;
					this.myResult[userSearch.currentrow].workforceID=userSearch.employeeNumber;
				</cfscript>
		</cfoutput>
		
		<cfreturn this.myResult>
		
	</cffunction>
	
</cfcomponent>