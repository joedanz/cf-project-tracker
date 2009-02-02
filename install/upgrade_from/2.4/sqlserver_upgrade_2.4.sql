/* UPGRADE FROM 2.4 */

/* pt_client_rates */
CREATE TABLE [dbo].[pt_client_rates] (
	[rateID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[clientID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[rate] numeric (6,2) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[pt_client_rates] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_client_rates] PRIMARY KEY  CLUSTERED 
	(
		[rateID]
	)  ON [PRIMARY] 
GO

/* pt_clients */
ALTER TABLE [dbo].[pt_clients] ADD [contactEmail] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_clients] ADD [website] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

/* pt_milestones */
ALTER TABLE [dbo].[pt_milestones] ADD [rate] numeric (8,2) NULL
GO

/* pt_project_users */
ALTER TABLE [dbo].[pt_project_users] ADD [billing] [tinyint] NULL
GO
UPDATE [dbo].[pt_project_users] SET billing = 0
GO

/* pt_projects */
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

/* pt_timetrack */
ALTER TABLE [dbo].[pt_timetrack] ADD [rateID] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

/* pt_user_notify */
CREATE TABLE [dbo].[pt_user_notify] (
	[userID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[email_files] [tinyint] NULL ,
	[mobile_files] [tinyint] NULL ,
	[email_issues] [tinyint] NULL ,
	[mobile_issues] [tinyint] NULL ,
	[email_msgs] [tinyint] NULL ,
	[mobile_msgs] [tinyint] NULL ,
	[email_mstones] [tinyint] NULL ,
	[mobile_mstones] [tinyint] NULL ,
	[email_todos] [tinyint] NULL ,
	[mobile_todos] [tinyint] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[pt_user_notify] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_user_notify] PRIMARY KEY  CLUSTERED 
	(
		[userID],[projectID]
	)  ON [PRIMARY] 
GO
