<cfcomponent displayName="Projects" hint="Methods dealing with projects.">

	<cfset variables.dsn = "">
	<cfset variables.tableprefix = "">
	
	<cffunction name="init" access="public" returntype="project" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN & table prefix.">
		<cfargument name="settings" type="struct" required="true" hint="Settings">

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.dbUsername = arguments.settings.dbUsername>
		<cfset variables.dbPassword = arguments.settings.dbPassword>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get" access="public" returntype="query" output="false"
				hint="Returns project records.">				
		<cfargument name="userID" type="string" required="false" default="">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT p.projectID, p.ownerID, p.clientID, p.name, p.description, p.display, p.added, p.allow_def_rates,
				p.addedBy, p.status, p.ticketPrefix, p.svnurl, p.svnuser, p.svnpass, p.logo_img,
				p.tab_billing, p.tab_files, p.tab_issues, p.tab_msgs, p.tab_mstones,p.tab_todos, 
				p.tab_time, p.tab_svn, p.issue_svn_link, p.issue_timetrack,
				<cfif compare(arguments.userID,'')> 
					pu.admin, pu.file_view, pu.file_edit, pu.file_comment, pu.issue_view, pu.issue_edit, 
					pu.issue_assign, pu.issue_resolve, pu.issue_close, pu.issue_comment, pu.msg_view, 
					pu.msg_edit, pu.msg_comment, pu.mstone_view, pu.mstone_edit, pu.mstone_comment, 
					pu.todolist_view, pu.todolist_edit, pu.todo_edit, pu.todo_comment, pu.time_view, pu.time_edit, 
					pu.bill_view, pu.bill_edit, pu.bill_rates, pu.bill_invoices, pu.bill_markpaid, pu.report, 
					pu.svn,
					un.email_file_new, un.mobile_file_new, un.email_file_upd, un.mobile_file_upd, 
					un.email_file_com, un.mobile_file_com, un.email_issue_new, un.mobile_issue_new, 
					un.email_issue_upd, un.mobile_issue_upd, un.email_issue_com, un.mobile_issue_com,
					un.email_msg_new, un.mobile_msg_new, un.email_msg_upd, un.mobile_msg_upd, 
					un.email_msg_com, un.mobile_msg_com, un.email_mstone_new, un.mobile_mstone_new, 
					un.email_mstone_upd, un.mobile_mstone_upd, un.email_mstone_com, un.mobile_mstone_com,
					un.email_todo_new, un.mobile_todo_new, un.email_todo_upd, un.mobile_todo_upd, 
					un.email_todo_com, un.mobile_todo_com, un.email_time_new, un.mobile_time_new, 
					un.email_time_upd, un.mobile_time_upd, un.email_bill_new, un.mobile_bill_new, 
					un.email_bill_upd, un.mobile_bill_upd, un.email_bill_paid, un.mobile_bill_paid,  
				<cfelse>
					1 as admin, 1 as file_view, 1 as file_edit, 1 as file_comment, 1 as issue_view, 
					1 as issue_edit, 1 as issue_assign, 1 as issue_resolve, 1 as issue_close, 
					1 as issue_comment, 1 as msg_view, 1 as msg_edit, 1 as msg_comment, 1 as mstone_view, 
					1 as mstone_edit, 1 as mstone_comment, 1 as todolist_view, 1 as todolist_edit, 
					1 as todo_edit, 1 as todo_comment, 1 as time_view, 1 as time_edit, 1 as bill_view, 
					1 as bill_edit, 1 as bill_rates, 1 as bill_invoices, 1 as bill_markpaid, 1 as report, 
					1 as svn,
					0 as email_file_new, 0 as mobile_file_new, 0 as email_file_upd, 0 as mobile_file_upd, 
					0 as email_file_com, 0 as mobile_file_com, 0 as email_issue_new, 0 as mobile_issue_new, 
					0 as email_issue_upd, 0 as mobile_issue_upd, 0 as email_issue_com, 0 as mobile_issue_com,
					0 as email_msg_new, 0 as mobile_msg_new, 0 as email_msg_upd, 0 as mobile_msg_upd, 
					0 as email_msg_com, 0 as mobile_msg_com, 0 as email_mstone_new, 0 as mobile_mstone_new, 
					0 as email_mstone_upd, 0 as mobile_mstone_upd, 0 as email_mstone_com, 0 as mobile_mstone_com,
					0 as email_todo_new, 0 as mobile_todo_new, 0 as email_todo_upd, 0 as mobile_todo_upd, 
					0 as email_todo_com, 0 as mobile_todo_com, 0 as email_time_new, 0 as mobile_time_new, 
					0 as email_time_upd, 0 as mobile_time_upd, 0 as email_bill_new, 0 as mobile_bill_new, 
					0 as email_bill_upd, 0 as mobile_bill_upd, 0 as email_bill_paid, 0 as mobile_bill_paid,
				</cfif> 
				c.name as clientName, u.firstName as ownerFirstName, u.lastName as ownerLastName
			FROM #variables.tableprefix#projects p 
				<cfif compare(arguments.userID,'')>
					INNER JOIN #variables.tableprefix#project_users pu ON p.projectID = pu.projectID
					INNER JOIN #variables.tableprefix#user_notify un ON p.projectID = un.projectID
				</cfif>
				INNER JOIN #variables.tableprefix#users u ON p.ownerID = u.userID
				LEFT JOIN #variables.tableprefix#clients c on p.clientID = c.clientID 
			WHERE 0=0
			  <cfif compare(ARGUMENTS.projectID,'')>
				  AND p.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			  </cfif>
			  <cfif compare(ARGUMENTS.userID,'')>
				  AND pu.userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
				  AND un.userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
			  </cfif>
				ORDER BY p.name
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>
	
	<cffunction name="getDistinct" access="public" returntype="query" output="false"
				hint="Returns project records.">				
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="allowReg" type="boolean" required="false" default="false">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT p.projectID, p.ownerID, p.clientID, p.name, p.description, p.display, p.added, 
				p.addedBy, p.status, p.ticketPrefix, p.svnurl, p.svnuser, p.svnpass, p.logo_img, p.allow_reg, 
				p.allow_def_rates, 
				p.reg_file_view, p.reg_file_edit, p.reg_file_comment, p.reg_issue_view, p.reg_issue_edit, 
				p.reg_issue_assign, p.reg_issue_resolve, p.reg_issue_close, p.reg_issue_comment, p.reg_msg_view, 
				p.reg_msg_edit, p.reg_msg_comment, p.reg_mstone_view, p.reg_mstone_edit, p.reg_mstone_comment, 
				p.reg_todolist_view, p.reg_todolist_edit, p.reg_todo_edit, p.reg_todo_comment, p.reg_time_view, 
				p.reg_time_edit, p.reg_bill_view, p.reg_bill_edit, p.reg_bill_rates, p.reg_bill_invoices, 
				p.reg_bill_markpaid, p.reg_svn, p.tab_billing, p.tab_files, p.tab_issues, p.tab_msgs, 
				p.tab_mstones, p.tab_todos, p.tab_time, p.tab_svn, p.issue_svn_link, p.issue_timetrack,
				c.name as clientName, u.firstName as ownerFirstName, u.lastName as ownerLastName
			FROM #variables.tableprefix#projects p
				INNER JOIN #variables.tableprefix#users u ON p.ownerID = u.userID
				LEFT JOIN #variables.tableprefix#clients c on p.clientID = c.clientID 
			WHERE 0=0
			  <cfif compare(ARGUMENTS.projectID,'')>
				  AND projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			  </cfif>
			  <cfif ARGUMENTS.allowReg>
				  AND allow_reg = 1
			  </cfif>
			ORDER BY p.name
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>	

	<cffunction name="userNotify" access="public" returntype="query" output="false"
				hint="Returns project notification settings.">				
		<cfargument name="userID" type="string" required="true">
		<cfargument name="userIDlist" type="string" required="false" default="">
		<cfargument name="projectID" type="string" required="false" default="">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT distinct p.projectID, p.name, un.email_file_new, un.mobile_file_new, un.email_file_upd, 
				un.mobile_file_upd, un.email_file_com, un.mobile_file_com, un.email_issue_new, 
				un.mobile_issue_new, un.email_issue_upd, un.mobile_issue_upd, un.email_issue_com, 
				un.mobile_issue_com, un.email_msg_new, un.mobile_msg_new, un.email_msg_upd, un.mobile_msg_upd, 
				un.email_msg_com, un.mobile_msg_com, un.email_mstone_new, un.mobile_mstone_new, 
				un.email_mstone_upd, un.mobile_mstone_upd, un.email_mstone_com, un.mobile_mstone_com, 
				un.email_todo_new, un.mobile_todo_new, un.email_todo_upd, un.mobile_todo_upd, 
				un.email_todo_com, un.mobile_todo_com, un.email_time_new, un.mobile_time_new, 
				un.email_time_upd, un.mobile_time_upd, un.email_bill_new, un.mobile_bill_new, 
				un.email_bill_upd, un.mobile_bill_upd, un.email_bill_paid, un.mobile_bill_paid, 
				u.userid, u.firstName, u.lastName, u.email, u.mobile, c.prefix, c.suffix 
			FROM #variables.tableprefix#projects p 
				INNER JOIN #variables.tableprefix#user_notify un ON p.projectID = un.projectID
				INNER JOIN #variables.tableprefix#users u ON un.userID = u.userID
				LEFT JOIN #variables.tableprefix#carriers c ON u.carrierID = c.carrierID
			WHERE 0=0
			  <cfif compare(ARGUMENTS.userID,'')>
				  AND un.userID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
			  </cfif>
			  <cfif compare(ARGUMENTS.userIDlist,'')>
				  AND un.userID IN (<cfqueryparam value="#arguments.userIDlist#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
			  </cfif>
			  <cfif compare(ARGUMENTS.projectID,'')>
				  AND p.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			  </cfif>
				ORDER BY p.name
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>

	<cffunction name="add" access="public" returnType="boolean" output="false"
				hint="Adds a project.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="ownerID" type="uuid" required="true">
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="display" type="numeric" required="true">
		<cfargument name="clientID" type="string" required="true">
		<cfargument name="status" type="string" required="true">
		<cfargument name="ticketPrefix" type="string" required="true">
		<cfargument name="svnurl" type="string" required="true">
		<cfargument name="svnuser" type="string" required="true">
		<cfargument name="svnpass" type="string" required="true">
		<cfargument name="logo_img" type="string" required="true">
		<cfargument name="allow_reg" type="numeric" required="true">
		<cfargument name="allow_def_rates" type="numeric" required="true">
		<cfargument name="reg_file_view" type="numeric" required="true">
		<cfargument name="reg_file_edit" type="numeric" required="true">
		<cfargument name="reg_file_comment" type="numeric" required="true">
		<cfargument name="reg_issue_view" type="numeric" required="true">
		<cfargument name="reg_issue_edit" type="numeric" required="true">
		<cfargument name="reg_issue_assign" type="numeric" required="true">
		<cfargument name="reg_issue_resolve" type="numeric" required="true">
		<cfargument name="reg_issue_close" type="numeric" required="true">
		<cfargument name="reg_issue_comment" type="numeric" required="true">
		<cfargument name="reg_msg_view" type="numeric" required="true">
		<cfargument name="reg_msg_edit" type="numeric" required="true">
		<cfargument name="reg_msg_comment" type="numeric" required="true">
		<cfargument name="reg_mstone_view" type="numeric" required="true">
		<cfargument name="reg_mstone_edit" type="numeric" required="true">
		<cfargument name="reg_mstone_comment" type="numeric" required="true">
		<cfargument name="reg_todolist_view" type="numeric" required="true">
		<cfargument name="reg_todolist_edit" type="numeric" required="true">
		<cfargument name="reg_todo_edit" type="numeric" required="true">
		<cfargument name="reg_todo_comment" type="numeric" required="true">
		<cfargument name="reg_time_view" type="numeric" required="true">
		<cfargument name="reg_time_edit" type="numeric" required="true">
		<cfargument name="reg_bill_view" type="numeric" required="true">
		<cfargument name="reg_bill_edit" type="numeric" required="true">
		<cfargument name="reg_bill_rates" type="numeric" required="true">
		<cfargument name="reg_bill_invoices" type="numeric" required="true">
		<cfargument name="reg_bill_markpaid" type="numeric" required="true">				
		<cfargument name="reg_svn" type="numeric" required="true">
		<cfargument name="tab_files" type="numeric" required="true">
		<cfargument name="tab_issues" type="numeric" required="true">
		<cfargument name="tab_msgs" type="numeric" required="true">
		<cfargument name="tab_mstones" type="numeric" required="true">
		<cfargument name="tab_todos" type="numeric" required="true">
		<cfargument name="tab_time" type="numeric" required="true">
		<cfargument name="tab_billing" type="numeric" required="true">
		<cfargument name="tab_svn" type="numeric" required="true">
		<cfargument name="issue_svn_link" type="numeric" required="true">
		<cfargument name="issue_timetrack" type="numeric" required="true">
		<cfargument name="addedBy" type="string" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#projects (projectID,ownerID,name,description,display,added,addedBy,clientID,status,ticketPrefix,svnurl,svnuser,svnpass,logo_img,allow_reg,allow_def_rates,reg_file_view,reg_file_edit,reg_file_comment,reg_issue_view,reg_issue_edit,reg_issue_assign,reg_issue_resolve,reg_issue_close,reg_issue_comment,reg_msg_view,reg_msg_edit,reg_msg_comment,reg_mstone_view,reg_mstone_edit,reg_mstone_comment,reg_todolist_view,reg_todolist_edit,reg_todo_edit,reg_todo_comment,reg_time_view,reg_time_edit,reg_bill_view,reg_bill_edit,reg_bill_rates,reg_bill_invoices,reg_bill_markpaid,reg_svn,tab_files,tab_issues,tab_msgs,tab_mstones,tab_todos,tab_time,tab_billing,tab_svn,issue_svn_link,issue_timetrack)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.ownerID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.display#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateConvert("local2Utc",Now())#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addedBy#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clientID#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#" maxlength="8">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticketPrefix#" maxlength="2">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnurl#" maxlength="100">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnuser#" maxlength="20">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnpass#" maxlength="20">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.logo_img#" maxlength="150">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.allow_reg#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.allow_def_rates#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_file_view#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_file_edit#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_file_comment#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_view#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_edit#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_assign#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_resolve#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_close#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_comment#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_msg_view#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_msg_edit#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_msg_comment#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_mstone_view#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_mstone_edit#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_mstone_comment#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_todolist_view#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_todolist_edit#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_todo_edit#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_todo_comment#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_time_view#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_time_edit#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_bill_view#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_bill_edit#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_bill_rates#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_bill_invoices#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_bill_markpaid#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_svn#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_files#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_issues#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_msgs#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_mstones#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_todos#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_time#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_billing#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_svn#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issue_svn_link#" maxlength="1">,
					<cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issue_timetrack#" maxlength="1">)
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="update" access="public" returnType="boolean" output="false"
				hint="Updates a project.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="ownerID" type="uuid" required="true">		
		<cfargument name="name" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="display" type="numeric" required="true">
		<cfargument name="clientID" type="string" required="true">
		<cfargument name="status" type="string" required="true">
		<cfargument name="ticketPrefix" type="string" required="true">
		<cfargument name="svnurl" type="string" required="true">
		<cfargument name="svnuser" type="string" required="true">
		<cfargument name="svnpass" type="string" required="true">
		<cfargument name="logo_img" type="string" required="true">
		<cfargument name="allow_reg" type="numeric" required="true">
		<cfargument name="allow_def_rates" type="numeric" required="true">
		<cfargument name="reg_file_view" type="numeric" required="true">
		<cfargument name="reg_file_edit" type="numeric" required="true">
		<cfargument name="reg_file_comment" type="numeric" required="true">
		<cfargument name="reg_issue_view" type="numeric" required="true">
		<cfargument name="reg_issue_edit" type="numeric" required="true">
		<cfargument name="reg_issue_assign" type="numeric" required="true">
		<cfargument name="reg_issue_resolve" type="numeric" required="true">
		<cfargument name="reg_issue_close" type="numeric" required="true">
		<cfargument name="reg_issue_comment" type="numeric" required="true">
		<cfargument name="reg_msg_view" type="numeric" required="true">
		<cfargument name="reg_msg_edit" type="numeric" required="true">
		<cfargument name="reg_msg_comment" type="numeric" required="true">
		<cfargument name="reg_mstone_view" type="numeric" required="true">
		<cfargument name="reg_mstone_edit" type="numeric" required="true">
		<cfargument name="reg_mstone_comment" type="numeric" required="true">
		<cfargument name="reg_todolist_view" type="numeric" required="true">
		<cfargument name="reg_todolist_edit" type="numeric" required="true">
		<cfargument name="reg_todo_edit" type="numeric" required="true">
		<cfargument name="reg_todo_comment" type="numeric" required="true">
		<cfargument name="reg_time_view" type="numeric" required="true">
		<cfargument name="reg_time_edit" type="numeric" required="true">
		<cfargument name="reg_bill_view" type="numeric" required="true">
		<cfargument name="reg_bill_edit" type="numeric" required="true">
		<cfargument name="reg_bill_rates" type="numeric" required="true">
		<cfargument name="reg_bill_invoices" type="numeric" required="true">
		<cfargument name="reg_bill_markpaid" type="numeric" required="true">	
		<cfargument name="reg_svn" type="numeric" required="true">
		<cfargument name="tab_files" type="numeric" required="true">
		<cfargument name="tab_issues" type="numeric" required="true">
		<cfargument name="tab_msgs" type="numeric" required="true">
		<cfargument name="tab_mstones" type="numeric" required="true">
		<cfargument name="tab_todos" type="numeric" required="true">
		<cfargument name="tab_time" type="numeric" required="true">
		<cfargument name="tab_billing" type="numeric" required="true">
		<cfargument name="tab_svn" type="numeric" required="true">
		<cfargument name="issue_svn_link" type="numeric" required="true">
		<cfargument name="issue_timetrack" type="numeric" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#projects 
				SET name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#" maxlength="50">,
					ownerID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.ownerID#" maxlength="35">,
					description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
					display = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.display#">,
					clientID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clientID#" maxlength="35">,
					status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#" maxlength="8">,
					ticketPrefix = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticketPrefix#" maxlength="2">,
					svnurl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnurl#" maxlength="100">,
					svnuser = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnuser#" maxlength="20">,
					svnpass = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.svnpass#" maxlength="20">,
					<cfif compare(arguments.logo_img,'')>
						logo_img = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.logo_img#" maxlength="150">,
					</cfif>
					allow_reg = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.allow_reg#" maxlength="1">,
					allow_def_rates = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.allow_def_rates#" maxlength="1">,
					reg_file_view = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_file_view#" maxlength="1">,
					reg_file_edit = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_file_edit#" maxlength="1">,
					reg_file_comment = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_file_comment#" maxlength="1">,
					reg_issue_view = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_view#" maxlength="1">,
					reg_issue_edit = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_edit#" maxlength="1">,
					reg_issue_assign = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_assign#" maxlength="1">,
					reg_issue_resolve = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_resolve#" maxlength="1">,
					reg_issue_close = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_close#" maxlength="1">,
					reg_issue_comment = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_issue_comment#" maxlength="1">,
					reg_msg_view = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_msg_view#" maxlength="1">,
					reg_msg_edit = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_msg_edit#" maxlength="1">,
					reg_msg_comment = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_msg_comment#" maxlength="1">,
					reg_mstone_view = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_mstone_view#" maxlength="1">,
					reg_mstone_edit = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_mstone_edit#" maxlength="1">,
					reg_mstone_comment = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_mstone_comment#" maxlength="1">,
					reg_todolist_view = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_todolist_view#" maxlength="1">,
					reg_todolist_edit = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_todolist_edit#" maxlength="1">,
					reg_todo_edit = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_todo_edit#" maxlength="1">,
					reg_todo_comment = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_todo_comment#" maxlength="1">,
					reg_time_view = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_time_view#" maxlength="1">,
					reg_time_edit = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_time_edit#" maxlength="1">,
					reg_bill_view = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_bill_view#" maxlength="1">,
					reg_bill_edit = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_bill_edit#" maxlength="1">,
					reg_bill_rates = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_bill_rates#" maxlength="1">,
					reg_bill_invoices = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_bill_invoices#" maxlength="1">,
					reg_bill_markpaid = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_bill_markpaid#" maxlength="1">,
					reg_svn = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.reg_svn#" maxlength="1">,
					tab_files = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_files#" maxlength="1">,
					tab_issues = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_issues#" maxlength="1">,
					tab_msgs = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_msgs#" maxlength="1">,
					tab_mstones = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_mstones#" maxlength="1">,
					tab_todos = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_todos#" maxlength="1">,
					tab_time = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_time#" maxlength="1">,
					tab_billing = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_billing#" maxlength="1">,
					tab_svn = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.tab_svn#" maxlength="1">,
					issue_svn_link = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issue_svn_link#" maxlength="1">,
					issue_timetrack = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#arguments.issue_timetrack#" maxlength="1">
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="removeLogo" access="public" returnType="boolean" output="false"
				hint="Updates a project.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#projects 
				SET logo_img = ''
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="delete" access="public" returntype="void" output="false"
				hint="Deletes a project record.">
		<cfargument name="projectID" type="string" required="true">
		
		<cfset var qProject = application.project.getDistinct(arguments.projectID)>
		
		<!--- delete physical files --->
		<cfset var qFiles = application.file.get(arguments.projectid)>
		<cfloop query="qFiles">
			<cfset application.file.delete(arguments.projectid,fileID,uploadedBy)>
		</cfloop>
		<cftry>
			<cffile action="delete" file="#application.userFilesPath#projects/#qProject.logo_img#">
			<cfcatch></cfcatch>
		</cftry>
		
		<!--- delete database records --->
		<cftransaction>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#activity 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#files 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#issues 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#messages 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#milestones 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#projects 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#project_components 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#project_users 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#project_versions 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#svn_link 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#todolists 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
			<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
				DELETE FROM #variables.tableprefix#todos 
				WHERE projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#">
			</cfquery>
		</cftransaction>
	</cffunction>
	
	
	<cffunction name="projectUsers" access="public" returntype="query" output="false"
				hint="Returns project users.">				
		<cfargument name="projectID" type="string" required="false" default="">
		<cfargument name="admin" type="numeric" required="false" default="0">
		<cfargument name="order_by" type="string" required="false" default="lastName, firstName">
		<cfargument name="projectIDlist" type="string" required="false" default="">
		<cfargument name="useList" type="boolean" required="false" default="false">
		
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT distinct u.userID, u.firstName, u.lastName, u.username, u.email, u.phone, u.mobile,
				u.lastLogin, u.avatar, u.admin, c.prefix, c.suffix, 
				un.email_file_new, un.mobile_file_new, un.email_file_upd, un.mobile_file_upd,
				un.email_file_com, un.mobile_file_com, un.email_issue_new, un.mobile_issue_new, 
				un.email_issue_upd, un.mobile_issue_upd, un.email_issue_com, un.mobile_issue_com,
				un.email_msg_new, un.mobile_msg_new, un.email_msg_upd, un.mobile_msg_upd,
				un.email_msg_com, un.mobile_msg_com, un.email_mstone_new, un.mobile_mstone_new, 
				un.email_mstone_upd, un.mobile_mstone_upd, un.email_mstone_com, un.mobile_mstone_com,
				un.email_todo_new, un.mobile_todo_new, un.email_todo_upd, un.mobile_todo_upd,
				un.email_todo_com, un.mobile_todo_com, un.email_time_new, un.mobile_time_new, 
				un.email_time_upd, un.mobile_time_upd, un.email_bill_new, un.mobile_bill_new, 
				un.email_bill_upd, un.mobile_bill_upd, un.email_bill_paid, un.mobile_bill_paid,  
				pu.projectID, pu.admin, pu.file_view, pu.file_edit, pu.file_comment, pu.issue_view, 
				pu.issue_edit, pu.issue_assign, pu.issue_resolve, pu.issue_close, pu.issue_comment, 
				pu.msg_view, pu.msg_edit, pu.msg_comment, pu.mstone_view, pu.mstone_edit, 
				pu.mstone_comment, pu.todolist_view, pu.todolist_edit, pu.todo_edit, pu.todo_comment, 
				pu.time_view, pu.time_edit, pu.bill_view, pu.bill_edit, pu.bill_rates, pu.bill_invoices, 
				pu.bill_markpaid, pu.report, pu.svn
			FROM #variables.tableprefix#users u 
				INNER JOIN #variables.tableprefix#project_users pu ON u.userID = pu.userID
				INNER JOIN #variables.tableprefix#user_notify un ON pu.userID = un.userID
				LEFT JOIN #variables.tableprefix#carriers c on u.carrierID = c.carrierID
			WHERE u.active = 1
			<cfif compare(arguments.projectID,'')>
				AND pu.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				AND un.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			</cfif>
			<cfif arguments.uselist>
				AND pu.projectID IN (<cfqueryparam value="#arguments.projectIDlist#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
				AND un.projectID IN (<cfqueryparam value="#arguments.projectIDlist#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
			</cfif>
			<cfif arguments.admin>AND pu.admin = 1</cfif>
			ORDER BY #arguments.order_by#
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>	

	<cffunction name="allProjectUsers" access="public" returntype="query" output="false"
				hint="Returns project users.">
		<cfargument name="projectIDlist" type="string" required="false" default="">
		
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT distinct u.userID, u.firstName, u.lastName
			FROM #variables.tableprefix#users u 
				INNER JOIN #variables.tableprefix#project_users pu ON u.userID = pu.userID
			WHERE u.active = 1
				AND pu.projectID IN (<cfqueryparam value="#arguments.projectIDlist#" cfsqltype="CF_SQL_VARCHAR" list="Yes" separator=",">)
			ORDER BY lastName, firstName
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>	
	
	<cffunction name="nonProjectUsers" access="public" returntype="query" output="false"
				hint="Returns project users.">				
		<cfargument name="projectID" type="string" required="true">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT userID, firstName, lastName
			FROM #variables.tableprefix#users 
			WHERE active = 1
				AND userID NOT IN (
					select userID from #variables.tableprefix#project_users where projectID = 
						<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
				)
			ORDER BY lastName, firstName
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>		
	
	<cffunction name="makeOwner" access="public" returntype="void" output="false"
				hint="Makes user the owner of a project.">
		<cfargument name="projectID" type="string" required="true">
		<cfargument name="userID" type="string" required="true">
		
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#projects
			SET ownerID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.userID#" maxlength="35">
			WHERE projectid = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
		</cfquery>
	</cffunction>

	<cffunction name="component" access="public" returntype="query" output="false"
				HINT="Returns project component records.">
		<cfargument name="projectID" type="string" required="true">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT c.componentID, c.component, count(i.issueID) as numIssues
			FROM #variables.tableprefix#project_components c LEFT JOIN #variables.tableprefix#issues i
				ON c.componentID = i.componentID
			WHERE c.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			GROUP BY c.componentID, c.component
			ORDER BY component
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>

	<cffunction name="addProjectItem" access="public" returnType="string" output="false"
				hint="Adds a project item.">
		<cfargument name="projectID" type="uuid" required="true">
		<cfargument name="item" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfargument name="newID" type="string" required="false" default="#createUUID()#">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			INSERT INTO #variables.tableprefix#project_#arguments.type#s (projectID,#arguments.type#ID,#arguments.type#)
			VALUES (<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">,
					'#arguments.newID#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.item#" maxlength="50">)
		</cfquery>
		<cfreturn newID>
	</cffunction>

	<cffunction name="updateProjectItem" access="public" returnType="boolean" output="false"
				hint="Updates a project item.">
		<cfargument name="itemID" type="string" required="true">
		<cfargument name="item" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			UPDATE #variables.tableprefix#project_#arguments.type#s
			SET	#arguments.type# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.item#" maxlength="50">
			WHERE #arguments.type#ID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.itemID#" maxlength="35">  
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="deleteProjectItem" access="public" returnType="boolean" output="false"
				hint="Deletes a project item.">
		<cfargument name="itemID" type="string" required="true">
		<cfargument name="type" type="string" required="true">
		<cfquery datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			DELETE FROM #variables.tableprefix#project_#arguments.type#s
			WHERE #arguments.type#ID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.itemID#" maxlength="35">
		</cfquery>
		<cfreturn true>
	</cffunction>

	<cffunction name="version" access="public" returntype="query" output="false"
				HINT="Returns project version records.">
		<cfargument name="projectID" type="string" required="true">
		<cfset var qRecords = "">
		<cfquery name="qRecords" datasource="#variables.dsn#" username="#variables.dbUsername#" password="#variables.dbPassword#">
			SELECT v.versionID, v.version, count(i.issueID) as numIssues
			FROM #variables.tableprefix#project_versions v LEFT JOIN #variables.tableprefix#issues i
				ON v.versionID = i.versionID
			WHERE v.projectID = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.projectID#" maxlength="35">
			GROUP BY v.versionID, v.version
			ORDER BY version
		</cfquery>		
		<cfreturn qRecords>
	</cffunction>

</CFCOMPONENT>
