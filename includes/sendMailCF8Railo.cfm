<cfmail to="#arguments.emailTo#" from="#arguments.emailFrom#" subject="#arguments.emailSubject#"
	server="#application.settings.mailServer#" username="#application.settings.mailUsername#" 
	password="#application.settings.mailPassword#" port="#application.settings.mailPort#"
	useSSL="#application.settings.mailUseSSL#" useTLS="#application.settings.mailUseTLS#"
	>#arguments.emailBody#</cfmail>