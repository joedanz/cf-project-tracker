/* UPGRADE FROM 2.4 */

/* pt_client_rates - add table + index */
CREATE TABLE [dbo].[pt_client_rates] (
	[rateID] [char] (35) NOT NULL ,
	[clientID] [char] (35) NOT NULL ,
	[category] [nvarchar] (50) NULL ,
	[rate] numeric (6,2) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[pt_client_rates] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_client_rates] PRIMARY KEY  CLUSTERED 
	(
		[rateID]
	)  ON [PRIMARY] 
GO

/* pt_clients - add columns */
ALTER TABLE [dbo].[pt_clients] ADD [contactEmail] [nvarchar] (150) NULL
GO
ALTER TABLE [dbo].[pt_clients] ADD [website] [nvarchar] (150) NULL
GO

/* pt_milestones - add columns */
ALTER TABLE [dbo].[pt_milestones] ADD [rate] numeric (8,2) NULL
GO
ALTER TABLE [dbo].[pt_milestones] ADD [billed] [tinyint] NULL
GO
UPDATE [dbo].[pt_milestones] SET billed = 0
GO
ALTER TABLE [dbo].[pt_milestones] ADD [paid] [tinyint] NULL
GO
UPDATE [dbo].[pt_milestones] SET paid = 0
GO

/* pt_project_users - add fine grained permissions and default everything to off */
ALTER TABLE [dbo].[pt_project_users] ADD [file_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [file_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [file_comment] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [issue_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [issue_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [issue_assign] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [issue_resolve] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [issue_close] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [issue_comment] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [msg_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [msg_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [msg_comment] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [mstone_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [mstone_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [mstone_comment] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [todolist_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [todolist_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [todo_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [todo_comment] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [time_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [time_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [bill_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [bill_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [bill_rates] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [bill_invoices] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_project_users] ADD [bill_markpaid] [tinyint] NULL
GO
UPDATE [dbo].[pt_project_users] SET file_view = 0
GO
UPDATE [dbo].[pt_project_users] SET file_edit = 0
GO
UPDATE [dbo].[pt_project_users] SET file_comment = 0
GO
UPDATE [dbo].[pt_project_users] SET issue_view = 0
GO
UPDATE [dbo].[pt_project_users] SET issue_edit = 0
GO
UPDATE [dbo].[pt_project_users] SET issue_assign = 0
GO
UPDATE [dbo].[pt_project_users] SET issue_resolve = 0
GO
UPDATE [dbo].[pt_project_users] SET issue_close = 0
GO
UPDATE [dbo].[pt_project_users] SET issue_comment = 0
GO
UPDATE [dbo].[pt_project_users] SET msg_view = 0
GO
UPDATE [dbo].[pt_project_users] SET msg_edit = 0
GO
UPDATE [dbo].[pt_project_users] SET msg_comment = 0
GO
UPDATE [dbo].[pt_project_users] SET mstone_view = 0
GO
UPDATE [dbo].[pt_project_users] SET mstone_edit = 0
GO
UPDATE [dbo].[pt_project_users] SET mstone_comment = 0
GO
UPDATE [dbo].[pt_project_users] SET todolist_view = 0
GO
UPDATE [dbo].[pt_project_users] SET todolist_edit = 0
GO
UPDATE [dbo].[pt_project_users] SET todo_edit = 0
GO
UPDATE [dbo].[pt_project_users] SET todo_comment = 0
GO
UPDATE [dbo].[pt_project_users] SET time_view = 0
GO
UPDATE [dbo].[pt_project_users] SET time_edit = 0
GO
UPDATE [dbo].[pt_project_users] SET bill_view = 0
GO
UPDATE [dbo].[pt_project_users] SET bill_edit = 0
GO
UPDATE [dbo].[pt_project_users] SET bill_rates = 0
GO
UPDATE [dbo].[pt_project_users] SET bill_invoices = 0
GO
UPDATE [dbo].[pt_project_users] SET bill_markpaid = 0
GO

/* pt_projects - add new columns + columns for default permissions */
ALTER TABLE [dbo].[pt_projects] ADD [logo_img] [nvarchar] (150) NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_billing] [tinyint] NULL
GO
UPDATE [dbo].[pt_projects] SET tab_billing = 0
GO
ALTER TABLE [dbo].[pt_projects] ADD [issue_svn_link] [tinyint] NULL
GO
UPDATE [dbo].[pt_projects] SET issue_svn_link = 1
GO
ALTER TABLE [dbo].[pt_projects] ADD [issue_timetrack] [tinyint] NULL
GO
UPDATE [dbo].[pt_projects] SET issue_timetrack = 1
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_file_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_file_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_file_comment] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_issue_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_issue_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_issue_assign] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_issue_resolve] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_issue_close] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_issue_comment] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_msg_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_msg_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_msg_comment] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_mstone_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_mstone_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_mstone_comment] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_todolist_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_todolist_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_todo_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_todo_comment] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_time_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_time_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_bill_view] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_bill_edit] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_bill_rates] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_bill_invoices] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_bill_markpaid] [tinyint] NULL
GO

