<cfcomponent displayname="Database Structure" output="false">

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="DataMgr" type="any" required="true">
		<cfargument name="tablePrefix" type="string" required="false" default="">
		
		<cfset arguments.DataMgr.loadXML(getDbXml(arguments.tablePrefix),true,true)>
	</cffunction>
	
	<cffunction name="getDbXml" access="public" returntype="string" output="false">
		<cfargument name="tablePrefix" type="string" required="true">
		
		<cfset var tableXML = "">
		
		<cfsavecontent variable="tableXML">
		<cfoutput>
		<tables>
			<table name="#arguments.tablePrefix#activity">
				<field ColumnName="activityID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="userID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="type" CF_DataType="CF_SQL_VARCHAR" Length="12" />
				<field ColumnName="id" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="name" CF_DataType="CF_SQL_VARCHAR" Length="100" />
				<field ColumnName="activity" CF_DataType="CF_SQL_VARCHAR" Length="50" />
				<field ColumnName="stamp" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
			</table>
			<table name="#arguments.tablePrefix#carriers">
				<field ColumnName="carrierID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="carrier" CF_DataType="CF_SQL_VARCHAR" Length="20" />
				<field ColumnName="countryCode" CF_DataType="CF_SQL_VARCHAR" Length="2" />
				<field ColumnName="country" CF_DataType="CF_SQL_VARCHAR" Length="20" />
				<field ColumnName="prefix" CF_DataType="CF_SQL_VARCHAR" Length="3" />
				<field ColumnName="suffix" CF_DataType="CF_SQL_VARCHAR" Length="40" />
				<field ColumnName="active" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
			</table>
			<table name="#arguments.tablePrefix#categories">
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="categoryID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="type" CF_DataType="CF_SQL_VARCHAR" Length="5" />
				<field ColumnName="category" CF_DataType="CF_SQL_VARCHAR" Length="80" />
			</table>
			<table name="#arguments.tablePrefix#client_rates">
				<field ColumnName="rateID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="clientID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="category" CF_DataType="CF_SQL_VARCHAR" Length="50" />
				<field ColumnName="rate" CF_DataType="CF_SQL_NUMERIC" Precision="6" Scale="2" />
			</table>
			<table name="#arguments.tablePrefix#clients">
				<field ColumnName="clientID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="name" CF_DataType="CF_SQL_VARCHAR" Length="150" />
				<field ColumnName="address" CF_DataType="CF_SQL_LONGVARCHAR" />
				<field ColumnName="city" CF_DataType="CF_SQL_VARCHAR" Length="150" />
				<field ColumnName="locality" CF_DataType="CF_SQL_VARCHAR" Length="200" />
				<field ColumnName="country" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="postal" CF_DataType="CF_SQL_VARCHAR" Length="40" />
				<field ColumnName="phone" CF_DataType="CF_SQL_VARCHAR" Length="40" />
				<field ColumnName="fax" CF_DataType="CF_SQL_VARCHAR" Length="40" />
				<field ColumnName="contactName" CF_DataType="CF_SQL_VARCHAR" Length="60" />
				<field ColumnName="contactPhone" CF_DataType="CF_SQL_VARCHAR" Length="40" />
				<field ColumnName="contactEmail" CF_DataType="CF_SQL_VARCHAR" Length="150" />
				<field ColumnName="website" CF_DataType="CF_SQL_VARCHAR" Length="150" />
				<field ColumnName="notes" CF_DataType="CF_SQL_LONGVARCHAR" />
				<field ColumnName="active" CF_DataType="CF_SQL_TINYINT" Precision="3" Scale="0" />
			</table>
			<table name="#arguments.tablePrefix#comments">
				<field ColumnName="commentID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="messageID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="issueID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="userID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="commentText" CF_DataType="CF_SQL_LONGVARCHAR" />
				<field ColumnName="stamp" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="type" CF_DataType="CF_SQL_VARCHAR" Length="6" />
				<field ColumnName="itemID" CF_DataType="CF_SQL_CHAR" Length="35" />
			</table>
			<table name="#arguments.tablePrefix#file_attach">
				<field ColumnName="itemID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="fileID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="type" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="6" />
			</table>
			<table name="#arguments.tablePrefix#files">
				<field ColumnName="fileID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="title" CF_DataType="CF_SQL_VARCHAR" Length="200" />
				<field ColumnName="description" CF_DataType="CF_SQL_LONGVARCHAR" />
				<field ColumnName="filename" CF_DataType="CF_SQL_VARCHAR" Length="150" />
				<field ColumnName="serverfilename" CF_DataType="CF_SQL_VARCHAR" Length="150" />
				<field ColumnName="filetype" CF_DataType="CF_SQL_VARCHAR" Length="4" />
				<field ColumnName="filesize" CF_DataType="CF_SQL_BIGINT" Precision="19" Scale="0" />
				<field ColumnName="uploaded" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="uploadedBy" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="categoryID" CF_DataType="CF_SQL_CHAR" Length="35" />
			</table>
			<table name="#arguments.tablePrefix#issues">
				<field ColumnName="issueID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="milestoneID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="shortID" CF_DataType="CF_SQL_VARCHAR" Length="7" />
				<field ColumnName="issue" CF_DataType="CF_SQL_VARCHAR" Length="120" />
				<field ColumnName="detail" CF_DataType="CF_SQL_LONGVARCHAR" />
				<field ColumnName="type" CF_DataType="CF_SQL_VARCHAR" Length="11" />
				<field ColumnName="severity" CF_DataType="CF_SQL_VARCHAR" Length="10" />
				<field ColumnName="status" CF_DataType="CF_SQL_VARCHAR" Length="8" />
				<field ColumnName="relevantURL" CF_DataType="CF_SQL_VARCHAR" Length="255" />
				<field ColumnName="created" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="createdBy" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="assignedTo" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="updated" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="updatedBy" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="resolution" CF_DataType="CF_SQL_VARCHAR" Length="12" />
				<field ColumnName="resolutionDesc" CF_DataType="CF_SQL_LONGVARCHAR" />
				<field ColumnName="componentID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="versionID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="dueDate" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
			</table>
			<table name="#arguments.tablePrefix#message_notify">
				<field ColumnName="messageID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="userID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
			</table>
			<table name="#arguments.tablePrefix#messages">
				<field ColumnName="messageID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="milestoneID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="userID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="title" CF_DataType="CF_SQL_VARCHAR" Length="120" />
				<field ColumnName="message" CF_DataType="CF_SQL_LONGVARCHAR" />
				<field ColumnName="allowcomments" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="stamp" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="categoryID" CF_DataType="CF_SQL_CHAR" Length="35" />
			</table>
			<table name="#arguments.tablePrefix#milestones">
				<field ColumnName="milestoneID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="userID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="forID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="name" CF_DataType="CF_SQL_VARCHAR" Length="50" />
				<field ColumnName="description" CF_DataType="CF_SQL_LONGVARCHAR" />
				<field ColumnName="dueDate" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="completed" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="rate" CF_DataType="CF_SQL_NUMERIC" Precision="8" Scale="2" />
			</table>
			<table name="#arguments.tablePrefix#project_components">
				<field ColumnName="componentID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="component" CF_DataType="CF_SQL_VARCHAR" Length="50" />
			</table>
			<table name="#arguments.tablePrefix#project_users">
				<field ColumnName="userID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="admin" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="file_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="file_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="file_comment" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="issue_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="issue_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="issue_accept" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="issue_comment" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="msg_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="msg_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="msg_comment" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="mstone_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="mstone_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="mstone_comment" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="todolist_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="todolist_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="todo_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="todo_comment" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="time_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="time_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="bill_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="bill_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="bill_rates" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="bill_invoices" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="bill_markpaid" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="svn" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
			</table>
			<table name="#arguments.tablePrefix#project_versions">
				<field ColumnName="versionID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="version" CF_DataType="CF_SQL_VARCHAR" Length="50" />
			</table>
			<table name="#arguments.tablePrefix#projects">
				<field ColumnName="projectID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="clientID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="name" CF_DataType="CF_SQL_VARCHAR" Length="50" />
				<field ColumnName="description" CF_DataType="CF_SQL_LONGVARCHAR" />
				<field ColumnName="display" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="ticketPrefix" CF_DataType="CF_SQL_VARCHAR" Length="2" />
				<field ColumnName="added" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="addedBy" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="status" CF_DataType="CF_SQL_VARCHAR" Length="8" />
				<field ColumnName="svnurl" CF_DataType="CF_SQL_VARCHAR" Length="100" />
				<field ColumnName="svnuser" CF_DataType="CF_SQL_VARCHAR" Length="20" />
				<field ColumnName="svnpass" CF_DataType="CF_SQL_VARCHAR" Length="20" />
				<field ColumnName="ownerID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="logo_img" CF_DataType="CF_SQL_VARCHAR" Length="150" />
				<field ColumnName="allow_reg" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_file_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_file_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_file_comment" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_issue_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_issue_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_issue_accept" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_issue_comment" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_msg_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_msg_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_msg_comment" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_mstone_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_mstone_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_mstone_comment" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_todolist_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_todolist_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_todo_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_todo_comment" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_time_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_time_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_bill_view" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_bill_edit" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_bill_rates" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_bill_invoices" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_bill_markpaid" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="reg_svn" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="tab_billing" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="tab_files" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="tab_issues" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="tab_msgs" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="tab_mstones" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="tab_svn" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="tab_time" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="tab_todos" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="tab_todos" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="issue_svn_link" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
				<field ColumnName="issue_timetrack" CF_DataType="CF_SQL_TINYINT" Precision="1" Scale="0" />
			</table>
			<table name="#arguments.tablePrefix#screenshots">
				<field ColumnName="fileID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="issueID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="title" CF_DataType="CF_SQL_VARCHAR" Length="200" />
				<field ColumnName="description" CF_DataType="CF_SQL_LONGVARCHAR" />
				<field ColumnName="filename" CF_DataType="CF_SQL_VARCHAR" Length="150" />
				<field ColumnName="serverfilename" CF_DataType="CF_SQL_VARCHAR" Length="150" />
				<field ColumnName="filetype" CF_DataType="CF_SQL_VARCHAR" Length="4" />
				<field ColumnName="filesize" CF_DataType="CF_SQL_BIGINT" Precision="19" Scale="0" />
				<field ColumnName="uploaded" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="uploadedBy" CF_DataType="CF_SQL_CHAR" Length="35" />
			</table>
			<table name="#arguments.tablePrefix#settings">
				<field ColumnName="settingID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="setting" CF_DataType="CF_SQL_VARCHAR" Length="20" />
				<field ColumnName="settingValue" CF_DataType="CF_SQL_VARCHAR" Length="50" />
			</table>
			<table name="#arguments.tablePrefix#svn_link">
				<field ColumnName="linkID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="revision" CF_DataType="CF_SQL_INTEGER" Precision="5" Scale="0" />
				<field ColumnName="itemID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="itemType" CF_DataType="CF_SQL_VARCHAR" Length="10" />
			</table>
			<table name="#arguments.tablePrefix#tags">
				<field ColumnName="projectID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="tag" CF_DataType="CF_SQL_VARCHAR" Length="50" />
				<field ColumnName="type" CF_DataType="CF_SQL_VARCHAR" Length="50" />
				<field ColumnName="id" CF_DataType="CF_SQL_VARCHAR" Length="35" />
			</table>
			<table name="#arguments.tablePrefix#timetrack">
				<field ColumnName="timetrackID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="userID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="dateStamp" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="hours" CF_DataType="CF_SQL_NUMERIC" Precision="6" Scale="2" />
				<field ColumnName="description" CF_DataType="CF_SQL_VARCHAR" Length="255" />
				<field ColumnName="itemID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="itemType" CF_DataType="CF_SQL_VARCHAR" Length="10" />
				<field ColumnName="rateID" CF_DataType="CF_SQL_VARCHAR" Length="35" />				
			</table>
			<table name="#arguments.tablePrefix#todolists">
				<field ColumnName="todolistID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="title" CF_DataType="CF_SQL_VARCHAR" Length="100" />
				<field ColumnName="description" CF_DataType="CF_SQL_LONGVARCHAR" />
				<field ColumnName="milestoneID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="userID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="added" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="rank" CF_DataType="CF_SQL_TINYINT" Precision="3" Scale="0" />
				<field ColumnName="timetrack" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
			</table>
			<table name="#arguments.tablePrefix#todos">
				<field ColumnName="todoID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="todolistID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="userID" CF_DataType="CF_SQL_CHAR" Length="35" />
				<field ColumnName="task" CF_DataType="CF_SQL_VARCHAR" Length="300" />
				<field ColumnName="rank" CF_DataType="CF_SQL_INTEGER" Precision="10" Scale="0" />
				<field ColumnName="added" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="completed" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="due" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
			</table>
			<table name="#arguments.tablePrefix#user_notify">
				<field ColumnName="userID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="projectID" CF_DataType="CF_SQL_CHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="email_files" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="mobile_files" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="email_issues" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="mobile_issues" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="email_msgs" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="mobile_msgs" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="email_mstones" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="mobile_mstones" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="email_todos" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="mobile_todos" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
			</table>
			<table name="#arguments.tablePrefix#users">
				<field ColumnName="userID" CF_DataType="CF_SQL_VARCHAR" PrimaryKey="true" Length="35" />
				<field ColumnName="firstName" CF_DataType="CF_SQL_VARCHAR" Length="12" />
				<field ColumnName="lastName" CF_DataType="CF_SQL_VARCHAR" Length="20" />
				<field ColumnName="username" CF_DataType="CF_SQL_VARCHAR" Length="30" />
				<field ColumnName="password" CF_DataType="CF_SQL_CHAR" Length="32" />
				<field ColumnName="email" CF_DataType="CF_SQL_VARCHAR" Length="120" />
				<field ColumnName="phone" CF_DataType="CF_SQL_VARCHAR" Length="15" />
				<field ColumnName="mobile" CF_DataType="CF_SQL_VARCHAR" Length="15" />
				<field ColumnName="carrierID" CF_DataType="CF_SQL_VARCHAR" Length="35" />
				<field ColumnName="lastLogin" CF_DataType="CF_SQL_DATE" Precision="23" Scale="3" />
				<field ColumnName="avatar" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="style" CF_DataType="CF_SQL_VARCHAR" Length="20" />
				<field ColumnName="admin" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
				<field ColumnName="active" CF_DataType="CF_SQL_BIT" Precision="1" Scale="0" />
			</table>
			<data table="#arguments.tablePrefix#users">
				<row userID="FCDCF4CD-16E6-58DE-13EDC6A2B362B22C" firstName="Admin" lastName="User" username="admin" password="21232F297A57A5A743894A0E4A801FC3" email="" phone="" mobile="" carrierID="" lastLogin="" avatar="0" style="blue" email_files="0" mobile_files="0" email_issues="0" mobile_issues="0" email_msgs="0" mobile_msgs="0" email_mstones="0" mobile_mstones="0" email_todos="0" mobile_todos="0" admin="1" active="1" />
				<row userID="7F16CA08-1372-7975-6F7F9DA33EBD6A09" firstName="Guest" lastName="User" username="guest" password="084E0343A0486FF05530DF6C705C8BB4" email="" phone="" mobile="" carrierID="" lastLogin="" avatar="0" style="blue" email_files="0" mobile_files="0" email_issues="0" mobile_issues="0" email_msgs="0" mobile_msgs="0" email_mstones="0" mobile_mstones="0" email_todos="0" mobile_todos="0" admin="0" active="1" />
			</data>
			<data table="#arguments.tablePrefix#settings">
				<row settingID="FC3D187C-16E6-58DE-133C5098C58225D3" setting="app_title" settingValue="Project Tracker" />
				<row settingID="FC3D861A-16E6-58DE-1346E4E01F578F52" setting="default_style" settingValue="blue" />
				<row settingID="E59DED9F-1372-7975-6FCD9DFAE904B617" setting="enable_api" settingValue="0" />
				<row settingID="E5A50225-1372-7975-6F9777FB42FD45E6" setting="api_key" settingValue="" />
				<row settingID="50ED062A-16E6-58DE-13EF9FEB2312EE8C" setting="email_subject_prefix" settingValue="" />
				<row settingID="50ED2D69-16E6-58DE-130067F4C29ABF35" setting="sms_subject_prefix" settingValue="" />
				<row settingID="1E5ED63A-C938-2FE9-C60035D81F955266" setting="company_name" settingValue="" />
				<row settingID="1E77669A-963D-735E-C7C22FA82FABC398" setting="company_logo" settingValue="" />
				<row settingID="5D717D09-1372-7975-6F21844EACDAFC54" setting="invoice_logo" settingValue="" />
				<row settingID="3D72D1F7-CD23-8BE3-60F9614093F89CCF" setting="hourly_rate" settingValue="" />
			</data>
			<data table="#arguments.tablePrefix#carriers">
				<row carrierID="8464AB28-1372-7975-6F2E9747CA6E4693" carrier="AT&amp;T" countryCode="US" country="United States" prefix="" suffix="@txt.att.net" active="1" />
				<row carrierID="8464DE00-1372-7975-6FE886FCD149E667" carrier="Boost" countryCode="US" country="United States" prefix="" suffix="@myboostmobile.com" active="1" />
				<row carrierID="84653DF3-1372-7975-6F03DA67DD9FB6A9" carrier="Cingular" countryCode="US" country="United States" prefix="" suffix="@txt.att.net" active="1" />
				<row carrierID="846562C1-1372-7975-6F0D79371C491F0C" carrier="Helio" countryCode="US" country="United States" prefix="" suffix="@messaging.sprintpcs.com" active="1" />
				<row carrierID="846589B2-1372-7975-6F34C8F27502E0DE" carrier="Nextel" countryCode="US" country="United States" prefix="" suffix="@messaging.nextel.com" active="1" />
				<row carrierID="8465AECE-1372-7975-6FAEBDD9F3DDB156" carrier="Sprint" countryCode="US" country="United States" prefix="" suffix="@messaging.sprintpcs.com" active="1" />
				<row carrierID="846F02F5-1372-7975-6F6C106050F904CD" carrier="T-Mobile" countryCode="US" country="United States" prefix="" suffix="@tmomail.net" active="1" />
				<row carrierID="8465D060-1372-7975-6F83333D63966358" carrier="Verizon" countryCode="US" country="United States" prefix="" suffix="@vtext.com" active="1" />
				<row carrierID="8465FEC3-1372-7975-6F5CA6C75C25C7D4" carrier="Virgin USA" countryCode="US" country="United States" prefix="" suffix="@vmobl.com" active="1" />
				<row carrierID="84662779-1372-7975-6F8F1751F5B64D4E" carrier="Aliant Mobility" countryCode="CA" country="Canada" prefix="" suffix="@chat.wirefree.ca" active="1" />
				<row carrierID="846652B0-1372-7975-6F46C791E680C346" carrier="Bell Mobility" countryCode="CA" country="Canada" prefix="" suffix="@txt.bellmobility.ca" active="1" />
				<row carrierID="84667ED1-1372-7975-6F97CD40347FC5CB" carrier="Fido" countryCode="CA" country="Canada" prefix="" suffix="@fido.ca" active="1" />
				<row carrierID="8466BB0F-1372-7975-6F6ABCC0603EE274" carrier="MTS" countryCode="CA" country="Canada" prefix="" suffix="@text.mtsmobility.com" active="1" />
				<row carrierID="8466DE85-1372-7975-6F261B5E9D329B92" carrier="Rogers" countryCode="CA" country="Canada" prefix="" suffix="@pcs.rogers.com" active="1" />
				<row carrierID="8466FEFD-1372-7975-6F8EA4D54A0C57F3" carrier="SaskTel" countryCode="CA" country="Canada" prefix="" suffix="@sms.sasktel.com" active="1" />
				<row carrierID="84672060-1372-7975-6F8456BEBA71E39A" carrier="Solo Mobile" countryCode="CA" country="Canada" prefix="" suffix="@txt.bell.ca" active="1" />
				<row carrierID="84675A6C-1372-7975-6F496C2375ED2815" carrier="TELUS" countryCode="CA" country="Canada" prefix="" suffix="@msg.telus.com" active="1" />
				<row carrierID="84677BCF-1372-7975-6F89C8D24436A08A" carrier="Virgin Canada" countryCode="CA" country="Canada" prefix="" suffix="@vmobile.ca" active="1" />
				<row carrierID="8467A2B0-1372-7975-6FEB7589919DC435" carrier="O2" countryCode="UK" country="United Kingdom" prefix="" suffix="@mmail.co.uk" active="1" />
			</data>
		</tables>
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn tableXML>
	</cffunction>

</cfcomponent>