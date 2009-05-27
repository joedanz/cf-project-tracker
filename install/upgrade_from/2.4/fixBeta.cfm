<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify RENAME COLUMN email_files TO email_file_new
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify RENAME COLUMN mobile_files TO mobile_file_new
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify RENAME COLUMN email_issues TO email_issue_new
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify RENAME COLUMN mobile_issues TO mobile_issue_new
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify RENAME COLUMN email_msgs TO email_msg_new
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify RENAME COLUMN mobile_msgs TO mobile_msg_new
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify RENAME COLUMN email_mstones TO email_mstone_new
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify RENAME COLUMN mobile_mstones TO mobile_mstone_new
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify RENAME COLUMN email_todos TO email_todo_new
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify RENAME COLUMN mobile_todos TO mobile_todo_new
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_file_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_file_upd tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_file_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_file_com tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_issue_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_issue_upd tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_issue_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_issue_com tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_msg_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_msg_upd tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_msg_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_msg_com tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_mstone_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_mstone_upd tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_mstone_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_mstone_com tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_todo_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_todo_upd tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_todo_com tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_todo_com tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_time_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_time_upd tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_bill_upd tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_bill_upd tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD email_bill_paid tinyint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	ALTER TABLE #application.settings.tableprefix#user_notify ADD mobile_bill_paid tintint
</cfquery>
<cfquery datasource="#application.settings.dsn#">
	UPDATE #application.settings.tableprefix#user_notify 
	SET email_file_upd = 0,
		mobile_file_upd = 0,
		email_file_com = 0,
		mobile_file_com = 0,
		email_issue_upd = 0,
		mobile_issue_upd = 0,
		email_issue_com = 0,
		mobile_issue_com = 0,
		email_msg_upd = 0,
		mobile_msg_upd = 0,
		email_msg_com = 0,
		mobile_msg_com = 0,
		email_mstone_upd = 0,
		mobile_mstone_upd = 0,
		email_mstone_com = 0,
		mobile_mstone_com = 0,
		email_todo_upd = 0,
		mobile_todo_upd = 0,
		email_todo_com = 0,
		mobile_todo_com = 0,
		email_time_upd = 0,
		mobile_time_upd = 0,
		email_bill_upd = 0,
		mobile_bill_upd = 0,
		email_bill_paid = 0,
		mobile_bill_paid = 0
</cfquery>
