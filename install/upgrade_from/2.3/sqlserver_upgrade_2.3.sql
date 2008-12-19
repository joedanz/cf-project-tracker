/* UPGRADE FROM 2.3 */

/* pt_issues */
ALTER TABLE [dbo].[pt_issues] ADD [componentID] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_issues] ADD [versionID] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_issues] ADD [dueDate] [datetime] NULL
GO
ALTER TABLE [dbo].[pt_issues] ADD [svnrevision] [int] NULL 
GO

/* pt_projects */
ALTER TABLE [dbo].[pt_projects] ADD [reg_time] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_files] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_issues] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_msgs] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_mstones] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_svn] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_time] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_todos] [tinyint] NULL
GO
UPDATE [dbo].[pt_projects] SET reg_time = 1
GO
UPDATE [dbo].[pt_projects] SET tab_files = 1
GO
UPDATE [dbo].[pt_projects] SET tab_issues = 1
GO
UPDATE [dbo].[pt_projects] SET tab_msgs = 1
GO
UPDATE [dbo].[pt_projects] SET tab_mstones = 1
GO
UPDATE [dbo].[pt_projects] SET tab_svn = 1
GO
UPDATE [dbo].[pt_projects] SET tab_time = 1
GO
UPDATE [dbo].[pt_projects] SET tab_todos = 1
GO

/* pt_project_components */
CREATE TABLE [dbo].[pt_project_components] (
	[componentID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[component] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[pt_project_components] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_project_components] PRIMARY KEY  CLUSTERED 
	(
		[componentID]
	)  ON [PRIMARY] 
GO

/* pt_project_users */
ALTER TABLE [dbo].[pt_project_users] ADD [timetrack] [tinyint] NULL
GO
UPDATE [dbo].[pt_project_users] SET timetrack = 0
GO

/* pt_project_versions */
CREATE TABLE [dbo].[pt_project_versions] (
	[versionID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[version] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[pt_project_versions] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_project_versions] PRIMARY KEY  CLUSTERED 
	(
		[versionID]
	)  ON [PRIMARY] 
GO

/* pt_timetrack */
CREATE TABLE [pt_timetrack] (
	[timetrackID] char (35) NOT NULL,
	[projectID] char (35) NULL,
	[userID] char (35) NULL,
	[dateStamp] datetime NULL,
	[hours] numeric (6,2) NULL,
	[description] nvarchar (255) NULL,
	[itemID] [nvarchar] (35) NULL ,
	[itemType] [nvarchar] (10) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[pt_timetrack] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_timetrack] PRIMARY KEY  CLUSTERED 
	(
		[timetrackID]
	)  ON [PRIMARY] 
GO

/* pt_todolists */
ALTER TABLE [dbo].[pt_todolists] ADD [timetrack] [tinyint] NULL
GO
UPDATE [dbo].[pt_todolists] SET timetrack = 0
GO