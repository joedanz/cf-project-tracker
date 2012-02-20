<cfcomponent displayName="Google Base" output="false">

	<!--- Static variable for auth logon --->
	<cfset variables.authURL = "https://www.google.com/accounts/ClientLogin">	
	<!--- Cached value of auth --->
	<cfset variables.authCode = "">
		
	<cffunction name="init" access="public" returnType="void" hint="Base init">
		<cfargument name="tzOffset" type="string" required="false" hint="Your offset from GMT.">
		<cfset var tz = "">
			
		<cfif structKeyExists(arguments, "tzOffset") and isNumeric(arguments.tzOffset)>
			<cfset variables.tzOffset = arguments.tzOffset>
		<cfelse>
			<cfset tz = getTimeZoneInfo()>
			<cfset variables.tzOffset = tz.utcHourOffset>
		</cfif>

	</cffunction>

	<cffunction name="convertDate" access="private" returnType="date" output="false" hint="Converts the long funky date to a real datetime object">
		<cfargument name="date" type="string" required="true" hint="The date.">
		<cfargument name="offset" type="numeric" required="true" hint="The offset.">
		<!--- 
			You may ask, why not use getTZOffset? Some of the dates
			from google are gmt, and some are offset already, so I let the caller
			figure it out and use either the real offset, or the Diffed offset.
			
			This may be sucky. Be warned.
		--->
		<cfset arguments.date = replace(arguments.date, "T", " ")>
		<cfset arguments.date = replace(arguments.date, "Z", "")>
		<cfset arguments.date = reReplace(arguments.date, "[\-\+][0-9][0-9]:[0-9][0-9]", "")>
		<cfset arguments.date = parseDateTime(arguments.date)>
		<cfset arguments.date = dateAdd("h", arguments.offset, arguments.date)>
		<cfreturn arguments.date>
		
	</cffunction>	

	<cffunction name="getAuthCode" access="public" returnType="string" hint="Hits Google for the auth code.">
		<cfargument name="email" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfargument name="source" type="string" required="true">
		<cfargument name="service" type="string" required="true">
			
		<cfset var result = "">
		<cfset var authStr = "">
		
		<cfif variables.authCode neq "">
			<cfreturn variables.authCode>
		</cfif>
		
		<cfhttp url="#variables.authURL#" method="post" result="result">
			<cfhttpparam type="formField" name="accountType" value="HOSTED_OR_GOOGLE">			
			<cfhttpparam type="formField" name="Email" value="#arguments.email#">
			<cfhttpparam type="formField" name="Passwd" value="#arguments.password#">
			<cfhttpparam type="formField" name="source" value="#arguments.source#">
			<cfhttpparam type="formField" name="service" value="#arguments.service#">				
		</cfhttp>

		<cfif findNoCase("BadAuthentication", result.fileContent)>
			<cfthrow message="Google Authentication Error">
		<cfelse>
			<!--- result is:
				SID=.....
				LSID=....
				Auth=....
			--->
			<cfset authStr = result.filecontent>
			<cfset variables.authCode = reReplaceNoCase(authStr, ".*?Auth=", "")>
			<cfreturn variables.authCode>
		</cfif>

	</cffunction>

</cfcomponent>