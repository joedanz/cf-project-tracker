<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_file_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_file_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_file_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_file_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_file_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_file_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_issue_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_issue_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_issue_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_issue_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_issue_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_issue_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_msg_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_msg_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_msg_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_msg_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_msg_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_msg_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_mstone_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_mstone_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_mstone_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_mstone_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_mstone_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_mstone_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_todo_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_todo_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_todo_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_todo_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_todo_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_todo_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_time_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_time_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_time_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_time_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_bill_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_bill_new tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_bill_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_bill_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_bill_paid tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_bill_paid tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	UPDATE #application.settings.tableprefix#user_notify 
	SET email_file_new = 0,
		mobile_file_new = 0,
		email_file_upd = 0,
		mobile_file_upd = 0,
		email_file_com = 0,
		mobile_file_com = 0,
		email_issue_new = 0,
		mobile_issue_new = 0,
		email_issue_upd = 0,
		mobile_issue_upd = 0,
		email_issue_com = 0,
		mobile_issue_com = 0,
		email_msg_new = 0,
		mobile_msg_new = 0,
		email_msg_upd = 0,
		mobile_msg_upd = 0,
		email_msg_com = 0,
		mobile_msg_com = 0,
		email_mstone_new = 0,
		mobile_mstone_new = 0,
		email_mstone_upd = 0,
		mobile_mstone_upd = 0,
		email_mstone_com = 0,
		mobile_mstone_com = 0,
		email_todo_new = 0,
		mobile_todo_new = 0,
		email_todo_upd = 0,
		mobile_todo_upd = 0,
		email_todo_com = 0,
		mobile_todo_com = 0,
		email_time_new = 0,
		mobile_time_new = 0,
		email_time_upd = 0,
		mobile_time_upd = 0,
		email_bill_new = 0,
		mobile_bill_new = 0,
		email_bill_upd = 0,
		mobile_bill_upd = 0,
		email_bill_paid = 0,
		mobile_bill_paid = 0
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify DROP COLUMN email_files
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify DROP COLUMN mobile_files
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify DROP COLUMN email_issues
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify DROP COLUMN mobile_issues
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify DROP COLUMN email_msgs
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify DROP COLUMN mobile_msgs
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify DROP COLUMN email_mstones
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify DROP COLUMN mobile_mstones
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify DROP COLUMN email_todos
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify DROP COLUMN mobile_todos
</cfquery>