/* pt_settings - add new settings */
INSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('1E5ED63A-C938-2FE9-C60035D81F955266','company_name','')
GO
INSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('1E77669A-963D-735E-C7C22FA82FABC398','company_logo','')
GO
INSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('5D717D09-1372-7975-6F21844EACDAFC54','invoice_logo','')
GO
INSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('3D72D1F7-CD23-8BE3-60F9614093F89CCF','hourly_rate','')
GO

/* pt_timetrack - add new columns */
ALTER TABLE [dbo].[pt_timetrack] ADD [rateID] [nvarchar] (35) NULL
GO
ALTER TABLE [dbo].[pt_timetrack] ADD [billed] [tinyint] NULL
GO
UPDATE [dbo].[pt_timetrack] SET billed = 0
GO
ALTER TABLE [dbo].[pt_timetrack] ADD [paid] [tinyint] NULL
GO
UPDATE [dbo].[pt_timetrack] SET paid = 0
GO

/* pt_user_notify - add per project notifications table + index */
CREATE TABLE [dbo].[pt_user_notify] (
	[userID] [char] (35) NOT NULL ,
	[projectID] [char] (35) NOT NULL ,
	[email_file_new] [tinyint] NULL ,
	[mobile_file_new] [tinyint] NULL ,
	[email_file_upd] [tinyint] NULL ,	
	[mobile_file_upd] [tinyint] NULL ,
	[email_file_com] [tinyint] NULL ,	
	[mobile_file_com] [tinyint] NULL ,
	[email_issue_new] [tinyint] NULL ,
	[mobile_issue_new] [tinyint] NULL ,
	[email_issue_upd] [tinyint] NULL ,
	[mobile_issue_upd] [tinyint] NULL ,
	[email_issue_com] [tinyint] NULL ,
	[mobile_issue_com] [tinyint] NULL ,
	[email_msg_new] [tinyint] NULL ,
	[mobile_msg_new] [tinyint] NULL ,
	[email_msg_upd] [tinyint] NULL ,
	[mobile_msg_upd] [tinyint] NULL ,
	[email_msg_com] [tinyint] NULL ,
	[mobile_msg_com] [tinyint] NULL ,
	[email_mstone_new] [tinyint] NULL ,
	[mobile_mstone_new] [tinyint] NULL ,
	[email_mstone_upd] [tinyint] NULL ,
	[mobile_mstone_upd] [tinyint] NULL ,
	[email_mstone_com] [tinyint] NULL ,
	[mobile_mstone_com] [tinyint] NULL ,
	[email_todo_new] [tinyint] NULL ,
	[mobile_todo_new] [tinyint] NULL ,
	[email_todo_upd] [tinyint] NULL ,
	[mobile_todo_upd] [tinyint] NULL ,	
	[email_todo_com] [tinyint] NULL ,
	[mobile_todo_com] [tinyint] NULL ,	
	[email_time_new] [tinyint] NULL ,
	[mobile_time_new] [tinyint] NULL ,
	[email_time_upd] [tinyint] NULL ,
	[mobile_time_upd] [tinyint] NULL ,	
	[email_bill_new] [tinyint] NULL ,
	[mobile_bill_new] [tinyint] NULL ,
	[email_bill_upd] [tinyint] NULL ,
	[mobile_bill_upd] [tinyint] NULL ,	
	[email_bill_paid] [tinyint] NULL ,
	[mobile_bill_paid] [tinyint] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[pt_user_notify] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_user_notify] PRIMARY KEY  CLUSTERED 
	(
		[userID],[projectID]
	)  ON [PRIMARY] 
GO
