/* UPGRADE FROM 2.3 */
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
UPDATE [dbo].[pt_projects] SET reg_time = 1 WHERE reg_time IS NULL
GO
UPDATE [dbo].[pt_projects] SET tab_files = 1 WHERE tab_files IS NULL
GO
UPDATE [dbo].[pt_projects] SET tab_issues = 1 WHERE tab_issues IS NULL
GO
UPDATE [dbo].[pt_projects] SET tab_msgs = 1 WHERE tab_msgs IS NULL
GO
UPDATE [dbo].[pt_projects] SET tab_mstones = 1 WHERE tab_mstones IS NULL
GO
UPDATE [dbo].[pt_projects] SET tab_svn = 1 WHERE tab_svn IS NULL
GO
UPDATE [dbo].[pt_projects] SET tab_time = 1 WHERE tab_time IS NULL
GO
UPDATE [dbo].[pt_projects] SET tab_todos = 1 WHERE tab_todos IS NULL
GO

/* pt_project_users */
ALTER TABLE [dbo].[pt_project_users] ADD [timetrack] [tinyint] NULL
GO
UPDATE [dbo].[pt_project_users] SET timetrack = 0 WHERE timetrack IS NULL
GO

/* pt_issues */
ALTER TABLE [dbo].[pt_issues] ADD [componentID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_issues] ADD [versionID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_issues] ADD [dueDate] [datetime] NULL
GO

CREATE TABLE [dbo].[pt_project_components] (
	[componentID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[component] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[pt_project_versions] (
	[versionID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[version] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[pt_project_components] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_project_components] PRIMARY KEY  CLUSTERED 
	(
		[componentID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[pt_project_versions] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_project_versions] PRIMARY KEY  CLUSTERED 
	(
		[versionID]
	)  ON [PRIMARY] 
GO